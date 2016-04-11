Import mojo

Class bullet
    Field x:Float,y:Float
    Field angle:Int
    Field speed:Float
    Field delete:Bool=False
    Method New(x:Int,y:Int,angle:Int,speed:Float)
        Self.x = x
        Self.y = y
        Self.angle = angle
        Self.speed = speed
    End Method
    Method update()
        x+=Cos(angle)*speed
        y+=Sin(angle)*speed
        If x<0 Then delete = True
        If x>DeviceWidth() Then delete = True
        If y<0 Then delete = True
        If y>DeviceHeight() Then delete = True
    End Method
    Method draw()
        SetColor 255,255,0
        DrawOval x,y,8,8
    End Method
End Class

Class turret
    Field x:Int,y:Int
    Field firecountdown:Int=30
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
    End Method
    Method update()
        firecountdown-=1
        If firecountdown<0 Then 
            firecountdown = 30
            Local firedist:Int=4
            If distance(myplayer.x,
                        myplayer.y,x,y) > 256 Then firedist=10
            mybullet.AddLast(New bullet(x,y,
                                        getangle(myplayer.tx,
                                        myplayer.ty,x+Rnd(-16,16),
                                        y+Rnd(-16,16)),
                                        firedist))
        End If
    End Method
    Method draw()
        SetColor 255,0,0
        DrawOval x,y,32,32
    End Method
    Method getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return ATan2(y1-y2, x1-x2)
    End Method        
    Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Function
End Class

Class player
    Field x:Float=100,y:Float=100
    Field w:Float=32,h:Float=32
    Field angle:Int
    Field speed:Float=0
    Field tx:Int,ty:Int
    Method New()
    End Method
    Method update()
        If speed>0.0 Then speed-=0.05
        If KeyDown(KEY_RIGHT)
            angle+=2
        End If
        If KeyDown(KEY_LEFT)
            angle-=2
        End If
        If angle<0 Then angle=360
        If angle>360 Then angle=0
        If KeyDown(KEY_UP)
            If speed < 2 Then speed+=.1
        End If
        x+=Cos(angle)*speed
        y+=Sin(angle)*speed
        ' get the target coords for the turrets
        tx=x+(Cos(angle)*speed*32)        
        ty=y+(Sin(angle)*speed*32)
    End Method
    Method draw()
        SetColor 100,100,0
        For Local i=0 Until speed*20
            Local y2=Int(Sin(angle)*i)
            Local x2=Int(Cos(angle)*i)
            DrawOval x+x2,y+y2,32,32
        Next
        SetColor 255,255,255
        DrawOval x,y,w,h
        Local y2:Int=(Sin(angle)*48)
        Local x2:Int=(Cos(angle)*48)
        DrawLine x+16,y+16,x+16+x2,y+16+y2
    End Method
End Class

Global myturret:List<turret> = New List<turret>
Global mybullet:List<bullet> = New List<bullet>
Global myplayer:player = New player

Class MyApp Extends App
    
    Method OnCreate()
        SetUpdateRate(60)
        myturret.AddLast(New turret(200,200))
        myturret.AddLast(New turret(400,400))        
    End Method

    Method OnUpdate()
        For Local i:=Eachin myturret
            i.update
        Next
        For Local i:=Eachin mybullet
            i.update
        Next
        myplayer.update
        For Local i:=Eachin mybullet
            If i.delete = True Then mybullet.Remove i
        Next
    End Method
    
    Method OnRender()
        Cls 0,0,0
        For Local i:=Eachin mybullet
            i.draw
        Next
        For Local i:=Eachin myturret
            i.draw
        Next
        myplayer.draw
        SetColor 255,255,255
        DrawText "Monkey-X Targeting example.",10,10
        DrawText "Cursor left and Right = turn , cursor up = move",10,30
    End Method
    
End Class

Function Main()
    New MyApp
End Function
