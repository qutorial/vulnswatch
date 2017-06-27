require 'rails_helper'

RSpec.describe "Vulnerabilities", type: :request do
  describe "GET /vulnerabilities" do
    it "works! (now write some real specs)" do
      get vulnerabilities_path
      expect(response).to have_http_status(200)
    end
  end
end
