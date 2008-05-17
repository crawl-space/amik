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
require 'amik/logger'

$log = get_logger()


class Gui

    def initialize
        icon = Gtk::StatusIcon.new
        icon.file = 'data/amik.svg'

        icon.tooltip = make_tooltip()
        icon.signal_connect('activate') do |icon|
            show_menu(icon, 0, 0)
        end
        icon.signal_connect('popup-menu') do |icon, button, time|
            show_menu(icon, button, time)
        end
    end

    def make_tooltip
        data_dir = File.expand_path("~/.local/share/amik/")
        FileUtils.mkdir_p(data_dir)
        data_file = File.join(data_dir, 'data.yml')

        dm = AmikYaml.load(data_file)

        point = dm.points.last

        date_fmt = "%m/%d"
        "%s/%s GiB\nfor %s to %s" % [point.used, point.total,
            point.start_date.strftime(date_fmt), point.end_date.strftime(date_fmt)]
    end

    def do_refresh
        $log.debug("Refresh pressed")
    end

    def show_about
        $log.debug("About pressed")

        about = Gtk::AboutDialog.new
        about.show_all
    end

    def show_menu(icon, button, time)
        $log.debug("Showing menu")

        menu = Gtk::Menu.new()

        item = Gtk::ImageMenuItem.new(Gtk::Stock::REFRESH)
        item.signal_connect("activate") { do_refresh }
        menu.add(item)

        item = Gtk::SeparatorMenuItem.new
        menu.add(item)

        item = Gtk::ImageMenuItem.new(Gtk::Stock::ABOUT)
        item.signal_connect("activate") { show_about }
        menu.add(item)

        item = Gtk::ImageMenuItem.new(Gtk::Stock::QUIT)
        menu.add(item)
        item.signal_connect("activate") do
            $log.debug("Quit pressed")
            $log.info("Quitting...")
            Gtk.main_quit
        end

        menu.show_all

        # XXX need to position this properly
        menu.popup(nil, nil, button, time)
    end

end

def main
    icon = Gui.new
    Gtk.main()
end

if __FILE__ == $0
    main()
end
