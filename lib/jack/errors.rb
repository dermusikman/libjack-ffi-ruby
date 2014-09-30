module JACK
  class Errors
    class NoSuchPortError < Exception; end
    class InvalidPortsChosenToConnect < Exception; end
  end
end
