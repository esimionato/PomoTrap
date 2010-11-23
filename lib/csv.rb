require 'fastercsv'

class CSV

  def self.append(filename, content)
    currents = FasterCSV.read(filename)
    FasterCSV.open(filename, "w") do |csv|
      currents.each do |current|
        csv << current
      end
      csv << content
    end
  end
  
  def self.read(filename)
    FasterCSV.read(filename)
  end


end