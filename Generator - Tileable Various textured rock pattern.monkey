Import mojo

'
' This is the tile class.
' Here a stone tile is created
' using the generate method
Class tile
	Field width:Int,height:Int
	Field map:Int[][]
	Field a:Int[][]
	Field tile:Int[][][]
	Method New(w:Int,h:Int)
		Self.width = w
		Self.height = h
		map = New Int[width][]
		For Local i:Int=0 Until width
			map[i] = New Int[height]
		Next	
		tile = New Int[width][][]
        For Local i:Int = 0 Until width
            tile[i] = New Int[height][]
            For Local z:Int=0 Until height
                tile[i][z] = New Int[10]
            Next
        Next		
	End Method
	Method generate(spacing:Int)
		' Put a number of stone points on the map
		' try to keep a distance between them
		Local numpoints:Int=Rnd(width/5,width/2)
		For Local i:Int=0 Until numpoints
			Local x:Int=Rnd(width)
			Local y:Int=Rnd(height)
			Local exitloop:Bool=False
			While exitloop=False
				exitloop = True
				If disttootherstone(x,y,i) < spacing
				x=Rnd(width)
				y=Rnd(height)
				exitloop=False
				End If
			Wend
			map[x][y] = i
		Next
		'
		growstone(spacing)
		copyintotile(0)
		shadeedges(0)
		'
		For Local i:Int=1 Until 5
		preparecenter()
		growstone(spacing)		
		copyintotile(i)
		shadeedges(i)
		Next
		
	End Method
	
	Method copyintotile(num:Int)
		For Local y:Int=0 Until height
		For Local x:Int=0 Until width
			tile[x][y][num] = map[x][y]
		Next
		Next
	End Method


	Method preparecenter()
		'
		' Erase the center and create a new center
		'
		For Local y:Int=4 Until height-4
		For Local x:Int=4 Until width-4
			map[x][y] = 0
		Next
		Next
		' Create a few new points
		Local numpoints:Int=Rnd(1,4)
		For Local i:Int=40 Until 40+numpoints
			map[Rnd(9,width-9)][Rnd(9,height-9)] = i
		Next
		'

	End Method

	Method growstone(spacing:Int)	
		' Grow the stone points
		For Local i:Int=0 Until (width*height)*10
			Local x:Int=Rnd(width)
			Local y:Int=Rnd(height)
			If map[x][y] > 0
				If disttootherstone(x,y,map[x][y]) < spacing Then Continue  
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
	
	' Add ligther and darker pixels ontop of the stones
	' value 1 to <100 is each seperate stone
	' value 200 is light color 100 is dark color
	Method shadeedges(mytile:Int)
		For Local y:Int=0 Until height
		For Local x:Int=0 Until width
			If tile[x][y][mytile] > 0 And tile[x][y][mytile] <> 200			
			If x-1 >=0 And tile[x-1][y][mytile] = 0		
				For Local x2:Int=x+2 To x+4
					If Rnd(2)<1 
					If x2>=0 And x2<width And tile[x2][y][mytile] >0 Then tile[x2][y][mytile] = 100
					End If
				Next

			End If
			If x-1 >=0 And y-1>=0 And tile[x-1][y-1][mytile] = 0
			tile[x][y][mytile] = 100
			End If
			If x+1 < width And tile[x+1][y][mytile] = 0
				For Local x2:Int=x-4 To x+2
					If Rnd(2)<1 
					If x2>=0 And x2<width And tile[x2][y][mytile] >0 Then tile[x2][y][mytile] = 200
					End If
				Next

			End If
			End If
		Next
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
	' Draw the tile at x and y position and tw=size
	Method draw(thetile:Int,sx:Int,sy:Int,tw:Int,th:Int)
		Local x:Int
		Local y:Int
		

		For y=0 Until height
		For x=0 Until width		
			Local t:Int
			t = tile[x][y][thetile]
			Local x2:Int=x*tw
			Local y2:Int=y*th
			x2+=sx
			y2+=sy
			
			If t >= 1 Then 'grey base color
				SetColor 100,100,100
			End If
			If t=100 Then SetColor 40,40,40 'dark shade color
			If t=200 Then SetColor 140,140,140 'light shade color
			If t>0  ' draw a rect (part of the stone)
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
	Field cnt:Int=0
	Field map:Int[][]
    Method OnCreate()
    	Seed = GetDate[4]*GetDate[5]
        SetUpdateRate(1)
        mytile = New tile(32,32)
        mytile.generate(6)	
		map = New Int[30][]
		For Local i:Int=0 Until 30
			map[i] = New Int[30]
		Next
		For Local y:Int=0 Until 30
		For Local x:Int=0 Until 30
			map[x][y] = Rnd(0,5)
		Next
		Next
    End Method
    Method OnUpdate()
    	cnt+=1  
    	If KeyHit(KEY_SPACE) Or cnt>3
    		cnt = 0
	        mytile = New tile(32,32) 'reset/create new tile
	        Local spacing:Int=Rnd(4,10)  ' set random spacing
	        If Rnd(3)<1 Then spacing=4
    	    mytile.generate(spacing)	' generate the tile
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0
		For Local y:Int=0 Until 10
		For Local x:Int=0 Until 10
			Local x2:Int=x*32*2
			Local y2:Int=y*32*2
			mytile.draw(map[x][y],x2,y2,2,2)
		Next
		Next

    End Method
End Class


Function Main()
    New MyGame()
End Function
