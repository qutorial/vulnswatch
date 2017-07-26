require 'test_helper'

class ManagementTest < ActiveSupport::TestCase

  def setup
    @user1 = User.new(name: "Test User", email: "test_user@ema.il", password: "123qwehello123harder", password_confirmation: "123qwehello123harder")
    @user1.save!
    @project1 = @user1.projects.build(name: "First project", systems_description: "X11, X.org").save!

    @v1 = Vulnerability.create(modified: DateTime.new(2015), name: "v1", summary: "I affect X.org")
    @v2 = Vulnerability.create(modified: DateTime.new(2015), name: "v2", summary: "I affect X11")
    @v3 = Vulnerability.create(modified: DateTime.new(2015), name: "v3", summary: "I affect X.org and more")
    tag(@v3, 'X11')
    @v4 = Vulnerability.create(name: "v4", summary: "X.org and more is affected by me when using perl", modified: DateTime.new(2015))
    tag(@v4, 'perl')
    @v5 = Vulnerability.create(name: "v5", summary: "X.org is affected by me", modified: DateTime.new(2015))
    @v6 = Vulnerability.create(modified: DateTime.new(2015), name: "v6", summary: "X11")
    @v7 = Vulnerability.create(modified: DateTime.new(2015), name: "v7", summary: "X11 has bug")
    @v8 = Vulnerability.create(modified: DateTime.new(2015), name: "v8", summary: "bug in X11")
    react(@v8)
    @v9 = Vulnerability.create(modified: DateTime.new(2015), name: "v9", summary: "Nothing told about a system here")
    tag(@v9, "X11")
    @v10 = Vulnerability.create(modified: DateTime.new(2015), name: "v10", summary: "Irrelevant but tagged")
    tag(@v10, 'something irrelevant')
    @v11 = Vulnerability.create(modified: DateTime.new(2015), name: "v11", summary: "Irrelevant but reacted upon")
    react(@v11)
    @v12 = Vulnerability.create(modified: DateTime.new(2015), name: "v12", summary: "Irrelevant but tagged and reacted upon")
    tag(@v12, 'another irrelevant')
    react(@v12)
    @v13 = Vulnerability.create(modified: DateTime.new(2017), name: "v13", summary: "A very new one but irrelevant")
    @v14 = Vulnerability.create(modified: DateTime.new(2017), name: "v14", summary: "New, relevant to X.org")
    @v15 = Vulnerability.create(modified: DateTime.new(2017), name: "v15", summary: "New, relevant by tag")
    tag(@v15, 'X.org')
    @v16 = Vulnerability.create(modified: DateTime.new(2017), name: "v16", summary: "New, reacted upon, irrelevant")
    react(@v16)
    @v17 = Vulnerability.create(modified: DateTime.now, name: "v17", summary: "Very new, irrelevant, not tagged, not reactions")
    @v18 = Vulnerability.create(modified: DateTime.new(1999), name: "v18", summary: "Old, irrelevant")
    

    @relevants = RelevantVulnerability.all_relevant_vulnerabilities_for_user(@user1).to_a
  end

  test "test data is saved fine" do
    assert User.count == 1
    assert Project.count == 1
    assert Vulnerability.count == 18
    assert Tag.count == 6
    assert Reaction.count == 4
    assert @relevants.count == 10
  end
  
  test "test delete old and unused throws error" do
    assert_raises(Management::ArgumentError) {
      Management.delete_old_unused_vulnerabilities("bla")
    }
    assert_raises(Management::ArgumentError) {
      Management.delete_old_unused_vulnerabilities(2014)
    }
    assert_raises(Management::ArgumentError) {
      Management.delete_old_unused_vulnerabilities(DateTime.now)
    }
    assert_nothing_raised {
      Management.delete_old_unused_vulnerabilities(DateTime.now, true)
    }
  end

  test "delete old and unused works" do
    assert_difference 'Vulnerability.count', -1 do
      Management.delete_old_unused_vulnerabilities(DateTime.new(2016))
    end
  end

  test "delete old and unused reacts on date" do
    assert_difference 'Vulnerability.count', -2 do
      Management.delete_old_unused_vulnerabilities(DateTime.new(2017))
    end
  end

  test "delete old and unused force works" do
    assert_difference 'Vulnerability.count', -3 do
      Management.delete_old_unused_vulnerabilities(DateTime.now, true)
    end
  end

end
