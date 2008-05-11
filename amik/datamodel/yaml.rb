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

require 'fileutils'
require 'yaml'

require 'amik/logger'

$log = get_logger()

module AmikYaml

    class DataPoint

        attr_accessor :used, :total, :start_date, :end_date

        def initialize(used, total, start_date, end_date)
            @used = used
            @total = total
            @start_date = start_date
            @end_date = end_date
        end

        def to_s
            "#{@start_date} - #{@end_date} : #{@used}/#{@total} GB"
        end

    end

    class DataModel

        attr_reader :points
        attr_accessor :last_updated
        
        def initialize
            @version = "0.0.1"
            @points = []

            # This is as good a default as any
            @last_updated = Time.local(1970, 'jan', 1)
            print @last_updated
        end

        def add_data_point(point)
            if @points.length != 0 and @points.last.end_date >= point.end_date
                $log.info("Datapoint '#{point}' not newer than last point")
                return false
            else
                @points << point
                return true
            end
        end
    end

    def load(path)
        if File.readable?(path)
            YAML::load(File.read(path))
        else
            $log.info("Unable to read data file; will create a new one on save")
            DataModel.new
        end
    end
    module_function :load

    def save(path, model)
        model.last_updated = Time.now
        safe_write(path, model.to_yaml)
    end
    module_function :save

    # Write file to path, making a backup of path if it exists
    # if the write fails, the original file will be preserved
    def safe_write(path, contents)
        if File.exists?(path)
            $log.debug("Making a backup of #{path}")
            FileUtils.cp(path, path + '.bak')
        end

        $log.debug("Writing new contents to #{path}.new")
        outfile = File.new(path + '.new', 'w')
        outfile.puts(contents)

        $log.debug("Moving #{path}.new to #{path}")
        FileUtils.mv(path + '.new', path)
    end
    module_function :safe_write

end

def get_datamodel()
    dm = AmikYaml::load('data.yml')
end
