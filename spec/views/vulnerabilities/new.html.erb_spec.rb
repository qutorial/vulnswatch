require 'rails_helper'

RSpec.describe "vulnerabilities/new", type: :view do
  before(:each) do
    assign(:vulnerability, Vulnerability.new(
      :name => "MyString",
      :summary => "MyText"
    ))
  end

  it "renders new vulnerability form" do
    render

    assert_select "form[action=?][method=?]", vulnerabilities_path, "post" do

      assert_select "input[name=?]", "vulnerability[name]"

      assert_select "textarea[name=?]", "vulnerability[summary]"
    end
  end
end
