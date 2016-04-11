Import mojo

Class MyGame Extends App

    Field image:Image
    
    Method OnCreate:Int()
        SetUpdateRate(15)
        
        image = CreateImage(320, 200)
        Local pixels:Int[320 * 200]
        
        For Local i:Int = 0 Until 320 * 200
            ' $alpha(00=fully transparent, FF = not transparent)
            ' folowed by red(00-FF),green(00-FF),blue(00-FF)
            pixels[i] = $FFFF0000
        Next
        image.WritePixels(pixels, 0, 0, 320, 200, 0)
    End
    
    Method OnRender:Int()
        Cls()
        
        DrawImage(image, 10, 10)
        
    End
    
End

Function Main:Int()
    New MyGame()
End
