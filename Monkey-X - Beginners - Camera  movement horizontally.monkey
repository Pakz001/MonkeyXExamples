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
	Field map:Int[][]
	Method New(width:Int,height:Int)
		Self.width = width
		Self.height = height			
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
		If comp < 0 Or comp > width-displaywidth Then Return
		camerax+=x
	End Method
	Method movecameray(y:Int)
		Local comp:Int=cameray+y
		If comp < 0 Or comp > height-displayheight Then Return
		cameray+=y
	End Method
	Method draw()
		For Local y=0 Until displayheight
		For Local x=0 Until displaywidth
			Select map[x+camerax][y+cameray]
				Case 0
				Case 1
					DrawRect (x*tilewidth)+100,(y*tileheight)+50,tilewidth,tileheight
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
    	If KeyHit(KEY_RIGHT)
    		m.movecamerax(1)
    	End If
    	If KeyHit(KEY_LEFT)
    		m.movecamerax(-1)
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
    
        m.draw
        '
        SetColor 255,255,255
        DrawText "Camera/Scrolling example (Horizontally)",100,10
        Local y:Int=200
        DrawText "Press cursor left or right to scroll map",100,y
        y+=20
        DrawText "camerax value is : "+m.camerax,100,y        
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
