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
	End Method
	Method makemap()	
	End Method
	Method makeroom()
		Local w:Int=Rnd(3,10)
		Local h:Int=Rnd(3,10)
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
