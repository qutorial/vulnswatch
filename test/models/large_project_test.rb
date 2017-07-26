require 'test_helper'
require_relative 'define_large_project'

class LargeProjectTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Test User", email: "test_user@ema.il", password: "123qwehello123harder", password_confirmation: "123qwehello123harder")
    @user.save!
    @project = @user.projects.build(name: "First project", systems_description: LargeProject.systems().join("\n"))
    @v = Vulnerability.new(name: "v1", summary: "Summary")
    @v.save!
  end

  test "one large test" do
    assert @user.valid?
    assert @project.valid?
    assert @project.systems.count == 7783
    RelevantVulnerability.set_many_systems(8000)
    # this fails because an SQL statement is too big for this search
    assert_raise('SQLException') {
      relvs = RelevantVulnerability.relevant_vulnerabilities(@user)
    }
  end

end
