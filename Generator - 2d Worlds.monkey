Import mojo

Class map
	Field screenwidth:Int,screenheight:Int
	Field mapwidth:Int,mapheight:Int
	Field tilewidth:Float,tileheight:Float
	Field map:Int[][]
	Field depth:Int
	Method New(sw:Int,sh:Int,mw:Int,mh:Int,depth:Int)
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
		Self.depth=depth
		generatemap()
	End Method
	Method generatemap()
		' Here we create points on the map
		' and connect these points with thick lines
		Local x1:Int=Rnd(5)
		Local y1:Int=Rnd(mapheight)
		For Local i:Int=0 Until (mapwidth+mapheight/10)/depth
			Local x2:Int=Rnd(mapwidth)
			Local y2:Int=Rnd(mapheight) 
			If i=4 Then
				x2 = mapwidth-1
			End If
			Local exitloop:Bool=False
			While exitloop=False
				If x1<x2 Then x1+=1
				If y1<y2 Then y1+=1
				If x1>x2 Then x1-=1
				If y1>y2 Then y1-=1
				For Local i:Int=0 Until 9
					Local x3:Int=x1+Rnd(-2,2)
					Local y3:Int=y1+Rnd(-2,2)
					If x3<0 Or y3<0 Or x3>=mapwidth Or y3>=mapheight Then Continue
					map[x3][y3] = i
				Next
				If x1=x2 And y1=y2 Then exitloop=True
			Wend
		Next
		' here we pick a spot on the map
		' and then if this spot is a terrain then
		' we grow it on one of the sides.
		Local mx:Int[]=[0,-1,1,0]
		Local my:Int[]=[-1,0,0,1]
		For Local i:Int=0 Until (mapwidth*mapheight)*depth
			Local x:Int=Rnd(mapwidth)
			Local y:Int=Rnd(mapheight)
			If map[x][y] = 0 Then Continue
			Local terrain:Int=map[x][y]
			For Local ii:Int=0 Until mx.Length
				Local x2:Int=x+mx[ii]
				Local y2:Int=y+my[ii]
				If x2<0 Or y2<0 Or x2>=mapwidth Or y2>=mapheight Then Continue
				If Rnd(5)<2 Then map[x2][y2] = terrain
			Next			
		Next
	End Method
	Method draw()
		For Local y:Int=0 Until mapheight
		For Local x:Int=0 Until mapwidth
			If map[x][y] = 0 Then Continue
			Local x2:Int = x*tilewidth
			Local y2:Int = y*tileheight
			Local c:Int=(map[x][y])+20
			If map[x][y] = 1 Then 
			SetColor c*4,c*4,10 ' desert
			Elseif map[x][y] = 2
			SetColor c*4,c*4,c*4 'mountain
			Else
			SetColor 4,c*4,10 'grass/forrest/plains
			End If
			DrawRect x2,y2,tilewidth+1,tileheight+1
		Next
		Next
	End Method
End Class

Class MyGame Extends App
	
	Field mymap:map
	Field depth:Int
	Field mapsize:Int
	Field refresh:Int
    Method OnCreate()
        SetUpdateRate(5)
        Seed = GetDate[4]*GetDate[5]
        setgenvalue()
        mymap = New map(DeviceWidth,DeviceHeight,50,50,5)
    End Method
    Method OnUpdate()
    	refresh+=1
    	If KeyHit(KEY_SPACE) Or refresh>10
    		refresh=0
			setgenvalue()
    		mymap = New map(DeviceWidth,DeviceHeight,mapsize,mapsize,depth)
    	End If        
    End Method
    Method OnRender()
        Cls 10,20,200
        mymap.draw()
        SetColor 255,0,0
        DrawText "mapdimension: "+mapsize+" X "+mapsize+" - depth: "+depth,0,0
    End Method
    Method setgenvalue()
     	' how deep	
   		depth = Rnd(1,6)
   		mapsize = Rnd(20,255)    
    End Method
End Class


Function Main()
    New MyGame()
End Function
