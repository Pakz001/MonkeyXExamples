#rem
Randomized Kruskal's Algorithm - Maze

From the book - Mazes for programmers -

#end

Import mojo


Class cell
    Field x:Int,y:Int
    Field north:Bool,east:Bool
    Field south:Bool,west:Bool
    Field visited:Bool=False
	Field value:Int
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
    End Method
End Class

Class randomizedkruskalsmaze
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
        randomizedkruskalsmaze
    End Method
    '
    ' This method creates the maze
    '
    ' Randomized kruskal works by creating a stack list
    ' with connections between each cell. Either a east or
    ' a south. On the map each cell has a unique value.
    ' we randomly pick a connection from the list and connect it
    ' if the map values are different. We then turn both the
    ' different map values and turn them into one value.
    ' We then delete this connection from the list. The maze 
    ' is done if the list is empty.
    '
    Method randomizedkruskalsmaze()
    	' create a stack list with cell class
    	Local connection:Stack<cell> = New Stack<cell>
    	' variable with value to assign to each cell
    	Local val:Int=0
    	' loop though the map
    	For Local y=0 Until height
    	For Local x=0 Until width
    		' add east link to connection stack
    		If x<width-1
	    		connection.Push(New cell(x,y))
	    		connection.Top.east = True
    		End If
    		' add south link to connection stack
    		If y<height-1
    			connection.Push(New cell(x,y))
    			connection.Top.south = True    		
    		End If
    		' give the map its unique value
    		map[x][y].value = val
    		' increase the value
    		val+=1
    	Next
    	Next
    	' loop until the connection stack is empty
    	While connection.IsEmpty = False
	    	' get a random link from the stack
    		Local r:Int = Rnd(connection.Length)
    		' get its x and y and value
    		Local x:Int = connection.Get(r).x
    		Local y:Int = connection.Get(r).y
    		Local v:Int = map[x][y].value
    		' s we use to see if it is east or south
    		Local s:Int
    		If connection.Get(r).east = True Then s = 0
    		If connection.Get(r).south = True Then s = 1
    		' remove the link from the stack list
			connection.Remove(r)
			' here we carve a connection if the cell
			' we are on and the east or south has a different
			' value. Then we give them one and the same value.
    		Select s
    			Case 0 'east
    			If map[x][y].value <> map[x+1][y].value
    				map[x][y].east = True
    				map[x+1][y].west = True
    				merge(v,map[x+1][y].value)
    			End If
    			Case 1'south
    			If map[x][y].value <> map[x][y+1].value
    				map[x][y].south = True
    				map[x][y+1].north = True
    				merge(v,map[x][y+1].value)
    			End If
    		End Select
    	Wend
	End Method
	' This method takes all of one value on the map and turns it into 
	' another.
	Method merge(a:Int,b:Int)
		For Local y=0 Until height
		For Local x=0 Until width
			If map[x][y].value = b Then map[x][y].value = a
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

Global maze:randomizedkruskalsmaze

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
        maze = New randomizedkruskalsmaze(10,10,500,400)
    End Method
    Method OnUpdate()        
        If MouseHit(MOUSE_LEFT)
            maze = New randomizedkruskalsmaze(10,10,500,400)
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        maze.draw
        DrawText "Randomized Kruskal's Algorithm Maze",0,480-40
        DrawText "Press Mouse or Touch to create new maze",0,480-20
    End Method
End Class


Function Main()
    New MyGame()
End Function
