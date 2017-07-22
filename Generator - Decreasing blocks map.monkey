Import mojo

Class themap
	Field tw:Float,th:Float 'tile width and height
	Field mw:Int,mh:Int ' map width and height
	Field sw:Int,sh:Int ' screen width and height
	Field map:Int[][]  ' the array that holds the map
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		tw = Float(sw) / Float(mw)
		th = Float(sh) / Float(mh)
		' create the monkey array
		map = New Int[mw][]
		For Local i:=0 Until mw
			map[i] = New Int[mh]
		Next
		createmap()
	End Method
	' Here we create the map. Solid tiles (walls) are
	' value 1. nothing is value 0.
	' We create with the largest room size and see if it
	' fits on the map. The actual solid area size is 
	' a little bit smaller since we want movement space
	' between the blocks. If we can not fit a area
	' then we decrease the size and then see if it 
	' fits in the map and so on.
	Method createmap()
		Local rw:Int = (mw*mh)/100 ' roomwidth
		Local rh:Int = (mw*mh)/100' roomheight
		' Do not start with rooms to large or to small
		' and keep them somewhat squared in shape.
		If rw > 10 Then rw = 10 ; rh = 10
		If rh > 10 Then rh = 10 ; rw = 10
		If rw < 10 Then rw = 10 ; rh = 10
		If rh < 10 Then rh = 10 ; rw = 10
		Local countdown:Int=mw*mh/20
		Repeat
			Local x:Int=Rnd(0,mw-(rw+1))
			Local y:Int=Rnd(0,mh-(rh+1))
			' does the current block fit in the map?
			If fitshere(x,y,rw,rh)
				' Put it in
				putitin(x,y,rw,rh)
			Else  ' If it does not fit
				countdown-=1 	' give it some time to try other
								' locations
				If countdown <=0 Then  ' when tried enough times
					countdown = mw*mh/20
					rw -= 1 ' decrease the width and height of the rooms
					rh -= 1
				End If
			End If
			If rw <= 4 Or rh <= 4 Then Exit
		Forever
		
	End Method
	' Here we draw(fill in) the rectangle input into 
	' the map.
	
	Method putitin(x1:Int,y1:Int,w:Int,h:Int)
		For Local y2:=y1+2 Until y1+h-1
		For Local x2:=x1+2 Until x1+w-1
			map[x2][y2] = 1
		Next
		Next
	End Method
	' This takes rectangular area and see's if there is
	' a solid(1) value underneath it. If so it returns
	' a false.
	Method fitshere:Bool(x1:Int,y1:Int,w:Int,h:Int)
		For Local y2:=y1 Until y1+h
		For Local x2:=x1 Until x1+w
			If map[x2][y2] = 1 Then Return False
		Next
		Next
		Return True ' nothing underneath so it fits
	End Method
	' This method simply draws the map to the screen.
	Method draw()
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			If map[x][y] = 1
				SetColor 255,255,255
				DrawRect x*tw,y*th,tw,th
			End If
		Next
		Next
	End Method
End Class

Class MyGame Extends App
	Field mymap:themap
	Field cntdown:Int=2
	Field size:Int=30 ' Contains the size of the map w/h
    Method OnCreate()
        SetUpdateRate(1)
        Seed = GetDate[4] + GetDate[5]
        mymap = New themap(DeviceWidth(),DeviceHeight,size,size)
    End Method
    Method OnUpdate()   
    	cntdown-=1
    	If cntdown<=0 Then 
    		size = Rnd(20,100)    
        	mymap = New themap(DeviceWidth(),DeviceHeight,size,size)
        	cntdown = 2
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymap.draw()
        SetColor 255,255,255
		DrawText "Map width And height : "+size,0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
