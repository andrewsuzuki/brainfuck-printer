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

		cells = [0]

		bytes.each_with_index do |c, i|
			nearest_10 = c.round(-1) # get c's closest multiple of 10
			part1_times = nearest_10 / 10

			# determine +/- depending on comparison with c
			plus_or_minus = lambda {|nearest| if nearest < c then "+" else "-" end }
			
			candidates = []

			base_of_10m = ">" + ("+" * part1_times)
			
			# candidate 1: create base in loop (multiple of ten), then increment/decrement
			candidates.push([base_of_10m, ">" + (plus_or_minus.call(nearest_10) * (c - nearest_10).abs) + ".", lambda {cells.push(c)}])

			# candidate 2+: shift to previous cells (or not), modify, print, then shift back
			cells.each_with_index do |cell, i|
				if i == 0 then next end # skip first false cell
				shift = cells.count - i - 1 # determine shifts to make to get to cell and back
				candidates.push(["", ("<" * shift) + (plus_or_minus.call(cell) * (c - cell).abs) + "." + (">" * shift), lambda {cells[i] = c}])
			end
			
			# determine winner (whatever's shortest)
			candidate_lengths = []
			candidates.each {|can| candidate_lengths.push(can[0].length + can[1].length) }
			winner = candidate_lengths.each_with_index.min[1]

			part1.push(candidates[winner][0])
			part2.push(candidates[winner][1])

			candidates[winner][2].call() # execute winning candidate's lamda
		end

		p_delim = lambda {|string| print string + delim() }
		
		p_delim.call("+" * 10)
		p_delim.call("[")
		p_delim.call(part1.reject!(&:empty?).join(delim()))
		p_delim.call("<" * part1.count {|x| x != "" })
		p_delim.call("-")
		p_delim.call("]")

		part2_str = part2.join(delim())
		# optimize by removing side-by-side shifts and such
		remove = ["><", "<>", "+-", "-+"]
		includes = lambda { remove.each { |rep| if part2_str.include?(rep) then return true end }; return false }
		while includes.call()
			remove.each {|rep| part2_str.gsub!(rep, "") }
		end
		# remove tail not-periods
		until part2_str[-1] == '.'
			part2_str = part2_str[0..-2]
		end
		print part2_str

		print "\n"
	end
end
