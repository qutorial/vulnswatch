require 'rails_helper'

RSpec.describe "reactions/edit", type: :view do
  before(:each) do
    @reaction = assign(:reaction, Reaction.create!(
      :user => nil,
      :vulnerability => nil,
      :status => 1,
      :title => "MyString",
      :text => "MyText"
    ))
  end

  it "renders the edit reaction form" do
    render

    assert_select "form[action=?][method=?]", reaction_path(@reaction), "post" do

      assert_select "input[name=?]", "reaction[user_id]"

      assert_select "input[name=?]", "reaction[vulnerability_id]"

      assert_select "input[name=?]", "reaction[status]"

      assert_select "input[name=?]", "reaction[title]"

      assert_select "textarea[name=?]", "reaction[text]"
    end
  end
end
