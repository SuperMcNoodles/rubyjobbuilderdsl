module JenkinsJob
  module Postbuild
    class TapPublisher < BasicObject
      attr_reader :test_results_,
                  :verbose_,
                  :fail_if_no_test_results_,
                  :fail_if_test_fail_,
                  :include_diagnostics_,
                  :require_plan_

      def initialize(test_restult)
        @test_results_ = test_restult
        @fail_if_test_fail_ = true
        @fail_if_no_test_results_ = true
        @include_diagnostics_ = true
        @require_plan_ = false
      end

      def test_results(value)
        @test_results_ = value
      end

      def verbose(value = true)
        @verbose_ = value
      end

      def fail_if_no_test_results(value = true)
        @fail_if_no_test_results_ = value
      end

      def fail_if_test_fail(value = true)
        @fail_if_test_fail_ = value
      end

      def include_diagnostics(value = true)
        @include_diagnostics_ = value
      end

      def require_plan(value = true)
        @require_plan_ = value
      end
    end
  end
end
