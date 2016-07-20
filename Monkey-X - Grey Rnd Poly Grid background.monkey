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
		Self.mapwidth = mapwidth
		Self.mapheight = mapheight
		tilewidth = DeviceWidth()/Float(mapwidth)
		tileheight = DeviceHeight()/Float(mapheight)
		mapx = New Float[mapwidth][]
		mapy = New Float[mapwidth][]
        For Local i = 0 Until mapwidth
            mapx[i] = New Float[mapheight]
            mapy[i] = New float[mapheight]
        Next 
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
		For Local y=0 Until mapheight-1
		For Local x=0 Until mapwidth-1
			Local pol:Float[8]
			pol[0] = mapx[x][y]
			pol[1] = mapy[x][y]
			pol[2] = mapx[x+1][y]
			pol[3] = mapy[x+1][y]
			pol[4] = mapx[x+1][y+1]
			pol[5] = mapy[x+1][y+1]
			pol[6] = mapx[x][y+1]
			pol[7] = mapy[x][y+1]
			Local a:Int=Rnd(0,256)
			SetColor a,a,a
			DrawPoly pol
		Next
		Next	
	End Method
End Class

Global mygbg:gridbackground

Class MyGame Extends App
	
    Method OnCreate()
        SetUpdateRate(1)
        mygbg = New gridbackground(25,25)
    End Method
    Method OnUpdate() 
	    mygbg = New gridbackground(Rnd(10,30),Rnd(10,30))       
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
