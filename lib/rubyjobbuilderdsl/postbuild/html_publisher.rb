module JenkinsJob
  module Postbuild
    class HtmlPublisher < BasicObject
      attr_reader :name, :keep_all_, :allow_missing_, :dir_, :file_

      def initialize(name)
        @name = name
      end

      def dir(value)
        @dir_ = value
      end

      def file(value)
        @file_ = value
      end

      def keep_all(value = true)
        @keep_all_ = value
      end

      def allow_missing(value = true)
        @allow_missing_ = value
      end
    end
  end
end
