require 'rails_helper'

RSpec.describe "tags/show", type: :view do
  before(:each) do
    @tag = assign(:tag, Tag.create!(
      :component => "Component",
      :vulnerability => nil,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Component/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
