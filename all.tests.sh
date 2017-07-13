#!/bin/bash
echo "CLEARING COVERAGE"
rm -rf coverage && mkdir coverage
echo "RUNNING RSPEC TESTS"
bundle exec rspec spec/models/vulnerability_spec.rb # RSpec unit tests
echo "RUNNING UNIT TESTS"
bundle exec rails test # simplest unit and ActiveRecord tests
echo "RUNNING CUCUMBER TESTS"
bundle exec cucumber # Integration tests
