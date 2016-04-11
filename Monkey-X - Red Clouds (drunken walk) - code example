Import mojo

Class themap
    Field map:Int[][]
    Field mapwidth:Int
    Field mapheight:Int
    Field tilewidth:Float
    Field tileheight:Float
    Method New(    mapwidth:Int,
                mapheight:Int)
        tilewidth = DeviceWidth()/Float(mapwidth)
        tileheight = DeviceHeight()/Float(mapheight)
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        map = New Int[mapwidth][]
           For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        makemap        
    End Method
    Method makemap()
        Local x:Int=mapwidth/2
        Local y:Int=mapheight/2
        Local dx:Int[]=[0,1,0,-1]
        Local dy:Int[]=[-1,0,1,0]
        For Local i=0 To mapwidth*mapheight
              Local m : Int = map[x][y]+16
              If m>255 Then m=255 
            map[x][y] = m 
            Local d:Int=Rnd(0,4)
            x+=dx[d]
            y+=dy[d]
              If     x<1 Or y<1 Or 
                  x>mapwidth-3 Or 
                  y>mapheight-3 Then 
                  x=mapwidth/2 
                  y=mapheight/2 
              End If
        Next        
    End Method
    Method draw()
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            Local col:Int=map[x][y]    
            If col > 0        
                SetColor col,0,0
                DrawRect     x*tilewidth,
                            y*tileheight,
                            tilewidth+1,
                            tileheight+1
            end if
        Next
        Next
    End Method
End Class

Global mymap:themap

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        Local date := GetDate()
        Seed = date[5]
        mymap = New themap(320,256)
    End Method
    Method OnUpdate()        
        If KeyHit(KEY_SPACE) = True
            mymap = New themap(320,356)
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymap.draw
        SetColor 255,255,255
        DrawText     "Monkey-X - Red Clouds Example.",
                    0,0
        DrawText "Press Space to Render new",0,20
    End Method
End Class


Function Main()
    New MyGame()
End Function
