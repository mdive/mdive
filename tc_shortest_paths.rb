require_relative "graph"
require_relative "analyzer"
require "test/unit"
require "set"

class TestShortestPaths < Test::Unit::TestCase

	def setup
		@graph = Graph.new
		@a = Analyzer.new(@graph)
	end

	def test_no_path
		assert_nil @a.shortest_paths(:a, :b)
	end

	def test_no_path_to
		@graph.add(:a, :b, 0.1)
		assert_nil @a.shortest_paths(:a, :c)
	end

	def test_no_path_from
		@graph.add(:a, :b, 0.1)
		assert_nil @a.shortest_paths(:c, :b)
	end

	def test_direct_path
		@graph.add(:a, :b, 0.1)
		assert_equal([[:a, :b]], @a.shortest_paths(:a, :b))
	end

	def test_no_direct_path
		@graph.add(:a, :b, 0.1)
		assert_nil @a.shortest_paths(:b, :a)
	end

	def test_indirect_path
		@graph.add(:a, :b, 0.1)
		@graph.add(:b, :c, 0.1)
		assert_equal([[:a, :b, :c]], @a.shortest_paths(:a, :c))
	end

	def test_no_indirect_path
		@graph.add(:a, :b, 0.1)
		@graph.add(:b, :c, 0.1)
		assert_nil @a.shortest_paths(:c, :a)
	end

	def test_shortest_path
		@graph.add(:a, :c, 0.5)
		@graph.add(:a, :b, 0.1)
		@graph.add(:b, :c, 0.1)
		assert_equal([[:a, :b, :c]], @a.shortest_paths(:a, :c))
	end

	def test_shortest_paths
		@graph.add(:a, :z, 0.5)

		@graph.add(:a, "1", 0.1)
		@graph.add("1", :z, 0.1)

		@graph.add(:a, "2", 0.1)
		@graph.add("2", :z, 0.1)

		@graph.add(:a, "3", 0.1)
		@graph.add("3", :z, 0.1)

		assert_equal([
			[:a, "1", :z],
			[:a, "2", :z],
			[:a, "3", :z]
			].to_set,
			@a.shortest_paths(:a, :z).to_set)
	end

end