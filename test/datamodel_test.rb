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

require 'test/unit'

require 'date'

require 'amik/datamodel/yaml'

class DataModelTest < Test::Unit::TestCase

    def test_older_point_wont_be_added
        model = AmikYaml::DataModel.new

        point1 = AmikYaml::DataPoint.new(15, 60, Date.new(2008, 04, 01),
                                         Date.new(2008, 04, 28))
        point2 = AmikYaml::DataPoint.new(13, 60,  Date.new(2008, 04, 01),
                                         Date.new(2008, 04, 27))

        model.add_data_point(point1)
        assert model.points.length == 1

        model.add_data_point(point2)
        assert model.points.length == 1
    end
end
