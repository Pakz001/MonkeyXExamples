Import mojo

Class player
	Field x:Float,y:Float'player x and y position
	Field w:Int,h:Int 'width and height
	Method New()
		x = 350
		y = 350
		w = 20
		h = 20
	End Method
	Method update()
		Local oldx:Int=x,oldy:Int=y
		'controls
		If KeyDown(KEY_LEFT) Then 'if cursor key left
			If Not mymap.mapcollision(x-1,y,w,h) 'if new position NOT collide with map
				x-=1 ' move the player
			End If
		End If
		If KeyDown(KEY_RIGHT) Then
			If Not mymap.mapcollision(x+1,y,w,h)
			x+=1	
			End If		
		End If
		If KeyDown(KEY_UP) Then
			If Not mymap.mapcollision(x,y-1,w,h)
			y-=1
			End If
		End If
		If KeyDown(KEY_DOWN) Then
			If Not mymap.mapcollision(x,y+1,w,h)
			y+=1
			End If
		End If
		If x+w+1>=mymap.screenwidth Then x=oldx
		If x<=0 Then x=oldx
		If y<=0 Then y=oldy
		If y+h+1>=mymap.screenheight Then y=oldy
	End Method
	' Draw the player
	Method draw()
		SetColor 255,255,0
		DrawOval x,y,w,h
	End Method
End Class

Class map
	Field mapwidth:Int,mapheight:Int
	Field screenwidth:Int,screenheight:Int
	Field tilewidth:Float,tileheight:Float
	Field map:Int[][]
	Method New(screenwidth:Int,screenheight:Int,mapwidth:Int,mapheight:Int)
		Self.screenwidth = screenwidth
		Self.screenheight = screenheight
		Self.mapwidth = mapwidth
		Self.mapheight = mapheight
		tilewidth = Float(screenwidth) / Float(mapwidth)
		tileheight = Float(screenheight) / Float(mapheight)
		map = New Int[mapwidth][]
		For Local i:Int=0 Until mapwidth
			map[i] = New Int[mapheight]
		Next
		' draw a line of tiles in the map
		For Local x:=10 Until 15
			map[x][10] = 1
		Next
		map[19][19] = 1
	End Method
	'the x and y need to be at the center
	'if tile is 1 then collide
	Method mapcollision:Bool(x:Int,y:Int,w:Int,h:Int)
		Local lefttopx:Int=((x)/tilewidth)
		Local lefttopy:Int=((y)/tileheight)
		Local righttopx:Int=((x+w)/tilewidth)
		Local righttopy:Int=((y)/tileheight)
		Local leftbottomx:Int=((x)/tilewidth)
		Local leftbottomy:Int=((y+h)/tileheight)
		Local rightbottomx:Int=((x+w)/tilewidth)
		Local rightbottomy:Int=((y+h)/tileheight)
		' If there is a tile of value 1 here then return true
		If map[lefttopx][lefttopy] = 1 Then Return True
		If map[leftbottomx][leftbottomy] = 1 Then Return True
		If map[righttopx][righttopy] = 1 Then Return True
		If map[rightbottomx][rightbottomy] = 1 Then Return True
		' If there is no collision with the map then return
		' false
		Return False
	End Method
	Method draw()
		For Local y:Int=0 Until mapheight
		For Local x:Int=0 Until mapwidth
			Local px:Int=x*tilewidth
			Local py:Int=y*tileheight
			If map[x][y] = 1
				SetColor 255,0,0
				DrawRect px,py,tilewidth+1,tileheight+1
				SetColor 255,255,255
				DrawRect px+1,py+1,tilewidth-1,tileheight-1
			End If
		Next
		Next
	End Method
End Class

Global mymap:map
Global myplayer:player

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        mymap = New map(DeviceWidth,DeviceHeight,20,20)
        myplayer = New player()
    End Method
    Method OnUpdate()  
    	myplayer.update()      
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mymap.draw()
        myplayer.draw()
    End Method
End Class


Function Main()
    New MyGame()
End Function
