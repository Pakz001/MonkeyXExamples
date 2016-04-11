Import mojo

Class test
    Field x:Int,y:Int
    Method incx:test(val:Int)
        x+=val
        If x>1000 Then x=0
        Return Self
    End Method
    Method incy:test(val:Int)
        y+=val
        If y>1000 Then y=0
        Return Self
    End Method
    Method drawvalue()
        DrawText "x:"+x+" y:"+y,0,15
    End Method
End Class

Global t:test = New test

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
        t.incx(1).incy(1)
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Chaining example.",0,0
        t.drawvalue
    End Method
End Class


Function Main()
    New MyGame()
End Function
