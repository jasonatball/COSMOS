# encoding: ascii-8bit

# Copyright 2014 Ball Aerospace & Technologies Corp.
# All Rights Reserved.
#
# This program is free software; you can modify and/or redistribute it
# under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 3 with
# attribution addendums as found in the LICENSE.txt

if Kernel.is_windows?
  require 'cosmos/io/win32_serial_driver'
else
  require 'cosmos/io/posix_serial_driver'
end

module Cosmos

  # A platform independent serial driver
  class SerialDriver
    EVEN = :EVEN
    ODD  = :ODD
    NONE = :NONE
    VALID_PARITY = [EVEN,ODD,NONE]

    # @param port_name [String] Name of the serial port
    # @param baud_rate [Integer] Serial port baud rate
    # @param parity [Symbol] Must be one of :EVEN, :ODD or :NONE
    # @param stop_bits [Integer] Number of stop bits
    # @param write_timeout [Float|nil] Number of seconds to wait for the write to
    #   complete or nil to block
    # @param read_timeout [Float|nil] Number of seconds to wait for the read to
    #   complete or nil to block
    def initialize(port_name,
                   baud_rate,
                   parity = :NONE,
                   stop_bits = 1,
                   write_timeout = 10.0,
                   read_timeout = nil)
      raise(ArgumentError, "Invalid parity: #{parity}") unless VALID_PARITY.include? parity
      if Kernel.is_windows?
        @driver = Win32SerialDriver.new(port_name,
                                        baud_rate,
                                        parity,
                                        stop_bits,
                                        write_timeout,
                                        read_timeout)
      else
        @driver = PosixSerialDriver.new(port_name,
                                        baud_rate,
                                        parity,
                                        stop_bits,
                                        write_timeout,
                                        read_timeout)
      end
    end

    # Disconnects the driver from the comm port
    def close
      @driver.close
    end

    # @return [Boolean] Whether the serial port has been closed
    def closed?
      @driver.closed?
    end

    # @param data [String] Binary data to write to the serial port
    def write(data)
      @driver.write(data)
    end

    # @return [String] Binary data read from the serial port
    def read
      @driver.read
    end

    # @return [String] Binary data read from the serial port
    def read_nonblock
      @driver.read_nonblock
    end

  end # class SerialDriver

end # module Cosmos
