Import mojo

Class waitanim
    Field angle:Int
    Field x:Int,y:Int
    Field size:Int
    Method New(x:Int,y:Int,size:Int)
        Self.x = x
        Self.y = y
        Self.size = size
    End Method
    Method update()
        angle+=4
        If angle>359 Then angle=0
    End Method
    Method draw()
        SetColor 150,150,150
        For Local i=0 To 360
            DrawOval     x+(Cos(i)*size),
                        y+(Sin(i)*size),4,4
        Next
        SetColor 220,220,220
        For Local i=0 To 48
            Local da:Int=angle+i
            If da>359 Then da = da-359
            DrawOval     x+(Cos(da)*size),
                        y+(Sin(da)*size),6,6
        Next
    End Method
End Class

Global mywait:waitanim

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)        
        mywait = New waitanim(    DeviceWidth/2,
                                DeviceHeight/2,
                                24)
    End Method
    Method OnUpdate()
        mywait.update        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText     "Wait/Busy Animation "+
                    "thing - code example.",
                    0,0
        mywait.draw
    End Method
End Class


Function Main()
    New MyGame()
End function
