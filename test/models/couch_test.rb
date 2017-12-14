require 'test_helper'

class CouchTest < ActiveSupport::TestCase

  def setup

   # Sad, but it works with a real couch db
   WebMock.disable!
   assert Couch::create_database[0] == true
   
   @user1 = User.new(name: "Test User", email: "test_user@ema.il", password: "123qwehello123harder", password_confirmation: "123qwehello123harder")
   @user1.save!
   @v1 = Vulnerability.create(name: "CVE 1", summary: "I affect X.org")
   @v2 = Vulnerability.create(name: "CVE 2", summary: "I affect X11")
   @v3 = Vulnerability.create(name: "CVE 3", summary: "I affect X.org and more")

   @v1.save!

   tag(@v1, "X.org")

   @v1.save!
   @v2.save!
   @v3.save!
   


  end


  def teardown
    assert Couch::delete_database[0] == true
    WebMock.enable!
  end

  test "couch uri building works" do
    assert Couch::couch_uri.to_s == "http://admin:admin@127.0.0.1:5984"
    assert Couch::couch_address == "http://admin:admin@127.0.0.1:5984"
    assert Couch::address[:db] == "cves_test"
  end
  
  test "getting uuid works" do
    uuid = Couch::uuid
    assert uuid.length == 32
  end

  test "db path works" do
    assert Couch::db_path == "/cves_test/"
  end

  test "getting couch status works" do
    status =  Couch::get_couchdb_status()
    assert status[:success] == true # got fine
    assert status[:busy] == false # not busy
  end

  test "check database with cves" do
    [@v1, @v2, @v3].each do |v|
      v1 = Couch::get_vuln v.id
      assert v1[0] == true # got fine
      v1 = v1[1]
      assert v1["name"] == v.name
      assert v1["summary"] == v.summary
      assert v1["_id"] == v.id.to_s
      v.tags.each do |t|
        assert v1["tags"].include?(t.component)
      end
    end
  end

  # Continue with testing for saving design docs

end
