module Maze
    def self.execute
        #Generate maze
        board=Board.new 20, 20
        board.show
        #Play maze
    end
    class Board
        def initialize(width, length)
            @@board= Array.new(length) { Array.new(width) }
            (0...length).each do |column|
                (0...width).each do |row|
                    @@board[column][row]= Cell.new(column,row)
                end
            end
            @@board
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
            def initialize column, row
                @column=column
                @row=row
                @right_wall=true
                @bottom_wall=true
            end
            attr_accessor :right_wall, :bottom_wall
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
        end
    end
end
