Import mojo

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Local date:=GetDate()
        Cls(0,0,0)
        SetColor(255,255,255)
        DrawText "Millisecs command, milliseconds from start of app : "+Millisecs,10,10
        DrawText "DeviceWidth and DeviceHeight command : "+DeviceWidth +","+DeviceHeight,10,20
        DrawText "Date Year :"+date[0]+" Month :"+date[1]+" Day:"+date[2],10,30        
    End
End

Function Main()
    New MyGame()
End
