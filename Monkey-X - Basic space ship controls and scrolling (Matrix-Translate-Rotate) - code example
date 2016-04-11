Import mojo

Const screenwidth:Int=640
Const screenheight:Int=480
Const numstars:Int=150


Class player
    Field x:Float=screenwidth/2
    Field y:Float=screenheight/2
    Field incx:Float=0
    Field incy:Float=0
    Field w:Int=16
    Field h:Int=16
    Field angle:Int=0
    Method draw()
        PushMatrix()
        Translate 320,240
        Rotate(-angle)
        DrawPoly([Float(0-8),0 ,8,0-8 ,8,8])
        DrawLine -10,0,8,0        
        PopMatrix()
        

    End Method    
    Method update()

        If KeyDown(KEY_UP)
            incx = incx+Cos(angle)/10
            incy = incy+Sin(angle)/10
        End If
        If KeyDown(KEY_DOWN)
            incx = incx-Cos(angle)/30
            incy = incy-Sin(angle)/30
        End If
        If incx>3 Then incx = 3
        If incy>3 Then incy = 3
        If incx<-3 Then incx = -3
        If incy<-3 Then incy = -3

        If KeyDown(KEY_LEFT)
            angle-=1
            If angle<-180 Then angle = 180
        End If
        If KeyDown(KEY_RIGHT)
            angle+=1
            If angle>180 Then angle=-180
        End If
        For Local i:=Eachin s
            i.x+=incx
            i.y+=incy
            If i.x>screenwidth Then i.x = 0 ; i.y=Rnd(screenheight)
            If i.y>screenheight Then i.y=0 ; i.x = Rnd(screenwidth)
            If i.x<0 Then i.x=screenwidth ; i.y=Rnd(screenheight)
            If i.y<0 Then i.y=screenheight ; i.x=Rnd(screenwidth)
        Next
    End Method
End Class

Class star
    Field x:Float
    Field y:Float
    Method New()
        x = Rnd(screenwidth)
        y = Rnd(screenheight)
    End Method
    Method draw()
        DrawPoint x,y
    End Method
End Class

Global s:List<star> = New List<star>
Global p:player = New player

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        For Local i=0 Until numstars
            s.AddLast(New star())
        Next
    End Method
    Method OnUpdate()  
        p.update      
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Use cursor keys to control the ship.",0,0
        For Local i:=Eachin s
            i.draw
        Next
        p.draw
    End Method
End Class


Function Main()
    New MyGame()
End Function
