Import mojo

Class map
	Field mw:Int,mh:Int,sw:Int,sh:Int
	Field tw:Float,th:Float
	Field map:Int[][]
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		tw = Float(sw)/Float(mw)
		th = Float(sh)/Float(mh)
		map = New Int[mw][]
		For Local i:Int=0 Until mw
			map[i] = New Int[mh]
		Next
		generate()
	End Method
	Method generate()
		' draw a line in the center of the map(horizontally)
		For Local x:Int=0 Until mw
			map[x][mw/2] = 1
		Next
		'pull a section of the line up or down
		For Local i:Int=0 Until mw
			pull()
		Next
		' Add hallways up/down
		For Local i:Int=0 Until mw
			hallup()
		Next
		' add rooms to the sides where possible
		For Local i:Int=0 Until mw
			hallroom()
		Next
		' make the lines wider
		double()
		If Rnd()<.5 Then grow(Rnd(.2,3))
	End Method
	Method grow(mult:Float)
		For Local i:Int= 0 Until mw*mh*mult
			Local x:Int=Rnd(1,mw-2)
			Local y:Int=Rnd(1,mh-2)
			If map[x][y] = 1
				map[x+Rnd(-1,2)][y+Rnd(-1,2)] = 1
			Endif
		Next
	End Method
	' Add rooms
	Method hallroom()
		' get random x and y coordinate
		Local y:Int=Rnd(mh)
		Local x:Int=Rnd(mw)
		' step to move left of right
		Local sx:Int
		If Rnd()<.5 Then sx=-1 Else sx=1
		' while inside the map
		While x>2 And x<mw-2
			' go left or right
			x+=sx
			' if we hit a line
			If map[x][y] = 1
				' Get a height for a room
				Local h:Int=Rnd(3,12)
				'see if there is room above and below
				' to place the room else return from method
				For Local a:Int=y-h/2 Until y+h/2	
					If a<0 Or a>=mw	Then return
					If map[x][a] = 0 Then Return
				Next
				'see if there is space to create room
				' either on the left or right side
				' get our new room width
				Local w:Int=Rnd(3,5)
				' randomly choose left or right side of the current location
				If Rnd()<.5 Then x+=w+1
				' check if this new space is already taken and
				' if so return from method
				For Local b:Int=y-h/2 Until y+h/2
				For Local a:Int=x-w Until x
					If a<0 Or a>=mw Or b<0 Or b>=mh Then Return
					If map[a][b] = 1 Then Return
				Next
				Next
				' create the room
				For Local b:Int=y-h/2 Until y+h/2
				For Local a:Int=x-w Until x
					map[a][b] = 1
				Next
				Next
				
			End If
		Wend
	End Method
	' Here we loop through the map
	' and we make the lines/rooms thicker
	Method double()
		For Local y:Int=0 Until mh
		For Local x:Int=1 Until mw
			If map[x][y] = 1 Then 
				map[x-1][y] = 1
			Endif
		Next
		Next
		For Local y:Int=1 Until mh
		For Local x:Int=0 Until mw
			If map[x][y] = 1 Then 
				map[x][y-1] = 1
			Endif
		Next
		Next
		
	End Method
	' Here we create hallways up or down
	Method hallup()
		' get a random x position
		Local x:Int=Rnd(mw)
		' set a width variable for the space left and right
		' of the hallway
		Local w:Int=5
		' set our hallway vertical length
		Local h:Int=Rnd(-mh/2,mh/2)
		' we scan top to bottom to find a space
		' where we can create a hallway.
		Local y:Int=0
		' loop top to bottom
		For Local y2:Int=y Until mh-1
			' if we found a map position taken
			If map[x][y2] = 1
				' Get the left and right coordinates
				Local lx:Int=x-w/2
				Local rx:Int=x+w/2
				' Exit if coordinates out of map
				If lx < 3 Or rx>mw-3 Then Return
				' exit if depth is 1+
				If map[x][y2] = 1 And map[x][y2+1] = 1 Then Return
				' Exit method if there is no straight line here
				' no suitable space
				For Local check:Int=lx-1 Until rx+1
					If map[check][y2] = 0 Then Return
					If y2-1>=0 And y2<=mh And map[check][y2-1] = 1 Then Return
					If map[check][y2+1] = 1 Then Return
				Next
				' draw the hallway
				Local a:Int
				Local b:Int
				If y2+h < y2 Then 
					a=y2+h ; b=y2
				Else
					a=y2 ; b=y2+h
				Endif
				For Local y3:Int=a To b
					If y3<0 Or y3>=mw Then continue
					map[x][y3] = 1
				Next
				' exit here
				Exit
			End If
		Next

		
	End Method
	' Pull a section of a line in the map up or down
	Method pull()		
		Local x:Int=Rnd(mw)
		Local w:Int=Rnd(5,25)
		Local h:Int=Rnd(-mh/2,mh/2)
		Local y:Int=0
		For Local y2:Int=y Until mh
			If map[x][y2] = 1
				' Get the left and right pull coordinates
				Local lx:Int=x-w/2
				Local rx:Int=x+w/2
				' Exit if coordinates out of map
				If lx < 3 Or rx>mw-3 Then Return
				If y2+h >= mh Or y2+h<0 Then Return
				' Exit method if there is no straight line here
				For Local check:Int=lx-2 Until rx+2
					If map[check][y2] = 0 Then Return
				Next
				' erase the line here
				For Local x3:Int=lx Until rx
					map[x3][y2] = 0
				Next
				' create new line here
				For Local x3:Int=lx Until rx
					map[x3][y2+h] = 1
				Next
				' connect line to main line
				Local a:Int
				Local b:Int
				If y2+h < y2 Then 
					a=y2+h ; b=y2
				Else
					a=y2 ; b=y2+h
				Endif
				For Local y3:Int=a To b
					map[lx][y3] = 1
					map[rx][y3] = 1
				Next
				' exit here
				Exit
			End If
		Next
	End Method	
	Method draw()
		SetColor 255,255,255
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			If map[x][y] > 0
				DrawRect x*tw,y*th,tw+1,th+1
			End If
		Next
		Next
	End Method
End Class

Class MyGame Extends App
	Field mymap:map
    Method OnCreate()
        SetUpdateRate(60)
        mymap = New map(DeviceWidth,DeviceHeight,100,100)
    End Method
    Method OnUpdate()   
    	If MouseHit(MOUSE_LEFT)
    		Local s:Int=Rnd(50,200)
	        mymap = New map(DeviceWidth,DeviceHeight,s,s)
    	End If         	
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mymap.draw()
    End Method
End Class


Function Main()
    New MyGame()
End Function
