Import mojo

Global starx:Float[100]
Global stary:Float[100]
Global stars:Float[100]

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        For Local i:Int = 0 Until 100
            starx[i] = Rnd(640)
            stary[i] = Rnd(480)
            stars[i] = Rnd(3)+1
        End
    End
    Method OnUpdate()
        For Local i:Int = 0 Until 100
            starx[i] -= stars[i]
            If starx[i] < 0 Then starx[i] = 640
        End
    End
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        For Local i:Int = 0 Until 100
            DrawRect(starx[i],stary[i],1,1)
        End
    End
End

Function Main()
    New MyGame()
End
