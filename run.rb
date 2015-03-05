require_relative 'printer.rb'
if ARGV[0].nil?
	puts "No string specified."
	exit()
end
delim = if ARGV[1].nil? then "" else ARGV[1].gsub('\n', "\n") end
printer = BrainfuckPrinter.new(ARGV[0], delim)
printer.output()
