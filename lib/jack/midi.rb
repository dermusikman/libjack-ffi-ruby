module JACK
  class MIDI
    extend FFI::Library
    ffi_lib LIB



    protected

    # Deprecated?
    #attach_function :jack_midi_get_event, [:buffer_in], :uint32

    attach_function :jack_midi_event_get, [:pointer, :buffer_in, :uint32], :int

    attach_function :jack_midi_clear_buffer, [:buffer_out], :void

    attach_function :jack_midi_event_reserve, [:buffer_out, :uint32, :int], :int

    attach_function :jack_midi_event_write, [:buffer_out, :uint32, :string, :int], :int

    attach_function :jack_midi_max_event_size, [:buffer_in], :int
  end
end
