module Proofcheater
  class Attributes

    # Turn Any hash into attributes of a class
    # Usage: Proofcheater::Attribute.new({:album => "Test Album", :date => "Oct. 2001"})

    def initialize(attributes)
      attributes.each do |k,v|
        k = k.downcase
        self.instance_variable_set("@#{k}", v)
        self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
        self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
      end
    end

  end
end
