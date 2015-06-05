module JenkinsJob
  module Common
    class Gerrit < BasicObject
      attr_reader :change_merged_, :patchset_uploaded_, :comment_added_, :projects_

      def initialize
        @comment_added_ = []
        @projects_ = []
      end

      def change_merged(value = true)
        @change_merged_ = value
      end

      def patchset_uploaded(value = true)
        @patchset_uploaded_ = value
      end

      def comment_added(param = {})
        param.each do |k, v|
          @comment_added_ << {
            :approval_category => k,
            :approval_value => v
          }
        end
      end

      def project(project, &block)
        project = GerritProject.new(project)
        project.instance_eval(&block)

        @projects_ << project
      end
    end

    class GerritProject < BasicObject
      attr_reader :project_, :branches_, :files_

      def initialize(project)
        @project_ = project
        @branches_ = ['**']
      end

      def branch(*value)
        @branches_ = value
      end

      def file(*value)
        @files_ = value
      end
    end
  end
end
