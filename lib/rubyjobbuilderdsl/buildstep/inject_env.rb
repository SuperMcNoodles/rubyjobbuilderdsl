module JenkinsJob
  module BuildStep
    class InjectEnv < BasicObject
      attr_reader :properties_content_, :properties_file_

      def initialize
      end

      def properties_content(value)
        @properties_content_ = value
      end

      def properties_file(value)
        @properties_file_ = value
      end
    end
  end
end
