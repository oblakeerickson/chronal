require 'minitest/autorun'
require_relative '../lib/chronal'

class TestChronal < Minitest::Test

  def setup
    @chronal = Chronal::Chronal.new('/tmp/chronal_test')
    @default = Chronal::Chronal.new
    File.delete(@chronal.filename) if File.exist? @chronal.filename
  end

  def test_filename
    assert_equal '/tmp/chronal_test', @chronal.filename
    assert_equal '/tmp/chronal', @default.filename
  end

  def test_start
    started = @chronal.start
    assert_equal 'Started!', started
  end

  def test_already_started
    @chronal.start
    started = @chronal.start
    assert_equal "Please 'stop' the timer before starting a new one", started
  end

  def test_stop_when_not_started
    stopped = @chronal.stop
    assert_equal false, stopped
  end

  def test_stop
    @chronal.start
    stopped = @chronal.stop
    assert_equal '0m', stopped
    contents = File.read(@chronal.filename)
    assert_equal '', contents
  end

  def test_current_when_not_started
    current = @chronal.current
    assert_equal false, current
  end

  def test_current
    @chronal.start
    current = @chronal.current
    assert_equal '0m', current
  end

  def test_live_when_not_started
    assert_raises(ArgumentError) { @chronal.live }
  end

  def test_live
    @chronal.start
    live = @chronal.live
    assert_equal '00:00:00', live
  end

end

