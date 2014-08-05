require_relative "graph"
require "set"

class Analyzer
	def initialize(graph)
		@graph = graph
	end

	def path_between?(from,to)
		visited = Set.new [from]
		seeds = [from]
		until seeds.empty? do
			next_seeds = []
			seeds.each do |seed|
				destinations = @graph.destinations(seed)
				destinations.each do |destination,weight|
					return true if destination == to
					next_seeds.push destination unless visited.include? destination
					visited.add destination
				end
			end
			seeds = next_seeds
		end
		false
	end

	def min_weight(from,to)
		return 0 if from == to
		weights,origins = dijkstra(from,to)
		weights[to]
	end

	def shortest_path(from,to)
		return [from] if from == to
		weights,origins = dijkstra(from,to)
		return nil unless weights[to]
		current = to
		path=[to]
		while origins[current]
			origin = origins[current].first
			path.push origin
			current = origin
		end
		path.reverse
	end

	def walk(path,origins,paths)
		froms = origins[path.last]
		if froms
			froms.each do |origin|
				walk(Array.new(path).push(origin), origins, paths)
			end
		else
			paths.push(path)
		end
	end

	def shortest_paths(from,to)
		return [[from]] if from == to
		weights,origins = dijkstra(from,to)
		return nil unless weights[to]
		current = to
		paths=[]
		walk([to],origins,paths)
		paths.map { |path| path.reverse  }
	end

	def dijkstra(from,to)
		weights = { from => 0 }
		origins = {}
		nodes = @graph.nodes()
		until nodes.empty?
			# sorted subset of weights
			sorted_weights = weights.select { |node, weight|
				nodes.include? node}.sort_by { |node, weight| weight }

			# the lightest, break if early end
			lightest = sorted_weights.first
			if not lightest
				return [weights,origins]
			end
			current = lightest.first
			if current == to 
				return [weights,origins]
			end
			nodes.delete current

			# update weights around current
			@graph.destinations(current).each do |destination,weight|
				next unless nodes.include? destination
				updated_weight = weight
				if weights[current]
					updated_weight += weights[current]
				end
				if not weights[destination] or updated_weight < weights[destination]
					weights[destination] = updated_weight
					origins[destination] = [current]
				elsif updated_weight == weights[destination]
					origins[destination].push(current)
				end
			end
		end
		[weights,origins]
	end

end