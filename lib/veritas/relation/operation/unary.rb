module Veritas
  class Relation
    module Operation
      module Unary
        attr_reader :relation

        def initialize(relation)
          @relation = relation
        end

        def header
          @header ||= relation.header
        end

        def body
          @body ||= self.class::Body.new(relation.body, header)
        end
      end # module Unary
    end # module Operation
  end # class Relation
end # module Veritas