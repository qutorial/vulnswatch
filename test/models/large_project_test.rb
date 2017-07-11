require 'test_helper'
require_relative 'define_large_project'

class RelevantVulnerabilityTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Test User", email: "test_user@ema.il", password: "123qwehello123harder", password_confirmation: "123qwehello123harder")
    @user.save!
    @project = @user.projects.build(name: "First project", systems_description: LargeProject.systems().join("\n"))
  end

  test "test data is valid" do
    assert @user.valid?
    assert @project.valid?
  end


  test "project is large" do 
    assert @project.systems.count == 7783
  end

  def affects?(v, s)
    return RelevantVulnerability.vulnerability_affects_system?(v, s)
  end
  
  test "vulnerability affects system works" do
    # case tested
#    assert affects?(@v1, "x.org")
  end

  test "users systems works" do
#    assert RelevantVulnerability.users_systems(@user1) == ["X11", "X.org"]
  end
  
  def relvs(u)
    return RelevantVulnerability.relevant_vulnerabilities(u)
  end

  test "relevant vulnerabilities for user detection works" do
#    assert relvs(@user1) == @affecteds 
  end

  def affs(vulnerability, user)
    return RelevantVulnerability.affected_systems(vulnerability, user)
  end

  def phs(system, user)
    return RelevantVulnerability.projects_having_system(system, user)
  end
  
  test "project detection by system works" do
#    assert phs("Linux", @user1) == []    
  end
end
