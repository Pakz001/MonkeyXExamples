Import mojo

Class map
    Field tilewidth:Int,tileheight:Int
    Field mapwidth:Int,mapheight:Int
    Field map:Int[][]
    Field bwipe:Int[10]
    Field wipeactive:Bool=False
    Field wipemode:String
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
    End Method    
    Method update()
        If wipemode = "wipeout"
            For Local i=0 Until 10
                If bwipe[i] < 64 Then bwipe[i] +=2
            Next
            If bwipe[0] > 63 Then wipemode="black"
        End If
        If wipemode = "wipein"
            For Local i=9 To 0 Step -1
                If bwipe[i] > 0 Then bwipe[i] -= 2
            Next
            If bwipe[9] <= 0 Then wipemode="nothing"
        End If
    End Method
    Method wipeininit()
        wipemode="wipein"
        For Local i=0 To 9
            bwipe[i] = 64+i*10
        Next
    End Method
    Method wipeoutinit()
        wipemode="wipeout"
        For Local i=0 To 9
            bwipe[i] = -100+(i*10)
        Next
    End Method
    Method setmap:Void(x:Int,y:Int,val:Int)
        If x>=0 And y>=0 And x<mapwidth And y<mapheight
            map[x][y] = val
        End If
    End Method
    Method drawmap:Void()
        For Local y1=0 Until mapheight
        For Local x1=0 Until mapwidth
            drawtile(map[x1][y1],x1*tilewidth,y1*tileheight)
        Next
        Next
        If wipemode="wipeout"
            SetColor 0,0,0
            For Local i=0 Until 10
                If bwipe[i]>0
                    DrawRect i*64,0,bwipe[i],480
                End If
            Next
        End If
        If wipemode="wipein"
            SetColor 0,0,0
            For Local i=0 Until 10
                If bwipe[i]<64
                    DrawRect i*64,0,bwipe[i],480
                Else
                    DrawRect i*64,0,64,480
                End If
            Next
        End If
        If wipemode="black"
            SetColor 0,0,0
            DrawRect 0,0,640,480
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
Global mdelay:Int=Millisecs()+3000

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        mymap.wipeoutinit
    End Method
    Method OnUpdate()
        mymap.update
        If mymap.wipemode="black" And Millisecs() > mdelay
            mdelay=Millisecs()+3000
            mymap.wipeininit
        End If
        If mymap.wipemode="nothing" And Millisecs() > mdelay
            mdelay=Millisecs()+3000
            mymap.wipeoutinit
        End If
    End Method
    Method OnRender()
        Cls 0,0,0
        mymap.drawmap
        SetColor 255,255,255
        DrawText "Screenwipe example : "+mymap.wipemode,0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
