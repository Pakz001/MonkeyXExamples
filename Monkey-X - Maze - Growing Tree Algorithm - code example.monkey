#rem
Growing Tree Algorithm - Maze

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

Class growingtreemaze
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
        growingtreemaze
    End Method
    '
    ' This method creates the maze
    '
 	' The growing tree algorithm is like the prim's
 	' algorithm. It has a list with cells and either
 	' picks one out randomly or the last one. This
 	' cell location is used to carve to a neighbor.
 	' If the list is empty then the maze is done.
 	'
 	'
 	'
    Method growingtreemaze()
    	'This variable is used to select more or less
    	'variation. Lower is longer paths
    	Local variation:=Rnd(1,5)
        ' This is the list with neighbor cells
        Local availneighbors:Stack<cell> = New Stack<cell>
        ' pick a random cell position
        Local x:Int=Rnd(0,width)
        Local y:Int=Rnd(0,height)
        ' push to the neighbor list
        availneighbors.Push(New cell(x,y))
        ' mark visited
        map[x][y].visited = True
        ' loop until the list is emtpy
        While availneighbors.IsEmpty = False
        	' variable that holds the position we are
        	' on in the stack(deletion)
        	Local p:Int
        	' Chose between random and last
            If Int(Rnd(variation)) = 0 'last
            	p = availneighbors.Length-1
            	x = availneighbors.Get(p).x
            	y = availneighbors.Get(p).y
            Else'random
	            'get random position from list
	            p = Rnd(availneighbors.Length)
	            x = availneighbors.Get(p).x
	            y = availneighbors.Get(p).y
            End If
            ' make list for positions around the current cell
            Local dirs:Stack<Int> = New Stack<Int>
            ' put cells on the dirs list if unvisited and 
            ' on the map.
            If y-1 >= 0 And map[x][y-1].visited = False Then dirs.Push(0)
            If x+1 < width And map[x+1][y].visited = False Then dirs.Push(1)
            If y+1 < height And map[x][y+1].visited = False Then dirs.Push(2)
            If x-1 >= 0 And map[x-1][y].visited = False Then dirs.Push(3)
            ' if there are directions we can go into
            If dirs.Length > 0
                ' from all positions around the current cell
                ' select one direction.
                Local s:Int=dirs.Get(Rnd(0,dirs.Length))
                ' carve into direction and set x,y with new value
                Select s
                    Case 0'north
                    map[x][y].north = True
                    y-=1                    
                    map[x][y].south = True                    
                    Case 1'east
                    map[x][y].east = True
                    x+=1
                    map[x][y].west = True
                    Case 2'south
                    map[x][y].south = True
                    y+=1
                    map[x][y].north = True
                    Case 3'west
                    map[x][y].west = True
                    x-=1
                    map[x][y].east = True
                End Select
                ' mark new position as visited
                map[x][y].visited = True
                ' push new position to the availneighbors 
                ' list
                availneighbors.Push(New cell(x,y))                    
            Else ' if no neighbors then remove from 
                 ' availneighbors list
                availneighbors.Remove(p)
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

Global maze:growingtreemaze

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
        maze = New growingtreemaze(20,20,500,400)
    End Method
    Method OnUpdate()        
        If MouseHit(MOUSE_LEFT)
        	Seed = Millisecs
            maze = New growingtreemaze(20,20,500,400)
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        maze.draw
        DrawText "Growing Tree Algorithm Maze",0,480-40
        DrawText "Press Mouse or Touch to create new maze",0,480-20
    End Method
End Class


Function Main()
    New MyGame()
End Function
