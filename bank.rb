require_relative 'categories'

@transactions = {}
@running_total = 0

def add_transaction(cat, amount)
  cat = cat.to_s.capitalize
  amount = amount.to_f
  @transactions[cat] = 0 if @transactions[cat].nil?
  @transactions[cat] += amount
  @running_total += amount
end

def find_category(name)
  @categories.each do |txt, cat|
    return cat if name.downcase.include? txt.downcase
  end

  STDERR.puts "No category for #{name}"
  :no_category
end

def load_qif(file)
  require 'qif'
  qif = Qif::Reader.new(open(file))

  qif.each do |transaction|
    p = transaction.payee
    p = transaction.category if p.nil?
    if p.nil?
      STDERR.puts p.inspect
    end
    add_transaction(find_category(p), transaction.amount)
    #puts transaction.inspect
    #puts [transaction.payee, transaction.amount].join(", ")
  end
end

Dir.glob('./*.qif').each do |file|
  load_qif(file)
end

puts "Total #{@running_total}"

require 'chartkick'
include Chartkick::Helper

template = "<%= column_chart @transactions%>"
renderer = ERB.new(template)

puts '<script src="https://www.google.com/jsapi"></script>'
puts '<script src="chartkick.js"></script>'
puts renderer.result()
