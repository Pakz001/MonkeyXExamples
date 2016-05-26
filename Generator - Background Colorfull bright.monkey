Import mojo

Class themap
    Field mapwidth:Int
    Field mapheight:Int
    Field tilewidth:Float
    Field tileheight:Float
    Field map:Float[][]
    Method New(    mapwidth:Int,
                mapheight:Int)
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        tilewidth = DeviceWidth()/Float(mapwidth)
        tileheight = DeviceHeight()/Float(mapheight)
        map = New Float[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Float[mapheight]
        Next
		fillwithrects()
        dripmap()
        blur()
        If Rnd(0,2) < 1 Then sharpen()
    End Method
    Method sharpen()
    	For Local i=0 Until mapwidth*mapheight/4
    		Local x:Int=Rnd(0,mapwidth-1)
    		Local y:Int=Rnd(0,mapheight-1)
    		Local a:Int=map[x][y]
    		Local b:Int=map[x+1][y]
    		Local c:Int=map[x][y+1]
    		Local d:Int=map[x+1][y+1]
    		map[x][y] = ((a+b+c+d/4)/100)*Rnd(101,110)
    		If map[x][y]>255 Then map[x][y]=255
    	Next
    End Method
    Method fillwithrects()
    	For Local i=0 Until mapwidth/30
    		Local w:Int=Rnd(mapwidth/3,mapwidth*.5)
    		Local h:Int=Rnd(mapheight/3,mapheight*.5)
    		Local x:Int=Rnd(-w/2,mapwidth-w)
    		Local y:Int=Rnd(-h/2,mapheight-h)
    		makerect(x,y,w,h)
    	Next
    	For Local x=0 Until mapwidth
    		map[x][0] = 0
    		map[x][mapheight-2] = 0
    	Next
    	For Local y=0 Until mapheight
    		map[0][y] = 0
    		map[mapwidth-1][y] = 0
    	Next
    End Method
    Method makerect(x:Int,y:Int,w:Int,h:Int)
    	For Local y1=y To y+h
    	For Local x1=x To x+w
    	If x1>0 And x1<mapwidth
    	If y1>0 And y1<mapheight
    		map[x1][y1] = 254
       	End If
    	End If
    	Next
    	Next
    	
    End Method
    Method blur()
    	Local amount:Int=Rnd(mapwidth*mapheight*3,mapwidth*mapheight*15)
    	For Local i=0 Until amount
    		Local x:Int=Rnd(0,mapwidth-1)
    		Local y:Int=Rnd(0,mapheight-1)
    		If x+1<mapwidth
    		If y+1<mapheight
    		Local a=map[x+1][y]
    		Local b=map[x][y+1]
    		Local c=map[x+1][y+1]
    		map[x][y] = (a+b+c)/3
    		End If
    		End If
    	Next
    End Method
    Method dripmap()
    	For Local x=0 Until mapwidth
    		Local dp:Int=Rnd(mapwidth/10,mapwidth/3)
    		For Local do = 0 Until dp
    		For Local y=mapheight-1 Until 1 Step -1
   				map[x][y] = map[x][y-1]
    		Next
    		Next
    	Next
    	For Local y=0 Until mapheight
    		Local dp:Int=Rnd(mapheight/10,mapheight/3)
    		For Local do = 0 Until dp
    		For Local x=mapwidth-1 Until 1 Step -1
   				map[x][y] = map[x-1][y]
    		Next
    		Next
    	Next
    End Method
    Method drawmap()
    	Local tr1:Float=Rnd(0,125)
    	Local tg1:Float=Rnd(0,125)
    	Local tb1:Float=Rnd(0,125)
    	Local cmr:Float[256]
    	Local cmg:Float[256]
		Local cmb:Float[256]
		For Local i=0 Until 256
			cmr[i] = 255-i/2+tr1
			cmg[i] = 255-i/2+tg1
			cmb[i] = 255-i/2+tb1
			If cmr[i] > 255 Then cmr[i]=255
			If cmg[i] > 255 Then cmg[i]=255
			If cmb[i] > 255 Then cmb[i]=255
			If cmr[i] < 0 Then cmr[i] = 0
			If cmg[i] < 0 Then cmg[i] = 0
			If cmb[i] < 0 Then cmb[i] = 0
		Next
        For Local y:Float=0 Until mapheight Step 1
        For Local x:Float=0 Until mapwidth Step 1
        	SetColor cmr[map[x][y]],cmg[map[x][y]],cmb[map[x][y]]
            DrawRect     x*tilewidth,
                        y*tileheight,
                        tilewidth+1,
                        tileheight+1
        Next
        Next
    End Method
    Method clearheightmap()
    End Method
End Class

Global mymap:themap 

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(1)
        Local date := GetDate()
        Seed = date[5]        
        mymap = New themap( 320,
                            100)
    End Method
    Method OnUpdate()  
    Local sc:Int = 320
    mymap = New themap(sc,sc/1.5)      
    End Method
    Method OnRender()
        Cls 40,40,40 
        mymap.drawmap
        SetColor 255,255,255
        DrawText    "MonkeyX",
                    (DeviceWidth()/2),20,.5,.5
        DrawText 	"Background Image Generator",
        			(DeviceWidth()/2),45,.5,.5
    End Method
End Class


Function Main()
    New MyGame()
End Function
