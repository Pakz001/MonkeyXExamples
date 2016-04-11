Import mojo

Class filledballs
    Field myc:Int=0 'oval color
    Field x:Int,y:Int
    Field w:Int,h:Int
    Field im:Image
    Field pixels:Int[]
    Method New(x:Int,y:Int,w:Int,h:Int,c:Int)
        Self.x = x
        Self.y = y
        Self.w = w
        Self.h = h
        myc=c
        pixels = New Int[w*h]
        im = CreateImage(w,h,1,Image.MidHandle)
        For Local i=0 Until im.Width()*im.Height()
            pixels[i] = $00000000
        Next
        Local i2:Int=0
        For Local i=(w/2)-1 To 1 Step -1
            Local col:Int=0
            Select myc
                Case 0;col=argb(i2,i2,i2,255)
                Case 1;col=argb(i2,0,i2,255)
                Case 2;col=argb(i2,i2,0,255)
                Case 3;col=argb(i2,0,0,255)
                Case 4;col=argb(0,i2,i2,255)
                Case 5;col=argb(0,0,i2,255)
                Case 6;col=argb(0,i2,0,255)
            End Select
            drawo(w/2,w/2,i,col)
            i2+=255/(w/2)
        Next
        im.WritePixels(pixels, 0, 0, w, h, 0)
    End Method
    Method drawo(x1,y1,radius,col)
        For Local y2=-radius To radius
        For Local x2=-radius To radius
            If (y2*y2+x2*x2) <= radius*radius+radius*0.8
                Local x3 = x2+x1
                Local y3 = y2+y1
                Local pc = y3*im.Width()+x3
                If pc>=0 And pc < im.Width()*im.Height()
                    pixels[pc] = col
                End If
            End If
        Next
        Next      
    End Method
    Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
        Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
    End Function     
    Method draw()
        DrawImage im,x,y
    End Method
End Class

Global myfball:List<filledballs> = New List<filledballs>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        For Local y=0 To DeviceHeight() Step 64
        For Local x=0 To DeviceWidth() Step 64
            myfball.AddLast(New filledballs(x,y,64,64,Rnd(0,7)))
        Next
        Next
        For Local x=0 To DeviceWidth()+96 Step 96
            myfball.AddLast(New filledballs(x,100,96,96,Rnd(07)))
        Next
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        For Local i:=Eachin myfball
            i.draw
        Next
        SetColor 0,0,0
        DrawRect 0,100,DeviceWidth(),20
        SetColor 255,255,255
        DrawText "MonkeyX - Filled balls, WritePixels/CreateImage",10,105
    End Method
End Class


Function Main()
    New MyGame()
End function
