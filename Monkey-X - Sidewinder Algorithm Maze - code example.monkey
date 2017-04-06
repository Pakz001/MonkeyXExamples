#rem
Sidewinder algorithm Mazes

From the book - Mazes for programmers -

#end

Import mojo

Class cell
    Field north:Bool,east:Bool
    Field south:Bool,west:Bool
End Class

Class bintreemaze
    Field width:Int,height:Int
    Field tilewidth:Float,tileheight:Float
    Field map:cell[][]
    Method New(mazewidth:Int,mazeheight:Int,sw:Int,sh:Int)
        Self.width = mazewidth
        Self.height = mazeheight
        map = New cell[width][]
        For Local i=0 Until width
            map[i] = New cell[height]
        Next
        For Local y=0 Until height
        For Local x=0 Until width
            map[x][y] = New cell
        Next
        Next
        tilewidth = Float(sw)/Float(mazewidth)
        tileheight = Float(sh)/Float(mazeheight)
        makesidewindermaze
    End Method
    '
    ' This method creates the maze
    '
    ' Starts left top and moves to bottom right.
    ' Every series of cells horizontally it picks a corridor towards
    ' the bottom.
    ' The series of cells horizontally connect also.
    '
    ' aaabbcccc
    '  |  |  |
    '
    Method makesidewindermaze()
        For Local y = 0 Until height
        Local runstart:Int = 0
        For Local x = 0 Until width
            If y>0 And (x+1 = width Or Rnd(3)  <1)
                Local cell:Int=runstart+Rnd(x - runstart + 1)
                map[cell][y].north = True
                map[cell][y-1].south = True
                runstart = x+1
            Elseif x+1 < width
                map[x][y].east = True
                map[x+1][y].west = True
            End If
        Next
        Next
    End Method
    '
    ' Draw the maze
    '
    Method draw()
        For Local y=0 Until height
        For Local x=0 Until width
            Local x1:Int=x*tilewidth
            Local y1:Int=y*tileheight
            SetColor 255,255,255
            If map[x][y].north = False
                DrawLine x1,y1,x1+tilewidth,y1
            End If
            If map[x][y].east = False
                DrawLine x1+tilewidth,y1,x1+tilewidth,y1+tileheight
            End If
            If map[x][y].south = False
                DrawLine x1,y1+tileheight,x1+tilewidth,y1+tileheight
            End If
            If map[x][y].west = False
                DrawLine x1,y1,x1,y1+tileheight
            End If
        Next
        Next
    End Method
End Class

Global maze:bintreemaze

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
        maze = New bintreemaze(10,10,500,400)
    End Method
    Method OnUpdate()        
        If MouseHit(MOUSE_LEFT)
            maze = New bintreemaze(10,10,500,400)
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        maze.draw
        DrawText "Sidewinder Algorithm Maze",0,480-40
        DrawText "Press Mouse or Touch to create new maze",0,480-20
    End Method
End Class


Function Main()
    New MyGame()
End Function
