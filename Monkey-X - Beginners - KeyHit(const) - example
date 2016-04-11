Import mojo

Global lastpressed:Int=10

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
        lastpressed+=1
        If KeyHit(KEY_SPACE)
            lastpressed = 0
        End If     
    End Method
    Method OnRender()
        If lastpressed < 10 Then
            Cls 200,200,200
        Else
            Cls 0,0,0 
        End If        
        SetColor 255,255,255
        DrawText "Monkey-X - KeyHit(key) Example.",10,10
        DrawText "Press the space bar....",10,30
        DrawText "Space last pressed "+lastpressed/60+" second(s) ago",100,100
        DrawText "KeyHit(KEY_SPACE)",100,130
    End Method
End Class


Function Main()
    New MyGame()
End Function
