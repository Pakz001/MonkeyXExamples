Import mojo

' This is a class that holds a x and y value
Class graph
	Field x:Int,y:Int
	Method New(x:Int,y:Int)
		Self.x = x
		Self.y = y
	End Method
End Class

Class themapgenerator
	' set up the variables for map width/height
	' screen width/height and tile width/height
	Field mw:Int,mh:Int,sw:Int,sh:Int
	Field tw:Float,th:Int
	' map contains the tile data (1=walkable area)
	Field map:Int[][]
	' For contains the graphnodes. (dots where
	' we draw the level/lines btween)
	Field nodes:Stack<graph>
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		' set up the variables
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
		' create the map
		generatemap()
	End Method
	' We basically create the map by creating a begin and
	' goal point. We then step a random amount of times
	' from below to begin to the goal and then from the
	' goal back to the begin. Each time creating a point
	' on the map. We then use these points to tunnel(paint)
	' the walkable area with.
	Method generatemap()
		' how many nodes between cycles (top and bottom)
		Local numnodes:Int
		' the tile steps based on the map widht
		' and the amount of nodes
		Local sx:Int
		' last x and y position for tunneling 
		Local lastx:Int,lasty:Int
		' current x and y position for tunneling
		Local currentx:Int,currenty:Int
		' this contains the points*graphs) between the
		' begin and goal points
		Local tunnel:Stack<graph> = New Stack<graph>
		' the begin and goal location
		Local begin:graph = New graph(mw/6,mh/2)
		Local goal:graph = New graph(mw-mw/6,mh/2)
		'-------------------------
		' Create nodes from begin to goal (left to right - below)
		' create random amount of nodes
		numnodes=Rnd(5,15)
		' calculate the steps
		sx = mw/numnodes
		' set start position
		Local x:Int=begin.x
		' while we are not at the goal put
		' new point in the stack
		Repeat 			
			x+=sx
			tunnel.Push(New graph(x,goal.y+Rnd(mh/2.5)))
			If x>=goal.x Then Exit
		Forever
		' put goal location on the stack
		tunnel.Push(New graph(goal.x,goal.y))
		' -----------------------
		'create nodes from goal to begin (right to left - above)
		' create random armount of nodes
		numnodes=Rnd(5,15)
		' calculate steps between nodes
		sx = mw/numnodes
		' set starting position
		x=goal.x
		' while we are not at the beginning point
		' put new point on the stack
		Repeat 			
			x-=sx
			tunnel.Push(New graph(x,goal.y-Rnd(mh/2.5)))
			If x<=begin.x Then Exit
		Forever
		tunnel.Push(New graph(begin.x,begin.y))
		
		' Tunnel between nodegraphs
		lastx = begin.x
		lasty = begin.y
		nodes = New Stack<graph>
		For Local i:=Eachin tunnel
			' put the node on the global node stack
			nodes.Push(New graph(i.x,i.y))
			' what is our current position
			currentx = i.x
			currenty = i.y
			' if the last position is not our current 
			' then tunnel towards it until we are there.
			While lastx <> currentx Or lasty<>currenty
				If lastx<currentx Then lastx+=1
				If lastx>currentx Then lastx-=1
				If lasty<currenty Then lasty+=1
				If lasty>currenty Then lasty-=1
				brushmap(lastx,lasty,2)
			Wend
			' set new last position
			lastx = currentx
			lasty = currenty
		Next
	End Method
	' Simple brush to draw a rectangle in a array (drawing)
	Method brushmap(x:Int,y:Int,size:Int)
		For Local y2:=-size To size
		For Local x2:=-size To size
			Local x3:Int=x+x2
			Local y3:Int=y+y2
			If x3<0 Or y3<0 Or x3>=mw Or y3>=mh Then Continue
			map[x3][y3] = 1
		Next
		Next
	End Method
	' Draw the tile 1 as a map in screen size
	Method draw()
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			If map[x][y] = 1
				SetColor 255,255,255
				DrawRect x*tw,y*th,tw+1,th+1
			End If
		Next
		Next
	End Method
	' Draw lines between graphs/points/nodes
	Method drawnodes()
		Local lastx:Int=nodes.Get(0).x
		Local lasty:Int=nodes.Get(0).y
		For Local i:=Eachin nodes
			SetColor 255,0,0
			DrawLine lastx*tw,lasty*th,i.x*tw,i.y*th
			lastx = i.x
			lasty = i.y
		Next
		DrawLine lastx*tw,lasty*th,nodes.Get(0).x*tw,nodes.Get(0).y*th
	End Method

End Class

Class MyGame Extends App
	Field mymapgenerator:themapgenerator
    Method OnCreate()
        SetUpdateRate(1)
        Seed = GetDate[4] + GetDate[5]
   		
    End Method
    Method OnUpdate() 
    	Local s:Int=Rnd(30,256)       
		mymapgenerator = New themapgenerator(DeviceWidth(),DeviceHeight(),s,s)
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymapgenerator.draw()
        mymapgenerator.drawnodes()
        SetColor 255,255,255
        DrawText "Graph based Cyclic Map Generator",0,0
        DrawText "Red Lines are drawn between nodegraphs",0,20
        DrawText "White area is the walkable area(created by tunneling between nodes",0,40
    End Method
End Class


Function Main()
    New MyGame()
End Function
