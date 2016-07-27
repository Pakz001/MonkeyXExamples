Import mojo

Class tilemap
	Field camerax:Int
	Field cameray:Int
	Field width:Int
	Field height:Int
	Field tilewidth:Int=16
	Field tileheight:Int=16
	Field displaywidth:Int=20
	Field displayheight:Int=10
	Field maxcamerax:Int
	Field maxcameray:Int
	Field map:Int[][]
	Method New(width:Int,height:Int)
		Self.width = width
		Self.height = height			
		maxcamerax = (width*tilewidth)-(displaywidth*tilewidth)
		maxcameray = (height*tileheight)-(displayheight*tileheight)		
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
		Local offx:Int=tx*tilewidth-camerax
		Local offy:Int=ty*tileheight-cameray
		For Local y=0 Until displayheight
		For Local x=0 Until displaywidth
			Select map[x+tx][y+ty]
				Case 0
				Case 1
					DrawRect (x*tilewidth)+100+offx,(y*tileheight)+50+offy,tilewidth,tileheight
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
        m = New tilemap(120,20)
    End Method
    Method OnUpdate()
    	If KeyDown(KEY_RIGHT)
    		m.movecamerax(1)
    	End If
    	If KeyDown(KEY_LEFT)
    		m.movecamerax(-1)
    	End If
    	If KeyDown(KEY_UP)
    		m.movecameray(-1)
    	End If
    	If KeyDown(KEY_DOWN)
    		m.movecameray(1)
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
    
        m.draw
        '
        SetColor 255,255,255
        DrawText "Camera/Smooth Scrolling example (Hor/vert)",100,10
        Local y:Int=200
        DrawText "Press cursor left/right/up/down to scroll map",100,y
        y+=20
        DrawText "camerax value is : "+m.camerax,100,y        
        y+=20
        DrawText "cameray value is : "+m.cameray,100,y        
        y+=20
        DrawText "Maximum camera x is : "+m.maxcamerax,100,y        
        y+=20
        DrawText "Maximum camera y is : "+m.maxcameray,100,y        
        y+=20
        
        DrawText "Map Width is : " +m.width,100,y
        y+=20
        DrawText "Map height is : "+m.height,100,y
        y+=20
        DrawText "Blocks drawn horizontally : "+m.displaywidth,100,y        
        y+=20
        DrawText "Blocks drawn vertically : "+m.displayheight,100,y        
        y+=20
		

    End Method
End Class


Function Main()
    New MyGame()
End Function
