class OpeningService < ModelService

  def initialize(serviceable)
    type = serviceable.class.to_s
    @var  = "@opening"
    self.instance_variable_set(@var, serviceable)
  end
  
  def views
    Stats::OpeningView.count(:conditions => "opening_id = #{@opening.id}")
  end
  
end