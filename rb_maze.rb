#!/usr/bin/ruby
require 'pp'
require 'curses'

class Maze
    def initialize l=20, w=20, v=false
        board=Board.new( l, w )
        init_screen do
            board.generate_RecursiveBacktracker
        end
    end
    def init_screen
        Curses.init_screen
        Curses.stdscr.keypad(true)
        begin
            yield
        ensure
            Curses.close_screen
        end
    end
    class Board
        def initialize length, width
            @@board=[]
            length.times {|i|
                @@board<<[]
                width.times {|j|
                    @@board[i]<<Cell.new( i, j )
                }
            }
        end
        def write_to_screen line, col, text
            text.split("\n").each {|text|
                Curses.setpos(line,col)
                Curses.addstr(text)
                line+=1
            }
            Curses.refresh
        end
        def [] i
            @@board[i]
        end
        def show
            # print top edge of board
            output=''
            boarder_length= (@@board[0].size.*2) +1
            boarder_length.times do
                output << "_"
            end
            output << "\n"
            @@board.each {|row|
                output << "|"
                row.each {|cell|
                    output << cell.display rescue nil
                }
                output << "\n"
            }
            output
        end
        def get_random_cell
            @@board[rand(@@board.size)][rand(@@board[0].size)]
        end
        def get_unvisited_neighbors cell
            populate_neighbors(cell.neighbors).delete_if {|cell| cell.nil? or cell.visited }
        end
        def populate_neighbors neighbors
            neighbors.map {|cell_coordinates|
                @@board[ cell_coordinates[0] ][ cell_coordinates[1] ] rescue nil
            }
        end
        def join cell_1, cell_2
            #if cell_2 is to the right of cell_1
            if (cell_1.column - cell_2.column) < 0
               cell_1.right_wall=false
            end
            #if cell_2 is below cell_1
            if (cell_1.row - cell_2.row) < 0
               cell_1.bottom_wall=false
            end
            #if cell_1 is to the right of cell_2
            if (cell_1.column - cell_2.column) > 0
                cell_2.right_wall=false
            end
            #if cell_1 is below cell_2
            if (cell_1.row - cell_2.row) > 0
                cell_2.bottom_wall=false
            end
        end
        def unvisited_cells?
            @@board.each {|row|
                row.each {|cell|
                    return true if cell.visited==false
                }
            }
            return false
        end
        def generate_RecursiveBacktracker
            starting_cell= get_random_cell
            starting_cell.visited=true
            current_cell=starting_cell
            stack=[starting_cell]
            while unvisited_cells?
                if !get_unvisited_neighbors( current_cell ).empty?
                    u_neighbors=get_unvisited_neighbors( current_cell )
                    chosen_cell=u_neighbors[rand(u_neighbors.size)]
                    join( current_cell, chosen_cell )
                    current_cell=chosen_cell
                    current_cell.visited=true
                    stack<<current_cell
                    Curses.clear
                    write_to_screen( 0,0,show )
                    sleep( 0.3 )
                else
                    current_cell=stack.pop
                end
            end
        end
    end
    class Cell
        def initialize row, column
            @row=row
            @column=column
            @right_wall=true
            @bottom_wall=true
            @visited=false
        end
        attr_reader :row, :column
        attr_accessor :visited, :right_wall, :bottom_wall
        def display
            o=''
            if @bottom_wall
                o<< "_"
            else
                o<< " "
            end
            if @right_wall
                o<< "|"
            else
                o<< " "
            end
            o
        end
        def neighbors
            neighbors=[]
            #top
            unless @row==0
                neighbors<<[@row-1,@column]
            end
            #right side
            #we don't need to check if @column is at the edge because
            #later when neighbor cell co-ordinates are turned into the 
            #actual cells, an off-the-board reference becomes nil anyway.
            neighbors<<[@row,@column+1]
            #bottom
            neighbors<<[@row+1,@column]
            unless @column==0
                neighbors<<[@row,@column-1]
            end
            neighbors
        end
    end
end
Maze.new 20,40,true
