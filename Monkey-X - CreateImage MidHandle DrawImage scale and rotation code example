Import mojo

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

    Global rotation:Int = 0              

Class MyGame Extends App
    Field image:Image

    Method OnCreate()
        SetUpdateRate(60)
        image = CreateImage(16, 16,1,image.MidHandle)
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
    End Method
    Method OnUpdate()
        rotation+=1
        If rotation>360 Then rotation = 0  
    End Method
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        For Local i = 0 To 10
            DrawImage image,100+Rnd(32)-16,100+Rnd(32)-16,0,3,3
        Next
        DrawImage image,100,200,rotation,2,2
    End
End

Function Main()
    New MyGame()
End

Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
        Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
End Function
