# dsl methods for job builder
module JenkinsJob
  module Postbuild
    class EmailPublisher < BasicObject
      attr_reader :recipients_, :notify_every_unstable_build_,  :send_to_individuals_

      def initialize(recipients)
        @recipients_ = recipients

        @notify_every_unstable_build_ = true
        @send_to_individuals_ = false
      end

      def notify_every_unstable_build(value)
        @notify_every_unstable_build_ = value
      end

      def send_to_individuals(value = true)
        @send_to_individuals_ = value
      end
    end
  end
end
