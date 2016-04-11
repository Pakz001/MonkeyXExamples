Import mojo

Class map
    Field tilewidth:Int,tileheight:Int
    Field mapwidth:Int,mapheight:Int
    Field map:Int[][]
    Field screenwipe:Bool=False
    Field screenwipemode:String
    Field screenwipesize:Int
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
    End Method
    Method setmap:Void(x:Int,y:Int,val:Int)
        If x>=0 And y>=0 And x<mapwidth And y<mapheight
            map[x][y] = val
        End If
    End Method
    Method screenwipeininit()
        screenwipesize = 640
        screenwipe = True
        screenwipemode = "fadein"
    End Method
    Method screenwipeoutinit()
        screenwipesize = 0
        screenwipe = True
        screenwipemode = "fadeout"
    End Method
    Method drawmap:Void()
        For Local y1=0 Until mapheight
        For Local x1=0 Until mapwidth
            drawtile(map[x1][y1],x1*tilewidth,y1*tileheight)
        Next
        Next
        If screenwipe = True Then
            SetColor 0,0,0
            DrawRect 640/2-screenwipesize/2,480/2-screenwipesize/2,screenwipesize,screenwipesize
            If screenwipemode = "fadein"
                screenwipesize -= 10
                If screenwipesize <= 0 Then 
                    screenwipemode = "fadedone" 
                    screenwipe=False
                End If
            End If
            If screenwipemode = "fadeout"
                screenwipesize += 10
                If screenwipesize >= 640 Then 
                    screenwipemode = "fadedone" 
                    screenwipe = False
                End If
            End If
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
Global screenwipetp:Int=0
Global mydelay:Int

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        mymap.screenwipeininit
        mydelay = Millisecs() + 3000
    End Method
    Method OnUpdate()
        If Millisecs() > mydelay 'pauze between fades
            If mymap.screenwipemode = "fadedone" And screenwipetp = 0
                screenwipetp = 1
                mymap.screenwipeoutinit
            End If
            If mymap.screenwipemode = "fadedone" And screenwipetp = 1
                screenwipetp = 0
                mymap.screenwipeininit    
            End If
            mydelay = Millisecs() + 3000
        End If
    End Method
    Method OnRender()
        Cls 0,0,0
        If screenwipetp = 1 And mymap.screenwipemode = "fadedone"
        Else
            mymap.drawmap
        End If
           SetColor 255,255,255
           DrawText "Screenwipe example : "+mymap.screenwipemode,0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
