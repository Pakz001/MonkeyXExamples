Import mojo


Class MyGame Extends App

    Field image:Image

    Global im1data:Int[][] = [    [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
                                [0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0],
                                [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
                                [0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
                                [0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
                                [0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
                                [0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
                                [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
                                [0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0],
                                [0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0],
                                [0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0],
                                [0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0],
                                [0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0],
                                [0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0],
                                [0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0],
                                [0,0,0,0,0,0,2,2,2,2,0,0,0,0,0,0] ]
    
    Method OnCreate:Int()
        SetUpdateRate(60)
        
        image = CreateImage(16, 16)
        Local pixels:Int[16 * 16]
        
        For Local i:Int = 0 Until 16 * 16
            Local x:Int = i Mod 16
            Local y:Int = i / 16
            If im1data[y][x] = 0
                pixels[i] = argb(0,0,0,0)
            Elseif im1data[y][x] = 1
                pixels[i] = argb(10,200,25)
            Elseif im1data[y][x] = 2
                pixels[i] = argb(210,200,25)
            End If
        Next
        image.WritePixels(pixels, 0, 0, 16, 16, 0)
    End
    
    Method OnRender:Int()
        Cls()
        For Local x = 0 Until DeviceWidth Step 16
        For Local y = 0 Until DeviceHeight Step 16
            DrawImage(image, x,y)
        Next
        Next
        
    End
    
End

Function Main:Int()
    New MyGame()
End

Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
        Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
End Function
