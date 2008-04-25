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

require 'amik/datamodel/yaml'
require 'amik/backends/bell_ca'
#require 'amik/backends/dummy'

def main(args)
    dm = AmikYaml::load('data.yml')
    point = AmikYaml::DataPoint.new
    point.used, point.total, point.start, point.end = get_usage(args[0], args[1])
    if point.used:
        dm.add_data_point(point)
    end
    AmikYaml::save('data.yml', dm)
end

if __FILE__ == $0
    if not ARGV.length == 2
        puts "Usage: #{$0} USERNAME PASSWORD"
        exit
    end

    main(ARGV)
end
