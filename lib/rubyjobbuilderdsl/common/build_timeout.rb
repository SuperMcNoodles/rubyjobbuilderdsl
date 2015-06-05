module JenkinsJob
  module Common
    class BuildTimeout < BasicObject
      attr_reader :type_, :timeout_, :elastic_percentage_, :elastic_default_timeout_

      def initialize(type)
        @type_ = type
      end

      def timeout(value)
        @timeout_ = value
      end

      def elastic_percentage(value)
        @elastic_percentage_ = value
      end

      def elastic_default_timeout(value)
        @elastic_default_timeout_ = value
      end
    end
  end
end
