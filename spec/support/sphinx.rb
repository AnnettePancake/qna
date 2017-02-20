# frozen_string_literal: true
RSpec.configure do |config|
  # Transactional fixtures work with real-time indices
  config.use_transactional_fixtures = true

  config.before :each do |example|
    # Configure and start Sphinx for request specs
    if example.metadata[:sphinx]
      ThinkingSphinx::Test.init
      ThinkingSphinx::Test.start index: false
    end

    # Disable real-time callbacks if Sphinx isn't running
    ThinkingSphinx::Configuration.instance.settings['real_time_callbacks'] =
      !!example.metadata[:sphinx]
  end

  config.after(:each) do |example|
    # Stop Sphinx and clear out data after request specs
    if example.metadata[:sphinx]
      ThinkingSphinx::Test.stop
      ThinkingSphinx::Test.clear
    end
  end
end
