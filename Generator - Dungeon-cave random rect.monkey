Import mojo

Class tilemap	
	Field tilew:Int
	Field tileh:Int
	Field width:Int
	Field height:Int
	Field map:Int[][]
	Method New(width:Int,height:Int,tilew:Int,tileh:Int)
		Self.width=width
		Self.height=height
		Self.tilew=tilew
		Self.tileh=tileh
		map = New Int[width][]
		For Local i=0 Until width
			map[i] = New Int[height]
		Next
		makemap
		settiles
	End Method
	' Here we create the walls
	Method settiles()
		'create walls
		For Local y=1 Until height-1
		For Local x=1 Until width-1
			Local t:Int=map[x][y]
			If t=0 And map[x+1][y] = 1 Then map[x][y] = 2
			If t=0 And map[x][y+1] = 1 Then map[x][y] = 2
			If t=0 And map[x-1][y] = 1 Then map[x][y] = 2
			If t=0 And map[x][y-1] = 1 Then map[x][y] = 2
		Next
		Next
		' get corners
		For Local y=1 Until height-1
		For Local x=1 Until width-1
			Local t:Int=map[x][y]
			If t=0 And map[x+1][y] = 2 And map[x][y+1] = 2 Then map[x][y] = 3
			If t=0 And map[x-1][y] = 2 And map[x][y+1] = 2 Then map[x][y] = 3
			If t=0 And map[x][y-1] = 2 And map[x+1][y] = 2 Then map[x][y] = 3
			If t=0 And map[x-1][y] = 2 And map[x][y-1] = 2 Then map[x][y] = 3
		Next
		Next
		'set corners to value 2
		For Local y=1 Until height-1
		For Local x=1 Until width-1
			If map[x][y] = 3 Then map[x][y] = 2
		Next
		Next
	End Method
	Method makemap()
		'here we make random rectangles and see if they 
		'are placed next to another rectangle.
		'This will grow a random level...
		Local w1:Int=Rnd(1,4)
		Local h1:Int=Rnd(1,4)
		Local x1:Int=width/2
		Local y1:Int=height/2
		
		drawmaprect(x1,y1,w1,h1)
	
	
		Local maxrooms:Int=(width*height)/30
		Local numrooms:Int=0
		Local cnt:Int=0
		While numrooms < maxrooms And cnt<15000
			cnt+=1
			Local done:Bool=False
			w1=Rnd(1,4)
			h1=Rnd(1,4)
			x1=Rnd(3,width-5)
			y1=Rnd(3,height-5)
			'check right
			If map[x1][y1] = 1 And map[x1+1][y1] = 0 And map[x1+1][y1-2] = 0 And map[x1+1][y1+2] = 0 
				drawmaprect(x1,y1,w1,h1)
				numrooms+=1
				done=True
			End If
			'check bottom
			If done=False And map[x1][y1] = 1 And map[x1][y1+1] = 0 And map[x1-2][y1+1] = 0 And map[x1+2][y1+1] = 0
				drawmaprect(x1,y1,w1,h1)
				numrooms+=1
				done=True
			End If
			'check top
			If done=False And y1+h1<height-1
				If map[x1][y1+h1+1] = 1 And map[x1][y1+h1] = 0 And map[x1-2][y1+h1] = 0  And map[x1+2][y1+h1] = 0
					drawmaprect(x1,y1,w1,h1)
					numrooms+=1
					done=True
				End If
			End If
			'check left
			If done=False And x1+w1<width-1
				If map[x1+w1+1][y1] = 1 And map[x1+w1][y1] = 0 And map[x1+w1][y1-2] = 0 And map[x1+w1][y1+2] = 0
					drawmaprect(x1,y1,w1,h1)
					numrooms+=1					
				End If
			End If
		Wend

	End Method
	Method drawmaprect(x:Int,y:Int,w:Int,h:Int)
		For Local y1=y To y+h
		For Local x1=x To x+w
			If x1>-1 And y1>-1 And x1<width And y1<height
				map[x1][y1] = 1
			End If
		Next
		Next
	End Method
	Method draw()
		SetColor 255,255,255
		For Local y=0 Until height
		For Local x=0 Until width
			Local t:Int=map[x][y]
			Select t
				Case 1 'wall
				SetColor 100,100,100
				DrawRect x*tilew,y*tileh,tilew,tileh
				Case 2 'wall
				SetColor 200,200,200
				DrawRect x*tilew,y*tileh,tilew,tileh				
			End Select			
		Next
		Next
	End Method
End Class

Global m:tilemap

Class MyGame Extends App

    Method OnCreate()
    	Seed = GetDate[5]
        SetUpdateRate(60)
        createrandommap()
    End Method
    Method OnUpdate()  
    	If KeyHit(KEY_SPACE) Or MouseHit(MOUSE_LEFT)
	        createrandommap()
    	End If      
    End Method
    Method OnRender()
        Cls 0,0,0 
        m.draw
        SetColor 255,255,255
        DrawText "Press Space or Tab to create new level",0,0
    End Method
End Class

Function createrandommap()
	Local r:Int=Rnd(0,3)
	Local w:Int,h:Int,tw:Int,th:Int
	Select r
	Case 0 
		w=20;h=15;tw=32;th=32
	Case 1 
		w=20*2;h=15*2;tw=16;th=16
	Case 2 
		w=20*4;h=15*4;tw=8;th=8
	End Select
	m = New tilemap(w,h,tw,th)
End Function

Function Main()
    New MyGame()
End Function
