class AddDefaultsToContracts < ActiveRecord::Migration
  def self.up
    connection.execute("ALTER TABLE contracts MODIFY contract_type_id int default 1")
    connection.execute("ALTER TABLE contracts MODIFY contract_periodicity_type_id int default 1")
    connection.execute("ALTER TABLE contracts MODIFY contract_rate_type_id int default 1")
  end

  def self.down
  end
end
