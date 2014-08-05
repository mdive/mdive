require_relative "graph"
require_relative "analyzer"
require "test/unit"

class TestPathBetween < Test::Unit::TestCase

	def setup
		@graph = Graph.new
		@a = Analyzer.new(@graph)
	end

	def test_no_path
		assert (not @a.path_between?(:a, :b))
	end

	def test_no_path_to
		@graph.add(:a, :b, 0.1)
		assert (not @a.path_between?(:a, :c))
	end

	def test_no_path_from
		@graph.add(:a, :b, 0.1)
		assert (not @a.path_between?(:c, :b))
	end

	def test_direct_path
		@graph.add(:a, :b, 0.1)
		assert @a.path_between?(:a, :b)
	end

	def test_no_direct_path
		@graph.add(:a, :b, 0.1)
		assert (not @a.path_between?(:b, :a))
	end

	def test_indirect_path
		@graph.add(:a, :b, 0.1)
		@graph.add(:b, :c, 0.1)
		assert @a.path_between?(:a, :c)
	end

	def test_no_indirect_path
		@graph.add(:a, :b, 0.1)
		@graph.add(:b, :c, 0.1)
		assert (not @a.path_between?(:c, :a))
	end

end