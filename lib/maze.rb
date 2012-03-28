require 'pp'
module Maze
    def self.execute
        #Generate maze
        board=Board.new 20, 20
        board.show

        require 'pp'
        puts board.class
        puts board[5][5].class
        RecursiveBacktracker.generate(
            board[5][5],
            board
        )
        #Play maze
    end
    class Board < Array
        def initialize(width, length)
            @@board= Array.new(length) { Array.new(width) }
            (0...length).each do |column|
                (0...width).each do |row|
                    @@board[column][row]= Cell.new(column,row,@@board)
                end
            end
            @@board
        end
        def has_unvisited?
            @@board.each {|row|
                row.each {|cell|
                    return true if cell.visited?
                }
            }
            return false
        end
        #This lets us reference cells by board[0][0]
        #which is useful when debugging in irb
        def [] i
            @@board[i]
        end
        def show
            # print top edge of board
            boarder_length= (@@board.length.*2) +1
            boarder_length.times do
                print "_"
            end
            print "\n"
            @@board.each {|row|
                print "|"
                row.each {|cell|
                    cell.display
                }
                print "\n"
            }
        end

        class Cell
            def initialize column, row, board
                @column=column
                @row=row
                @right_wall=true
                @bottom_wall=true
                @visited=false
                @board=board
            end
            attr_accessor :right_wall, :bottom_wall
            def visited?
                @visited
            end
            def visited
                @visited=true
            end
            def destroy_wall neighbor
                difference= self.row-neighbor.row
                if difference < 0

                end
            end
            def display
                if @bottom_wall
                    print "_"
                else
                    print " "
                end
                if @right_wall
                    print "|"
                else
                    print " "
                end
            end
            def get_unvisited_neighbor
                unvisited=[]
                if @row!=0
                    if @board[@row-1][@column].visited==false
                        unvisited<<@board[@row-1][@column]
                    else
                        puts 'cell was visited'
                    end
                else
                    puts 'row was zero'
                end
                if @column==@board[0].size
                    if @board[@row][@column+1].visited==false
                        unvisited<<@board[@row][@column+1]
                    else
                        puts 'cell was visited'
                        pp @board[@row][@column+1]
                    end
                else
                    puts 'row was zero'
                end

=begin
                unless @row==0 or @board[@row-1][@column].visited==true
                    unvisited<<@board[@row-1][@column]
                end
                unless @column==@board[0].size or @board[@row][@column+1].visited==true
                    unvisited<<@board[@row][@column+1]
                end
=end
                unless @row==@board.size or @board[@row+1][@column].visited==true
                    unvisited<<@board[@row+1][@column]
                end
                unless @column==0 or @board[@row][@column-1].visited==true
                    unvisited<<@board[@row][@column-1]
                end
                puts 'I am here'
                puts unvisited.length
                unvisited[ rand(unvisited.size) ]
            end
            def has_unvisited_neighbors?
                 
                !self.get_unvisited_neighbor.empty?
            end
        end
    end
    module RecursiveBacktracker
        def self.generate starting_cell, board

            stack=[starting_cell]
            starting_cell.visited
            current_cell=starting_cell
            while board.has_unvisited?
                pp current_cell.has_unvisited_neighbors?.class
                if current_cell.has_unvisited_neighbors?
                    neighbor= cell.get_unvisited_neighbor
                    stack<<neighbor
                    cell.destroy_wall(neighbor)
                    pp neighbor.class
                    pp neighbor.has_unvisited_neighbors?
                    current_cell=neighbor
                else
                    unless stack.empty? 
                        current_cell= stack.pop
                    end
                end
            end
        end
    end
end
