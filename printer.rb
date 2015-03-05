class BrainfuckPrinter
	def initialize(statement = "", delim = "")
		set_statement(statement)
		@delim = delim
	end

	def statement
		@statement
	end

	def delim
		@delim
	end

	def set_statement(statement)
		@statement = statement
	end

	def set_delim(delim)
		@delim = delim
	end

	def output()
		bytes = statement().bytes.to_a

		part1 = []
		part2 = []

		previous = 0
		bytes.each_with_index do |c, i|
			nearest_10 = c.round(-1) # get c's closest multiple of 10
			part1_times = nearest_10 / 10

			# determine +/- depending on comparison with c
			plus_or_minus = lambda {|nearest| if nearest < c then "+" else "-" end }
			
			candidates = []

			base_of_10m = ">" + ("+" * part1_times)
			
			candidates.push(["", (plus_or_minus.call(previous) * (c - previous).abs) + "."])	

			candidates.push([base_of_10m, ">" + (plus_or_minus.call(nearest_10) * (c - nearest_10).abs) + "."])
			
			# determine winner (whatever's shortest)
			candidate_lengths = []
			candidates.each {|can| candidate_lengths.push(can[0].length + can[1].length) }
			winner = candidate_lengths.each_with_index.min[1]

			part1.push(candidates[winner][0])
			part2.push(candidates[winner][1])

			# keep track of previous
			previous = c
		end

		p_delim = lambda {|string| print string + delim() }
		
		p_delim.call("++++++++++")
		p_delim.call("[")
		p_delim.call(part1.reject!(&:empty?).join(delim()))
		p_delim.call("<" * part1.count {|x| x != "" })
		p_delim.call("-")
		p_delim.call("]")
		print part2.join(delim())
		puts ""
	end
end
