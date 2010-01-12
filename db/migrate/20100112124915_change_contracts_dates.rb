class ChangeContractsDates < ActiveRecord::Migration
  def self.up
    add_column :contracts, :from, :datetime
    add_column :contracts, :to, :datetime
    
    ActiveRecord::Base.transaction do
      Contract.all.each do |contract|
        
        if contract.from_month.present? and contract.from_year.present?
          contract.from =  DateTime.parse("#{contract.from_year}-#{contract.from_month}-01")
        end
      
        if contract.to_month.present? and contract.to_year.present?
          contract.to =  DateTime.parse("#{contract.to_year}-#{contract.to_month}-01") + 1.month - 1.second
        end
      
        contract.save!
      end
    end
    
    remove_column :contracts, :from_month
    remove_column :contracts, :from_year
    remove_column :contracts, :to_month
    remove_column :contracts, :to_year
  end

  def self.down
    add_column :contracts, :from_month, :integer
    add_column :contracts, :from_year, :integer
    add_column :contracts, :to_month, :integer
    add_column :contracts, :to_year, :integer
    
    ActiveRecord::Base.transaction do
      Contract.all.each do |contract|
        
        if contract.from.present?
          contract.from_month =  contract.from.month
          contract.from_year =  contract.from.year
        end
      
        if contract.to.present?
          contract.to_month =  contract.to.month
          contract.to_year =  contract.to.year
        end
      
        contract.save!
      end
    end
    
    remove_column :contracts, :to
    remove_column :contracts, :from
  end
end
