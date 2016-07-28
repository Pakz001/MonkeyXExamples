Import mojo

Class player
	Field x:Int
	Field y:Int
	Field width:Int=20
	Field height:Int=20
	Method New()
		x=220
		y=140
	End Method
	Method update()
		Local ox:Int=x
		Local oy:Int=y
		If KeyDown(KEY_RIGHT)			
			x+=1
		End If
		If KeyDown(KEY_LEFT)
			x-=1
		End If
		If KeyDown(KEY_UP)
			y-=1
		End If
		If KeyDown(KEY_DOWN)
			y+=1
		End If
		If x<m.camerax Then x=ox
		If y<m.cameray Then y=oy
		If x+width>m.rightborder Then x=ox
		If y+height>m.bottomborder Then y=oy		
		'scrolling
		'left
		If m.camerax < m.maxcamerax And x>m.camerax+(DeviceWidth()/2)
			m.movecamerax(1)
			x-=1			
		End If
		'right
		If m.camerax>0 And x<m.camerax+(DeviceWidth()/2)
			m.movecamerax(-1)
			x+=1
		End If
		'up
		If m.cameray<m.maxcameray And y>m.cameray+(DeviceHeight()/2)
			m.movecameray(1)
			y-=1			
		End If
		'down
		If m.cameray>0 And y<m.cameray+(DeviceHeight()/2)
			m.movecameray(-1)
			y+=1
		End If
		
	End Method
	Method draw()
		Local x1:Int=Abs(m.camerax-x)
		Local y1:Int=Abs(m.cameray-y)
		SetColor 255,0,0
		DrawRect x1,y1,width,height
	End Method
End Class

Class tilemap
	Field camerax:Int=0
	Field cameray:Int=0
	Field width:Int
	Field height:Int
	Field tilewidth:Int=32
	Field tileheight:Int=32
	Field displaywidth:Int=(640/32)+1
	Field displayheight:Int=(480/32)+1
	Field maxcamerax:Int
	Field maxcameray:Int
	Field rightborder:Int
	Field bottomborder:Int
	Field map:Int[][]
	Method New(width:Int,height:Int)
		Self.width = width
		Self.height = height			
		maxcamerax = (width*tilewidth)-(displaywidth*tilewidth)
		maxcameray = (height*tileheight)-(displayheight*tileheight)		
		rightborder=(width*tilewidth)-tilewidth
		bottomborder=(height*tileheight)-tileheight
		map = New Int[width][]
		For Local i = 0 Until width
			map[i] = New Int[height]
		Next
		makenoise
	End Method
	Method makenoise()
		For Local i=0 Until (width*height)/7
			map[Rnd(0,width)][Rnd(0,height)] = 1
		Next
	End Method
	Method movecamerax(x:Int)
		Local comp:Int=camerax+x
		If comp < 0 Or comp > maxcamerax Then Return
		camerax+=x
	End Method
	Method movecameray(y:Int)
		Local comp:Int=cameray+y
		If comp < 0 Or comp > maxcameray Then Return
		cameray+=y
	End Method
	Method draw()
		Local tx:Int=camerax/tilewidth
		Local ty:Int=cameray/tileheight
		Local offx:Int=camerax-(tx*tilewidth)
		Local offy:Int=cameray-(ty*tileheight)
		For Local y=0 Until displayheight
		For Local x=0 Until displaywidth
			Select map[x+tx][y+ty]
				Case 0
				Case 1
					DrawRect (x*tilewidth)-offx,(y*tileheight)-offy,tilewidth,tileheight
			End Select
		Next
		Next
	End Method
End Class

Global m:tilemap
Global p:player

Class MyGame Extends App

    Method OnCreate()
    	Seed = GetDate[5]
        SetUpdateRate(60)
        m = New tilemap(32,22)
        p = New player()
    End Method
    Method OnUpdate()
    	p.update
    	'If KeyDown(KEY_RIGHT) Then m.movecamerax(1)
    	'If KeyDown(KEY_LEFT) Then m.movecamerax(-1)
		'If KeyDown(KEY_UP) Then m.movecameray(-1)
		'If KeyDown(KEY_DOWN) Then m.movecameray(1)    	
    End Method
    Method OnRender()
        Cls 0,0,0 
    
        m.draw
        p.draw
        '
		SetColor 255,255,255
		DrawText "camerax:"+m.camerax,0,0
		DrawText "player x:"+p.x+" player y:"+p.y,0,20
		DrawText "bottomborder:"+m.bottomborder,0,40
		

    End Method
End Class


Function Main()
    New MyGame()
End Function
