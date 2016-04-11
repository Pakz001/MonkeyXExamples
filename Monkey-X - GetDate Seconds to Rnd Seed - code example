Import mojo

Global color:Int[] = New Int[3]

Class MyApp Extends App
    
    Method OnCreate()
        SetUpdateRate(60)
        ' here 
        Local date := GetDate()
        ' set the random seed to
        ' current second
        Seed = date[5]
        color[0] = Rnd(255)
        color[1] = Rnd(255)
        color[2] = Rnd(255)                
    End Method

    Method OnUpdate()
    End Method
    
    Method OnRender()
        Cls 0,0,0
        SetColor 255,255,255
        DrawText "Monkey-X different random seed each time.",10,10
        For Local i=0 Until 3
            SetColor color[i],0,0
            DrawRect i*DeviceWidth()/3,0,DeviceWidth()/3,DeviceHeight()
        Next
    End Method
    
End Class


Function Main()
    New MyApp
End Function
