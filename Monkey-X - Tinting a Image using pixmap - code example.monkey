Import mojo

Class theimage
    Field x:Int
    Field y:Int
    Field image:Image
    Field pixels:Int[]
    Field width:Int
    Field height:Int
    Method New(    x:Int,y:Int,
                width:Int,
                height:Int)
        pixels = New Int[width*height]
        image = CreateImage(width,height)
        Self.x = x
        Self.y = y
        Self.width = width
        Self.height = height
        makeimage
        image.WritePixels(pixels, 0, 0, width, height, 0)
    End Method
    Method makeimage()
        Seed = 10
        For Local i:Int = 0 Until width*height
            Local col:Int=Rnd(255)
            pixels[i] = argb(col,col,col)
        Next
    End Method
    Method tintimage(r:Int,g:Int,b:Int)
        makeimage
        For Local i:Int = 0 Until width*height
            Local r2:Int = getred(pixels[i])
            Local g2:Int = getgreen(pixels[i])
            Local b2:Int = getblue(pixels[i])
            r2+=r
            g2+=g
            b2+=b
            r2 = Clamp(r2,0,255)
            g2 = Clamp(g2,0,255)
            b2 = Clamp(b2,0,255)
            pixels[i] = argb(r2,g2,b2)
        Next
        image.WritePixels(pixels, 0, 0, width, height, 0)        
    End Method
    Method draw()
        DrawImage image,x,y
    End Method
End Class    

Global im1:theimage
Global im2:theimage

Class MyGame Extends App    
    Field tintred:Int = 100
    Field tintgreen:Int = 0
    Field tintblue:Int = 0
    Method OnCreate:Int()
        SetUpdateRate(60)
        im1 = New theimage(10,20,200,200)
        im2 = New theimage(330,20,200,200)
        '
        ' Here we tint the image
        '
        im2.tintimage(tintred,tintgreen,tintblue)
    End Method
    Method OnUpdate()
        If Rnd(320)<2
            DebugLog Millisecs()
            Seed = Millisecs()
            tintred = Rnd(0,255)
            tintgreen = Rnd(0,255)
            tintblue = Rnd(0,255)
            im2.tintimage(tintred,tintgreen,tintblue)
        End If
    End Method
    Method OnRender:Int()
        Cls
        im1.draw
        im2.draw
        SetColor 255,255,255
        DrawText "Monkey-X - Tinting a image (pixels).",0,0
        DrawText     "Red: "+tintred+
                    " Green: "+tintgreen+
                    " BLue: "+tintblue,
                    10,300
        SetColor tintred,tintgreen,tintblue
        DrawRect 400,300,50,50
    End Method    
End Class

Function Main:Int()
    New MyGame()
End Function

Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
   Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
End Function

Function getred:Int(rgba:Int)    
    Return((rgba Shr 16) & $FF)    
End Function
              
Function getgreen:Int(rgba:Int)    
    Return((rgba Shr 8) & $FF)    
End Function
    
Function getblue:Int(rgba:Int)    
    Return(rgba & $FF)    
End Function
    
Function getalpha:Int(rgba:Int)    
    Return ((rgba Shr 24) & $FF)    
End Function
