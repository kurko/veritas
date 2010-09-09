require 'spec_helper'

describe 'Veritas::Optimizer::Relation::Operation::Reverse::UnoptimizedOperand#optimize' do
  subject { object.optimize }

  let(:klass)    { Optimizer::Relation::Operation::Reverse::UnoptimizedOperand }
  let(:order)    { Relation.new([ [ :id, Integer ] ], [ [ 1 ] ].each).order    }
  let(:relation) { order.reverse                                               }
  let(:object)   { klass.new(relation)                                         }

  before do
    object.operation.should be_kind_of(Relation::Operation::Reverse)
  end

  it { should_not equal(relation) }

  it { should eql(relation) }

  its(:operand) { should equal(order) }
end