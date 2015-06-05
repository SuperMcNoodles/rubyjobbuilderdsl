module JenkinsJob
  module Common
    class LogRotate < BasicObject
      attr_reader :days_to_keep_, :num_to_keep_,
                  :artifact_days_to_keep_, :artifact_num_to_keep_

      def days_to_keep(value)
        @days_to_keep_ = value
      end

      def num_to_keep(value)
        @num_to_keep_ = value
      end

      def artifact_days_to_keep(value)
        @artifact_days_to_keep_ = value
      end

      def artifact_num_to_keep(value)
        @artifact_num_to_keep_ = value
      end
    end
  end
end
