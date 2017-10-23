Import mojo

Class tile
	Field width:Int,height:Int
	Field map:Int[][]
	Method New(w:Int,h:Int)
		Self.width = w
		Self.height = h
		map = New Int[width][]
		For Local i:Int=0 Until height
			map[i] = New Int[height]
		Next		
	End Method
	' Here we create the flasks or bottles
	' or what else.
	Method generate()
		'make right side
		' from the center top to center bottom 
		Local x:Float=width/2
		Local y:Float=0
		Local angle:Int=0
		While y<=height
		For Local i:Int=0 Until 20
			x+=Cos(angle)*.5
			y+=Sin(angle)*.5
			If x>=width Then x-=1
			If x<0 Or y<0 Or x>=width Or y>=height Then Exit
			map[x][y] = 1 ' create border point
			fillleftside(x-1,y) ' fill left side
		Next
		angle=Rnd(0,120)
		Wend
		If y>height Then y=height-1
		For Local x1:Int=x Until width/2-1 Step -1
			map[x1][y] = 1
		Next
		'make left side (mirror right side)
		For y = 0 Until height
		For x = width/2 Until width
			map[width-x][y] = map[x][y]
		Next
		Next
		Return
	End Method
	' here we put the value of
	' 2 inside the map from inputted
	' coords to most left position
	Method fillleftside(fx:Int,fy:Int)
		For Local x:Int=fx Until 0 Step -1
			map[x][fy] = 2
		Next
	End Method
	Method draw(sx:Int,sy:Int)
		Local c:Int
		For Local y:Int=0 Until height
		For Local x:Int=0 Until width
			If map[x][y] = 0 Then Continue
			' here we draw the border 
			' and the red (rainbowish color)
			Select map[x][y]
				Case 1'border 
				c = 255-((255/height)*y)
				SetColor c,c,c
				Case 2
				c = 255-((255/height)*y)
				SetColor c,55,55
			End Select
			DrawRect sx+x,sy+y,1,1			
		Next
		Next
	End Method
End Class

Class MyGame Extends App
	Field mytile:tile
    Method OnCreate()
    	Seed = GetDate[4]*GetDate[5]
        SetUpdateRate(1)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        For Local y:Int=0 Until DeviceHeight Step 55
        For Local x:Int=0 Until DeviceWidth Step 55
        mytile = New tile(48,48)
        mytile.generate()	
        mytile.draw(x,y)
        Next
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
