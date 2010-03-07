class JobApplicationStage < ActiveRecord::Base
  
  def self.for(contract)
    JobApplicationStage.all(:conditions => "contract_id = #{contract.id}")
  end
  
end