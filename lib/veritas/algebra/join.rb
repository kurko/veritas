# encoding: utf-8

module Veritas
  module Algebra

    # The join between relations
    class Join < Relation
      include Relation::Operation::Combination

      # The common headers between the operands
      #
      # @return [Header]
      #
      # @api private
      attr_reader :join_header

      # Initialize a Join
      #
      # @param [Relation] left
      # @param [Relation] right
      #
      # @return [undefined]
      #
      # @api private
      def initialize(left, right)
        super
        right_header     = right.header
        @join_header     = left.header  & right_header
        @disjoint_header = right_header - join_header
      end

      # Iterate over each tuple in the set
      #
      # @example
      #   join = Join.new(left, right)
      #   join.each { |tuple| ... }
      #
      # @yield [tuple]
      #
      # @yieldparam [Tuple] tuple
      #   each tuple in the set
      #
      # @return [self]
      #
      # @api public
      def each(&block)
        return to_enum unless block_given?
        util  = Relation::Operation::Combination
        index = build_index

        left.each do |left_tuple|
          right_tuples = index[join_tuple(left_tuple)]
          util.combine_tuples(header, left_tuple, right_tuples, &block)
        end

        self
      end

    private

      # Build an index using every tuple in the right relation
      #
      # @return [Hash]
      #
      # @api private
      def build_index
        index = Hash.new { |hash, tuple| hash[tuple] = Set.new }
        right.each { |tuple| index[join_tuple(tuple)] << disjoint_tuple(tuple) }
        index
      end

      # Generate a tuple with the join attributes between relations
      #
      # @return [Tuple]
      #
      # @api private
      def join_tuple(tuple)
        tuple.project(join_header)
      end

      # Generate a tuple with the disjoint attributes between relations
      #
      # @return [Tuple]
      #
      # @api private
      def disjoint_tuple(tuple)
        tuple.project(@disjoint_header)
      end

      module Methods
        extend Aliasable

        inheritable_alias(:+ => :join)

        # Return a relation that is the join of two relations
        #
        # @example natural join
        #   join = relation.join(other)
        #
        # @example theta-join using a block
        #   join = relation.join(other) { |r| r.a.gte(r.b) }
        #
        # @param [Relation] other
        #   the other relation to join
        #
        # @yield [relation]
        #   optional block to restrict the tuples with
        #
        # @yieldparam [Relation] relation
        #   the context to evaluate the restriction with
        #
        # @yieldreturn [Function, #call]
        #   predicate to restrict the tuples with
        #
        # @return [Join, Restriction]
        #
        # @api public
        def join(other)
          relation = Join.new(self, other)
          relation = relation.restrict { |context| yield context } if block_given?
          relation
        end

      end # module Methods

      Relation.class_eval { include Methods }

    end # class Join
  end # module Algebra
end # module Veritas
