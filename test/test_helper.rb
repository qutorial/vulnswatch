require 'simplecov'
SimpleCov.start 'rails'
# THE TWO LINES above shall be the first in this file

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'webmock/test_unit'
require 'support/fake_nvd'
WebMock.stub_request(:any, /nvd.nist.gov/).to_rack(FakeNvd)


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

def tag(vulnerability, component, user = @user1)
  vulnerability.tags.build(component: component, user: user).save!
end
  
