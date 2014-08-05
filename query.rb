require_relative "graph"
require_relative "analyzer"
require 'optparse'
require 'ostruct'

class QueryOptions
	def self.parse(args)
		options = OpenStruct.new
		options.filename = nil
		options.query = nil
		options.source = nil
		options.target = nil

		opt_parser = OptionParser.new do |opts|
			opts.banner = "Usage: query.rb [options]"

			opts.separator ""
			opts.separator "Specific options:"

			opts.on("-g", "--graph [GRAPH_FILENAME_CSV]",
				"Require the csv file describing the graph.") do |filename|
				options.filename = filename
			end

			opts.on("-q","--query [QUERY]", [:path?, :min, :shortest],
				"Select query type (path?, min, shortest)") do |query|
				options.query = query
			end

			opts.on("-s","--source [SOURCE]",
				"Select the source.") do |source|
				options.source = source
			end

			opts.on("-t","--target [TARGET]",
				"Select the target.") do |target|
				options.target = target
			end
		end

		opt_parser.parse!(args)
    	if not options.filename or
    		not options.query or
    		not options.source or
    		not options.target
    		print opt_parser.help()
    		abort "Missing parameters."
    	else
    		options
    	end
	end
end

options = QueryOptions.parse(ARGV)
graph = Graph.new

line_number=0
File.open(options.filename).each do |line|
	line_number += 1
	next if line_number == 1
	clean = line.gsub(/ */,'')
	source,target,distance = clean.split(/,/)
	if not source or not target or not distance
		raise "Format not supported line n°#{line_number} : #{line}."
	end
	graph.add(source,target,distance.to_f)
end

analyzer = Analyzer.new(graph)
source = options.source
target = options.target
case options.query
	when :path?
		print analyzer.path_between?(source,target)
	when :min
		print analyzer.min_weight(source,target)
	when :shortest
		print analyzer.shortest_paths(source,target)
	else
		abort "Unsupported query."
end

