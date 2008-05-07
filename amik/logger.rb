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

require 'logger'

def colorize(text, color_code)
    "#{color_code}#{text}\e[0m"
end

def red(text)
    colorize(text, "\e[31m")
end

def green(text)
    colorize(text, "\e[32m")
end

def blue(text)
    colorize(text, "\e[34m")
end

def purple(text)
    colorize(text, "\e[35m")
end

class ColorFormatter < Logger::Formatter

    def format_datetime(time)
        time.strftime("%Y-%m-%d %H:%M:%S.") << "%03d" % (time.usec / 1000)
    end

    def call(severity, time, progname, msg)
        msg = "  - #{msg2str(msg)}"
        msg.gsub!("\n", "\n    ")
        if severity == 'DEBUG'
            msg = purple(msg)
        elsif severity == 'INFO'
            msg = blue(msg)
        else
            msg = red(msg)
        end

        status_line = "%s #%d %5s %s" % [format_datetime(time), $$, severity,
            Kernel.caller[3]]

        "%s\n%s\n" % [green(status_line), msg]
    end
end

def get_logger
    log = Logger.new(STDOUT)
    log.level = Logger::DEBUG
    log.formatter = ColorFormatter.new

    return log
end

