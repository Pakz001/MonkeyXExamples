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
        next
    End Method
    Method expandheightmap()
        For Local n=0 To 100000
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
    End Method
    Method addheightmappoints(count:Int)
        For Local i=0 Until count
            Local x:Int=Rnd(    mapwidth/2-(mapwidth/3),
                                mapwidth/2+(mapwidth/3))
            Local y:Int=Rnd(    mapheight/2-(mapheight/3),
                                mapheight/2+(mapheight/3))
            map[x][y] = Rnd(64,200)
        Next
    End Method
    Method drawmap()
        For Local y:Float=0 Until mapheight Step 1
        For Local x:Float=0 Until mapwidth Step 1
            SetColor map[x][y],0,0
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
    Field nm:Int
    Method OnCreate()
        SetUpdateRate(60)
        Local date := GetDate()
        Seed = date[5]        
        mymap = New themap(    Rnd(50,150),
                            Rnd(50,150),
                            Rnd(2,20))
    End Method
    Method OnUpdate()        
        nm+=1
        If nm>100
            mymap = New themap(    Rnd(50,150),
                                Rnd(50,150),
                                Rnd(2,20))
            nm=0
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymap.drawmap
        SetColor 255,255,255
        DrawText     "MonkeyX - Heightmap/"+
                    "texture/image generator",
                    0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
