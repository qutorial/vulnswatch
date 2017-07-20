require 'rails_helper'

RSpec.describe "tags/new", type: :view do
  before(:each) do
    assign(:tag, Tag.new(
      :component => "MyString",
      :vulnerability => nil,
      :user => nil
    ))
  end

  it "renders new tag form" do
    render

    assert_select "form[action=?][method=?]", tags_path, "post" do

      assert_select "input[name=?]", "tag[component]"

      assert_select "input[name=?]", "tag[vulnerability_id]"

      assert_select "input[name=?]", "tag[user_id]"
    end
  end
end
