Import mojo

Class tilemap
	Field mapwidth:Int
	Field mapheight:Int
	Field tilewidth:Int=32
	Field tileheight:Int=32
	Field mapx:Int=0
	Field mapy:Int=0
	Field mapsx:Int=0
	Field mapsy:Int=0
	Field map:Int[][]
	Method New(mapwidth:Int,mapheight:Int)
		Self.mapwidth = mapwidth
		Self.mapheight = mapheight
		'create map array
		map = New Int[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        makenoisemap
	End Method

	Method alignmap()
        For Local i=0 Until 4	    
	        If p.x > DeviceWidth / 2
	            If mapx+20 < mapwidth-1
	                mapsx-=1
	                If mapsx < 0 Then 
	                    mapsx = 31
	                    mapx += 1
	                Endif
	                p.x-=1
	            End If
		  	End If
	    Next
	
        For Local i=0 Until 4
	        If p.x < DeviceWidth / 2
	            If mapx > 0
    	            mapsx+=1
	                If mapsx > 32 Then 
	                    mapsx = 0
	                    mapx -= 1
	                Endif
	                p.x+=1
	            End If
	        End If
        Next

        ' scrolling down
	    For Local i=0 Until 16
	        If p.y > DeviceHeight / 2
	            If mapy+14 < mapheight-1
	                mapsy-=1
	                If mapsy < 0 Then 
	                    mapsy = 31
	                    mapy += 1
	                Endif
	                p.y-=1
	            End If
	        End If
        Next

        ' scrolling up
        For Local i=0 Until 16
        	If p.y < DeviceHeight / 2
	            If mapy > 0
	                mapsy+=1
	                If mapsy > 31 Then 
	                    mapsy = 0
	                    mapy -= 1
	                Endif
	                p.y+=1
	            End If
	        End If
		Next
	End Method

	Method drawmap:Void()
	    For Local y=0 To 14
	    For Local x=0 To 20
	        Local x1 = ((x*tilewidth)+mapsx)-tilewidth
	        Local y1 = ((y*tileheight)+mapsy)
	        Select map[x+mapx][y+mapy]
	            Case 1'Wall
	            SetColor 100,100,100
	            DrawRect x1,y1,tilewidth,tileheight
	            Case 2'spriny
	            SetColor 0,100,0
	            DrawRect x1,y1,tilewidth,tileheight
	          End Select
	     Next
	     Next     
	End Method
	
	Method makenoisemap()
		' add random noise To the map
		For Local i=0 Until (mapwidth*mapheight)/7
			Local x:Int=Rnd(0,mapwidth)
			Local y:Int=Rnd(0,mapheight)
			Local tileval:Int=1
			map[x][y] = tileval			
		Next
		'make some room for the player start position
		For Local y=0 To 10
		For Local x=0 To 10
			map[x][y] = 0
		Next
		Next
		' make some borders at the edges
		For Local y=0 Until mapheight
			map[1][y] = 1
			map[mapwidth-2][y] = 1
		Next
		For Local x=0 Until mapwidth
			map[x][0] = 1
			map[x][1] = 1
			map[x][mapheight-2] = 1
		Next
	End Method
End Class

Class player    
    Field x:Float
    Field y:Float
    Field w:Int=32
    Field h:Int=32
    Field incy:Float=0
    Field isjumping:Bool = False
    Field facing:Int '0 = left , 1 = right
    
    Method New(x:Float,y:Float)
		Self.x = x
		Self.y = y
    End Method
		
    Method update()
    	' walking and jumping mode
		regularmode
    End Method
    
    Method regularmode()        

        'Left and Right movement
        If KeyDown(KEY_RIGHT)
            For Local i=0 Until 4 ' move with 4 pixels at a time
                If ptc(1,0) = False
                    x+=1
                    facing = 1
                End If
            Next
        End If
        If KeyDown(KEY_LEFT)
            For Local i=0 Until 4
                If ptc(-1,0) = False
                    x-=1
                    facing = 0
                End If
            Next
        End If
        'player gravity part
        'if in the air and not in jump
        If isjumping = False
            If ptc(0,1) = False
                isjumping=True
                incy=0
            End If
        End If
        ' jump
        If KeyDown(KEY_SPACE)
            If isjumping = False
                isjumping = True
                incy=-4
            End If
        End If
        ' if we are in a jump/falling down
        If isjumping=True
            If incy>=0 'if we are going down
                If incy<4 Then incy+=.1
                For Local i=0 Until(incy)
                    If ptc(0,1) = False
                        y+=1
                    Else
                        isjumping = False
                    End If
                Next
            End If
            If incy<0 'if we are going up
                incy+=.1
                For Local i=0 Until Abs(incy)
                    If ptc(0,-1) = False
                        y-=1
                    Else
                        incy=0
                    End If
                Next
            End If
        End If    
    End Method
	'player collide with solid blocks true/false
	Method ptc:Bool(offsetx:Int=0,offsety:Int=0)
	    Local cx = (p.x+offsetx)/m.tilewidth+m.mapx
	    Local cy = (p.y+offsety)/m.tileheight+m.mapy
	    For Local y2=cy-1 Until cy+4
	    For Local x2=cx-1 Until cx+4
	        If x2>=0 And x2<m.mapwidth And y2>=0 And y2<m.mapheight
	            If m.map[x2][y2] = 1 
	                Local x3 = (x2-m.mapx)*m.tilewidth-32+m.mapsx
	                Local y3 = (y2-m.mapy)*m.tileheight+m.mapsy
	                If rectsoverlap(p.x+offsetx,p.y+offsety,p.w,p.h,x3,y3,m.tilewidth,m.tileheight) = True
	                    Return True
	                End If
	            End If
	        End If
	    Next
	    Next
	    Return False
	End Method

    Method draw()
        SetColor 255,255,0
        DrawRect x,y,w,h
    End Method

	Method rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	    Return True
	End Method

End Class


Global p:player
Global m:tilemap

Class MyGame Extends App
    Method OnCreate()
	    Seed = GetDate[5]	    
	    m = New tilemap(100,20) ' 100 wide and 20 deep
	    p = New player(3*32,3*32) 'player start at 3*32 tile x 3*32 tile y
        SetUpdateRate(60)
    End Method
    Method OnUpdate()    
        p.update    
        m.alignmap
    End Method
    Method OnRender()
        Cls 0,0,0 
        m.drawmap
        p.draw
        SetColor 0,0,0
        DrawRect 0,0,DeviceWidth(),32
        SetColor 255,255,255
        DrawText "Use Cursor left/right to move, space to jump",0,0
    End Method
End Class

Function Main()
    New MyGame()
End Function
