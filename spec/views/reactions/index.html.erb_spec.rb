require 'rails_helper'

RSpec.describe "reactions/index", type: :view do
  before(:each) do
    assign(:reactions, [
      Reaction.create!(
        :user => nil,
        :vulnerability => nil,
        :status => 2,
        :title => "Title",
        :text => "MyText"
      ),
      Reaction.create!(
        :user => nil,
        :vulnerability => nil,
        :status => 2,
        :title => "Title",
        :text => "MyText"
      )
    ])
  end

  it "renders a list of reactions" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
