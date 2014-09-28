module JACK
  class Client
    extend FFI::Library
    ffi_lib LIB

    attr_reader :pointer

    def initialize(name, options = 0x00, &b)
      @name = name
      @options = options

      status = FFI::MemoryPointer.new :pointer

      @server = API.jack_client_open name, options, status
      # TODO return status handling

      if block_given?
        yield self
        close
      end

    end

    def close
      API.jack_client_close @server
    end

    def get_ports
      # TODO checking if i am connected
      # TODO parameters
      API.jack_get_ports(@server, nil, nil, 0).read_array_of_string_until_end.collect{ |port| Port.new(port, self) }
    end

    def port_by_name(name)
      port = API.jack_port_by_name(@server, name)

      raise Errors::NoSuchPortError, "There no such port as #{name}" if port.null?

      Port.new(port, self)
    end

    def connect(source, destination)
      change_graph(:connect, source, destination) == 0
    end

    def disconnect(source, destination)
      change_graph(:disconnect, source, destination) == 0
    end

    def change_graph(method, source, destination)
      raise ArgumentError, "You must pass JACK::Port or String to JACK::Client.port_connect" if not source.is_a? Port and not source.is_a? String and not destination.is_a? Port and not destination.is_a? String

      source = port_by_name(source) if source.is_a? String
      destination = port_by_name(destination) if destination.is_a? String

      if source.is_input? and destination.is_output?
        source = destination
        destination = source
      elsif source.is_output? and destination.is_input?
        # Direction ok
      else
        raise Errors::InvalidPortsChosenToConnect, "Cannot connect ports #{source} and #{destination} - both are input or output ports"
      end

      # TODO checking result
      send("jack_#{method}", @server, source.name, destination.name)
    end
  end
end
