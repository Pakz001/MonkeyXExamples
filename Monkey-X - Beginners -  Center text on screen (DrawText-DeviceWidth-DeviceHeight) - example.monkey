Import mojo

Class MyGame Extends App
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255        
        DrawText "Monkey-X Beginner Example",10,10
        DrawText "Center text on the screen.",10,30
        DrawText "Center of Screen.",DeviceWidth()/2,DeviceHeight()/2,.5,.5
    End Method
End Class

Function Main()
    New MyGame()
End Function
