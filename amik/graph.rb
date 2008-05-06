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

require 'cairo'
require 'amik/logger'

$log = get_logger()

class Graph

    def initialize
        @surface = Cairo::ImageSurface.new(400, 300)
        @context = Cairo::Context.new(@surface)
        @context.set_source_color(:white)
        @context.paint
    end

    def draw_grid
        @context.set_source_color(:black)
        (1..9).each do |i|
            @context.move_to(400/10 * i, 0)
            @context.line_to(400/10 * i, 300)
        end
        @context.stroke

        (1..9).each do |i|
            @context.move_to(0, 300/10 * i)
            @context.line_to(400, 300/10 * i)
        end
        @context.stroke
    end

    def transform_point(point)
        new_x = point[0] * 400/10
        new_y = 300 - point[1] * 300/10
        return [new_x, new_y]
    end

    def graph_points(points)
        @context.set_source_color(:blue)
        first_point = transform_point(points[0])
        @context.move_to(first_point[0], first_point[1])
        points.each do |point|
            point = transform_point(point)
            @context.line_to(point[0], point[1])
        end
        @context.stroke

        points.each do |point|
            point = transform_point(point)
            @context.move_to(point[0], point[1])
            @context.circle(point[0], point[1], 5)
        end
        @context.fill

    end

    def draw
        draw_grid
        graph_points([[1,1], [1,2], [2, 3]])
    end

    def write
        @surface.write_to_png("output.png")
    end

end

graph = Graph.new
graph.draw
graph.write
