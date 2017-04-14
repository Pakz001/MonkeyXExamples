#rem
Recursive Division with Rooms - Maze

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

Class recursivedivisionrmaze
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
        recursivedivisionrmaze
    End Method
    '
    ' This method creates the maze
    '
 	' We set every cell connection to true. Then
 	' we recursively split the grid in half by adding 
 	' walls back in. Every wall we add has one passage.
 	'
    Method recursivedivisionrmaze()
    	' Set all wall connections to true
    	For Local y=0 Until height
    	For Local x=0 Until width
    		map[x][y].north = True
    		map[x][y].east = True
    		map[x][y].south = True
    		map[x][y].west = True
    	Next
    	Next
		' Here we recursivly create the maze
		divide(0,0,width,height)
		' Here we add walls to the outer edge of the 
		' map.
		For Local y=0 Until height
			map[0][y].west = False
			map[width-1][y].east = False
		Next
		For Local x=0 Until width
			map[x][0].north = False
			map[x][height-1].south = False
		Next
    End Method
    ' Here we divide the grid vertically and
    ' horizontally. We exit it if the cell size
    ' is <=1
    Method divide(x:Int,y:Int,w:Int,h:Int)
    	If h <= 1 Or w <= 1 Then Return
		' Here we add the rooms    	
		Local roomw:Int=Rnd(3,8)
		Local roomh:Int=Rnd(3,8)
		If w<roomw And h<roomh And Int(Rnd(6)) = 0 Then Return
		' Here we select to either do a horizontal 
		' or vertical wall.
    	If h>w
    		divide_horizontally(x,y,w,h)
    	Else
    		divide_vertically(x,y,w,h)
    	End If
    End Method
    ' Here we create a horizontal line in the map
    Method divide_horizontally(x:Int,y:Int,w:Int,h:Int)
    	' Get the y location where we create the wall
    	Local divide_south_of:Int = Rnd(h-1)
    	' Here we set the location of the door
    	Local passage_at:Int = Rnd(w)
    	' Loop through the width of the map
    	For Local x1=0 Until w
    		' If not on the open door area
    		If passage_at <> x1 Then
    			' if not out of bounds
    			If x+x1 < width And y+divide_south_of < height
    			' Get the cell location
    			Local x2:Int = x+x1
    			Local y2:Int = y+divide_south_of
    			' Unlink the walls
    			map[x2][y2].south = False
    			If y2+1<height 
    			map[x2][y2+1].north = False
    			End If
    			End If
    		End If
    	Next
    	' Recurse - Make a new wall horizontally
    	' and vertically in the area we just did.
    	divide(x,y,w,divide_south_of+1)
    	divide(x,y+divide_south_of+1,w,h-divide_south_of-1)
    End Method    
    ' Here we create a vertical wall
    Method divide_vertically(x:Int,y:Int,w:Int,h:Int)
    	' get the location where we create the walls
    	Local divide_east_of:Int = Rnd(w-1)
    	' One location where we create an open door(passage)
    	Local passage_at:Int = Rnd(h)
    	' Loop from top to bottom of the map
    	For Local y1=0 Until h
    		' If not on a passage
    		If passage_at <> y1 Then
    		' If not out of bounds
    		If y+y1<height And x+divide_east_of < width
    			' Get the current cell to carve into
    			Local x2:Int = x+divide_east_of
    			Local y2:Int = y+y1
    			' Disconnect(carve) the wall
    			map[x2][y2].east = False
    			If x2+1<width
    			map[x2+1][y2].west = False
    			End If
    		End If
    		End If
    	Next
    	' Divide in this area again
    	divide(x,y,divide_east_of+1,h)
    	divide(x+divide_east_of+1,y,w-divide_east_of-1,h)
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

Global maze:recursivedivisionrmaze

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
        maze = New recursivedivisionrmaze(20,20,500,400)
    End Method
    Method OnUpdate()        
        If MouseHit(MOUSE_LEFT)
        	Seed = Millisecs
            maze = New recursivedivisionrmaze(20,20,500,400)
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        maze.draw
        DrawText "Recursive Division mazes with rooms.",0,480-40
        DrawText "Press Mouse or Touch to create new maze",0,480-20
    End Method
End Class


Function Main()
    New MyGame()
End Function
