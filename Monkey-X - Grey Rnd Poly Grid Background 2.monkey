Import mojo

Class gridbackground
	Field mapwidth:Int
	Field mapheight:Int
	Field tilewidth:Float
	Field tileheight:Float
	Field mapdepth:Int
	Field mapx:Float[][]
	Field mapy:Float[][]
	Method New(mapwidth:Int,mapheight:Int)
		mapwidth+=4
		mapheight+=4
		Self.mapwidth = mapwidth
		Self.mapheight = mapheight
		mapx = New Float[mapwidth][]
		mapy = New Float[mapwidth][]
        For Local i = 0 Until mapwidth
            mapx[i] = New Float[mapheight]
            mapy[i] = New Float[mapheight]
        Next 
        tilewidth = DeviceWidth()/Float(mapwidth-4)
		tileheight = DeviceHeight()/Float(mapheight-4)

        makegrid	
	End Method
	Method makegrid()
		For Local y=0 Until mapheight
		For Local x=0 Until mapwidth
			mapx[x][y] = x*tilewidth + Rnd(-tilewidth/3,tilewidth/3)
			mapy[x][y] = y*tileheight + Rnd(-tileheight/3,tileheight/3)
		Next
		Next
	End Method
	Method draw()
		'SetScissor(50,50,DeviceWidth()-100,DeviceHeight()-100)
		For Local y=0 Until mapheight-1
		For Local x=0 Until mapwidth-1
			Local pol:Float[8]
			pol[0] = mapx[x][y]			-tilewidth
			pol[1] = mapy[x][y]			-tileheight
			pol[2] = mapx[x+1][y]		-tilewidth
			pol[3] = mapy[x+1][y]		-tileheight
			pol[4] = mapx[x+1][y+1]		-tilewidth
			pol[5] = mapy[x+1][y+1]		-tileheight
			pol[6] = mapx[x][y+1]		-tilewidth
			pol[7] = mapy[x][y+1]		-tileheight
			Local col:Int=Clamp(255-(distance(x*tilewidth,y*tileheight,x*tilewidth,mapheight*tileheight))/3,0,255)
			SetColor col,col,col
			DrawPoly pol
		Next
		Next	
	End Method
    Method distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Method	
End Class

Global mygbg:gridbackground

Class MyGame Extends App
	
    Method OnCreate()
        SetUpdateRate(1)
        mygbg = New gridbackground(25,25)
    End Method
    Method OnUpdate() 
	    mygbg = New gridbackground(Rnd(10,50),Rnd(10,50))       
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mygbg.draw
    End Method
End Class


Function Main()
    New MyGame()
End Function
