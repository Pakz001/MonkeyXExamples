#rem
Aldous-Broder Maze

From the book - Mazes for programmers -

#end

Import mojo

Class cell
    Field north:Bool,east:Bool
    Field south:Bool,west:Bool
    Field visited:Bool
End Class

Class aldousbrodermaze
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
        makealdrousbrodermaze
    End Method
    '
    ' This method creates the maze
	' This is like the drunken walk algorithm.
	' You start a a random position And go in a
	' random diagonal direction. If the New cell
	' is unvisited Then carve a path And mark
	' visited. If not visited Then keep moving around
	' (no carving) until a unvisited cell is encountered.
    '
    Method makealdrousbrodermaze()
		Local remaining:Int=width*height-1
		Local mx:Int[] = [0,1,0,-1]
		Local my:Int[] = [-1,0,1,0]
		Local x:Int=Rnd(0,width)
		Local y:Int=Rnd(0,height)
		Local nx:Int,ny:Int
		map[x][y].visited = True
		While remaining>0		
			' random direction 0up 1right 2down 3left
			Local dir:Int=Rnd(0,4)
			' create new position
			nx = x+mx[dir]
			ny = y+my[dir]
			' if in bounds
			If nx>=0 And ny>=0 And nx<width And ny<height
			' if unvisited
			If map[nx][ny].visited = False
				' mark visited
				map[nx][ny].visited = True
				' exit loop counter -1
				remaining-=1
				' carve into direction
				Select dir
					Case 0'up
					map[x][y].north = True
					map[nx][ny].south = True
					Case 1'right
					map[x][y].east = True
					map[nx][ny].west = True
					Case 2'down
					map[x][y].south = True
					map[nx][ny].north = True
					Case 3'left
					map[x][y].west = True
					map[nx][ny].east = True
				End Select
			End If
			' set new position as current position
			x=nx
			y=ny
			End If
		Wend
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

Global maze:aldousbrodermaze

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
        maze = New aldousbrodermaze(10,10,500,400)
    End Method
    Method OnUpdate()        
        If MouseHit(MOUSE_LEFT)
            maze = New aldousbrodermaze(10,10,500,400)
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        maze.draw
        DrawText "Aldous Broder Maze",0,480-40
        DrawText "Press Mouse or Touch to create new maze",0,480-20
    End Method
End Class


Function Main()
    New MyGame()
End Function
