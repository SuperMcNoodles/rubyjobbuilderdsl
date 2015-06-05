# dsl methods for job builder
module JenkinsJob
  module Postbuild
    class XUnitPublisher < BasicObject
      attr_reader :test_results_pattern_,
                  :failed_threshold_, :unstable_threshold_

      THRESH_HOLDS = [:total_failed_tests, :new_failed_tests,
                      :total_skipped_tests, :new_skipped_tests]

      def initialize(test_results_pattern)
        @test_results_pattern_ = test_results_pattern

        @debug_ = false
        @keep_junit_reports_ = false
        @skip_junit_archiver_ = false

        @failed_threshold_ =  {}
        @unstable_threshold_ =  {}
      end

      def test_results_pattern(value)
        @test_results_pattern_ = value
      end

      def failed_threshold(params = {})
        @failed_threshold_ =  params
      end

      def unstable_threshold(params = {})
        @unstable_threshold_ = params
      end
    end
  end
end
