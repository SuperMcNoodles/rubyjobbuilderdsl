module JenkinsJob
  module Postbuild
    class CloverPhpPublisher < BasicObject
      attr_reader :xml_location_, :html_report_dir_, :archive_,
                  :healthy_target_, :unhealthy_target_, :failing_target_

      def initialize
        @archive_ = true
      end

      def xml_location(value)
        @xml_location_ = value
      end

      def html_report_dir(value)
        @html_report_dir_ = value
      end

      def archive(value = true)
        @archive_ = value
      end

      def healthy_target(value)
        @healthy_target_ = value
      end

      def unhealthy_target(value)
        @unhealthy_target_ = value
      end

      def failing_target(value)
        @failing_target_ = value
      end
    end
  end
end
