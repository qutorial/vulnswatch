require 'rails_helper'

RSpec.describe "Reactions", type: :request do
  describe "GET /reactions" do
    it "works! (now write some real specs)" do
      get reactions_path
      expect(response).to have_http_status(200)
    end
  end
end
