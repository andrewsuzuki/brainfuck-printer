require_relative 'printer.rb'
if ARGV[0].nil?
	puts "No string specified."
	exit()
end
printer = BrainfuckPrinter.new(ARGV[0])
printer.output()
