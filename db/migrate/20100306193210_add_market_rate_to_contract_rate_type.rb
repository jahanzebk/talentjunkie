class AddMarketRateToContractRateType < ActiveRecord::Migration
  def self.up
    connection.execute("INSERT INTO contract_rate_types VALUES (5, 'Market rate')")
    change_column :contracts, :rate, :string
  end

  def self.down
    change_column :contracts, :rate, :integer
    connection.execute("DELETE FROM contract_rate_types WHERE id = 5")
  end
end
