Import mojo

Class gridbackground
    Field mapwidth:Int
    Field mapheight:Int
    Field tilewidth:Float
    Field tileheight:Float
    Field mapdepth:Int
    Field map:Int[][]
    Method New(mapwidth:Int,mapheight:Int)
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        tilewidth = DeviceWidth()/Float(mapwidth)
        tileheight = DeviceHeight()/Float(mapheight)
        map = New Int[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next 
        addrectslayer
        brusheffect()
        smooth
        lightmap
    End Method
    Method lightmap()
    	Local tp:Int=Rnd(1,10)
    	For Local y=0 Until mapheight
    	For Local x=0 Until mapwidth
    		Local d:Int=(distance(x,y,mapwidth/2,mapheight/2)/10)+1
    		If tp<5 Then
    			map[x][y] = 255-map[x][y]/d 
    		Else
    			map[x][y] = map[x][y]/d 
    		End If
    	Next
    	Next
    End Method
    Method smooth()
    	For Local i=0 Until (mapwidth*mapheight)
    		Local x:Int=Rnd(0,mapwidth-1)
    		Local y:Int=Rnd(0,mapheight-1)
    		Local col1:Int=map[x+1][y]
    		Local col2:Int=map[x+1][y+1]
    		Local col3:Int=map[x][y+1]    		    		
    		Local col4:Int=(col1+col2+col3)/3
    		map[x][y] = col4
    	Next
    End Method
    Method brusheffect() 'explosion effect copy from in area to another part in area in half the brishtness
    	For Local i=0 Until (mapwidth*mapheight)/20
    		Local x:Int=Rnd(-3,mapwidth)
    		Local y:Int=Rnd(-3,mapheight)
    		For Local y1=-5 To 5
    		For Local x1=-5 To 5
    			Local x2:Int=x+x1
    			Local y2:Int=y+y1
				If Rnd(10)<3
				If x2>-1 And y2>-1 And x2<mapwidth And y2<mapheight
					Local col:Int=map[x2][y2]
					Local x3:Int=x2+Rnd(-5,5)
					Local y3:Int=y2+Rnd(-5,5)
					If x3>-1 And y3>-1 And x3<mapwidth And y3<mapheight
						map[x3][y3] = col/2
					End If
				End If
				End If
    		Next
    		Next
    	Next
    End Method
    Method addrectslayer()
    	For Local i=0 Until (mapwidth*mapheight)/20
    		Local w:Int=Rnd(3,10)
    		Local h:Int=Rnd(3,10)
    		Local x:Int=Rnd(-3,mapwidth)
    		Local y:Int=Rnd(-3,mapheight)
    		Local col:Int=255
    		mapdrawrect(x,y,w,h,col)
    	Next
    End Method
    Method mapdrawrect(x:Int,y:Int,w:Int,h:Int,col:Int)
    	For Local y1=y Until y+h
    	For Local x1=x Until x+w
    		If x1>-1 And y1>-1 And x1<mapwidth And y1<mapheight
    			map[x1][y1] = col
    		End If
    	Next
    	Next
    End Method
    Method draw()
        For Local y=0 Until mapheight-1
        For Local x=0 Until mapwidth-1
			Local col:Int=map[x][y]
			SetColor col,col,col
			DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
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
    	Seed = GetDate[5]
        SetUpdateRate(1)
        mygbg = New gridbackground(128,128)
    End Method
    Method OnUpdate() 
		mygbg = New gridbackground(128,128)
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
