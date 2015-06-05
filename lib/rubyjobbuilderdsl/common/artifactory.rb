module JenkinsJob
  module Common
    class Artifactory < BasicObject
      attr_reader :server_, :repository_, :deploy_, :resolve_, :build_info_

      def initialize
        @deploy_ = []
        @resolve_  = []
        @build_info_  = false
      end

      def server(value)
        @server_ = value
      end

      def repository(value)
        @repository_ = value
      end

      def deploy(*value)
        @deploy_ = value
      end

      def resolve(*value)
        @resolve_ = value
      end

      def build_info(value = true)
        @build_info_ = value
      end
    end
  end
end
