Import mojo


Class MyGame Extends App

    Field image:Image
    
    Method OnCreate:Int()
        SetUpdateRate(15)
        
        image = CreateImage(320, 200)
        Local pixels:Int[320 * 200]
        
        For Local i:Int = 0 Until 320 * 200
            pixels[i] = argb(255,255,255)
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

Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
        Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
End Function
