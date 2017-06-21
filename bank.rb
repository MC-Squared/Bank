def load_qif(file)
  require 'qif'
  qif = Qif::Reader.new(open(file))

  @transactions = {}

  qif.each do |transaction|
    @transactions[transaction.payee] = 0 if @transactions[transaction.payee].nil?

    @transactions[transaction.payee] += transaction.amount.to_f
    #puts [transaction.payee, transaction.amount].join(", ")
  end
end

Dir.glob('./*.qif').each do |file|
  load_qif(file)
end



require 'chartkick'
include Chartkick::Helper
@data = [
  ["Washington", "1789-04-29", "1797-03-03"],
  ["Adams", "1797-03-03", "1801-03-03"],
  ["Jefferson", "1801-03-03", "1809-03-03"]
]
template = "<%= column_chart @transactions%>"
renderer = ERB.new(template)

puts '<script src="https://www.google.com/jsapi"></script>'
puts '<script src="chartkick.js"></script>'
puts renderer.result()
