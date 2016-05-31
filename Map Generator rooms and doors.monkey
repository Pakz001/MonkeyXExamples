Import mojo


Class map
	Field tw:Float,th:Float
	Field mw:Int,mh:Int
	Field map:Int[][]
	Field maxroomsize:Int=15
	Field minroomsize:Int=5
	Method New(mapwidth,mapheight)
        map = New Int[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next	
		tw = 640/mapwidth
		th = 480/mapheight
		Self.mw = mapwidth
		Self.mh = mapheight
		makemap()
	End Method
	Method makemap()
		map[mw/2][mh/2] = 3
		Local total:Int=Rnd(20000,150000)
		For Local i=0 To total
			Local x:Int = Rnd(maxroomsize+2,mw-(maxroomsize+2))
			Local y:Int = Rnd(maxroomsize+2,mh-(maxroomsize+2))
			If map[x][y] = 3
				Local a:Int = Rnd(0,4)
				Local w:Int=Rnd(minroomsize,maxroomsize)
				Local h:Int=Rnd(minroomsize,maxroomsize)
				Select a
					Case 0'nroom
					If fits(x-w/2,y-h,w,h-1) = True
						mr(x,y-h,x+w/2,y-h/2,x,y,x-w/2,y-h/2)
					Endif
					Case 1'eroom
					If fits(x+1,y-h/2,w,h) = True
						mr(x+w/2,y-h/2,x+w,y,x+w/2,y+h/2,x,y)
					Endif
					Case 2'sroom
					If fits(x-w/2,y+1,w,h) = True
						mr(x,y,x+w/2,y+h/2,x,y+h,x-w/2,y+h/2)
					Endif
					Case 3'wroom
					If fits(x-w-1,y-h/2,w,h) = True
						mr(x-w/2,y-h/2,x,y,x-w/2,y+h/2,x-w,y)
					Endif
				End Select
			End If
		Next
		' here we remove left over doors
		For Local y:Int=2 To mh-2
		For Local x:Int=2 To mw-2
			If map[x][y] = 3
				' If into darkness Then remove
				If map[x-1][y] = 0 Or map[x+1][y] = 0
					map[x][y] = 2
				End If
				If map[x][y-1] = 0 Or map[x][y+1] = 0
					map[x][y] = 2
				End If
				Local cnt:Int=0
				' every door If blocked remove
				For Local y1:Int=y-1 To y+1
				For Local x1:Int=x-1 To x+1
					If map[x1][y1] = 2 Then cnt=cnt+1
				Next
				Next
				If cnt>2 Then map[x][y]=2
			End If
		Next
		Next		
	End Method
	'	 makeroom
	Method mr(x1:Int,y1:Int,x2:Int,y2:Int,x3:Int,y3:Int,x4:Int,y4:Int)
		For Local y5=y1 To y3
		For Local x5=x4 To x2
			map[x5][y5] = 1
		Next
		Next
		For Local y5=y1 To y3
			map[x4][y5] = 2
			map[x2][y5] = 2		
		Next
		For Local x5=x4 To x2
			map[x5][y1] = 2
			map[x5][y3] = 2
		Next
		map[x1][y1] = 3
		map[x2][y2] = 3
		map[x3][y3] = 3
		map[x4][y4] = 3
	End Method
	' Is there anything in the map
	Method fits(x:Int,y:Int,w:Int,h:Int)
		' If outside
		If x<0 Or y<0 Or x+w>mw Or y+h>mh Then Return False	
		' If inside
		For Local y1=y To y+h
		For Local x1=x To x+w
			If map[x1][y1]>0 Then Return False
		Next
		Next
		Return True
	End Method

	Method draw()
		For Local y1=0 Until mh
		For Local x1=0 Until mw
			Select map[x1][y1]
				Case 0;SetColor 0,0,0
				Case 1;SetColor 100,100,100
				Case 2;SetColor 200,200,200
				Case 3;SetColor 255,0,0
			End Select
			DrawRect x1*tw,y1*th,tw,th
		Next
		Next
	End Method
End Class

Global m:map = New map(100,100)

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0         
        SetColor 255,255,255
        m.draw
    End Method
End Class


Function Main()
    New MyGame()
End function
