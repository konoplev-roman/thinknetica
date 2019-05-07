# frozen_string_literal: true

module InstanceCounter
  def self.included(klass)
    klass.extend ClassMethods
    klass.send :include, InstanceMethods

    klass.instances = 0
  end

  module ClassMethods
    attr_accessor :instances

    def inherited(subclass)
      subclass.instances = 0
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instances += 1
    end
  end
end
