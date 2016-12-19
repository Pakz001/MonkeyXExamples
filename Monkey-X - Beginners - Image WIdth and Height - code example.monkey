Import mojo

Class MyGame Extends App
	'
    Field image:Image
	'
    Method OnCreate:Int()
        SetUpdateRate(60)        
        ' create an image 
        image = CreateImage(64, 64)
        ' create an array for that image
        Local pixels:Int[image.Width * image.Height]
        ' draw the color red in the pixels array
        For Local i:Int = 0 Until image.Width * image.Height
			pixels[i] = argb(200,0,0)
	    Next
	    ' copy the array to the image
        image.WritePixels(pixels, 0, 0, image.Width, image.Height, 0)
    End Method
    
    Method OnRender:Int()
        Cls 0,0,0
        DrawImage(image, 50,50)
        SetColor 255,255,255
        DrawText "Image Width is : "+image.Width+" Image Height is : "+image.Height,0,0
    End Method
    
End Class

Function Main:Int()
    New MyGame()
End Function

'helper function
Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
        Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
End Function
