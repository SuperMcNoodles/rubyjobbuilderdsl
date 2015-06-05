module JenkinsJob
  module Common
    class BlockingJob < BasicObject
      attr_reader :jobs_

      def initialize(*value)
        @jobs_  = value
      end
    end
  end
end
