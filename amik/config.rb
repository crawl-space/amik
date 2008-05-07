# amik: Track your bandwidth cap.
#
# Copyright (C) 2008 James Bowes <jbowes@dangerouslyinc.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

require 'amik/logger'

$log = get_logger()

class Config

    attr_reader :backend, :model, :check_frequency

    def initialize()
        @backend = "bell_ca"
        @model = "yaml"

        # Check daily
        @check_frequency = 24 * 60 * 60

        $log.debug("Backend set to '#{@backend}'\n" +
                   "Data model set to '#{@model}'\n" +
                   "Checking every #{@check_frequency} seconds")
    end
end
