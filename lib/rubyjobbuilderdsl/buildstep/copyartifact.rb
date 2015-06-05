module JenkinsJob
  module BuildStep
    class CopyArtifact < BasicObject
      attr_reader :project_, :filter_, :target_, :build_number_

      def initialize(artifact_job)
        @project_ = artifact_job
      end

      def file(*files)
        @filter_ = files.join(',')
      end

      def to(dir)
        @target_ = dir
      end

      def build_number(value = nil)
        @build_number_ = value
      end
    end
  end
end
