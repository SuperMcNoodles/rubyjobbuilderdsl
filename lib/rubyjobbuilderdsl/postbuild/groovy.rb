module JenkinsJob
  module Postbuild
    class PostbuildGroovy < BasicObject
      attr_reader :value_
      def initialize(value)
        @value_ = value
      end
    end
  end
end
