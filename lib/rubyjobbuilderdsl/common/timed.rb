module JenkinsJob
  module Common
    class Timed < BasicObject
      attr_reader :value_
      def initialize(value)
        @value_ = value
      end
    end
  end
end
