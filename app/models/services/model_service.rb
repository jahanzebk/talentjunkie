class ModelService
  
  def initialize(serviceable)
    type = serviceable.class.to_s
    @var  = "@#{type.underscore}"
    self.instance_variable_set(@var, serviceable)
  end
  
  def get_serviceable
    self.instance_variable_get(@var)
  end
  
end