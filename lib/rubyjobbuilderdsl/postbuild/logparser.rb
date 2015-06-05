module JenkinsJob
  module Postbuild
    class LogParser < BasicObject
      attr_reader :rule_file_, :unstable_on_warning_, :fail_on_error_

      def initialize(rule_file)
        @rule_file_ = rule_file
        @unstable_on_warning_ = false
        @fail_on_error_ = false
      end

      def unstable_on_warning(value = true)
        @unstable_on_warning_ = value
      end

      def fail_on_error(value = true)
        @fail_on_error_ = value
      end
    end
  end
end
