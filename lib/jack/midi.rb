module JACK
  class MIDI
    extend FFI::Library
    ffi_lib LIB



    protected

    # Deprecated?
    #attach_function :jack_midi_get_event, [:buffer_in], :uint32

    attach_function :jack_midi_event_get, [:pointer, :buffer_in, :uint32], :int

    attach_function :jack_midi_clear_buffer, [:buffer_out], :void

    attach_function :jack_midi_event_reserve, [:buffer_out, :uint32, :size_t], :int

    attach_function :jack_midi_event_write, [:buffer_out, :uint32, :string, :size_t], :int

    attach_function :jack_midi_max_event_size, [:buffer_in], :int

    attach_function :jack_midi_get_lost_event_count, [:buffer_inout], :uint32

  end
end
