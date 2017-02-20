Import mojo

Class map
	Field tilewidth:Float
	Field tileheight:Float
	Field mapwidth:Int
	Field mapheight:Int
	Field screenwidth:Int
	Field screenheight:Int
	Field map:Int[][]
	Method New(	screenwidth:Int,
				screenheight:Int,
				mapwidth:Int,
				mapheight:Int)
		Self.screenwidth = screenwidth
		Self.screenheight = screenheight
		Self.mapwidth = mapwidth
		Self.mapheight = mapheight
		Self.tilewidth = Float(screenwidth)/Float(mapwidth)
		Self.tileheight = Float(screenheight)/Float(mapheight)
		map = New Int[mapwidth][]
		For Local i=0 Until mapwidth
			map[i] = New Int[mapheight]
		Next
		map[mapwidth/2][mapheight/2] = 3 ' 3 is a door
		makemap
	End Method
	Method makemap()
		Local timeout:Int
		While timeout<mapwidth*mapheight
			timeout+=1
			Local x:Int=Rnd(11,mapwidth-11)
			Local y:Int=Rnd(11,mapheight-11)
			If map[x][y] = 3
				makeroom(x,y)
			End If
		Wend	
	End Method
	Method makeroom(x:Int,y:Int)
		Local side:String
		If map[x][y-1] = 0
			side="up"
		Elseif map[x+1][y] = 0
			side="right"
		Elseif map[x][y+1] = 0
			side="down"
		Elseif map[x-1][y] = 0
			side="left"
		End If		
		Local w:Int=Rnd(5,10)
		Local h:Int=Rnd(5,10)
		If side="up"
			Local x1:Int=x-w/2
			Local y1:Int=y-h
			If roomfits(x1,y1,w,h)
				insertroom(x1,y1,w,h)
				map[x1+Rnd(2,w-2)][y1] = 3
			End If						
			map[x1+w-1][y1+Rnd(2,h-2)] = 3
		End If
		If side="right"
		End If
	End Method
	Method insertroom(x,y,w,h)
		For Local y2=y Until y+h
		For Local x2=x Until x+w
			map[x2][y2] = 1
		Next
		Next		
	End Method
	Method roomfits(x:Int,y:Int,w:Int,h:Int)
		For Local y1=y Until y+h
		For Local x1=x Until x+w
			If map[x1][y1] = 1 Then Return False
		Next
		Next
		Return True
	End Method
	Method draw()
		For Local y=0 Until mapheight
		For Local x=0 Until mapwidth
			Select map[x][y]
				Case 0
				Case 1'floor
				SetColor 100,100,100
				DrawRect 	x*tilewidth,
							y*tileheight,
							tilewidth+1,
							tileheight+1
				Case 2'wall
				SetColor 200,200,200
				DrawRect 	x*tilewidth,
							y*tileheight,
							tilewidth+1,
							tileheight+1
				Case 3'wall
				SetColor 244,244,0
				DrawRect 	x*tilewidth,
							y*tileheight,
							tilewidth+1,
							tileheight+1

			End Select
		Next
		Next
	End Method
End Class

Global mymap:map

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(5)
        Seed = GetDate[4]+GetDate[5]
        mymap = New map(DeviceWidth,DeviceHeight,50,50)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymap.draw
        SetColor 255,255,255
    End Method
End Class


Function Main()
    New MyGame()
End Function
