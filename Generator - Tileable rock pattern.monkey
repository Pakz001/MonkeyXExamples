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
	Method generate()
		' Put a number of stone points on the map
		Local numpoints:Int=Rnd(width/5,width/2)
		For Local i:Int=0 Until numpoints
			Local x:Int=Rnd(width)
			Local y:Int=Rnd(height)
			Local exitloop:Bool=False
			While exitloop=False
				exitloop = True
				If disttootherstone(x,y,i) < 6
				x=Rnd(width)
				y=Rnd(height)
				exitloop=False
				End If
			Wend
			map[x][y] = i
		Next
		'
		' Grow the stone points
		For Local i:Int=0 Until (width*height)*10
			Local x:Int=Rnd(width)
			Local y:Int=Rnd(height)
			If map[x][y] > 0
				If disttootherstone(x,y,map[x][y]) < 6 Then Continue  
				For Local y2:Int=y-1 To y+1
				For Local x2:Int=x-1 To x+1
					If x2<0 Or y2<0 Or x2>=width Or y2>=height Then Continue
					If Rnd(5)<2 Then 
					If map[x2][y2] = 0
						If x2 = 0 Then map[width-1][y2] = map[x][y]
						If x2 = width-1 Then map[0][y2] = map[x][y]
						If y2 = 0 Then map[x2][height-1] = map[x][y]
						If y2 = height-1 Then map[x2][0] = map[x][y]
						map[x2][y2] = map[x][y]
					End If
					End If
				Next
				Next
			End If
		Next
	End Method
	' Returns the shortest distance to any other stone part then
	' the currentstore
	Method disttootherstone:Int(sx:Int,sy:Int,currentstone:Int)
		Local shortest:Int=9999
		For Local y:Int=0 Until height
		For Local x:Int=0 Until width
			If map[x][y] <> 0 And map[x][y] <> currentstone
				Local d:Int=distance(sx,sy,x,y)
				If d<shortest Then shortest = d
			End If
		Next
		Next
		Return shortest
	End Method
	Method draw(sx:Int,sy:Int,tw:Int,th:Int)
		Local x:Int
		Local y:Int
		

		For y=0 Until height
		For x=0 Until width
			Local t:Int=map[x][y]
			Local x2:Int=x*tw
			Local y2:Int=y*th
			x2+=sx
			y2+=sy
			
			If t >= 1 Then 'white outline
				SetColor 100,100,100
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
    	If KeyHit(KEY_SPACE)
	        mytile = New tile(32,32)
    	    mytile.generate()	
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0
        For Local y:Int=0 Until DeviceHeight() Step 32*4
        For Local x:Int=0 Until DeviceWidth() Step 32*4
        	mytile.draw(x,y,4,4)
        Next
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
