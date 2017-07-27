' Cyclic map generator on tilemap

Import mojo

Class graph
	Field x:Int,y:Int
	Method New(x:Int,y:Int)
		Self.x = x
		Self.y = y
	End Method
End Class

Class themap	
	Field sx:Int,sy:Int,ex:Int,ey:Int
	Field mw:Int,mh:Int
	Field tw:Float,th:Float
	Field sw:Int,sh:Int
	Field map:Int[][]	
	Field maxgraphs:Int=5
	Field maxtunnelsize:Int
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		Self.tw = Float(sw) / Float(mw)
		Self.th = Float(sh) / Float(mh)
		map = New Int[mw][]
		For Local i:=0 Until mw
			map[i] = New Int[mh]
		Next
		If mw > 40 Then maxgraphs = mw/8
		maxtunnelsize = 5
		If mw>40 And Rnd(5)<2 Then maxtunnelsize = mw/7
		createcyclicmap
	End Method
	Method createcyclicmap()
		Local path1:List<graph> = New List<graph>
		Local path2:List<graph> = New List<graph>
		'x1 and y1 is the left starting graph on the map
		Local x1:Int=4
		Local y1:Int=mh/2
		'get the start location in the variables
		sx = x1
		sy = y1
		' number of graphs in the next path
		Local numgraphs:Int=Rnd(3,maxgraphs)
		' distance between graphs
		Local sx:Int=mw/(numgraphs+3)
		' holds the new location of the graph
		Local x2:Int=sx
		' path1 (bottom row - left to right)
		For Local i:=0 Until numgraphs			
			path1.AddLast(New graph(x1+x2,y1+mh/4+Rnd(mh/6)))
			x2+=sx
		Next
		' Set the amount of graphs in this path
		numgraphs=Rnd(3,maxgraphs)
		' distance between graphs
		sx=mw/(numgraphs+6)
		' set location to location of the end graph(right of map)
		x2-=sx

		' path2 (top row - right to left)
		For Local i:=0 Until numgraphs			
			path2.AddLast(New graph(x1+x2,y1-mh/4-Rnd(mh/6)))
			x2-=sx
		Next
		
		'carve tiles (lower path left to right)
		Local lastx:Int=x1
		Local lasty:Int=y1
		Local newx:Int
		Local newy:Int
		For Local i:=Eachin path1
			newx = i.x
			newy = i.y
			tunnel(lastx,lasty,newx,newy)
			lastx = newx
			lasty = newy
		Next
		tunnel(lastx,lasty,mw-4,mh/2)

		'carve tiles (lower path right to left)
		lastx=mw-4
		lasty=mh/2
		' Get the end point in the variables
		ex = lastx
		ey = lasty
		For Local i:=Eachin path2
			newx = i.x
			newy = i.y
			tunnel(lastx,lasty,newx,newy)
			lastx = newx
			lasty = newy
		Next
		tunnel(lastx,lasty,x1,y1)
		
	End Method
    ' This is the bresenham algorithm. It is modified so
    ' it fills two arrays with the x coordinates of the
    ' lines inside the triangles.
    Method tunnel:Void(x4:Int,y4:Int,x5:Int,y5:Int)
        Local dx:Int, dy:Int, sx:Int, sy:Int, e:Int
        dx = Abs(x5 - x4)
        sx = -1
        If x4 < x5 Then sx = 1      
        dy = Abs(y5 - y4)
        sy = -1
        If y4 < y5 Then sy = 1
        If dx < dy Then 
            e = dx / 2 
        Else 
            e = dy / 2          
        End If
        Local exitloop:Bool=False
        While exitloop = False

			' Here we create a walkable area			
		
			maprect(x4,y4,Rnd(3,maxtunnelsize))
			
          If x4 = x5 
              If y4 = y5
                  exitloop = True
              End If
          End If
          If dx > dy Then
              x4 += sx ; e -= dy 
               If e < 0 Then e += dx ; y4 += sy
          Else
              y4 += sy ; e -= dx 
              If e < 0 Then e += dy ; x4 += sx
          Endif

        Wend    		
	End Method
	Method maprect(x:Int,y:Int,s:Int)
		For Local y2:=-s/2 To s/2
		For Local x2:=-s/2 To s/2
			Local x3:Int=x2+x
			Local y3:Int=y2+y
			If x3<=0 Or y3<=0 Or x3>=mw Or y3>=mh Then Continue
			map[x3][y3] = 1
		Next
		Next
		
	End Method
	Method draw()
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			If map[x][y] = 1
				SetColor 255,55,5
				DrawRect x*tw,y*th,tw+1,th+1
			End If
		Next
		Next
		SetColor 255,0,0
		DrawCircle(sx*tw,sy*th,tw*2)
		SetColor 255,255,0
		DrawCircle(ex*tw,ey*th,tw*2)
		
	End Method
End Class

Global mymap:themap

Class MyGame Extends App
	Field s:Int=50
    Method OnCreate()
        SetUpdateRate(1)
        Seed = GetDate[4] + GetDate[5]
        mymap = New themap(DeviceWidth,DeviceHeight,s,s)
    End Method
    Method OnUpdate()        
    	s = Rnd(20,100)
        mymap = New themap(DeviceWidth,DeviceHeight,s,s)
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mymap.draw
    End Method
End Class



Function Main()
    New MyGame()
End Function
