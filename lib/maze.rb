module Maze
    def self.execute
        #Generate maze
        board=Board.new 20, 20
        puts 'what the fuck'
        board.show
        puts "I got here"
        #Play maze
    end
    class Board
        def initialize(width, length)
          @@board=[]
          length.times do
            @@board << generate_row(width)
          end
        end
        def generate_row(width)
            row=[]
            width.times do
                row << Cell.new
            end
            row
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
            def initialize
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
