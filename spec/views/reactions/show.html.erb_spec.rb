require 'rails_helper'

RSpec.describe "reactions/show", type: :view do
  before(:each) do
    @reaction = assign(:reaction, Reaction.create!(
      :user => nil,
      :vulnerability => nil,
      :status => 2,
      :text => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/MyText/)
  end
end
