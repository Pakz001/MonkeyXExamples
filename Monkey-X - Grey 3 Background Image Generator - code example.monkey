Import mojo

Class themap
    Field mapwidth:Int
    Field mapheight:Int
    Field tilewidth:Float
    Field tileheight:Float
    Field map:Float[][]
    Method New(    mapwidth:Int,
                mapheight:Int,
                numpoints:Int)
        mapwidth+=6
        mapheight+=6
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        tilewidth = DeviceWidth()/Float(mapwidth)
        tileheight = DeviceHeight()/Float(mapheight)
        map = New Float[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Float[mapheight]
        Next
        addheightmappoints(numpoints)
        For Local i=0 Until numpoints
        expandheightmap
        Next
        dripmap()
        darken()
        blur()
    End Method
    Method blur()
    	For Local i=0 Until 550000
    		Local x:Int=Rnd(0,mapwidth)
    		Local y:Int=Rnd(0,mapheight)
    		If x+1<mapwidth-1
    		If y+1<mapheight-1
    		Local a=map[x+1][y]
    		Local b=map[x][y+1]
    		Local c=map[x+1][y+1]
    		map[x][y] = (a+b+c)/3
    		End If
    		End If
    	Next
    End Method
    Method darken()
    	For Local x=0 Until mapwidth
    	For Local y=0 Until mapheight
    		If map[x][y]>40
    			map[x][y] = map[x][y]/2
    		End If
    	Next
    	Next
    End Method
    Method dripmap()
		For Local i=0 Until 100
			Local x:Int=Rnd(0,mapwidth)
			For Local y=mapheight-2 Until 1 Step -1
				map[x][y]=map[x][y+1]
			Next
		Next
		For Local i=0 Until 100
			Local y:Int=Rnd(0,mapheight)
			For Local x=mapwidth-2 Until 1 Step -1
				map[x][y]=map[x+1][y]
			Next
		Next

    End Method
    Method expandheightmap()
    	Local stp:Int=Rnd(150000,250000)
        For Local n=0 To stp
            Local x1:Int=Rnd(1,mapwidth-1)
            Local y1:Int=Rnd(1,mapheight-1)
            If map[x1][y1] > 0
                For Local y2=y1-1 To y1+1
                For Local x2=x1-1 To x1+1
                    If map[x1][y1] > map[x2][y2]
                        map[x2][y2] = 
                                        (map[x1][y1]+
                                        map[x2][y2])*Rnd(0.49,0.5)
                    End If
                Next
                Next 
            End If
        Next
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
        	If map[x][y] = 0 Then map[x][y] = 25
        Next
        Next
        For Local x=0 Until mapwidth
        	map[x][0] = 25
        	map[x][mapheight-1]=25
        Next
        For Local y=0 Until mapheight
        	map[0][y] = 25
        	map[mapwidth-1][y] = 25
        Next
    End Method
    Method addheightmappoints(count:Int)
        For Local i=0 Until count
            Local x:Int=Rnd(    mapwidth/(i+1),
                                mapwidth-1)
            Local y:Int=Rnd(    0,
                                mapheight-1)
            map[x][y] = Rnd(64,200)
        Next
    End Method
    Method drawmap()
        For Local y:Float=3 Until mapheight-3 Step 1
        For Local x:Float=3 Until mapwidth-3 Step 1        
            SetColor map[x][y],map[x][y],map[x][y]
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
                            240,
                            9)
    End Method
    Method OnUpdate()  
    mymap = New themap(320,240,9)      
    End Method
    Method OnRender()
        Cls 40,40,40 
        mymap.drawmap
        SetColor 255,255,255
        DrawText    "MonkeyX",
                    (DeviceWidth()/2),10,.5,.5
        DrawText 	"Background",
        			(DeviceWidth()/2),25,.5,.5
    End Method
End Class


Function Main()
    New MyGame()
End Function
