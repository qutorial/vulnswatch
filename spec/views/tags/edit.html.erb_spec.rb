require 'rails_helper'

RSpec.describe "tags/edit", type: :view do
  before(:each) do
    @tag = assign(:tag, Tag.create!(
      :component => "MyString",
      :vulnerability => nil,
      :user => nil
    ))
  end

  it "renders the edit tag form" do
    render

    assert_select "form[action=?][method=?]", tag_path(@tag), "post" do

      assert_select "input[name=?]", "tag[component]"

      assert_select "input[name=?]", "tag[vulnerability_id]"

      assert_select "input[name=?]", "tag[user_id]"
    end
  end
end
