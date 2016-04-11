Import mojo

Const screenwidth:Int = 640
Const screenheight:Int = 480
Global myimagearray:Int[] = New Int[screenwidth*screenheight]
Global myimage:Image
Global makemyimage:Bool=True

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        myimage = CreateImage(screenwidth,screenheight)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        If makemyimage = True 
            createmyimage()
            makemyimage = False            
        End If
        Cls 0,0,0 
        SetColor 255,255,255
        DrawImage myimage,0,0
        DrawText "ReadPixels example : image created from canvas.",0,0
    End Method
End Class


Function createmyimage:Void()
    Cls 0,0,0
    SetColor 255,255,255
    For Local i=0 Until 10
        DrawRect Rnd(0,screenwidth),Rnd(0,screenheight),10,10
    Next    
    ReadPixels(myimagearray, 0, 0, screenwidth, screenheight)
    myimage.WritePixels(myimagearray,0,0,screenwidth,screenheight)
    Cls
End Function

Function Main()
    New MyGame()
End Function
