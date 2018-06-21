Import mojo

Class map
	Field sw:Int,sh:Int,mw:Int,mh:Int
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
		'Draw a rect on the map
		Local hor:Bool=False,ver:Bool=False
		If Rnd()<.5 Then hor=True Else ver=True
		Local x1:Int,y1:Int,x2:Int,y2:Int
		x1 = Rnd(10,mw/2)
		y1 = Rnd(10,mh/2)
		If hor=True
			x2 = x1+Rnd(mw/3,mw/1.5)
			y2 = y1+Rnd(2,4)
		Else
			x2 = x1+Rnd(2,4)
			y2 = y1+Rnd(mh/3,mh/1.5)
		End If
		For Local y:Int=y1 To y2
		For Local x:Int=x1 To x2
			If x<0 Or y<0 Or x>=mw Or y>=mh Then Continue
			map[x][y] = 1
		Next
		Next
		'Here we pull the drawers
		For Local i:Int=0 Until mw*mh/10
			drawer()
		Next
	End Method
	' Here we start at a point on the map
	' and go one direction until we reach a edge
	' we check if the size is suitable and then
	' pull out a chunk(drawer) creating a new part
	' of the map.
	'
	Method drawer()
		' First chose if we want to scan horizontal
		' or vertical
		Local ver:Bool=False
		Local hor:Bool=False
		If Rnd()<.5 Then ver=True Else hor=True
		' Then we scan from the edge inwards and
		' pull a drawer out of a side.
		Local x:Int,y:Int,s1:Int=Rnd(4,20),s2:Int=Rnd(2,mw*mh/100),mx:Int,my:Int
		If ver = True
			Local left:Bool=False
			Local right:Bool=False
			If Rnd()<.5 Then left = True Else right = True
			If left Then 
				x=Rnd(mw)
				mx=1				
			Elseif right
				x=Rnd(mw)
				mx=-1
			End If
			y = Rnd(5,mh-5)
			While x>5 And x<mw-5
				x+=mx
				' If we hit a edge part 
				If map[x][y] > 0
					' check if edge size is large enough
					For Local a:Int=y-s1/2-1 Until y+s1/2+1
						If a<0 Or a>=mw Then Return
						If map[x][a] <> 1 Then Return
					Next
					' pull out drawer
					Local lx:Stack<Int> = New Stack<Int>
					Local ly:Stack<Int> = New Stack<Int>
					For Local a:Int=0 Until s2
						For Local b:Int=y-s1/2 Until y+s1/2
							Local c:Int
							If left Then c = -1-a Else c=a+1
							If x+c<5 Or x+c>mw-1 Then Return
							If map[x+c][b] = 1 Then Return
							'map[x+c][b] = 1
							lx.Push(x+c)
							ly.Push(b)
						Next
					Next
					For Local i:Int=0 Until lx.Length
						map[lx.Get(i)][ly.Get(i)] = 1
					Next
					Return
				End If
			Wend
		Elseif hor=True
			Local up:Bool=False,down:Bool=False
			If Rnd()<.5 Then up=True Else down=True
			If down Then 
				y=Rnd(mh)
				my=1				
			Elseif up
				y=Rnd(mh)
				my=-1
			End If
			x = Rnd(5,mw-5)
			While y>5 And y<mw-5
				y+=my
				' If we hit a edge part 
				If map[x][y] > 0
					' check if edge size is large enough
					For Local a:Int=x-s1/2-1 Until x+s1/2+1
						If a<0 Or a>=mw Then Return
						If map[a][y] <> 1 Then Return
					Next
					' pull out drawer
					Local lx:Stack<Int> = New Stack<Int>
					Local ly:Stack<Int> = New Stack<Int>
					For Local a:Int=0 Until s2
						For Local b:Int=x-s1/2 Until x+s1/2
							Local c:Int
							If down Then c = -1-a Else c=a+1
							If y+c<5 Or y+c>mh-1 Then Return
							If map[b][y+c] = 1 Then Return
							lx.Push(b)
							ly.Push(y+c)
							'map[b][y+c] = 1
						Next
					Next
					For Local i:Int=0 Until lx.Length
						map[lx.Get(i)][ly.Get(i)] = 1
					Next
					Return
				End If
			Wend
			
		End If
	End Method
	Method draw()
		SetColor 255,255,255
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			If map[x][y] > 0
				DrawRect x*tw,y*th,tw+1,th+1
			Endif
		Next
		Next
	End Method
End Class

Class MyGame Extends App
	Field mymap:map
	Field cnt:Int=500
    Method OnCreate()
        SetUpdateRate(60)
        Seed = GetDate[4]+GetDate[5]
        mymap = New map(DeviceWidth,DeviceHeight,100,100)
    End Method
    Method OnUpdate()    
	    cnt-=1
    	If MouseHit(MOUSE_LEFT) Or cnt=0
    		cnt=500
    		Local s:Int=Rnd(32,300)
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
