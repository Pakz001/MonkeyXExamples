Import mojo

Class player
    Field x:Int = 10
    Field y:Int = 20
    Field lives:Int = 3
End

Global p:player = New player

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)        
    End
    Method OnUpdate()
    End
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        DrawText "Player x :" + p.x,10,10
        DrawText "Player y :" + p.y,10,20
        DrawText "Player Lives : " + p.lives,10,30
    End
End

Function Main()
    New MyGame()
End
