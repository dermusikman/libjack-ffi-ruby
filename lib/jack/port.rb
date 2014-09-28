module JACK
  class Port
    extend FFI::Library
    ffi_lib LIB

    attr_reader :pointer, :client

    FLAGS_IS_INPUT    = 0x1
    FLAGS_IS_OUTPUT   = 0x2
    FLAGS_IS_PHYSICAL = 0x4
    FLAGS_CAN_MONITOR = 0x8
    FLAGS_IS_TERMINAL = 0x10

    def initialize(identifier, client)
      @client = client

      if identifier.is_a? String
        @pointer = @client.port_by_name(identifier).pointer
      else
        @pointer = identifier
      end
    end

    def name
      API.jack_port_name @pointer
    end

    def flags
      API.jack_port_flags @pointer
    end

    def connect(destination)
      raise ArgumentError, "You must pass JACK::Port or String to JACK::Port.connect" if not destination.is_a? Port and not destination.is_a? String
      destination = client.port_by_name(destination) if destination.is_a? String

      client.connect self, destination
    end

    def disconnect(destination)
      raise ArgumentError, "You must pass JACK::Port or String to JACK::Port.disconnect" if not destination.is_a? Port and not destination.is_a? String
      destination = client.port_by_name(destination) if destination.is_a? String

      client.disconnect self, destination
    end

    def is_input?
      flags & FLAGS_IS_INPUT != 0
    end

    def is_output?
      flags & FLAGS_IS_OUTPUT != 0
    end

    def is_physical?
      flags & FLAGS_IS_PHYSICAL != 0
    end

    def can_monitor?
      flags & FLAGS_CAN_MONITOR != 0
    end

    def is_terminal?
      flags & FLAGS_IS_TERMINAL != 0
    end

    def to_s
      name
    end

    def inspect
      "#<#{self.class} name=#{name}>"
    end
  end
end
