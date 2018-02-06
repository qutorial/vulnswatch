class VulnerabilitiesController < ApplicationController
  before_action :set_vulnerability, only: [:show, :edit, :update, :destroy]
  before_action :alert_on_huge_projects, only: [:index]

  def relevant
    redirect_to vulnerabilities_path(project: params[:project] || 0)
  end

  def index
    @couch_db_busy = false
    @couch_db_down = false
    @couch_exception = nil
    # TODO:  This method shall be split in many!!
    # TODO: This method should go into relevant vulnerability model


    # First we do everything in the database

    # prefilter on fields
    @vulnerabilities = Vulnerability.filter(filtering_params) 
    
    # filter on component using tags
    @vulnerabilities = Vulnerability.join_tags_and_reactions(current_user, @vulnerabilities)

    if component_filter_params[:component].present?
      @vulnerabilities = @vulnerabilities.where("LOWER(tags.component) = ?", component_filter_params[:component].to_s.downcase) 
    end

    # fulfil search
    if search_params[:search].present?
      conditions =['']
      search_params[:search].split(/\s+/).each do |term|
        term.downcase!
        # tags shall come here
        newpart = '(LOWER(summary) LIKE ? OR LOWER(name) LIKE ? OR LOWER(tags.component) LIKE ?)'
        conditions[0] =  conditions[0].empty? ? newpart : conditions[0] + ' AND ' + newpart
        conditions.push "%#{term}%"
        conditions.push "%#{term}%"
        conditions.push "%#{term}%"
      end      
      @vulnerabilities = @vulnerabilities.where(conditions)
    end

    # filter on reaction
    rfp = reaction_filter_param
    if rfp.nil? 
      # pass, no filtering requested
    else
      if rfp == 1 # no reaction
        @vulnerabilities = @vulnerabilities.where('reactions.id is NULL', current_user.id)
      else
        @vulnerabilities = @vulnerabilities.where('reactions.user_id = ?', current_user.id).where('reactions.status = ?', rfp - 1)   
      end   
     end    
    
     begin # talking to Couch DB inside exception block

      # Second in-memory procedures might start
      relevant_project = relevance_filter_params

      @searching_relevants = relevant_project == 0 || ! Project.find_by(id: relevant_project).nil?

      if @searching_relevants
        # relevance is requested project selected
        @couch_status = Couch.get_couchdb_status
        if !@couch_status[:success]
          @couch_db_down = true
          return
        elsif @couch_status[:busy]
          @couch_db_busy = true
          return
        end
      end
        

      
      if relevant_project == 0
          #any project
          @vulnerabilities = RelevantVulnerability.filter_relevant_vulnerabilities_for_user(@vulnerabilities, current_user)
      else
        project =  Project.find_by(id: relevant_project)
        if project.nil?
          # pass: no project selected
        elsif project.user != current_user
          flash[:danger] = "You have selected a wrong project for filtering."
        else
          @vulnerabilities = RelevantVulnerability.filter_relevant_vulnerabilities_for_project(@vulnerabilities, project)
        end
      end

    rescue RelevantVulnerability::CouchException => exc
      logger.error exc
      @couch_db_down = true
      @couch_exception = exc
    end

    # sort
    case sorting_param
      when 'reaction'
        @vulnerabilities = @vulnerabilities.order("reactions.status  #{sorting_way_param}")
      when nil
        @vulnerabilities = @vulnerabilities.order("name DESC")
      else
        @vulnerabilities = @vulnerabilities.order(sorting_param.to_sym => sorting_way_param)
    end

    @vulnerabilities = @vulnerabilities.paginate(page: all_search_params[:page], :per_page => 15)
  end

  # GET /vulnerabilities/nvd
  def nvd
    Vulnerability.load_new_vulnerabilities_from_nvd()
    flash[:success] = "Vulnerabilities Updated from NVD"
    redirect_to vulnerabilities_path
  end


  # GET /vulnerabilities/nvd_load_year/:year
  def nvd_load_year
    year = params[:year]
    year = year.to_i unless year.nil?
    if year.nil? or ! ( year.class == Fixnum ) or ! ( 2012 <= year and year <= Date.today.year.to_i)
      flash[:warning] = "Year was not properly specified"
    else
      flash[:success] = "Vulnerabilities for year #{year} loaded from NVD"
      Vulnerability.load_vulnerabilities_from_nvd_for_year(year)
    end
    redirect_to vulnerabilities_path
  end


  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vulnerability
      @vulnerability = Vulnerability.find_by(id: params[:id])
      if @vulnerability.nil? 
        flash[:danger] = "Invalid vulnerability specified"
        redirect_to vulnerabilities_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vulnerability_params
      params.require(:vulnerability)
    end

    def all_search_params
      if ! @search_params.nil?
        return @search_params
      end
      # they will be stored and picked up from session
      # they are shared between relevant vulnerabilities and all, thus page makes no sense here
      allowed_params = [:name, :summary, :component, :search, :project, :reaction, :clearsearch, :sorting, :sorting_way]
      prefix = :vulnsindex
      @search_params = params.permit(:name, :summary, :component, :search, :project, :reaction, :clearsearch, :sorting, :sorting_way, :page)
      if @search_params[:clearsearch].present?
        allowed_params.each do |param|
          @search_params.delete(param)
        end
      else
        @search_params = extend_params_from_session(@search_params, allowed_params, prefix)
      end
      if @search_params[:sorting].nil?
        @search_params[:sorting] = 'modified'
        @search_params[:sorting_way] = 'desc'
      end
      @search_params
    end

    # params - params object, extended_params - arrays of symbol-names of which params to extend, 
    # prefix - name prefix in session store
    def extend_params_from_session(destination_params, extended_params, prefix)
      extended_params.each do |param|
        destination_params = extend_from_session(destination_params, param, prefix)
      end
      destination_params
    end
    


    def extend_from_session(destination_params, extended_param, prefix, default = nil)
      session_index = (prefix.to_s + "_" + extended_param.to_s).to_sym
      if destination_params[extended_param].nil?
        if session.has_key?(session_index)
          destination_params[extended_param] = session[session_index]
        elsif ! default.nil?
          destination_params[extended_param] = default
        end
      else
        session[session_index] = destination_params[extended_param]
      end
      destination_params
    end

    def filtering_params
      all_search_params.permit(:name, :summary)
    end
    
    def component_filter_params
      all_search_params.permit(:component)
    end

    def search_params
      all_search_params.permit(:search)
    end

    def relevance_filter_params
      par = all_search_params.permit(:project)
      if not par.has_key?(:project) or not par[:project].present?
        return nil
      elsif par[:project].to_i == 0 
        return 0 # any project
      elsif current_user.projects.map(&->(p){p.id}).include? par[:project].to_i
        return par[:project].to_i
      end
      return nil
    end
    
    def allowed_sorting_params
      return ['name', 'modified', 'reaction', 'summary']
    end

    def sorting_way_param
      par = all_search_params.permit(:sorting_way)
      if par.has_key?(:sorting_way)
        case par[:sorting_way]
          when 'asc'
            return :asc
          when 'desc'
            return :desc
        end
      end
      return :desc
    end
        
    def sorting_param
      par = all_search_params.permit(:sorting)
      if par.has_key?(:sorting) and (allowed_sorting_params.include? par[:sorting])
        return par[:sorting]
      end
      return nil      
    end

    def reaction_filter_param
      par = all_search_params.permit(:reaction)
      if not par.has_key?(:reaction) or not par[:reaction].present?
        return nil
      elsif par.has_key?(:reaction) and (1..5).include? par[:reaction].to_i
        return par[:reaction].to_i
      end
      return nil
    end

end
