Import mojo

Global ang:Float=0
' poly shape
Global ship:Float[]=[    -5.0,-5.0,
                         5.0,0.0,
                         -5.0,5.0]  
Class bullet
    Field x:Float
    Field y:Float
    Field angle:Float
    Field speed:Float
    Field timeout:Int
    Field deleteme:Bool=False
    Field tp:Int 'type of bullet/laser
    Method New(    x:Int,y:Int,
                angle:Float,
                speed:Float,
                tp:Int)
        Self.x = x
        Self.y = y
        Self.angle = angle
        Self.speed = speed
        Self.tp = tp
        timeout = 200
    End Method
    Method update()
        x+=Cos(angle)*speed
        y+=Sin(angle)*speed
        timeout-=1
        If timeout<0 Then
            deleteme = True
        End If
    End Method
    Method draw()
        SetColor 255,255,0
        Select tp
            Case 1
            DrawOval x-3,y-3,6,6
            Case 2
            DrawOval x-6,y-6,12,12
        End Select
    End Method
End Class

Global mybullet:List<bullet> = New List<bullet>

Class MyGame Extends App
    Field bulletdelay:Int=30
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate() 
        ang+=1
        If ang>360 Then ang=0        
        ' here we shoot when bulletdelay
        ' is <0
        bulletdelay-=1
        If bulletdelay<0
            shoot(Rnd(1,4))
            bulletdelay=30
        Endif
        '
        For Local i:=Eachin mybullet
            i.update
            If i.deleteme = True
                mybullet.Remove(i)
            End If
        Next
    End Method
    Method OnRender()
        Cls 0,0,0  
        SetColor 255,255,255
        PushMatrix()
        Translate DeviceWidth()/2,DeviceHeight()/2
        Rotate(-ang)
        Scale(4,4)
        DrawPoly(ship)
        PopMatrix()  
        Translate 0,0
        SetColor 255,0,0
        DrawLine    DeviceWidth()/2,
                      DeviceHeight()/2,
                    DeviceWidth()/2+Cos(ang)*64,
                    DeviceHeight()/2+Sin(ang)*64
        For Local i:=Eachin mybullet
            i.draw
        Next
        SetColor 255,255,255
           DrawText "MonkeyX - Space game ship/shooting/rotating example.",0,0
    End Method
End Class

Function shoot(tp:Int)
    Select tp
        Case 1
        'forwards shot
        mybullet.AddLast(New bullet(    DeviceWidth/2,
                                        DeviceHeight/2,
                                        ang,
                                        3,
                                        1))
        'backward shot
        mybullet.AddLast(New bullet(    DeviceWidth/2,
                                        DeviceHeight/2,
                                        ang-180,
                                        3,
                                        1))
        Case 2        
        ' three forwards spread shot
        For Local a=-16 To 16 Step 16
            mybullet.AddLast(New bullet(    DeviceWidth/2,                
                                            DeviceHeight/2,
                                            ang+a,
                                            2,
                                            2))
        Next
        Case 3
        ' circle shot
        For Local a=0 Until 360 Step 16
            mybullet.AddLast(New bullet(    DeviceWidth/2,
                                            DeviceHeight/2,
                                            ang+a,
                                            4,
                                            1))            
        Next
    End Select

End Function

Function Main()
    New MyGame()
End Function
