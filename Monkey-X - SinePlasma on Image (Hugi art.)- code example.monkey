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
    Method sineplasmaimage(set:Int)
        Local x:Int,y:Int
        For Local i:Int = 0 Until width*height
            If x>width-1
                x=0
                y+=1
            End If
            Local c:Float
            c =    127+63.5*Sin(x*set)+
                63.5*Sin(y*set)
               pixels[i] = argb(c,c,c)
               x+=1
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
    Field passim:Int
    Method OnCreate:Int()
        SetUpdateRate(60)
        Seed = GetDate[5]
        im1 = New theimage(10,20,200,200)
        im2 = New theimage(330,20,200,200)
    End Method
    Method OnUpdate()
        cnt+=1
        If cnt>10
            im2.sineplasmaimage(passim)
            cnt=0
            passim+=1
        End If
        If passim > 20
            im2 = New theimage(330,20,200,200)
            passim = 0        
        End If
    End Method
    Method OnRender:Int()
        Cls
        im1.draw
        im2.draw
        SetColor 255,255,255
        DrawText     "Monkey-X - SinePlasma(Hugi) on"+ 
                    " Random Greyscale Image (pixels).",0,0
        DrawText     "modifier : "+
                    passim+
                    " of 20",10,400
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
