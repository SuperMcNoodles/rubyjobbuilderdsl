module JenkinsJob
  module Postbuild
    class PostbuildScript < BasicObject
      attr_reader :builders_
      def initialize
        @builders_ = []
      end

      def add(step)
        @builders_ << step
      end
    end
  end
end
