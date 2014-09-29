require 'ffi'

module FFI
  class Pointer
    def read_array_of_type_until_end(type, reader)
      ary = []
      size = FFI.type_size(type)
      tmp = self
      loop do
        last = tmp.send(reader)
        break if last.null?
        ary << last
        tmp += size
      end
      ary
    end

    def read_array_of_pointer_until_end
      read_array_of_type_until_end :pointer, :read_pointer
    end

    def read_array_of_string_until_end
      read_array_of_pointer_until_end.collect { |p| p.read_string }
    end
  end
end

module JACK
  LIB = [ "libjack.so.0.0.28", "libjack.so.0", "libjack.so", "libjack" ]
  VERSION = "0.0.1"
end

require 'jack/errors'
require 'jack/client'
require 'jack/port'

