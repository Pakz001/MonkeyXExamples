Import mojo

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()       
    End Method
    Method OnRender()
        Local test:String="Part of a string."
        Cls(0,0,0)
        SetColor(255,255,255)
        DrawText "Complete string : ",10,10
        DrawText "Sliced part of the String [0..4]: ",10,20
        DrawText test,DeviceWidth*.5,10
        DrawText test[0..4],DeviceWidth*.5,20
    End
End

Function Main()
    New MyGame()
End
