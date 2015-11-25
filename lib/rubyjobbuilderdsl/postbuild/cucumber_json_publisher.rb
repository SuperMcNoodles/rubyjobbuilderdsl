module JenkinsJob
  module Postbuild
    class CucumberJsonPublisher < BasicObject
      attr_reader :test_results_, :ignore_bad_tests_

      def initialize
        @test_results_ = 'results.json'
        @ignore_bad_tests_ = false
      end

      def test_results(value)
        @test_results_ = value
      end

      def ignore_bad_tests(value)
        @ignore_bad_tests_ = value
      end
    end
  end
end
