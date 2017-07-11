# spec/support/fake_github.rb
require 'sinatra/base'

class FakeNvd < Sinatra::Base
  get '/feeds/xml/cve/2.0/nvdcve-2.0-modified.xml.zip' do
    zip_response 200, 'nvdcve-2.0-modified.xml.zip'
  end

  get %r{/feeds/xml/cve/2.0/nvdcve-2.0-(?<year>[\d]+).xml.zip} do
    if ["2015", "2016", "2017"].include?(params[:year])
      zip_response 200, "nvdcve-2.0-#{params[:year]}.xml.zip"
    else
      status 404
      "Not Found"
    end 
  end


  private

  def zip_response(response_code, file_name)
    content_type 'application/octet-stream'
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
