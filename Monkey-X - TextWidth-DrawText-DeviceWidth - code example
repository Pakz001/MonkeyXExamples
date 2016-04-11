Import mojo

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
    End Method
    Method OnRender()
        Cls 0,0,0           
        
        Local s:String="This is a string."
        Local tw:Int=TextWidth(s)
        
        SetColor 255,255,255
        DrawText s,DeviceWidth()/2,100,0.5,0.5
        DrawText "Width of text is :"+tw,DeviceWidth()/2,125,0.5,0.5
        
        SetColor 255,255,255
        DrawText "Monkey-X - TextWidth Example.",10,10
    End Method
End Class


Function Main()
    New MyGame()
End Function
