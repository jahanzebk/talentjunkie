File.open("oil_and_gas_producers.txt").each do |line|
  org = line.strip
  puts "INSERT INTO organizations (industry_id, name) VALUES (97, '#{org}');"
end