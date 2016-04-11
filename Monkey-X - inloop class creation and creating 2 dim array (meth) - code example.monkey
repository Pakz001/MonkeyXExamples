Import mojo

Class map
    Field mapwidth:Int,mapheight:Int
    ' the 2 dimensional array i set up here
    ' it needs no size yet.
    Field map:Int[][]
    Field tilewidth:Float,tileheight:Float
    Method New(mapwidth:Int,mapheight:Int)
        ' here we resize the map array
        map = makearray(mapwidth,mapheight)
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        tilewidth = 640/mapwidth
        tileheight = 480/mapheight
        makemap
    End Method
    Method makemap() 'create random blocks
        For Local i=0 Until (mapwidth*mapheight)/10
            map    [Rnd(0,mapwidth)][Rnd(0,mapheight)] = 1
        Next
    End Method
    Method draw()
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            If map[x][y] = 1
                SetColor 150,150,150
                DrawRect     x*tilewidth,
                            y*tileheight,
                            tilewidth,tileheight
                            
            End If
        Next
        Next
    End Method
    ' this function creates and returns a 2
    'dimensional array
    Method makearray:Int[][](a:Int,b:Int)
        Local aa:Int[a][]
        For Local i=0 Until a
            aa[i] = New Int[b]
        Next
        Return aa
    End Method    
End Class

Global mymap:map
Global mytime:Int

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        ' here we create the first map
        mymap = New map(20,20) 
    End Method
    Method OnUpdate()
        If mytime>60 
            mytime=0
            ' here we create a new map
            mymap = New map(    Rnd(10,51),
                                Rnd(10,51))
        Else
            mytime+=1
        End If
    End Method
    Method OnRender()
        Cls(0,0,0)
        mymap.draw
        SetColor 255,255,255
        DrawText     "Inloop Class creation and "+
                    "return 2 dim array",2,2
    End
End

Function Main()
    New MyGame()
End
