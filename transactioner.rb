#!/usr/bin/env ruby

require 'json'
require 'pry'
require 'date'


class TBimport
  def initialize
    file = File.read("./exampleTBs/qbonlineTB.json")
    @TB = JSON.parse(file)
    date = Date.parse @TB["Header"]["EndPeriod"]
    currency = @TB["Header"]["Currency"]
    desc = "Import Trial Balance"
    @newTB = []
    @TB["Rows"]["Row"].each do |x|
      if x.has_key?("ColData")
        @newTB << {"Account" => x["ColData"][0]["value"], "Amt" => {"value" => x["ColData"][1]["value"].to_f - x["ColData"][2]["value"].to_f , "Cur" => currency}}
      end
    end
    @transaction = {"Prot"=>"Journal", "Txn" => {"Desc" => desc, "Date"=>date, "Postings"=>@newTB}}
  end

  def to_hash
    return @transaction
  end

  def writeDefault()
    File.open(@transaction["Txn"]["Date"].strftime("%d%m%Y"),"w"){|f| f.write(@transaction.to_json)}
  end

  def write(location)
    File.open(location,"w"){|f| f.write(@transactions.to_json)}
  end
end


TBimport.new().writeDefault()
