class TagsController < ApplicationController
  load_and_authorize_resource  

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    vuln = @tag.vulnerability
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to vuln, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def tag_params
      res = params.require(:tag).permit(:component, :vulnerability)
      vuln = Vulnerability.find_by(name: params["tag"]["vulnerability"])
      res.delete("vulnerability")
      res["vulnerability_id"] = vuln.nil? ? "" : vuln.id
      res
    end
end
