module JenkinsJob
  module BuildStep
    class Ant < BasicObject
      attr_reader :targets_, :buildfile_, :properties_, :java_opts_

      def initialize
        @targets_ = []
        @properties_ = {}
        @java_opts_ = []
      end

      def target(*value)
        @targets_ = value
      end

      def buildfile(value)
        @buildfile_ = value
      end

      def property(value)
        @properties_ = value
      end

      def java_opts(*value)
        @java_opts_ = value
      end
    end
  end
end
