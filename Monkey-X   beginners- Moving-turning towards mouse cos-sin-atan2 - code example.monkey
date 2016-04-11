Import mojo

Class player
    Field angle:Int
    Field x:Float = 100
    Field y:Float = 100
    Field mx:Float = 2 'movement speed x
    Field my:Float = 2 'movement speed y    
    Method update()
        ' here we move the player with the current angle
        x+=Cos(angle)*mx
        y+=Sin(angle)*my
        'get the real angle between the mouse and player
        Local destinationangle = getangle(MouseX(),MouseY(),x,y)
        ' cnt1 is used to see which direction is closer towards the destination angle
        Local cnt1 = 0
        ' put the angle value in a1
        Local a1 = angle
        ' we exit the loop if the a1 value is the destination angle
        While a1<>destinationangle
            'increase the a1 value
            a1+=1
            ' valid angles range from -180 to 180
            If a1>180 Then a1=-180
            'increase the cnt1 counter with one
            cnt1+=1
        Wend
        ' if going left is shorter 
        If cnt1<180 Then angle+=3 Else angle-=3
        ' Keep the angle in the valid angle range
        If angle>180 Then angle=-180
        If angle<-180 Then angle=180
    End Method
    Method draw()
        SetColor 255,255,255
        DrawOval x,y,10,10
    End Method
End Class

Global p:player = New player

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
        p.update
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        p.draw
    End Method
End Class

Function getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return ATan2(y1-y2, x1-x2)
End Function

Function Main()
    New MyGame()
End Function
