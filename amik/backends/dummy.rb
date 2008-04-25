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

require 'date'
require 'logger'

$log = Logger.new(STDOUT)
$log.level = Logger::DEBUG

def get_usage(username, password)
    $log.debug("Getting dummy usage data for '#{username}'")

    current_usage = 15
    total_usage = 40
    start_date = Date::strptime("2008-04-01")
    end_date = Date::strptime("2008-04-24")
    $log.debug("Dummy current usage: #{current_usage}")
    $log.debug("Dummy total usage: #{total_usage}")
    $log.debug("Dummy start date: #{start_date}")
    $log.debug("Dummy end date: #{end_date}")

    return current_usage, total_usage, start_date, end_date
end

if __FILE__ == $0
    if not ARGV.length == 2
        puts "Usage: #{$0} USERNAME PASSWORD"
        exit
    end
    get_usage(ARGV[0], ARGV[1])
end
