require 'test/unit'
require 'routicle'

class TestRouticle < Test::Unit::TestCase
  def setup
    @template = Routicle::Template.new
  end

  def test_match
    @template.map('/foo', { :a => :b })
    router = @template.compile

    assert_equal({:a => :b}, router.match('/foo'))
  end

  def test_match_with_id
    @template.map('/foo/:id/bar', { :a => :b })
    router = @template.compile

    assert_equal({:a => :b}, router.match('/foo/1/bar'))
  end

  def test_route_to_list
    dest = [{ :a => :b }, 'cookie', 'monster']
    @template.map('/foo/:id/bar', dest)
    router = @template.compile

    assert_equal(dest, router.match('/foo/1/bar'))
  end

  def test_multiroute
    @template.map '/foo/:id/bar', { :foo => :bar }
    @template.map '/foo/:id/baz', { :foo => :baz }
    @template.map '/foo/:id/foo', { :foo => :foo }
    @template.map '/:id',         '/:id'

    router = @template.compile
    assert_equal({:foo => :bar}, router.match('/foo/1/bar'))
    assert_equal({:foo => :baz}, router.match('/foo/1/baz'))
    assert_equal({:foo => :foo}, router.match('/foo/1/foo'))
    assert_equal('/:id', router.match('/1'))
  end
end
