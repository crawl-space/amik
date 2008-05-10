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
require 'amik/config'

require 'amik/logger'

$log = get_logger()

# XXX possibly hacky way to load all this
def load_datamodel(config)
    $log.debug("Loading data model")
    require "amik/datamodel/#{config.model}"
    return eval("Amik#{config.model.capitalize}")
end

def load_backend(config)
    $log.debug("Loading backend")
    require "amik/backends/#{config.backend}"
end

def main(force, args)
    config = Config.new
    dm_module = load_datamodel(config)
    dm = dm_module::load('data.yml')

    if force
        $log.debug("Bandwidth check forced")
    elsif dm.last_updated + config.check_frequency <= Time.now
        $log.debug("Checking bandwidth usage")
    else
        $log.debug("Not checking bandwidth usage, too soon since last check")
        return
    end

    # XXX put get_usage in a module
    load_backend(config)
    used, total, start_date, end_date = get_usage(args[0], args[1])

    point = dm_module::DataPoint.new(used, total, start_date, end_date)
    if point.used
        if dm.add_data_point(point)
            $log.debug("Saving data model")
            dm_module::save('data.yml', dm)
        else
            $log.debug("Not saving data model")
        end
    end
end

if __FILE__ == $0
    force = false
    args = []
    ARGV.each do |item|
        if not item == '--force'
            args << item
        else
            force = true
        end
    end

    if not args.length == 2
        puts "Usage: #{$0} USERNAME PASSWORD"
        exit
    end

    main(force, args)
end
