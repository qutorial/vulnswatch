require 'rails_helper'

RSpec.describe "vulnerabilities/index", type: :view do
  before(:each) do
    assign(:vulnerabilities, [
      Vulnerability.create!(
        :name => "Name",
        :summary => "MyText"
      ),
      Vulnerability.create!(
        :name => "Name",
        :summary => "MyText"
      )
    ])
  end

  it "renders a list of vulnerabilities" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
