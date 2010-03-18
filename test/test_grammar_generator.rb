require 'test/unit'
require 'routicle'

class TestGrammarGenerator < Test::Unit::TestCase
  def test_gramgen
    gramgen = Routicle::GrammarGenerator.new
    gramgen.add [:SLASH, :ID], { :foo => :bar }
    grammar = gramgen.to_yacc

    assert_match(/class GeneratedGrammar/, grammar)
    assert_match(/SLASH/, grammar)
    assert_match(/ID/, grammar)
    assert_match(/rule/, grammar)
  end
end