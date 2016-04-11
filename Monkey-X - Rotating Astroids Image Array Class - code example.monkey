Import mojo

Global numasteroids:Int=10
Global awidth:Int=64
Global aheight:Int=64

Class asteroid
    Field im:Image
    Field pixels:Int[awidth*aheight]
    Field x:Int,y:Int
    Field angle:Float=0
    Field rotspeed:Float=Rnd(-3.3,3.3)
    Method New(x:Int,y:Int)
        im = CreateImage(awidth,aheight,1,Image.MidHandle)
        Self.x = x
        Self.y = y
        Local myan:Int=0
        Local x1:Int,y1:Int
        Local x2:Int,y2:Int        
        Local sx:Int,sy:Int
        x1 = awidth/2+((Cos(myan)*Rnd(16,32)))
        y1 = aheight/2+((Sin(myan)*Rnd(16,32)))        
        sx=x1
        sy=y1
        For Local i=0 Until 10
            myan+=350/10
            x2 = awidth/2+((Cos(myan)*Rnd(16,32)))
            y2 = aheight/2+((Sin(myan)*Rnd(16,32)))
            bline(x1,y1,x2,y2)
            x1 = x2
            y1 = y2
        Next
        bline x1,y1,sx,sy
        im.WritePixels(pixels, 0, 0, awidth, aheight, 0)
    End Method
    Method update()
        angle+=rotspeed
        If angle > 359 Then angle = 0
        If angle < 0 Then angle = 359
    End Method
    Method draw()
        DrawImage im,x,y,angle,1.0,1.0,0
    End Method
    Method bline:Void(x1:Int,y1:Int,x2:Int,y2:Int)
        Local dx:Int, dy:Int, sx:Int, sy:Int, e:Int
        dx = Abs(x2 - x1)
          sx = -1
          If x1 < x2 Then sx = 1      
          dy = Abs(y2 - y1)
          sy = -1
          If y1 < y2 Then sy = 1
          If dx < dy Then 
              e = dx / 2 
          Else 
              e = dy / 2          
          End If
          Local exitloop:Bool=False
          While exitloop = False
            Local pc:Int = y1*awidth+x1
            If pc>=0 And pc <awidth*aheight
                pixels[pc] = argb(255,255,255,255)
            End If
            If x1 = x2 
                If y1 = y2
                    exitloop = True
                End If
            End If
            If dx > dy Then
                x1 += sx ; e -= dy 
                  If e < 0 Then e += dx ; y1 += sy
            Else
                y1 += sy ; e -= dx 
                If e < 0 Then e += dy ; x1 += sx
            Endif
          Wend
    End Method
    Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
        Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
    End Function        
End Class

Global myasteroids:List<asteroid> = New List<asteroid>

Class MyApp Extends App
    
    Method OnCreate()
        SetUpdateRate(60)
        Local date := GetDate()
        Seed = date[5]        
        For Local y=64 Until DeviceHeight Step 128
        For Local x=64 Until DeviceWidth Step 128
        myasteroids.AddLast(New asteroid(x,y))
        Next
        Next
    End Method
    Method OnUpdate()
        For Local i:=Eachin myasteroids
            i.update
        Next
    End Method    
    Method OnRender()
        Cls 0,0,0
        For Local i:=Eachin myasteroids
            i.draw
        Next
        SetColor 255,255,255
        DrawText "Monkey-X Class Image Asteroids example.",10,10
    End Method
    
End Class


Function Main()
    New MyApp
End Function
