module JenkinsJob
  module BuildStep
    class Xvfb < BasicObject
      attr_reader :install_name_, :screen_, :debug_, :timeout_, :display_name_offset_, :shutdown_with_build_, :auto_display_name_, :parallel_build_

      def initialize
        @install_name_ = 'Xvfb'
        @screen_ = '1024x768x24'
        @debug_ = false
        @timeout_ = 0
        @display_name_offset_ = 1
        @shutdown_with_build_ = false
        @auto_display_name_ = true
        @parallel_build_ = false
      end

      def install_name(value)
        @install_name_ = value
      end

      def screen(value)
        @screen_ = value
      end

      def timeout(value)
        @timeout_ = value
      end

      def display_name_offset(value)
        @display_name_offset_ = value
      end

      def shutdown_with_build(value)
        @shutdown_with_build_ = value
      end

      def auto_display_name(value)
        @auto_display_name_ = value
      end

      def parallel_build(value)
        @parallel_build_ = value
      end
    end
  end
end
