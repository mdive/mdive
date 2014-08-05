require_relative "graph"
require_relative "analyzer"
require "test/unit"

class TestMinWeight < Test::Unit::TestCase

	def setup
		@graph = Graph.new
		@a = Analyzer.new(@graph)
	end

	def test_no_path
		assert_nil @a.min_weight(:a, :b)
	end

	def test_no_path_to
		@graph.add(:a, :b, 0.1)
		assert_nil @a.min_weight(:a, :c)
	end

	def test_no_path_from
		@graph.add(:a, :b, 0.1)
		assert_nil @a.min_weight(:c, :b)
	end

	def test_direct_path
		@graph.add(:a, :b, 0.1)
		assert_equal(0.1, @a.min_weight(:a, :b))
	end

	def test_no_direct_path
		@graph.add(:a, :b, 0.1)
		assert_nil @a.min_weight(:b, :a)
	end

	def test_indirect_path
		@graph.add(:a, :b, 0.1)
		@graph.add(:b, :c, 0.1)
		assert_equal(0.2, @a.min_weight(:a, :c))
	end

	def test_no_indirect_path
		@graph.add(:a, :b, 0.1)
		@graph.add(:b, :c, 0.1)
		assert_nil @a.min_weight(:c, :a)
	end

	def test_shortest_path
		@graph.add(:a, :c, 0.5)
		@graph.add(:a, :b, 0.1)
		@graph.add(:b, :c, 0.1)
		assert_equal(0.2, @a.min_weight(:a, :c))
	end

end