class BrainfuckPrinter
	def initialize(statement = nil)
		set_statement(statement)
	end

	def statement
		@statement
	end

	def set_statement(statement)
		@statement = statement
	end

	def print_bytes()
		statement().each_byte do |c|
			puts c
		end
	end

	def output()
		# TODO: have a candidate for part1 where it instead uses the 10 stored in cell#0
		# and uses that as the basis (copy and modify) for that cell
		# and same kinda thing for part2 i guess
		bytes = statement().bytes.to_a
		todo = bytes
		uniques = [] 
		copies = []
		close_enoughs = []

		part1 = []
		part2 = []

		previous = 0
		bytes.each_with_index do |c, i|
			nearest_10 = c.round(-1) # get c's closest multiple of 10
			part1_times = nearest_10 / 10

			plus_or_minus = lambda {|nearest| if nearest < c then "+" else "-" end }
			
			base_of_10m = ">" + ("+" * part1_times)

			candidates = []
			
			candidates.push(["", (plus_or_minus.call(previous) * (c - previous).abs) + "."])	

			candidates.push([base_of_10m, ">" + (plus_or_minus.call(nearest_10) * (c - nearest_10).abs) + "."])
			
			# determine winner (shortest)
			candidate_lengths = []
			candidates.each {|can| candidate_lengths.push(can[0].length + can[1].length) }
			winner = candidate_lengths.each_with_index.min[1]

			part1.push(candidates[winner][0])
			part2.push(candidates[winner][1])

			previous = c
		end
		
		print '++++++++++'
		print '['
		print part1.join()
		print "<" * part1.count {|x| x != "" }
		print "-"
		print ']'
		print part2.join()
		puts ""
	end
end
