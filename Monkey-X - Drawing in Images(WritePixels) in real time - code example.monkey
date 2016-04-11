Import mojo
Global blockwidth:Int=256
Global blockheight:Int=256

Class block
    Field x=640/2-blockwidth/2
    Field y=480/2-blockheight/2
    Field image:Image
    Field pixels:Int[blockwidth*blockheight]
    Method resetimage()
        For Local i:Int = 0 Until blockwidth * blockheight
            b.pixels[i] = $FFFF0000
        Next
        image.WritePixels(b.pixels, 0, 0, blockwidth, blockheight, 0)
    End Method
    Method drawr(x1,y1,w1,h1,col)
        For Local y2=y1 Until y1+h1
        For Local x2=x1 Until x1+w1
            Local pc = y2*blockwidth+x2
            If pc >= 0 And pc < blockwidth*blockheight
                pixels[pc] = col
            End If
        Next
        Next
        b.image.WritePixels(b.pixels, 0, 0, blockwidth, blockheight, 0)
    End Method 
    Method drawo(x1,y1,radius,col)
        For Local y2=-radius To radius
        For Local x2=-radius To radius
            If (y2*y2+x2*x2) <= radius*radius+radius*0.8
                Local x3 = x2+x1
                Local y3 = y2+y1
                Local pc = y3*blockwidth+x3
                If pc>=0 And pc < blockwidth*blockheight
                    pixels[pc] = col
                End If
            End If
        Next
        Next    
        b.image.WritePixels(b.pixels, 0, 0, blockwidth, blockheight, 0)
    End Method
End Class    

Global b:block = New block

Class MyGame Extends App    
    Method OnCreate:Int()
        Seed = Rnd(1000)
        SetUpdateRate(60)
        b.image = CreateImage(blockwidth, blockheight)        
        b.resetimage
    End Method
    Method OnUpdate()
        Select Int(Rnd(1,3))
            Case 1
                b.drawr Rnd(-5,blockwidth),Rnd(-5,blockheight),Rnd(5,15),Rnd(5,15),$FF000000
            Case 2
                b.drawo Rnd(-5,blockwidth),Rnd(-5,blockheight),Rnd(5,10),$FF000000
        End Select
        If Int(Rnd(0,70)) = 1 Then b.resetimage
    End Method
    Method OnRender:Int()
        Cls
        DrawImage b.image, b.x,b.y
        SetColor 255,255,255
        DrawText "Drawing in images in realtime.",0,0
    End Method    
End Class

Function Main:Int()
    New MyGame()
End Function
