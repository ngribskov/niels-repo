require 'csv'

class CodeViolations
  attr_accessor :violation_category_hash, :violations

  def initialize(filename)
    @violations = CSV.read(filename, headers: true)
    @violation_category_hash = {}
  end

  def sort_by_category
    @violations.each do |i|
      category =  @violation_category_hash[i['violation_category']]
      if @violation_category_hash.key?(i['violation_category']) == false
        date = i['violation_date']
        @violation_category_hash.store("#{i['violation_category']}",{'first'=>date,'last'=>date,'count'=>1})
      else
        date = i['violation_date']
        max = date > category['last'] ? date : category['last']
        min = date < category['first'] ? date : category['first']
        @violation_category_hash[i['violation_category']]['first'] = min
        @violation_category_hash[i['violation_category']]['last'] = max
        @violation_category_hash[i['violation_category']]['count'] += 1
      end
    end

  end

  def format_results
    @violation_category_hash.each do |i|
      puts "Category: #{i[0]}, Violations: #{i[1]['count']}, First Violation: #{i[1]['first']}, Last Violation: #{i[1]['last']}"
    end
  end

end

def main
  violations = CodeViolations.new('./Violations-2012.csv')
  violations.sort_by_category
  violations.format_results
end

main
