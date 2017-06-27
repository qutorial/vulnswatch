require 'rails_helper'

RSpec.describe "vulnerabilities/show", type: :view do
  before(:each) do
    @vulnerability = assign(:vulnerability, Vulnerability.create!(
      :name => "Name",
      :summary => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
