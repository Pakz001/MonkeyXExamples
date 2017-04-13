#rem
Recursive Backtracker Algorithm - Maze

From the book - Mazes for programmers -

#end

Import mojo

Class cell
    Field x:Int,y:Int
    Field north:Bool,east:Bool
    Field south:Bool,west:Bool
    Field visited:Bool=False
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
    End Method
End Class

Class recursivebacktrackermaze
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
        recursivebacktrackermaze
    End Method
    '
    ' This method creates the maze
    '
    '
    '
    Method recursivebacktrackermaze()
    	' This is a list that contains a x and y value
		Local path:Stack<cell> = New Stack<cell>
		' These variables we use to store the current cell we 
		' are on.
		Local x:Int=0,y:Int=0
		' push the first position to the top of the list
		path.Push(New cell(x,y))
		' mark the position as visited
		map[x][y].visited = True
		' loop until we have nothing left on the stack
		While path.IsEmpty = False
			' get position from the top of the stack list
			x = path.Top.x
			y = path.Top.y
			'get unvisited neighbours
			Local dir:Stack<Int> = New Stack<Int>
			If y-1 >= 0 And map[x][y-1].visited = False Then dir.Push(0)
			If x+1 < width And map[x+1][y].visited = False Then dir.Push(1)
			If y+1 < height And map[x][y+1].visited = False Then dir.Push(2)
			If x-1 >= 0 And map[x-1][y].visited = False Then dir.Push(3)
			' If we have unvisited neighbours
			If dir.Length > 0
				' get a random direction
				Local s:Int = dir.Get(Rnd(dir.Length))
				' carve to new position and add to top of stack
				' and mark visited for the selected direction.
				Select s
					Case 0'north
					map[x][y].north = True
					map[x][y-1].south = True
					path.Push(New cell(x,y-1))
					map[x][y-1].visited = True
					Case 1'east
					map[x][y].east = True
					map[x+1][y].west = True
					path.Push(New cell(x+1,y))
					map[x+1][y].visited =True
					Case 2'south
					map[x][y].south = True
					map[x][y+1].north = True
					path.Push(New cell(x,y+1))
					map[x][y+1].visited = True
					Case 3'west
					map[x][y].west = True
					map[x-1][y].east = True
					path.Push(New cell(x-1,y))
					map[x-1][y].visited = True
				End Select
			Else  
				'If no neighboors then backtrack 
				'(remove top item from stack)
				path.Pop
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

Global maze:recursivebacktrackermaze

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
        maze = New recursivebacktrackermaze(10,10,500,400)
    End Method
    Method OnUpdate()        
        If MouseHit(MOUSE_LEFT)
            maze = New recursivebacktrackermaze(10,10,500,400)
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        maze.draw
        DrawText "Recursive Backtracker Algorithm Maze",0,480-40
        DrawText "Press Mouse or Touch to create new maze",0,480-20
    End Method
End Class


Function Main()
    New MyGame()
End Function
