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

class DataPoint

    # Bandwith usage we can increment
    @@used = 15

    # A day of the month we can increment
    @@end = 26

    def initialize(used, total, start_date, end_date)
        @used = @@used
        @total = 60
        @start = "2007-01-01"
        @end = "2007-01-#{@@end}"

        @@used += 1
        @@end += 1
    end

    def to_s
        "#{@start} - #{@end} : #{@used}/#{@total} GB"
    end
end

class DataModel

    attr_reader :points

    def initialize
        @points = [DataPoint.new, DataPoint.new]
    end

    def add_data_point(point)
        @points << point
    end
end

puts DataModel.new.to_yaml
