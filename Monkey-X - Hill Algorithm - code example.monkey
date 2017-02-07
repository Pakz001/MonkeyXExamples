Import mojo

Global screenwidth:Int=640
Global screenheight:Int=480

Class hill
	Field map:Int[][]
	Field mapwidth:Int
	Field mapheight:Int
	Field tilewidth:Float
	Field tileheight:Float
	Method New(width:Int=20,height:Int=20)
		mapwidth = width
		mapheight = height
		tilewidth=Float(screenwidth)/Float(mapwidth)
		tileheight=Float(screenheight)/Float(mapheight)
		map = New Int[mapwidth][]
        For Local i=0 Until mapwidth
            map[i] = New Int[mapheight]
        Next		
        makehill
	End Method
	Method makehill()
		' Here we draw rectangles on the map adding by +1
		' with the underlaying value.
		'
		Local exitloop:Bool=False
		While exitloop = False
			Local x:Int=Rnd(-3,mapwidth)
			Local y:Int=Rnd(-3,mapheight)
			Local w:Int=Rnd(1,mapwidth/3)
			Local h:Int=Rnd(1,mapheight/3)
			If Rnd(2)<1.8
				w=1
				h=1
			End If
			' if highest map value > 20 then stop drawing
			' rectangles
			If addrect(x,y,w,h) > 24 Then exitloop = True
		Wend
	End Method
	Method addrect:Int(x:Int,y:Int,w:Int,h:Int)
		' This function draws the rectangle and
		' returns the highest value it makes in the map
		'
		Local highestvalue:Int
		For Local y1=y To y+h
		For Local x1=x To x+w
			If x1>=0 And x1<mapwidth And y1>=0 And y1<mapheight
				Local a:Int = map[x1][y1]
				a+=1
				If a>highestvalue Then highestvalue = a
				map[x1][y1] = a 
			End If
		Next
		Next
		Return highestvalue
	End Method
	Method draw()
		' world map
		' This function draws the map
		For Local y=0 Until mapheight
		For Local x=0 Until mapwidth
			Local c:Int=map[x][y]*10
			'water (low)
			If map[x][y] > 0 Then SetColor 0,0,100
			If map[x][y] > 5 Then SetColor 0,0,200
			If map[x][y] > 8 Then SetColor 0,0,250
			'grass (higher)
			If map[x][y] >=10 Then SetColor 0,c,0			
			'hills (higher)
			If map[x][y] >=15 Then SetColor c,c/2,0			
			'mountains (highest)
			If map[x][y] >=20 Then SetColor c,c,c						
			DrawRect Float(x)*tilewidth,Float(y)*tileheight,tilewidth+1,tileheight+1
		Next
		Next

		'heightmap
		SetScissor 320,0,320,480
		For Local y=0 Until mapheight
		For Local x=0 Until mapwidth
			Local c:Int=map[x][y]*10
			SetColor c,c,c
			DrawRect Float(x)*tilewidth,Float(y)*tileheight,tilewidth+1,tileheight+1		
		Next
		Next
		SetScissor 0,0,640,480
	End Method
End Class

Global mymap:hill

Class MyGame Extends App
	Field count:Int
    Method OnCreate()
    	Seed = GetDate[5]
        SetUpdateRate(1)
        mymap = New hill(20,20)
    End Method
    Method OnUpdate()        
    	count+=1
    	If count>3 Then
    		count=0
    		Local s:Int=Rnd(20,320)
    		mymap = New hill(s,s)
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymap.draw
        SetColor 255,255,255
		DrawText "Hill Algorithm",0,0
		DrawText "World Map",0,20
		DrawText "Height map",320,20
    End Method
End Class


Function Main()
    New MyGame()
End Function
