module JenkinsJob
  module BuildStep
    class Shell < BasicObject
      attr_reader :cmd_
      def initialize(cmd)
        @cmd_ = cmd
      end
    end

    class Batch < BasicObject
      attr_reader :cmd_
      def initialize(cmd)
        @cmd_ = cmd
      end
    end

    class Powershell < BasicObject
      attr_reader :cmd_
      def initialize(cmd)
        @cmd_ = cmd
      end
    end
  end
end
