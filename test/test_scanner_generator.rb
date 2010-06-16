require 'test/unit'
require 'routicle'

class TestScannerGenerator < Test::Unit::TestCase
  def test_add_id
    generator = Routicle::ScannerGenerator.new
    generator << ':id'

    assert_equal :ID, generator.lexemes.first.first
  end

  def test_add_foo
    generator = Routicle::ScannerGenerator.new
    generator << 'foo'

    assert_equal 1, generator.lexemes.length
  end

  def test_add_two_foo
    generator = Routicle::ScannerGenerator.new
    generator << 'foo/foo'

    assert_equal 2, generator.lexemes.length
  end

  def test_token_sequence
    generator = Routicle::ScannerGenerator.new
    seq = generator.add 'foo/foo'

    assert_equal(3, seq.length)
    assert_equal([:STRING1, :SLASH, :STRING1], seq)

  end

  def test_token_names_slash
    generator = Routicle::ScannerGenerator.new
    seq = generator.add '/foo'

    assert_equal(2, seq.length)
    assert_equal([:SLASH, :STRING1], seq)
  end

  def test_token_names_id
    generator = Routicle::ScannerGenerator.new
    seq = generator.add '/foo/:id'

    assert_equal(4, seq.length)
    assert_equal([:SLASH, :STRING1, :SLASH, :ID], seq)
  end
end
