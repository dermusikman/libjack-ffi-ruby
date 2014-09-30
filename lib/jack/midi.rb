module JACK
  module MIDI

    # In case we'd like multiple ports, we'll keep track to distinguish them
    @@total_ports = 0

    def self.register(client)
      port_num = @@total_ports + 1
      API.jack_port_register(client, "midi_in_#{port_num}", API::JACK_DEFAULT_MIDI_TYPE, :is_input, 0)
      API.jack_port_register(client, "midi_out_#{port_num}", API::JACK_DEFAULT_MIDI_TYPE, :is_output, 0)
      @@total_ports += 1
    end

    def self.process_input(client, port, nframes)
      if port.is_input?
        buffer = API.jack_port_get_buffer(port, nframes)
        API.jack_midi_clear_buffer(buffer)

      else
        raise "Output port provided to #process_input"
      end
    end

  end
end
