module JenkinsJob
  module Postbuild
    class PMDPublisher < BasicObject
      attr_reader :pmd_results_, :threshold_limit_

      def initialize
        @threshold_limit_ = 'low'
      end

      def pmd_results(value)
        @pmd_results_ = value
      end

      def threshold_limit(value)
        @threshold_limit_ = value
      end
    end
  end
end
