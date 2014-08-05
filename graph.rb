require "set"

class Graph
	def initialize()
		@edges = {}
	end

	def add(from, to, weight)
		raise "weight must be striclty positive." unless weight > 0
		destinations = @edges[from]
		if (not destinations)
			@edges[from] = {}
			destinations = @edges[from] 
		end

		if destinations[to]
			print "Warning : mapping already defined for #{from} -> #{to}." +
				"Old weight was #{destinations[to]}, new weight will be #{weight}."
		end

		destinations[to] = weight
	end

	def destinations(from)
		destinations = @edges[from]
		(destinations)? destinations : {}
	end

	def nodes()
		nodes = Set.new
		@edges.each do |origin,destinations|
			nodes.add origin
			destinations.keys.each do |destination|
				nodes.add destination
			end
		end
		nodes
	end

end