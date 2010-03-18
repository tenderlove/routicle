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
end
