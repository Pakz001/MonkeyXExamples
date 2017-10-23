' Create a map with lines.
' It works by randomly selecting a point on the map
' and the drawing into a random direction. We stop
' drawing if we are close to a previously drawn line.
'

Import mojo

Class map
	Field screenwidth:Int
	Field screenheight:Int
	Field mapwidth:Int
	Field mapheight:Int
	Field tilewidth:Float
	Field tileheight:Float
	Field map:Int[][]
	Field spacing:Int
	Method New(sw:Int,sh:Int,mw:Int,mh:Int,spacing:Int)
		Self.screenwidth = sw
		Self.screenheight = sh
		Self.mapwidth = mw
		Self.mapheight = mh
		Self.tilewidth = Float(sw) / Float(mw)
		Self.tileheight = Float(sh) / Float(mh)
		map = New Int[mapwidth][]
		For Local i:Int=0 Until mapwidth
			map[i] = New Int[mapheight]
		Next
		Self.spacing = spacing
		createmap()
	End Method
	Method createmap()
		' Loop a number of times
		For Local i:Int=0 Until (mapwidth+mapheight)
			' Get a random x and y spot on the map
			Local x:Float=Rnd(mapwidth)
			Local y:Float=Rnd(mapheight)
			' Chose an angle
			Local angle:Int=Rnd(360)
			' We will draw d into angle it's direction
			Local d:Int=Rnd(3,mapwidth/3)
			Local xitloop:Bool=False
			' We change the angle and distance 3 times
			For Local iii:Int=0 Until 3
			' Loop the distance
			For Local ii:Int=0 Until d
				' If spot taken with 1 or out of screen 
				' then exit the loop
				If maptaken(x-spacing,y-spacing,spacing*2,spacing*2) Then xitloop=True ; Exit
				' Put value 2 into the map
				map[x][y] = 2
				' Next x and y position
				x+=Cos(angle)*1
				y+=Sin(angle)*1				
			Next
			' Exit the loop(spot taken)
			If xitloop=True Then Exit
			' Change angle and distance
			angle+=Rnd(-90,90)
			d=Rnd(3,mapwidth/3)
			Next
			' Turn all new drawn 2 value's into
			' value of 1
			For Local y:Int=0 Until mapheight
			For Local x:Int=0 Until mapwidth
				If map[x][y] = 2 Then map[x][y] = 1
			Next
			Next
		Next
	End Method
	' See if the area selected is outside the
	' screen or if the map value is 1
	Method maptaken:Bool(x:Int,y:Int,w:Int,h:Int)
		For Local y2:Int=y Until y+h
		For Local x2:Int=x Until x+w
			If x2<0 Or x2>=mapwidth Or y2<0 Or y2>=mapheight Then Return True
			If map[x2][y2] = 1 Then Return True
		Next
		Next
		Return False
	End Method
	' Draw the map
	Method draw()
		For Local y:Int=0 Until mapheight
		For Local x:Int=0 Until mapwidth
			If map[x][y] = 0 Then Continue
			SetColor 255,255,255				
			Local x2:Int=x*tilewidth
			Local y2:Int=y*tileheight
			DrawRect x2,y2,tilewidth+1,tileheight+1
		Next
		Next
	End Method
End Class

Class MyGame Extends App
	Field mymap:map
	Field cnt:Int=0
    Method OnCreate()
    	Seed = GetDate[4] * GetDate[5]
        SetUpdateRate(1)
        createrandommap()
    End Method
    Method OnUpdate()
    	cnt+=1
    	If KeyHit(KEY_SPACE) Or cnt > 1
    		cnt=0
    		createrandommap()
    	End If    
    End Method
    Method OnRender()
        Cls 0,0,0 
        ' Draw the map
        mymap.draw()
        SetColor 255,255,255
		Local mw:Int=mymap.mapwidth
		Local mh:Int=mymap.mapheight
		Local sp:Int=mymap.spacing
		DrawText "Width : "+mw+" Height : "+mh+" Spacing : "+sp,0,0
    End Method
	Method createrandommap()
		Local size:Int=Rnd(20,200)
		mymap = New map(DeviceWidth,DeviceHeight,size,size,Rnd(2,6))
	End Method
End Class



Function Main()
    New MyGame()
End Function
