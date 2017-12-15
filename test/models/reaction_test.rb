require 'test_helper'

class ReactionTest < ActiveSupport::TestCase

  def setup
    @user = User.create!(name: "Test User", email: "test_user@ema.il", password: "123qwehello123harder", password_confirmation: "123qwehello123harder")
    @user.save!
    @project = @user.projects.create!(name: "Test Project", description: "Lorem ipsum")
    @project.save!
    @vulnerability = Vulnerability.create!(name: "CVE-2017-1234", summary: "A huge blow in the OpenBSD kernel", created: DateTime.now, modified: DateTime.now)
    @vulnerability.save!
    @reaction = Reaction.new(user_id: @user.id, vulnerability_id: @vulnerability.id, status: 1, text: "Veniam omnis architecto aut et.Veniam omnis architecto aut et. " * 2  )
    @reaction.save!
  end

  test "valid reaction validates" do
    assert @reaction.valid?    
  end

  test "no text allowed" do
    @reaction.text = nil
    assert @reaction.valid?    
  end

  test "user must exist" do
    @reaction.user_id = 666
    assert_not @reaction.valid?    
  end

  test "vulnerability must exist" do
    @reaction.vulnerability_id = 666
    assert_not @reaction.valid?    
  end

  test "associated with destroyed user reactions should be destroyed" do
    @reaction.save!
    assert_difference 'Reaction.count', -1 do
      @user.destroy
    end
  end

  test "associated with destroyed vulnerability reactions should be destroyed" do
    @reaction.save!
    assert_difference 'Reaction.count', -1 do
      @vulnerability.destroy
    end
  end

  test "status numericality, presence and borders" do
    assert @reaction.valid?
    @reaction.status = "Not a number"
    assert_not @reaction.valid?
    @reaction.status = 0
    assert_not @reaction.valid?
    @reaction.status = nil
    assert_not @reaction.valid?
    @reaction.status = 6
    assert_not @reaction.valid?
    @reaction.status = 100
    assert_not @reaction.valid?
    (1..4).each do |s|
      @reaction.status = s
      assert @reaction.valid?
    end
  end

  test "duplicate reactions not allowed" do
    @reaction.save!
    second_reaction = @user.reactions.build( vulnerability_id: @vulnerability.id, status: 1, text: "Bla bla" )
    assert_not second_reaction.valid?
    assert_raises(Exception) {
      second_reaction.save!
    }
  end
end

