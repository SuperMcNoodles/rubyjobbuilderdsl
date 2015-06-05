module JenkinsJob
  module Postbuild
    class JavaDocPublisher < BasicObject
      attr_reader :doc_dir_, :keep_all_

      def initialize
        @keep_all_ = false
      end

      def doc_dir(value)
        @doc_dir_ = value
      end

      def keep_all(value = true)
        @keep_all_ = value
      end
    end
  end
end
