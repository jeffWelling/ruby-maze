class Maze
    class Board
        def initialize length, width
            board=[]
            length.times {|i|
                board<<[]
                width.times {|j|
                    board[i]<<Cell.new( i, j )
                }
            }
            board
        end
    end
    class Cell
        def initialize length, width
            @length=length
            @width=width
            @right_wall=true
            @bottom_Wall=true
        end
    end
    def generate
        @@board= Board.new( 10,10 )
    end
end
