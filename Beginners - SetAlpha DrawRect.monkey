Import mojo

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        SetColor Rnd(255),0,0
        SetAlpha(Rnd(1))
        Local x:=Rnd(DeviceWidth)
        Local y:=Rnd(DeviceHeight)
		Local w:=Rnd(10,100)
		Local h:=Rnd(10,100)
        DrawRect(x,y,w,h)
        
        
    End Method
End Class


Function Main()
    New MyGame()
End function
