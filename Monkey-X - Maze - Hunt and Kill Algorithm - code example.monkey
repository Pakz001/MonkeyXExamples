#rem
Hunt and Kill Algorithm - Maze

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

Class huntandkillmaze
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
        makehuntandkillmaze
    End Method
    '
    ' This method creates the maze
    '
    ' We start left top of the map and step into a random direction
    ' were we have not been before and carve a path there.
    ' When we can not find a unvisited cell around our last position
    ' we enter the kill mode and find a new unvisited spot on the map
    ' and carve a path to one of the visited cells around it. Then we
    ' return to hunt mode. If no more spots are found in kill mode
    ' then the maze is finished.
    '
    '
    Method makehuntandkillmaze()
    	Local x:Int=0,y:Int=0
    	Local state:String="hunt"
    	map[x][y].visited = True
    	Repeat
    		If state="hunt"
    			'read around x,y for unvisited cells
    			Local dir:Stack<Int> = New Stack<Int>
				If y-1 >= 0 And map[x][y-1].visited = False Then dir.Push(0)
				If x+1 < width And map[x+1][y].visited = False Then dir.Push(1)
				If y+1 < height And map[x][y+1].visited = False Then dir.Push(2)
    			If x-1 >= 0 And map[x-1][y].visited = False Then dir.Push(3)
    			'If we have a place to go then carve a path
				If dir.Length > 0
					Local s:Int=dir.Get(Rnd(dir.Length))
					If s = 0 'north
						map[x][y].north = True
						map[x][y-1].south = True
						y-=1
					End If
					If s = 1 'east
						map[x][y].east = True
						map[x+1][y].west = True
						x+=1
					End If
					If s = 2 'south
						map[x][y].south = True
						map[x][y+1].north = True
						y+=1
					End If
					If s = 3 'west
						map[x][y].west = True
						map[x-1][y].east = True
						x-=1
					End If
					map[x][y].visited = True
					Else 'no place to go so go into kill mode
					state = "kill"
				End If
    		End If
    		If state = "kill"
    			' if we are done flag
    			Local newspot:Bool=False
    			'loop through the entire map
    			For Local y1=0 Until height
    			For Local x1=0 Until width
    				'if we find a unvisited cell
    				If map[x1][y1].visited = False
    					'set to current position
    					x = x1
    					y = y1
    					'exit flag
	    				newspot = True
	    				'back to hunt mode next
	    				state = "hunt"
	    				' create a list with visited cells around the new spot
	    				Local dir:Stack<Int> = New Stack<Int>
	    				If y-1 >= 0 And map[x][y-1].visited = True Then dir.Push(0)
	    				If x+1 < width And map[x+1][y].visited = True Then dir.Push(1)
	    				If y+1 < height And map[x][y+1].visited = True Then dir.Push(2)
	    				If x-1 >= 0 And map[x-1][y].visited = True Then dir.Push(3)
	    				' pick a direction from the list
	    				Local s:Int=dir.Get(Rnd(dir.Length))
	    				'carve a path to the selected cell
	    				Select s
	    					Case 0'north
	    					map[x][y].north = True
	    					map[x][y-1].south = True
	    					Case 1'east
	    					map[x][y].east = True
	    					map[x+1][y].west = True
	    					Case 2'south
	    					map[x][y].south = True
	    					map[x][y+1].north = True
	    					Case 3'west
	    					map[x][y].west = True
	    					map[x-1][y].east = True	    					
	    				End Select
	    				'mark the new cell visited
    					map[x][y].visited = True
    					'exit the for for loop
    					Exit
    				End If
    			Next
    			Next
    			' If we have no new spot then we are done
    			If newspot = False Then Return
    		End If
    	Forever
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

Global maze:huntandkillmaze

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
        maze = New huntandkillmaze(10,10,500,400)
    End Method
    Method OnUpdate()        
        If MouseHit(MOUSE_LEFT)
            maze = New huntandkillmaze(10,10,500,400)
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        maze.draw
        DrawText "Hunt and Kill Algorithm Maze",0,480-40
        DrawText "Press Mouse or Touch to create new maze",0,480-20
    End Method
End Class


Function Main()
    New MyGame()
End Function
