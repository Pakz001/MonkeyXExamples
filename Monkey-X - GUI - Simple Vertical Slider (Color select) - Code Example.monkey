Import mojo

Class vslider
    Field x:Int,y:Int
    Field w:Int,h:Int
    Field slidey:Float
    Field low:Float,heigh:Float
    Field name:String
    Method New(x:Int,y:Int,w:Int,h:Int,low:Int,heigh:Int,slidey:Int,name:String)
        Self.x = x
        Self.y = y
        Self.w = w
        Self.h = h
        Self.low = low
        Self.heigh = heigh
        Self.slidey = slidey
        Self.name = name
    End Method
    Method update()
        If MouseDown(MOUSE_LEFT)
            If rectsoverlap(    MouseX(),
                                MouseY(),
                                1,
                                1,
                                x+5,y+25,
                                w/2,h-50)
                Local val:Float
                val = MouseY()-(y+25)
                slidey = val*((heigh-low)/(h-50))
                slidey+=low
            End If        
        End If
        If MouseHit(MOUSE_LEFT)
            If rectsoverlap(    MouseX(),
                                MouseY(),
                                1,1,
                                x+5,y+5,
                                w/2,20)
                If slidey>low Then slidey-=1
                Return
            End If
            If rectsoverlap(    MouseX(),
                                MouseY(),
                                1,1,
                                x+5,y+h-25,
                                w/2,20)
                If slidey<heigh Then slidey+=1
                Return
            End If
        End If
        slidey=Floor(slidey)
    End Method
    Method draw()
        SetColor 0,0,0
        DrawRect x,y,w,h
        SetColor 150,150,150
        DrawRect x+1,y+1,w-2,h-2
        SetColor 255,255,255
        DrawLine x+1,y+1,x+w-1,y+1
        DrawLine x+1,y+1,x+1,y+h-1
        SetColor 50,50,50
        DrawRect x+5,y+25,w-10,h-50
        SetColor 0,0,0
        Local val:Float
        val = (slidey-low)*((h-70)/(heigh-low))
        DrawRect x+5,y+25+val,w/2,20
        SetColor 255,255,255
        DrawText name,x+w/2,y-16,0.5
    End Method
    Method rectsoverlap:Bool(    x1:Int, y1:Int, w1:Int, 
                                h1:Int, x2:Int, y2:Int, 
                                w2:Int, h2:Int)
        If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
        If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
        Return True
    End Method 
End Class

Global sr:vslider
Global sg:vslider
Global sb:vslider

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        sr = New vslider(100,100,20,150,0,225,50,"R")
        sg = New vslider(148,100,20,150,0,255,50,"G")
        sb = New vslider(192,100,20,150,0,255,50,"B")
    End Method
    Method OnUpdate()        
        sr.update
        sg.update
        sb.update
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "MonkeyX - GUI - Simple Vertical Sliders - Code Example.",10,10
        DrawText "Use the Mouse with the Sliders to change color of rect.",10,30         
        sr.draw
        sg.draw
        sb.draw
        SetColor 255,255,255
        DrawRect 320,100,100,100
        SetColor sr.slidey,sg.slidey,sb.slidey
        DrawRect 320+1,100+1,100-2,100-2
    End Method
End Class


Function Main()
    New MyGame()
End Function
