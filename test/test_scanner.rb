require 'test/unit'
require 'routicle'

class TestScanner < Test::Unit::TestCase
  def test_tokenize
    gen = Routicle::ScannerGenerator.new
    scanner = gen.compile

    tokens = tokenize(scanner, '/')
    assert_equal([[:SLASH, '/']], tokens)
  end

  def test_tokenize_slash_id
    gen = Routicle::ScannerGenerator.new
    scanner = gen.compile

    tokens = tokenize(scanner, '/10')
    assert_equal([[:SLASH, '/'], [:ID, '10']], tokens)
  end

  def test_tokenize_user_input
    gen = Routicle::ScannerGenerator.new
    gen << %w{ foo bar }
    scanner = gen.compile

    tokens = tokenize(scanner, '/foo/bar/10')
    assert_equal([
      [:SLASH, '/'],
      [:STRING2, 'foo'],
      [:SLASH, '/'],
      [:STRING3, 'bar'],
      [:SLASH, '/'],
      [:ID, '10']
    ], tokens)
  end

  def tokenize scanner, string
    list = []
    scanner.scan_setup(string)
    while tok = scanner.next_token
      list << tok
    end
    list
  end
end
