module JenkinsJob
  module Postbuild
    class PostbuildTrigger < BasicObject
      attr_reader :project_, :fail_on_missing_, :file_,
                  :predefined_parameters_, :current_parameters_, :trigger_with_no_parameters_,
                  :pass_through_git_commit_

      def initialize(*project)
        @project_ = project
        @trigger_with_no_parameters_ = false
      end

      def fail_on_missing(value = false)
        @fail_on_missing_ = value
      end

      def file(value)
        @file_ = value
      end

      def predefined_parameters(value)
        @predefined_parameters_ = value.map { |key, val| "#{key}=#{val}" }.join("\n")
      end

      def current_parameters(value)
        @current_parameters_ = value
      end

      def trigger_with_no_parameters(value)
        @trigger_with_no_parameters_ = value
      end

      def pass_through_git_commit(value = true)
        @pass_through_git_commit_ = value
      end
    end
  end
end
