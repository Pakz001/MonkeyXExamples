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
    End Method
    Method fillwithrects()
    	For Local i=0 Until mapwidth/15
    		Local w:Int=Rnd((mapwidth/7),(mapwidth/3))
    		Local h:Int=Rnd((mapheight/7),(mapheight/3))
    		Local x:Int=Rnd(0,mapwidth-w)
    		Local y:Int=Rnd(0,mapheight-h)
    		makerect(x,y,w,h)
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
    		Local x:Int=Rnd(0,mapwidth)
    		Local y:Int=Rnd(0,mapheight)
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
    		Local dp:Int=Rnd(mapwidth/15,mapwidth/5)
    		For Local do = 0 Until dp
    		For Local y=mapheight-1 Until 1 Step -1
   				map[x][y] = map[x][y-1]
    		Next
    		Next
    	Next
    	For Local y=0 Until mapheight
    		Local dp:Int=Rnd(mapheight/15,mapheight/5)
    		For Local do = 0 Until dp
    		For Local x=mapwidth-1 Until 1 Step -1
   				map[x][y] = map[x-1][y]
    		Next
    		Next
    	Next
    End Method
    Method drawmap()
    	Local tr1:Float=Rnd(0,255)
    	Local tg1:Float=Rnd(0,255)
    	Local tb1:Float=Rnd(0,255)
    	Local cmr:Float[256]
    	Local cmg:Float[256]
		Local cmb:Float[256]
		Local str:Float = 255/tr1
		Local stg:Float = 255/tg1
		Local stb:Float = 255/tb1
		For Local i=0 Until 256
			cmr[i] = str*i
			cmg[i] = stg*i
			cmb[i] = stb*i
		Next
        For Local y:Float=0 Until mapheight Step 1
        For Local x:Float=0 Until mapwidth Step 1
        	SetColor 255-cmr[map[x][y]],255-cmg[map[x][y]],255-cmb[map[x][y]]
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
                            200)
    End Method
    Method OnUpdate()  
    mymap = New themap(320,200)      
    End Method
    Method OnRender()
        Cls 40,40,40 
        mymap.drawmap
        SetColor 255,255,255
        DrawText    "MonkeyX",
                    (DeviceWidth()/2),10,.5,.5
        DrawText 	"Dripping/Blurring rectangles",
        			(DeviceWidth()/2),25,.5,.5
    End Method
End Class


Function Main()
    New MyGame()
End Function
