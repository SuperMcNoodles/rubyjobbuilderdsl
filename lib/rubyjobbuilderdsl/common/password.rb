module JenkinsJob
  module Common
    class Password < BasicObject
      attr_reader :name_, :password_

      def initialize(name, password)
        @name_ = name
        @password_ = password
      end
    end
  end
end
