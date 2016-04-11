Import mojo

Const numagents:Int=10
Global mapwidth:Int=10
Global mapheight:Int=10
Global tilewidth:Int=640/mapwidth
Global tileheight:Int=480/mapheight

Global map:Int[][] = [        [1,1,1,1,1,1,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,1,1,1,1],
                            [1,0,0,1,0,0,0,0,0,1],
                            [1,0,0,1,0,0,0,0,0,1],
                            [1,1,1,1,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,1,0,1],
                            [1,0,0,0,0,0,0,1,0,1],
                            [1,1,1,1,1,1,1,1,1,1] ]

Class agents
    Field x:Float,y:Float
    Field angle:Int    
    Method New(x:Float,y:Float)
        Self.x = x
        Self.y = y
        angle=Rnd(-180,180)
    End Method
    Method update()
        x+=Cos(angle)*3
        y+=Sin(angle)*3
        ' here we check 64 pixels in the angle we are going into
        ' if there is a wall there then the obstr boolean is set
        Local x1:Float=x
        Local y1:Float=y
        Local obstr:Bool=False
        For Local i=0 To 64
            x1=x+Cos(angle)*i
            y1=y+Sin(angle)*i
            Local x2:Int=x1/tilewidth
            Local y2:Int=y1/tileheight
            If x2>-1 And y2>-1 And x2<mapwidth And y2<mapheight
                If map[y2][x2] = 1 Then 
                    obstr = True
                    Exit
                End If
            End If
        Next
        ' if obstructed then turn
        If obstr = True
            angle+=16
        End If
        ' random movement
        If Rnd(10)<2 Then angle+=Rnd(-15,15)
        ' keep angle in check
        If angle>180 Then angle = -180
        If angle<-180 Then angle=180
    End Method
    Method draw()
        SetColor 255,255,255
        DrawOval x,y,10,10
        DrawLine x+5,y+5,x+Cos(angle)*64,y+Sin(angle)*64
    End Method
End Class

Global agent:List<agents> = New List<agents>

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)    
        ' ceate the agents on open tiles    
        For Local i=0 Until numagents
            Local exitloop:Bool = False
            While exitloop = False
                Local x:Int=Int(Rnd(10))
                Local y:Int=Int(Rnd(10))
                If map[y][x] = 0
                    agent.AddLast(New agents((x*tilewidth)+tilewidth/2,(y*tileheight)+tileheight/2))
                    exitloop = True
                End If
            Wend
        Next
    End Method
    Method OnUpdate()   
        Seed = Millisecs()
        For Local i:=Eachin agent
            i.update
        Next     
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        drawmap
        For Local i:=Eachin agent
            i.draw
        Next
        SetColor 255,255,255
        DrawText "Ray Casting roaming ai example.",0,0
    End Method
End Class

Function drawmap:Void()
    SetColor 200,200,200
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        If map[y][x] = 1
            SetColor 200,200,200
            DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
        End If
    Next
    Next
End Function

Function Main()
    New MyGame()
End Function
