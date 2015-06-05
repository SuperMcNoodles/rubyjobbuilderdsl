module JenkinsJob
  module Postbuild
    class Archive < BasicObject
      attr_reader :artifacts_, :exclude_, :allow_empty_, :latest_only_

      def file(*value)
        @artifacts_ = value.join(',')
      end

      def exclude(*value)
        @exclude_ = value.join(',')
      end

      def allow_empty(value = true)
        @allow_empty_ = value
      end

      def latest_only(value = true)
        @latest_only_ = value
      end
    end
  end
end
