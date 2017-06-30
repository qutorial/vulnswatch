require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Test User", email: "test_user@ema.il", password: "123qwehello123harder", password_confirmation: "123qwehello123harder")
  end

  test "associated projects should be destroyed" do
    @user.save
    @user.projects.create!(name: "Test Project", systems_description: "#Lorem ipsum")
    assert_difference 'Project.count', -1 do
      @user.destroy
    end
  end

end

