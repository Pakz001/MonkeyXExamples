Import mojo

Class tile
	Field width:Int,height:Int
	Field map:Int[][]
	Field map2:Int[][]

	Method New(w:Int,h:Int)
		Self.width = w
		Self.height = h
		map = New Int[width][]
		map2 = New Int[width][]
		For Local i:Int=0 Until width
			map[i] = New Int[height]
			map2[i] = New Int[height]
		Next		
	End Method
	' Here we create the flasks or bottles
	' or what else.
	Method generate()
		Local x:Float=width/2
		Local y:Float=height/4
		Local angle:Int=0

		While angle<200
			angle+=Rnd(1,10)
			For Local i:Int=0 Until 5
			x+=Cos(angle)*.2
			y+=Sin(angle)*.2
			If x>=width Then x=width-1
			If x<=0 Then x=1
			If y>=height Then y=height-1
			If y<=0 Then y=1
			map[x][y] = 1
			fillleftside(x-1,y)
			Next

		Wend
		clearleftside()
		mirrorrightside()
		shaderightside()
		shadecenter()
		createbottlelight()
		bottletop
	End Method
	Method bottletop()
		Local x:Float=width/2
		Local y:Float=2
		Local angle:Int=0

		While angle<200
			angle+=Rnd(5,20)
			For Local i:Int=0 Until 5
			x+=Cos(angle)*.2
			y+=Sin(angle)*.2
			If x>=width Then x=width-1
			If x<=0 Then x=1
			If y>=height Then y=height-1
			If y<=0 Then y=1
			map2[x][y] = 1
			fillleftsidetop(x-1,y)
			Next

		Wend
		clearleftsidetop()
		mirrorrightsidetop()
		addbottleceiling()
		darkshadebottletop()
		bottletopbottomshade()
		mergebottletop		
	End Method
	Method bottletopbottomshade()
		Local b:Int=0 'bottom y of bottletop
		Local t:Int=0 'start y of bottletop
		While map2[width/2][t] = 0
			t+=1
		Wend
		b=t
		While map2[width/2][b] <> 0
			b+=1
		Wend
		For Local y:Int=b Until b-3 Step -1
		For Local x:Int=0 Until width
			If map2[x][y] = 1 Then map2[x][y+1] = 4
		Next
		Next		
	End Method
	Method darkshadebottletop()
		Local b:Int=0 'bottom y of bottletop
		Local t:Int=0 'start y of bottletop
		While map2[width/2][t] = 0
			t+=1
		Wend
		b=t
		While map2[width/2][b] <> 0
			b+=1
		Wend
		For Local x:Int=0 Until width
		For Local y:Int=t+3 Until b
			If map2[x][y] = 6 Then map2[x][y] = 7
		Next
		Next
	End Method
	Method addbottleceiling()
		For Local y:Int=1 Until height-1
		For Local x:Int=0 Until width
		If map2[x][y+1] = 5 And map2[x][y] = 0 Then map2[x][y] = 1 ; map2[x][y+1] = 6
		Next
		Next
	End Method
	Method fillleftsidetop(fx:Int,fy:Int)
		For Local x:Int=fx Until 0 Step -1
			map2[x][fy] = 5
		Next
		map2[fx][fy] = 6
	End Method
	Method mirrorrightsidetop()
		For Local y:Int=0 Until height
		For Local x:Int=0 Until width/2
			map2[x][y] = map2[width-1-x][y]
		Next
		Next
		
	End Method
	Method clearleftsidetop()
		For Local y:Int=0 Until height
		For Local x:Int=0 Until width/2
			map2[x][y] = 0
		Next
		Next
	End Method


	Method mergebottletop()
		For Local y:Int=0 Until height
		For Local x:Int=0 Until width
			If map2[x][y] > 0
				map[x][y] = map2[x][y]
			End If
		Next
		Next
	End Method
	Method createbottlelight()
		For Local y:Int=height-height/2 Until height/2-height/4 Step -1
		For Local x:Int=width/2 Until width
			If map[x][y] = 1 Then 
				map[x-5][y+5] = 1
			End If
		Next
		Next
	End Method
	Method shadecenter()
		Local sw:Int=0
		For Local y:Int=height/1.7 Until height
		For Local x:Int=0 Until width
			If map[x][y] = 2
				If x Mod 2 = sw
				map[x][y] = 4
				End If
			End If
			
		Next
		If sw=1 Then sw=0 Else sw=1
		Next		
	End Method
	Method shaderightside()
		For Local y:Int=0 Until height
		For Local x:Int=0 Until width
			If x<width/2
				If map[x][y] = 3 Then map[x][y] = 4
			End If
		Next
		Next
	End Method
	Method mirrorrightside()
		For Local y:Int=0 Until height
		For Local x:Int=0 Until width/2
			map[x][y] = map[width-1-x][y]
		Next
		Next
		
	End Method
	Method clearleftside()
		For Local y:Int=0 Until height
		For Local x:Int=0 Until width/2
			map[x][y] = 0
		Next
		Next
	End Method
	' here we put the value of
	' 2 inside the map from inputted
	' coords to most left position
	Method fillleftside(fx:Int,fy:Int)
		For Local x:Int=fx Until 0 Step -1
			map[x][fy] = 2
		Next
		map[fx][fy] = 3
	End Method
	Method draw(sx:Int,sy:Int,tw:Int,th:Int,r:Int,g:Int,b:Int)
		Local x:Int
		Local y:Int
		
		For Local y:Int=0 Until height
			SetColor ((255/height)*y)/2,100,100
			DrawRect 0+sx,y+sy,width,1
		Next

		For y=0 Until height
		For x=0 Until width
			Local t:Int=map[x][y]
			Local x2:Int=x*tw
			Local y2:Int=y*th
			x2+=sx
			y2+=sy
			
			If t = 1 Then 'white outline
				SetColor 150,150,150
			End If
			' bottle color 2 = main 3 is light 4 is dark
			If t = 2 Then
				'SetColor 255,0,0
				SetColor r,g,b
			Elseif t = 3 Then 'light
				Local r2:Int=r+r/6
				Local g2:Int=g+g/6
				Local b2:Int=b+b/6
				If r2>255 Then r2=255
				If g2>255 Then g2=255
				If b2>255 Then b2=255
				'SetColor 255,150,150
				SetColor r2,g2,b2
			Elseif t = 4 Then 'dark
				'SetColor 200,0,0
				Local r2:Int=r-r/4
				Local g2:Int=g-g/4
				Local b2:Int=b-b/4
				If r2<0 Then r2=0
				If g2<0 Then g2=0
				If b2<0 Then b2=0
				SetColor r2,g2,b2
			End If
			If t = 5  'bottle top color 6 is light 7 is dark
				SetColor 155,100,0
			Elseif t=6
				SetColor 200,120,0				
			Elseif t=7
				SetColor 100,70,0
			End If
			If t>0
			DrawRect x2,y2,tw,th
			End If
		Next
		Next
	
	End Method
    Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Function	
End Class

Class MyGame Extends App
	Field mytile:tile
    Method OnCreate()
    	Seed = GetDate[4]*GetDate[5]
        SetUpdateRate(1)
        mytile = New tile(32,32)
        mytile.generate()	

    End Method
    Method OnUpdate()  
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
		For Local y:Int=0 Until DeviceHeight() Step 40
		For Local x:Int=0 Until DeviceWidth() Step 40
	        mytile = New tile(32,32)
    	    mytile.generate()	
			
	        mytile.draw(x,y,1,1,Rnd(255),Rnd(255),Rnd(255))
        Next
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
