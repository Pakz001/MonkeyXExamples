Import mojo

Class map
	Field map:Int[][]
	Field mw:Int,mh:Int
	Field tw:Float,th:Float
	Field sw:Int,sh:Int
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.tw = Float(sw) / Float(mw)
		Self.th = Float(sh) / Float(mh)
		Self.mw = mw
		Self.mh = mh
		map = New Int[mw][]
		For Local i:Int=0 Until mw
			map[i] = New Int[mh]
		Next
		If Rnd(2) < 1 Then createverlines else createhorlines
		makelines
		addblocks
		damage
		lighten
	End Method
	Method addblocks()
		For Local i:Int=0 Until (mw*mh)/200
			Local x1:Int=Rnd(mw)
			Local y1:Int=Rnd(mh)
			Local w:Int=Rnd(5,10)
			Local h:Int=Rnd(5,10)
			For Local y2:Int=y1-h To y1+h
			For Local x2:Int=x1-w To x1+w
				If x2<0 Or y2<0 Or x2>=mw Or y2>=mh Then Continue
				map[x2][y2] += 5
				map[x2][y2] *= 1.1
				If map[x2][y2] > 255 Then map[x2][y2] = 255
			Next
			Next
		Next
	End Method
	Method makelines()
		For Local i:Int=0 Until (mw*mh)/10
			mapline(Rnd(mw),Rnd(mh),Rnd(1,8),Rnd(360))
		Next
	End Method
	Method mapline(x1:Float,y1:Float,l:Int,an:Int)
		If map[x1][y1] < 10 Then Return
		Local effect:Int=Rnd(1,3)
		If effect = 0 Then Error "e"
		For Local i:Int=0 Until l
			x1 += Cos(an)
			y1 += Sin(an)
			If x1<0 Or y1<0 Or x1>=mw Or y1>=mh Then Return
			If effect = 1
				map[x1][y1] /= 2
			Else
				map[x1][y1] *= 1.2
				If map[x1][y1] > 255 Then map[x1][y1] = 255
			End If
		Next
	End Method
	Method damage()
		For Local i:Int=0 Until (mw*mh)
			Local x1:Int=Rnd(mw)
			Local y1:Int=Rnd(mh)
			If map[x1][y1] = 0 Then Continue
			Local cnt:Int=0
			For Local y2:Int=y1-1 To y1+1
			For Local x2:Int=x1-1 To x1+1
				If x2<0 Or y2<0 Or x2>=mw Or y2>=mh Then Continue
				If map[x2][y2] > 1 Then cnt+=1
			Next
			Next
			'Print cnt
			If cnt< 8 Then map[x1][y1] = 0
		Next
	End Method
	Method lighten()
		
		For Local i:Int=0 Until (mw*mh)*5
			Local x1:Int=Rnd(mw)
			Local y1:Int=Rnd(mh)
			If map[x1][y1] = 0 Then Continue
			Local cnt:Int=0
			For Local y2:Int=y1-1 To y1+1
			For Local x2:Int=x1-1 To x1+1
				If x2<0 Or y2<0 Or x2>=mw Or y2>=mh Then Continue
				If map[x2][y2] >= 128 Then cnt+=1
			Next
			Next
			If cnt>3 Then map[x1][y1] += 3 Else map[x1][y1] -= 3
			If map[x1][y1] < 0 Then map[x1][y1] = 0
			If map[x1][y1] > 255 Then map[x1][y1] = 255
			'If map[x1][y1] = 255 Or map[x1][y1] = 0 Then exitloop = True
		Next
	End Method
	Method createhorlines()
		For Local x:Int=0 Until mw 
		For Local y:Int=0 Until mh Step 11
		For Local y2:Int=y Until y+10
			If y2>=mh Then Continue
			map[x][y2] = 128
		Next
		Next
		Next
	End Method

	Method createverlines()
		For Local x:Int=0 Until mw Step 11
		For Local y:Int=0 Until mh
		For Local x2:Int=x Until x+10
			If x2>=mw Then Continue
			map[x2][y] = 128
		Next
		Next
		Next
	End Method
	Method draw()
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			Local c:Int=map[x][y]
			SetColor c,c,c
			DrawRect x*tw,y*th,tw+1,th+1
		Next
		Next
	End Method
End Class

Class MyGame Extends App
	Field mymap:map
	Field time:Int=Millisecs()+3000
    Method OnCreate()
        SetUpdateRate(1)
        mymap = New map(DeviceWidth,DeviceHeight,640,480)
    End Method
    Method OnUpdate()        
    	If Millisecs() > time Then
    		time = Millisecs() + 3000
	        mymap = New map(DeviceWidth,DeviceHeight,640,480)
    	Endif
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
