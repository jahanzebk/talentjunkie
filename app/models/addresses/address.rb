class Address < ActiveRecord::Base

  belongs_to :city
  validates_presence_of :address_1, :city_id

  def error_namespace
    "address"
  end

  def self.factory(params, city)
    case city.country.iso_code
      when "UK"
        @address = UkAddress.new({:address_1 => params[:address_1], :address_2 => params[:address_2], :postal_code => params[:postal_code], :city_id => city.id})
      when "US"
        @address = UsAddress.new({:address_1 => params[:address_1], :address_2 => params[:address_2], :postal_code => params[:postal_code], :city_id => city.id})
      else
        @address = GenericAddress.new({:address_1 => params[:address_1], :address_2 => params[:address_2], :postal_code => params[:postal_code], :city_id => city.id})
    end
    
    @address
  end
  
end
