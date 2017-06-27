require 'rails_helper'

RSpec.describe "vulnerabilities/edit", type: :view do
  before(:each) do
    @vulnerability = assign(:vulnerability, Vulnerability.create!(
      :name => "MyString",
      :summary => "MyText"
    ))
  end

  it "renders the edit vulnerability form" do
    render

    assert_select "form[action=?][method=?]", vulnerability_path(@vulnerability), "post" do

      assert_select "input[name=?]", "vulnerability[name]"

      assert_select "textarea[name=?]", "vulnerability[summary]"
    end
  end
end
