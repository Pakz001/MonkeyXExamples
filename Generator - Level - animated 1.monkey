Import mojo

Class theline
	Field x1:Int,y1:Int,x2:Int,y2:Int
	Method New(x1:Int,y1:Int,x2:Int,y2:Int)
		Self.x1 = x1
		Self.y1 = y1
		Self.x2 = x2
		Self.y2 = y2
	End Method
End Class

Class therect
	Field x:Int,y:Int,w:Int,h:Int
	Field move:Bool=False	
	Method New(x:Int,y:Int,w:Int,h:Int)
		Self.x = x
		Self.y = y
		Self.w = w
		Self.h = h
	End Method
End Class

Class thelevel
	Field myl:List<theline> = New List<theline>
	Field myr:List<therect> = New List<therect>
	Field mapwidth:Int
	Field mapheight:Int
	Field tilewidth:Int
	Field tileheight:Int
	Field numrects:Int
	Field phase:Int=1 'animate throught the steps
	Field timer:Int=0
	Field map:Int[][]
	Method New(mapwidth:Int,mapheight:Int,numrects:Int)
		Self.mapwidth = mapwidth
		Self.mapheight = mapheight
		Self.tilewidth = DeviceWidth()/mapwidth
		Self.tileheight = DeviceHeight()/mapheight
		Self.numrects = numrects
        map = New Int[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next		
		For Local i=0 Until numrects
			myr.AddLast(New therect(mapwidth/2+Rnd(-10,10),mapheight/2+Rnd(-10,10),Rnd(5,15),Rnd(5,15)))
		Next
	End Method
	Method update()
		If phase = 1 'phase 1- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			For Local i:=Eachin myr	
				i.move=False
			Next
			Local nothingdone:Bool=True
			For Local i:=Eachin myr
				For Local ii:=Eachin myr
					If i<>ii
						If i.move=False
						If rectsoverlap(i.x,i.y,i.w,i.h,ii.x,ii.y,ii.w,ii.h)
						If i.x <= ii.x Then i.x -= 1
						If i.x >= ii.x Then i.x += 1
						If i.y <= ii.y Then i.y -= 1
						If i.y >= ii.y Then i.y += 1
						i.move = True
						nothingdone = False
							End If
					Endif
					Endif				
				Next
			Next
			' if done moving		
			If nothingdone = True Then phase = 2
		End If
		
		If phase = 2 ' phase 2 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			myl.Clear()
			For Local i:=Eachin myr
				For Local ii:=Eachin myr
					If i<>ii
						If rectsoverlap(i.x-3,i.y-3,i.w+6,i.h+6,ii.x-3,ii.y-3,ii.w+6,ii.h+6)
							myl.AddLast(New theline(i.x+i.w/2,i.y+i.h/2,ii.x+ii.w/2,ii.y+ii.h/2))
						End If
					End If
				Next
			Next
			phase = 3
			timer = 0
		End If
		
		If phase = 3 ' phase 3 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			timer = timer + 1
			If timer > 120
				phase = 4
			End If
		End If
		
		If phase = 4 'phase 4 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			For Local i:=Eachin myl
				For Local y=-1 To 1
				For Local x=-1 To 1
				bline(i.x1+x,i.y1+y,i.x2+x,i.y2+y)
				Next
				Next
			Next
			phase = 5
			timer = 0
		End If
		
		If phase = 5 'phase 5 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			timer += 1
			If timer>120 Then phase = 6
		End If
		
	End Method
	Method draw()
		'draw the rooms
		SetColor 255,255,255
		For Local i:= Eachin myr
			DrawRect i.x*tilewidth,i.y*tileheight,i.w*tilewidth,i.h*tileheight
		Next
		'draw the corridors
		SetColor 255,255,255
		For Local y=0 Until mapheight
		For Local x=0 Until mapwidth
			If map[x][y] = 1
				DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
			Endif
		Next
		Next
		If phase < 4
			' draw the connections
			SetColor 255,0,0
			For Local i:=Eachin myl
				DrawLine i.x1*tilewidth,i.y1*tileheight,i.x2*tilewidth,i.y2*tileheight
			Next
		Endif
	End Method
	Method rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	    Return True
	End Method
	'bresenham line method
	Method bline:Void(x1:Int,y1:Int,x2:Int,y2:Int)
      Local dx:Int, dy:Int, sx:Int, sy:Int, e:Int
      dx = Abs(x2 - x1)
      sx = -1
      If x1 < x2 Then sx = 1      
      dy = Abs(y2 - y1)
      sy = -1
      If y1 < y2 Then sy = 1
      If dx < dy Then 
          e = dx / 2 
      Else 
          e = dy / 2          
      End If
      Local exitloop:Bool=False
      While exitloop = False
      	If x1>0 And y1>0 And x1<mapwidth And y1<mapheight
        	map[x1][y1] = 1
        Endif
        If x1 = x2 
            If y1 = y2
                exitloop = True
            End If
        End If
        If dx > dy Then
            x1 += sx ; e -= dy 
              If e < 0 Then e += dx ; y1 += sy
        Else
            y1 += sy ; e -= dx 
            If e < 0 Then e += dy ; x1 += sx
        Endif
      Wend
	End Method
End Class

Global mylevel:thelevel


Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        Seed = GetDate[5]
   		Local w:Int=Rnd(50,150)
   		Local h:Int=w
   		Local c:Int=w/6
        mylevel = New thelevel(w,h,c)
    End Method
    Method OnUpdate()
    	mylevel.update
    	If mylevel.phase = 6
    		Local w:Int=Rnd(50,150)
    		Local h:Int=w
    		Local c:Int=w/6
   	        mylevel = New thelevel(w,h,c)
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mylevel.draw
    End Method
End Class


Function Main()
    New MyGame()
End Function
