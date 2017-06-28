require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  def setup
    if User.first.nil?
      User.create(name: "Test User", email: "test_user@ema.il", password: "123qwehello123harder", password_confirmation: "123qwehello123harder")
    end
    @user = User.first
    # This code is not idiomatically correct.
    @project = @user.projects.build(name: "Test project", description: "Lorem ipsum")
  end

  test "should be valid" do
    assert @project.valid?
  end

  test "user id should be present" do
    @project.user_id = nil
    assert_not @project.valid?
  end
end
