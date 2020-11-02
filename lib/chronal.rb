require 'time'

module Chronal
  class Chronal

    attr_accessor :filename

    def initialize(filename = nil)
      @filename = (filename ? filename : '/tmp/chronal')
    end

    def start
      contents = read_file

      if contents.length > 0
        "Please 'stop' the timer before starting a new one"
      else
        write_file
        "Started!"
      end
    end

    def stop
      amount = current
      erase_file if amount
      amount
    end

    def current
      contents = read_file
      if contents.length > 0
        minutes(calculate(contents))
      else
        false
      end
    end

    def live
      format(calculate(read_file))
    end

    private

    def format(t)
      Time.at(t).utc.strftime("%H:%M:%S")
    end

    def minutes(t)
      "#{(t / 60).round}m"
    end

    def calculate(start)
      begin
        start = Time.parse(start)
        total = Time.now - start
      rescue ArgumentError => e
        raise ArgumentError, "Start time is not formatted correctly"
      end
    end

    def read_file
      begin
        contents = File.read(@filename)
      rescue Errno::ENOENT => e
        contents = ''
      end
    end

    def write_file
      File.write(@filename, Time.now)
    end

    def erase_file
      File.write(@filename, '')
    end
  end
end
