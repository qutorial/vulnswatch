require 'rails_helper'

RSpec.describe "reactions/new", type: :view do
  before(:each) do
    assign(:reaction, Reaction.new(
      :user => nil,
      :vulnerability => nil,
      :status => 1,
      :text => "MyText"
    ))
  end

  it "renders new reaction form" do
    render

    assert_select "form[action=?][method=?]", reactions_path, "post" do

      assert_select "input[name=?]", "reaction[user_id]"

      assert_select "input[name=?]", "reaction[vulnerability_id]"

      assert_select "input[name=?]", "reaction[status]"

      assert_select "textarea[name=?]", "reaction[text]"
    end
  end
end
