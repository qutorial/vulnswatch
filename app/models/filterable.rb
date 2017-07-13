module Filterable
  extend ActiveSupport::Concern

  module ClassMethods

    # This method requires allowed_filter_parameters function defined

    def filter(params)
      results = self.where(nil) # create an anonymous scope
      allowed_params = allowed_filter_parameters().map( &->p{p.to_s} )
      params.each do |key, value|
        if allowed_params.include?(key.to_s) and value.present?
          condition = "#{key.to_s} LIKE ?"
          results = results.where(condition, "%#{value}%") 
        end
      end      
      return results
    end
    

  end
end
