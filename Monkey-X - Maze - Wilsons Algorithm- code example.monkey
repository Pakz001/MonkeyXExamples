#rem
Wilsons Algorithm Maze

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

Class wilsonmaze
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
        makewilsonmaze
    End Method
    '
    ' This method creates the maze
    '
    ' The Wilson method of making a maze works by
    ' using the random walk method to create
    ' paths on unvisited parts on the map. It starts
    ' at a random position and moves around. If 
    ' its path overlaps then start over again. This until the
    ' path reaches a visited cell. Then carve the
    ' path out.
    '
    '
    Method makewilsonmaze()
		' tool for adding/subtracting directions
		Local mx:Int[] = [0,1,0,-1]
		Local my:Int[] = [-1,0,1,0]
		' one cell must be visited on the map
		Local x:Int=Rnd(0,width)
		Local y:Int=Rnd(0,height)
		map[x][y].visited = True
		' temp cell location
		Local nx:Int,ny:Int
		' starting state
		Local state:String="makepath"
		' here we select the starting cell 
		' an unvisited cell.
		Local exitloop:Bool=False
		While exitloop = False
			' create random pos
			x = Rnd(0,width)
			y = Rnd(0,height)
			' if unvisited then exit loop and set temp
			' position variables
			If map[x][y].visited = False
				exitloop = True
				nx = x
				ny = y
			End If
		Wend
		' create stack list
		Local path:Stack<cell> = New Stack<cell>
		' push first cell on the stack list
		path.Push(New cell(x,y))
		' if leftover = false then map is done
		Local leftover:Bool=True
		While leftover=True
			' here we make the path
			If state="makepath"
				' select a diagonal direction
				Local dir:Int
				dir=Rnd(0,4)
				' if inside of the map
				If nx+mx[dir]>=0 And ny+my[dir]>=0 And nx+mx[dir]<width And ny+my[dir]<height
					' set new position
					nx+=mx[dir]
					ny+=my[dir]
					Local go:Bool=True
					For Local i=0 Until path.Length
						' if we already have that position then start over
						If path.Get(i).x = nx And path.Get(i).y = ny
							path = New Stack<cell>
							nx = x
							ny = y
							path.Push(New cell(x,y))		
							go = False	
							Exit				
						End If
					Next
					' add new position to list and see
					' if we have reached a visited cell.
					If go=True
						path.Push(New cell(nx,ny))
						If map[nx][ny].visited = True
							' if we reached a visited cell then
							' carve out the path
							state = "carvepath"
						End If
					End If
				End If
			End If
			'
			' Here we carve the path we created
			If state="carvepath"
				' for getting the direction between the
				' data on the stack list
				Local dir:Int
				' get the first cell from the stack
				' list and mark it visited
				Local x1:Int,y1:Int
				x1 = path.Get(0).x
				y1 = path.Get(0).y
				map[x1][y1].visited = True
				' loop through the stack starting with the
				' second cell on the stack list
				For Local i=1 Until path.Length
					' copy the cell from the stack
					' list into vars and mark visited on map
					Local x2:Int=path.Get(i).x
					Local y2:Int=path.Get(i).y
					map[x2][y2].visited = True
					' find the direction between previous
					' and current cell from stack
					If x2=x1 And y2<y1 Then dir=0
					If x2>x1 And y2=y1 Then dir=1
					If x2=x1 And y2>y1 Then dir=2
					If x2<x1 And y2=y1 Then dir=3
					' carve out the path
					Select dir
						Case 0'up
						map[x1][y1].north = True
						map[x2][y2].south = True
						Case 1'right
						map[x1][y1].east = True
						map[x2][y2].west = True
						Case 2'down
						map[x1][y1].south = True
						map[x2][y2].north = True
						Case 3'left
						map[x1][y1].west = True
						map[x2][y2].east = True
					End Select
					' the last cell from the stack list
					' becomes the first cell
					x1 = x2
					y1 = y2
				Next
				'we no longer need the path list
				'so erase it
				path = New Stack<cell>
				' here we check if there are unvisited cells
				' left
				leftover = False
				For Local i=0 Until height
				For Local ii=0 Until width
					If map[ii][i].visited = False Then 
						leftover = True
						Exit
					End If
				Next
				Next
				' if there are unvisited cells left
				' then find a new cell to work with
				Local exitloop:Bool=False
				While exitloop = False And leftover = True
					Local x3:Int=Rnd(0,width)
					Local y3:Int=Rnd(0,height)
					If map[x3][y3].visited = False
						x = x3
						y = y3
						nx = x3
						ny = y3
						exitloop = True
					End If
				Wend
				' put the new cell on the path
				path.Push(New cell(x,y))
				' back to making the path
				state = "makepath"
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

Global maze:wilsonmaze

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
        maze = New wilsonmaze(10,10,500,400)
    End Method
    Method OnUpdate()        
        If MouseHit(MOUSE_LEFT)
            maze = New wilsonmaze(10,10,500,400)
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        maze.draw
        DrawText "Wilson Maze",0,480-40
        DrawText "Press Mouse or Touch to create new maze",0,480-20
    End Method
End Class


Function Main()
    New MyGame()
End Function
