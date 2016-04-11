Import mojo

Class map
    Field tilewidth:Int,tileheight:Int
    Field mapwidth:Int,mapheight:Int
    Field map:Int[][]
    Field wipemap:Int[][]
    Field wipeactive:Bool=False
    Field wipemode:String
    Field wipetime:Int
    Method New(mapwidth:Int,mapheight:Int,tilewidth:Int,tileheight:Int)
        Self.tilewidth = tilewidth
        Self.tileheight = tileheight
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        map = New Int[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            setmap(x,y,Rnd(0,5))
        Next
        Next
        wipemap = New Int[mapwidth][]
        For Local i=0 Until mapwidth
            wipemap[i] = New Int[mapheight]
        Next
    End Method    
    Method update()
        If wipemode="wipein"            
            If Millisecs()>wipetime Then wipemode="wipedone"
        End If
        If wipemode="wipeout"
            If Millisecs()>wipetime Then wipemode="nothing"
        End If
    End Method
    Method initwipein()
        For Local y1=0 Until mapheight
        For Local x1=0 Until mapwidth
            wipemap[x1][y1] = Millisecs()+Rnd(3000)
        Next
        Next
        wipemode="wipein"
        wipetime=Millisecs()+3500
    End Method
    Method initwipeout()
        For Local y1=0 Until mapheight
        For Local x1=0 Until mapwidth
            wipemap[x1][y1] = Millisecs()+Rnd(3000)
        Next
        Next
        wipemode="wipeout"
        wipetime=Millisecs()+3500        
    End Method
    Method setmap:Void(x:Int,y:Int,val:Int)
        If x>=0 And y>=0 And x<mapwidth And y<mapheight
            map[x][y] = val
        End If
    End Method
    Method drawmap:Void()
        If wipemode<>"nothing"
            For Local y1=0 Until mapheight
            For Local x1=0 Until mapwidth
                drawtile(map[x1][y1],x1*tilewidth,y1*tileheight)
            Next
            Next        
        End If
        If wipemode="wipein"
            SetColor 0,0,0
            For Local y1=0 Until mapheight
            For Local x1=0 Until mapwidth
                If wipemap[x1][y1] > Millisecs()
                    DrawRect x1*tilewidth,y1*tileheight,tilewidth,tileheight
                End If
            Next
            Next        
        End If
        If wipemode="wipeout"
              SetColor 0,0,0
            For Local y1=0 Until mapheight
            For Local x1=0 Until mapwidth
                If wipemap[x1][y1] < Millisecs()
                    DrawRect x1*tilewidth,y1*tileheight,tilewidth,tileheight
                End If
            Next
            Next                      
        End If
    End Method
    Method drawtile(val:Int,x1:Int,y1:Int)
        Select val
            Case 0'water
                SetColor 0,0,255
                DrawRect x1,y1,tilewidth,tileheight
            Case 1'land
                SetColor 0,200,0
                DrawRect x1,y1,tilewidth,tileheight
            Case 2'forrest
                drawtile(1,x1,y1)
                SetColor 0,255,0
                DrawOval x1+5,y1+5,tilewidth-10,tileheight/2
                SetColor 150,10,0
                DrawRect x1+12,y1+tileheight-10,tilewidth-24,tileheight/2-5
            Case 3'hill
                drawtile(1,x1,y1)
                SetColor 0,255,0
                DrawOval x1+5,y1+10,tilewidth-10,tileheight-15
                SetColor 0,200,0
                DrawRect x1,y1+tileheight/1.5,tilewidth,10
            Case 4'mountain
                drawtile(1,x1,y1)
                SetColor 200,200,200
                DrawPoly(    [Float(x1+tilewidth/2),Float(y1),
                            Float(x1+tilewidth-5),Float(y1+tileheight-5),
                            Float(x1+5),Float(y1+tileheight-5)])
        End Select
    End Method

End Class

Global mymap:map = New map(20,14,32,32)

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        mymap.initwipein
    End Method
    Method OnUpdate()
        mymap.update
        If mymap.wipemode="wipedone"
            mymap.initwipeout
        End If
        If mymap.wipemode="nothing"
            mymap.initwipein            
        End If
    End Method
    Method OnRender()
        Cls 0,0,0
        mymap.drawmap
        SetColor 255,255,255
        DrawText "Screen wipe example (blocks) wipemode "+mymap.wipemode,0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
