require 'simplecov'
SimpleCov.start 'rails'
# THE TWO LINES above shall be the first in this file

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'webmock/test_unit'
require 'support/fake_nvd'

WebMock.stub_request(:any, /nvd.nist.gov/).to_rack(FakeNvd)

def allow_couch_in_tests!
  WebMock.disable_net_connect!(:allow => "#{Couch::address[:host]}:#{Couch::address[:port]}")
  Couch::delete_database
  Couch::create_database
end

allow_couch_in_tests!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

def tag(vulnerability, component, user = @user1)
  the_tag  = vulnerability.tags.build(component: component, user: user)
  the_tag.save!
end

def react(vulnerability, status = 1, comment = "Test reaction", user = @user1)
  vulnerability.reactions.build(status: status, text: comment, user: user).save!
end
  
def affects?(v, s)
  return RelevantVulnerability.vulnerability_affects_system?(v, s)
end
  
