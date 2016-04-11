Import mojo

Class player
    Field x:Float = 320
    Field y:Float = 240
    Field width:Int=8
    Field height:Int=8
    Field incx:Float=0
    Field incy:Float=0
    Field throttle:Float=0.0
    Field direction:String="right"
    Field message:String=""
    Field messagetime:Int
    Method draw()
        SetColor 255,255,255
        DrawRect x,y,width,height
    End Method
End Class

Global p:player = New player

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
        'delete message if shown 2 seconds
        If p.messagetime+2000 < Millisecs() Then p.message = ""
        'go to the other side of the screen of outside of screen
        If p.x < 0 Then p.x = 640
        If p.x > 640 Then p.x = 0
        'if to hight then go no higher
        If p.y < 0 Then p.y = 0
        ' modify the player location variables
        p.x+=p.incx
        p.y+=p.incy
        ' slow down (friction)
        If p.incx > 0.05 Then p.incx-=0.01
        If p.incx < -0.05 Then p.incx+=0.01
        ' gravity
           If p.y < 240 And p.incy < 3 Then p.incy+=.03
           ' crash
           If p.y > 240 And p.incy > 1.5 Then 
               p.incx = 0 ; p.incy=0 ; p.y = 240
               p.x = 320 ; p.throttle = 0
               p.message = "Crashed."
               p.messagetime = Millisecs()
           End If
           'land
           If p.y > 240 And p.incy < 1.5 Then p.incy=0 ; p.y = 240;p.throttle=0
           If p.y = 240
               If KeyDown(KEY_RIGHT) = False And KeyDown(KEY_LEFT) = False
               If p.incx > 0 Then p.incx -= 0.03
               If p.incx < 0 Then p.incx += 0.03
               If p.incx > -0.05 And p.incx < 0.05 Then p.incx=0
               End If
           End If
           'plane control
        If KeyDown(KEY_RIGHT)
            If p.direction = "left" Then p.throttle = 0
            p.direction = "right"
            If p.incx < 2 Then p.incx += p.throttle
            p.throttle+=0.0005
            If p.throttle > 0.5 Then p.throttle = 0.5
        End If
        If KeyDown(KEY_LEFT)
            If p.direction = "right" Then p.throttle = 0
            p.direction = "left"
            If p.incx > -2 Then p.incx -= p.throttle
            p.throttle+=0.0005
            If p.throttle > 0.5 Then p.throttle = 0.5
        End If
        If KeyDown(KEY_UP)
            If p.incx > 1.5 Or p.incx < -1.5 Then
            If p.incy > -1 Then p.incy -= 0.1
            End If
        End If
        If KeyDown(KEY_DOWN)
            If p.incy < 1 Then p.incy += 0.1
        End If
        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        'draw the plane block
        p.draw
        'draw the ground
        DrawLine 0,240+p.height,640,240+p.height
        'draw the crashed message
        DrawText p.message,0,0
        'draw some info
        DrawText "Use cursor left and right to speed up. Use cursor up down to go up and down",100,0
        'draw throttle and lift/descent
        Local tx = Abs(p.incx)*20
        DrawText "Speed",280,250
        DrawRect 320,270,tx,20
        Local ty = Abs(p.incy)*10
        DrawText "Vertical",280,300
        If p.incy < 0 Then DrawRect 320,320,ty,20
        If p.incy > 0 Then DrawRect 320-ty,320,ty,20
    End Method
End Class


Function Main()
    New MyGame()
End Function
