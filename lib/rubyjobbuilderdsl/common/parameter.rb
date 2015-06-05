module JenkinsJob
  module Common
    class Parameter < BasicObject
      attr_reader :name, :default_, :description_

      def initialize(name)
        @name = name
      end

      def default(value)
        @default_ = value
      end

      def description(value)
        @description_ = value
      end
    end

    class PasswordParameter < Parameter
    end
  end
end
