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
            pixels[i] = argb(Rnd(255),Rnd(255),Rnd(255))
        Next
    End Method
    Method effectimage()
        For Local i:Int = 0 Until width*height
            Local r:Int = getred(pixels[i])
            Local g:Int = getgreen(pixels[i])
            Local b:Int = getblue(pixels[i])
            r=r*r/256
            g=g*g/256
            b=b*b/256
            r = Clamp(r,0,255)
            g = Clamp(g,0,255)
            b = Clamp(b,0,255)
            pixels[i] = argb(r,g,b)
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
    Field cnt:Int
    Field resetim:Int
    Method OnCreate:Int()
        SetUpdateRate(60)
        im1 = New theimage(10,20,200,200)
        im2 = New theimage(330,20,200,200)
        '
        im2.effectimage()
    End Method
    Method OnUpdate()
        cnt+=1
        resetim+=1
        If cnt>10 Then
            im2.effectimage()
            cnt=0
        End If    
        If resetim > 100
            im2 = New theimage(330,20,200,200)
            resetim=0
        End If    
    End Method
    Method OnRender:Int()
        Cls
        im1.draw
        im2.draw
        SetColor 255,255,255
        DrawText "Monkey-X - Effect(Hugi) on Image (pixels).",0,0
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
