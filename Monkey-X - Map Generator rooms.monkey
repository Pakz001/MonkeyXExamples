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
		While timeout<(mapwidth*mapheight)*20
			timeout+=1
			Local x:Int=Rnd(11,mapwidth-11)
			Local y:Int=Rnd(11,mapheight-11)
			If map[x][y] = 3
				makeroom(x,y)
			End If
		Wend	
		'here we turn doors into walls
		'if they should be walls
		For Local y1=1 Until mapheight-1
		For Local x1=1 Until mapwidth-1
			If map[x1][y1] = 3
			Local cnt:Int=0
			For Local y2=y1-1 To y1+1
			For Local x2=x1-1 To x1+1
				If map[x2][y2] = 2 Then cnt+=1
			Next
			Next
			If cnt>3 Then map[x1][y1] = 2
			End If
		Next
		Next
		'here we turn doors into walls if they
		' touch tiles that are nothing (0)
		For Local y1=1 Until mapheight-1
		For Local x1=1 Until mapwidth-1
			If map[x1][y1] = 3
			Local cnt:Int=0
			For Local y2=y1-1 To y1+1
			For Local x2=x1-1 To x1+1
				If map[x2][y2] = 0 Then cnt+=1
			Next
			Next
			If cnt>0 Then map[x1][y1] = 2
			End If
		Next
		Next		
		'here we turn the doors into floors
		For Local y1=0 Until mapheight
		For Local x1=0 Until mapwidth
			If map[x1][y1] = 3 Then map[x1][y1] = 1
		Next
		Next
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
				insertroom(x1,y1,w,h+1)
				'door up
				map[x1+Rnd(2,w-2)][y1] = 3
				' door right
				map[x1+w-1][y1+Rnd(2,h-2)] = 3
				'door left
				map[x1][y1+Rnd(2,h-2)] = 3
			End If						
			
		End If
		If side="right"
			Local x1:Int=x+1
			Local y1:Int=y-h/2
			If roomfits(x1,y1,w,h)
				insertroom(x1-1,y1,w,h)
				'door up
				map[x1+Rnd(2,w-2)][y1] = 3
				'door down
				map[x1+Rnd(2,w-2)][y1+h-1] = 3
				' door right
				map[x1+w-2][y1+Rnd(2,h-2)] = 3				
			End If
		End If
		If side="left"
			Local x1:Int=x-w
			Local y1:Int=y-h/2
			If roomfits(x1,y1,w,h)
				insertroom(x1,y1,w+1,h)
				'door up
				map[x1+Rnd(2,w-2)][y1] = 3
				'door down
				map[x1+Rnd(2,w-2)][y1+h-1] = 3				
				'door left
				map[x1][y1+Rnd(2,h-2)] = 3

			End If			
		End If
		If side="down"
			Local x1:Int=x-w/2
			Local y1:Int=y+1
			If roomfits(x1,y1,w,h)
				insertroom(x1,y1-1,w,h)
				'door down
				map[x1+Rnd(2,w-2)][y1+h-2] = 3				
				'door left
				map[x1][y1+Rnd(2,h-2)] = 3				
				' door right
				map[x1+w-1][y1+Rnd(2,h-2)] = 3				

			End If						
		End If
	End Method
	Method insertroom(x,y,w,h)
		For Local y2=y Until y+h
		For Local x2=x Until x+w
			If map[x2][y2] <> 3 Then map[x2][y2] = 2
		Next
		Next

		For Local y2=y+1 Until y+h-1
		For Local x2=x+1 Until x+w-1
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
    	If KeyHit(KEY_SPACE)
        mymap = New map(DeviceWidth,DeviceHeight,50,50)
    	End If    
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
