module JenkinsJob
  module BuildStep
    class PhaseJob < BasicObject
      attr_reader :name, :ignore_result_, :retries_, :abort_others_

      def initialize(name)
        @name = name
        @ignore_result_ = false
        @retries_ = 0
        @abort_others_ = false
      end

      def ignore_result(value = true)
        @ignore_result_ = value
      end

      def retries(value)
        @retries_ = value
      end

      def abort_others(value = true)
        @abort_others_ = value
      end
    end
  end
end
