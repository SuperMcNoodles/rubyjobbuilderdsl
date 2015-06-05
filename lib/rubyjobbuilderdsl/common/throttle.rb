module JenkinsJob
  module Common
    class Throttle < BasicObject
      attr_reader :categories_, :max_per_node_, :max_total_

      def initialize
        @max_per_node_ = 1
        @max_total_ = 0
      end

      def max_per_node(value)
        @max_per_node_ = value
      end

      def max_total(value)
        @max_total_ = value
      end

      def category(*value)
        @categories_ = value
      end
    end
  end
end
