Import mojo

Const mapwidth:Int=640 ' number of peaks
Global mapx:Int=320 ' location of the map to draw
Global mapsx = 0 'scroll offset
Global point:Int[mapwidth] 'these hold the points inbetween the lines of the mountains

Class player
    Field x:Float = 640/2
    Field y:Float = 480/2
    Field direction:String="right" ' direction we are flying to
    Field vdirection:String="up" ' vertical direction up/down
    Field vthrust:Float=6 'how fast we move up and down
    Field thrust:Float=12 ' how fast we move to the left and right
End Class

Global p:player = New player

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        Seed = Rnd(1000)
        ' Here we make the mountains
        Local switch:Int=1
        For Local i=0 Until mapwidth
            Select switch
                Case 1    
                    point[i] = Int(Rnd(0,150))
                    switch = 2
                Case 2
                    point[i] = Int(Rnd(150,300))
                    switch = 1
            End Select
        Next
    End Method
    Method OnUpdate()
        If p.thrust > 0 Then p.thrust-=0.1
        If p.vthrust > 0 Then p.vthrust-=0.1
        If p.vthrust < 0.3 Then p.vthrust= 0
        Select p.vdirection
            Case "up"
                If p.y>50 Then p.y -=p.vthrust
            Case "down"
                If p.y<480-50 Then p.y +=p.vthrust
        End Select
        If KeyDown(KEY_UP)
            p.vdirection="up"
               p.vthrust=6
        End If
        If KeyDown(KEY_DOWN)
            p.vdirection="down"
               p.vthrust=6
        End If
        
        If KeyDown(KEY_RIGHT)
            p.direction="right"
            p.thrust=12
        End If
        If KeyDown(KEY_LEFT)
            p.direction="left"
            p.thrust=12
        End If        
        If p.direction="right"
            For Local i=0 Until Int(p.thrust)
                mapsx-=1
                If mapsx<0            
                    mapx+=1
                    mapsx=96
                    If mapx > 500 Then 
                        p.direction = "left"
                        p.thrust = 12
                        Exit
                    End If
                End If
            Next
        End If
        If p.direction="left"
            For Local i=0 Until Int(p.thrust)
                mapsx+=1
                If mapsx>95            
                    mapx-=1
                    mapsx=0
                    If mapx<100 Then
                        p.direction="right"
                        p.thrust = 12
                        Exit
                    End If
                End If
            Next        
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255        
        ' here we draw the mountains
        Local x=-96
        Local loc=mapx
        For Local i=0 To (640/96)+1
            DrawLine x+mapsx,480-point[loc],x+96+mapsx,480-point[loc+1]
            x+=96
            loc+=1
            If loc+2>mapwidth Then loc=0
        Next
        ' draw the ship
        DrawRect p.x,p.y,32,32
        
        DrawText "Use cursor keys to move the ship.",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
