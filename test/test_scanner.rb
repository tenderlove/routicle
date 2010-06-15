require 'test/unit'
require 'routicle'

class TestScanner < Test::Unit::TestCase
  def test_tokenize
    gen = Routicle::ScannerGenerator.new
    gen << '/'
    scanner = gen.compile

    tokens = tokenize(scanner, '/')
    assert_equal([[:SLASH, '/']], tokens)
  end

  def test_tokenize_slash_id
    gen = Routicle::ScannerGenerator.new
    gen << '/:id'
    scanner = gen.compile

    tokens = tokenize(scanner, '/10')
    assert_equal([[:SLASH, '/'], [:ID, '10']], tokens)
  end

  def test_tokenize_user_input
    gen = Routicle::ScannerGenerator.new
    gen << '/foo/bar/:id'
    scanner = gen.compile

    tokens = tokenize(scanner, '/foo/bar/10')
    assert_equal([
      [:SLASH, '/'],
      [:STRING1, 'foo'],
      [:SLASH, '/'],
      [:STRING2, 'bar'],
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
