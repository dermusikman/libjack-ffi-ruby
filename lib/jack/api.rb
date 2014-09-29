module JACK

  # FFI code for binding to JACK (from C)
  module API
    extend FFI::Library
    # from original gem - works, but should probably be cleaned up
    #  -- I am basing the typedef, et al., on JACK 0.124.1
    LIB = ["libjack.so.0.0.28", "libjack.so.0", "libjack.so", "libjack"]
    ffi_lib LIB

# # # # #
#  Client/Port management - really, just universally JACK
#
    typedef :uint32,    :jack_nframes_t
    typedef :uint64,    :jack_time_t
    typedef :pointer,   :jack_port_t    # opaque struct, only accessed through API
    typedef :pointer,   :jack_client_t  # opaque struct, only accessed through API

    # from enum JackStatus
    enum :options, [
      :null_option,     0x00,
      :no_start_server, 0x01,
      :use_exact_name,  0x02,
      :server_name,     0x04,
      :load_name,       0x08,
      :load_init,       0x10,
      :session_id,      0x20
    ]

    # from enum JackPortFlags
    enum :port_flags, [
      :is_input,        0x01,
      :is_output,       0x02,
      :is_physical,     0x04,
      :can_monitor,     0x08,
      :is_terminal,     0x10
    ]

    enum :status, [
      :null_option,     0x00,
      :failure,         0x01,
      :invalid_option,  0x02,
      :name_not_unique, 0x04,
      :server_started,  0x08,
      :server_failed,   0x10,
      :server_error,    0x20,
      :no_such_client,  0x40,
      :load_failure,    0x80,
      :init_failure,    0x100,
      :shm_failure,     0x200,
      :version_error,   0x400,
      :backend_error,   0x800,
      :client_zombie,   0x1000
    ]

    JACK_DEFAULT_AUDIO_TYPE = "32 bit float mono audio"
    JACK_DEFAULT_MIDI_TYPE  = "8 bit raw midi"

#    jack_client_t * jack_client_open (const char *client_name,
#                                   jack_options_t options,
#                                   jack_status_t *status,...)
    attach_function :jack_client_open, [:string, :options, :status], :jack_client_t

#                int jack_client_close (jack_client_t *client)
    attach_function :jack_client_close, [:jack_client_t], :int

#      const char ** jack_get_ports (jack_client_t *client,
#                                       const char *port_name_pattern,
#                                       const char *type_name_pattern,
#                                     unsigned long flags)
    attach_function :jack_get_ports, [:jack_client_t, :string, :string, :ulong], :pointer

#      jack_port_t * jack_port_by_name (jack_client_t *, const char *port_name)
    attach_function :jack_port_by_name, [:jack_client_t, :string], :jack_port_t

#                int jack_connect (jack_client_t *, const char *source_port, const char *destination_port)
    attach_function :jack_connect, [:jack_client_t, :string, :string], :int

#                int jack_disconnect (jack_client_t *, const char *source_port, const char *destination_port)
    attach_function :jack_disconnect, [:jack_client_t, :string, :string], :int

#                int jack_port_disconnect (jack_client_t *, jack_port_t *)
    attach_function :jack_port_disconnect, [:jack_client_t, :jack_port_t], :int

#                int jack_port_flags (const jack_port_t *port)
    attach_function :jack_port_flags, [:jack_port_t], :int

#       const char * jack_port_name (const jack_port_t *port)
    attach_function :jack_port_name, [:jack_port_t], :string

#      jack_port_t * jack_port_register (jack_client_t *client,
#                                          const char * port_name,
#                                          const char * port_type,
#                                         unsigned long flags,
#                                         unsigned long buffer_size
#                                       )
    attach_function :jack_port_register, [:jack_client_t,
                                          :string,
                                          :string,
                                          :port_flags,
                                          :int           # Ignored for standard types
                                         ], :jack_port_t

#                int jack_port_unregister (jack_client_t *client, jack_port_t *port)
    attach_function :jack_port_unregister, [:jack_client_t, :jack_port_t], :int


# # # # #
#  MIDI types/events
#
    typedef   :uchar,             :jack_midi_data_t
    class MIDIEvent < FFI::Struct
      layout  :time,              :jack_nframes_t,
              :size,              :size_t,
              :buffer,            :jack_midi_data_t
    end

#                int jack_midi_event_get (jack_midi_event_t *event, void *port_buffer, uint32_t event_index)
    attach_function :jack_midi_event_get, [MIDIEvent.by_ref, :buffer_in, :uint32], :int

#               void jack_midi_clear_buffer (void *port_buffer)
    attach_function :jack_midi_clear_buffer, [:buffer_inout], :void

# jack_midi_data_t * jack_midi_event_reserve (void *port_buffer, jack_nframes_t time, size_t data_size)
    attach_function :jack_midi_event_reserve, [:buffer_out, :jack_nframes_t, :size_t], :jack_midi_data_t

#                int jack_midi_event_write (void *port_buffer, jack_nframes_t time, const jack_midi_data_t *data, size_t data_size)
    attach_function :jack_midi_event_write, [:buffer_out, :jack_nframes_t, :string, :size_t], :int

#             size_t jack_midi_max_event_size (void *port_buffer)
    attach_function :jack_midi_max_event_size, [:buffer_in], :size_t

#     jack_nframes_t jack_midi_get_event_count (void *port_buffer)
    attach_function :jack_midi_get_lost_event_count, [:buffer_inout], :jack_nframes_t

  end
end
