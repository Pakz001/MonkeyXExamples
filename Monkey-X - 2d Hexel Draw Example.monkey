Import mojo

Class hexelmap
	Field mapwidth:Int
    Field mapheight:Int
    Field tilewidth:Float
    Field tileheight:Float
    Field map1:Int[][]
    Field map2:Int[][]
    Method New(mapwidth:Int,mapheight:Int)
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        tilewidth = DeviceWidth()/Float(mapwidth)
        tileheight = DeviceHeight()/Float(mapheight)
        map1 = New Int[mapwidth][]
        map2 = New Int[mapwidth][]
        For Local i = 0 Until mapwidth
            map1[i] = New Int[mapheight]
            map2[i] = New Int[mapheight]            
        Next    	
    End Method
	Method update()
		' find the tile underneath the mouse pointer
		Local x:Int=MouseX() / tilewidth
		Local y:Int=MouseY() / tileheight
		Local y1:Int = MouseY()-y*tileheight
		Local x1:Int = MouseX()-x*tilewidth
		Local sd:Int=0
		Local t:Int=tilewidth
		For Local y2=0 Until tileheight
			For Local x2=0 Until tilewidth		
				If x2=x1 And y2=y1 And t<x1 Then sd=1
			Next
			t-=1
		Next
		' if mouse hold down
		If MouseDown(MOUSE_LEFT)
			If sd = 0 Then map1[x][y] = 1
			If sd = 1 Then map2[x][y] = 1
		Endif
		If MouseDown(MOUSE_RIGHT)
			If sd = 0 Then map1[x][y] = 0
			If sd = 1 Then map2[x][y] = 0
		Endif

	End Method
    Method drawmap()
		SetColor 255,255,255
    	For Local y=0 Until mapheight
    	For Local x=0 Until mapwidth
    		If map1[x][y] = 1    			
    			Local x1:Float=Float(x)*tilewidth
    			Local y1:Float=Float(y)*tileheight
	    		Local pol:Float[6]
	    		pol[0] = x1+tilewidth
	    		pol[1] = y1
	    		pol[2] = x1
	    		pol[3] = y1
	    		pol[4] = x1
	    		pol[5] = tileheight+y1
    			DrawPoly pol
    		End If
    		If map2[x][y] = 1
    			Local x1:Float=Float(x)*tilewidth
    			Local y1:Float=Float(y)*tileheight
	    		Local pol:Float[6]
	    		pol[0] = x1+tilewidth
	    		pol[1] = y1
	    		pol[2] = x1
	    		pol[3] = y1+tileheight
	    		pol[4] = x1+tilewidth
	    		pol[5] = tileheight+y1
    			DrawPoly pol
    		End If
    	Next
    	Next
    End Method
	Method rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	    Return True
	End Method
End Class

Global mymap:hexelmap

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        mymap = New hexelmap(20,20)
    End Method
    Method OnUpdate()        
    	mymap.update
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mymap.drawmap
    End Method
End Class


Function Main()
    New MyGame()
End Function
