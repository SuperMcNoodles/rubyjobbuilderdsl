module JenkinsJob
  module Common
    class Scms < BasicObject
      attr_reader :scms_

      def initialize
        @scms_ = []
      end

      def git(&block)
        git = Git.new
        git.instance_eval(&block)

        @scms_ << git
      end
    end
  end
end
