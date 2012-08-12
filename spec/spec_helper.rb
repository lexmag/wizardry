ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'minitest/autorun'
require 'action_controller/test_case'

class MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown
end

class RoutingSpec < Minitest::Spec
  include ActionDispatch::Integration::Runner
  include Rails.application.routes.url_helpers

  before do
    @routes = Rails.application.routes
  end

  register_spec_type(/Routing/, self)
end
