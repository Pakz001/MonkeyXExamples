#rem
Binary Tree Mazes

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
        makebintreemaze
    End Method
    '
    ' This method creates the maze
    '
    ' We go from left top to bottom right step by step.
    ' Here we remove then either the north wall or the west wall.
    '
    '
    Method makebintreemaze()
        ' north(0) west(1)
        For Local y=0 Until height
        For Local x=0 Until width
            ' create a stack
            Local dir:Stack<Int> = New Stack<Int>
            ' if on position where we can remove north and west wall
            ' add option to stack
            If y>0 Then dir.Push(0)
            If x>0 Then dir.Push(1)
            If dir.Length>0
                ' Get random north or west
                Local s:Int=dir.Get(Rnd(dir.Length))
                ' remove the north wall and south wall on neigbour cell
                If s=0 Then 
                    map[x][y].north=True
                    map[x][y-1].south=True
                End If
                ' remove the west wall and east wall on neigbour cell
                If s=1 Then
                    map[x][y].west=True
                    map[x-1][y].east=True
                End If
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
        DrawText "Binary Tree Maze",0,480-40
        DrawText "Press Mouse or Touch to create new maze",0,480-20
    End Method
End Class


Function Main()
    New MyGame()
End Function
