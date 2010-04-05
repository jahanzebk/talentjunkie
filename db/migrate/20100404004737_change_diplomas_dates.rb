class ChangeDiplomasDates < ActiveRecord::Migration
  def self.up
    add_column :diplomas, :from, :datetime
    add_column :diplomas, :to, :datetime
    
    ActiveRecord::Base.transaction do
      Diploma.all.each do |diploma|
        
        if diploma.from_month.present? and diploma.from_year.present?
          diploma.from =  {:year => diploma.from_year, :month => diploma.from_month}
        end
      
        if diploma.to_month.present? and diploma.to_year.present?
          diploma.to = {:year => diploma.to_year, :month => diploma.to_month}
        end
      
        diploma.save!
      end
    end
    
    remove_column :diplomas, :from_month
    remove_column :diplomas, :from_year
    remove_column :diplomas, :to_month
    remove_column :diplomas, :to_year
  end

  def self.down
    add_column :diplomas, :from_month, :integer
    add_column :diplomas, :from_year, :integer
    add_column :diplomas, :to_month, :integer
    add_column :diplomas, :to_year, :integer
    
    ActiveRecord::Base.transaction do
      Diploma.all.each do |diploma|
        
        if diploma.from.present?
          diploma.from_month =  diploma.from.month
          diploma.from_year =  diploma.from.year
        end
      
        if diploma.to.present?
          diploma.to_month =  diploma.to.month
          diploma.to_year =  diploma.to.year
        end
      
        diploma.save!
      end
    end
    
    remove_column :diplomas, :to
    remove_column :diplomas, :from
  end
end
