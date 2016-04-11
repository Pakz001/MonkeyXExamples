Import mojo

Global px:Float=640/2,py:Float=480/2
Global pw:Int=32,ph:Int=32
Global sgdelay:Int
Global sgshotshow:Int

Class sgbullets
    Field x:Float,y:Float
    Field incx:Float,incy:Float
    Field timeout:Int=Millisecs()+1000
    Field delete:Bool=False
    Method New(x:Float,y:Float)
        Self.x = x
        Self.y = y
        incx = Rnd(3.5,4.5)
        incy = Rnd(-0.3,0.3)
        If Rnd(10) < 2 Then incy=Rnd(-1,1)
    End Method
    Method update()
        x+=incx
        y+=incy
        If Millisecs() > timeout Then delete = True
        For Local i:=Eachin sgbullet
            If i.delete = True Then sgbullet.Remove i
        Next
    End Method
    Method draw()
        SetColor 200,200,200
        DrawOval x,y,3,3
    End Method
End Class

Global sgbullet:List<sgbullets> = New List<sgbullets>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
        If KeyDown(KEY_SPACE) And Millisecs() > sgdelay Or (Rnd(10)<2 And Millisecs() > sgdelay)
            sgdelay = Millisecs() + 700
            sgshotshow = Millisecs() + 500
            For Local i=0 Until 5
                sgbullet.AddLast(New sgbullets(px+32,py+10))
            Next
        End If
        For Local i:=Eachin sgbullet
            i.update
        Next        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Platformer Shotgun shooting example.",0,0
        DrawRect px,py,pw,ph
        SetColor 255,255,255
        If Millisecs() < sgshotshow
            PushMatrix()
            Translate px,py
            Rotate(45)
            Translate -px,-py
            DrawText "PANG",px+pw/3,py+ph
            PopMatrix()
        End If
        For Local i:=Eachin sgbullet
            i.draw
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
