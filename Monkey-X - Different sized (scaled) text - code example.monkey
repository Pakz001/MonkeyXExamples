Import mojo

Global screen:Image
Global firsttime:Bool=True

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        screen = CreateImage(640,480)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        ' to save the cpu/gpu we make the screen only once
        ' we draw it then every frame
        If firsttime
            Local screenarray:Int[640*480] ' store the screen in this array
            firsttime = False
            Cls 0,0,0 
            SetColor 255,255,255
            For Local i=0 Until 100
                Local scale:Float = Rnd(0.2,2) ' get a scale value
                Local x:Int=Rnd(640)
                Local y:Int=Rnd(480)
                'This is where the resizing happens
                PushMatrix()            
                Scale scale,scale
                DrawText "Test",x,y
                PopMatrix()
            Next
            ReadPixels(screenarray, 0, 0, 640, 480)
            screen.WritePixels(screenarray,0,0,640,480)
            Cls
        End If
        Cls 0,0,0
        SetColor 255,255,255
        DrawImage screen,0,0
        DrawText "Different sized Text.",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
