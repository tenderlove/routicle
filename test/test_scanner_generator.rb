require 'test/unit'
require 'routicle'

class TestScannerGenerator < Test::Unit::TestCase
  def test_default_tokens
    generator = Routicle::ScannerGenerator.new

    assert_equal([:ID, :SLASH], generator.possible_tokens)
  end

  def test_add_id
    generator = Routicle::ScannerGenerator.new
    generator << [':id']

    assert_equal([:ID, :SLASH], generator.possible_tokens)
  end

  def test_add_foo
    generator = Routicle::ScannerGenerator.new
    generator << ['foo']

    assert_equal(3, generator.possible_tokens.length)
  end

  def test_add_two_foo
    generator = Routicle::ScannerGenerator.new
    generator << %w{ foo foo }

    assert_equal(3, generator.possible_tokens.length)
  end

  def test_token_sequence
    generator = Routicle::ScannerGenerator.new
    seq = generator.add %w{ foo foo }

    assert_equal(2, seq.length)
    assert_equal([:STRING2, :STRING2], seq)
  end
end
