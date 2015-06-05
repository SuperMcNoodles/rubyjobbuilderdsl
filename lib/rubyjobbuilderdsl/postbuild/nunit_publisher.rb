# dsl methods for job builder
module JenkinsJob
  module Postbuild
    class NUnitPublisher < BasicObject
      attr_reader :test_results_pattern_, :debug_, :keep_junit_reports_,
                  :skip_junit_archiver_

      def initialize(test_results_pattern)
        @test_results_pattern_ = test_results_pattern

        @debug_ = false
        @keep_junit_reports_ = false
        @skip_junit_archiver_ = false
      end

      def test_results_pattern(value)
        @test_results_pattern_ = value
      end
    end
  end
end
