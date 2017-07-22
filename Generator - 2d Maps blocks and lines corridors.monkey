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
		tw+=1
		th+=1
		' create the monkey array
		map = New Int[mw][]
		For Local i:=0 Until mw
			map[i] = New Int[mh]
		Next
		' Here we create a random map
		createmap()
		' Here we remove islands (unreachable area's)
		fillislands()
	End Method
	'
	' Here we floodfill the map. We flood a open area and if done
	' we check if we can flood another unflooded area. We give
	' this a new value. We count the amount of tiles per island so
	' we can fill the islands with the smallest area's.
	'
	Method fillislands()
		' create out flood map	
		Local fmap:Int[mw][]
		fmap = New Int[mw][]
		For Local i:=0 Until mw
			fmap[i] = New Int[mh]
		Next
		' create the open list
		Local olistx:List<Int> = New List<Int>
		Local olisty:List<Int> = New List<Int>
		Local floodcount:Int=1
		Local floodindex:Int[] = New Int[100]
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			If map[x][y] = 0 And fmap[x][y] = 0
				'flood here
				floodcount+=1
				olistx = New List<Int>
				olisty = New List<Int>
				olistx.AddLast(x)
				olisty.AddLast(y)
				fmap[x][y] = floodcount
				Local xs:Int[]=[-1,0,1,0]
				Local ys:Int[]=[0,-1,0,1]
				While olistx.Count > 0
					Local x2:Int=olistx.First
					Local y2:Int=olisty.First
					Local nx:Int
					Local ny:Int
					olistx.RemoveFirst
					olisty.RemoveFirst
					For Local i:=0 Until 4						
						nx = x2+xs[i]
						ny = y2+ys[i]
						If nx >=0 And nx<mw And ny>=0 And ny<mh And fmap[nx][ny] = 0 And map[nx][ny] = 0
							olistx.AddLast(nx)
							olisty.AddLast(ny)
							fmap[nx][ny] = floodcount
							floodindex[floodcount] += 1
						End If
					Next
				Wend
			End If
		Next
		Next
		' Here we know how many island there are. We need
		' to fill the smallest islands
		If floodcount <= 2 Then Return  'If only one area then finished
		' Here we find the largest surface and select this to not
		' be filled.
		Local largest:Int=0
		Local donotflood:Int=-1
		For Local i:=0 Until floodcount
			If floodindex[i] > largest Then largest = floodindex[i] ; donotflood=i
		Next
		' Fill every unreachable island
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			If map[x][y] = 0 And fmap[x][y] <> donotflood Then map[x][y] = 1
		Next
		Next
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
		
		' create vertical lines with corridors
		Local numcors:Int=mw/5
		Local xpos:List<Int> = New List<Int> 'for the vertical walls (location x)
		While numcors > 0			
			Local x:Int=Rnd(3,mw-3)
			Local good:Bool=True
			' make sure we do not place the walls near each other
			For Local i:=Eachin xpos
				If x = i Or x-1 = i Or x+1 = i Then good = False
				If x-2 = i Or x+2 = i Then good = False
			Next
			' if we are not placing the walls near each other
			If good = True
				' make a wall
				For Local y:=0 Until mh
					map[x][y] = 1
					xpos.AddLast(x)
				Next
				'make a couple of corridors in the wall
				For Local i:=0 Until mh/5
					Local cnt:Int=100
					Repeat
						Local y:Int=Rnd(mh-1)
						If map[x-1][y] = 0 And map[x+1][y] = 0
							map[x][y] = 0
							Exit
						End If
						cnt-=1
						If cnt<0 Then Exit
					Forever
				Next
				numcors -= 1
			End If
		Wend
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
    	If cntdown<=0 Or KeyHit(KEY_SPACE) Then 
    		size = Rnd(20,60)    
        	mymap = New themap(DeviceWidth(),DeviceHeight,size,size)
        	cntdown = 6
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
