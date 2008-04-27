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

require 'gtk2'

require 'amik/datamodel/yaml'

def make_tooltip
    dm = AmikYaml.load('data.yml')

    point = dm.points.last

    date_fmt = "%m/%d"
    "%s/%s GiB\nfor %s to %s" % [point.used, point.total,
        point.start_date.strftime(date_fmt), point.end_date.strftime(date_fmt)]
end

def main
    icon = Gtk::StatusIcon.new
    icon.file = 'data/amik.svg'

    icon.tooltip = make_tooltip()

    Gtk.main()
end

if __FILE__ == $0
    main()
end
