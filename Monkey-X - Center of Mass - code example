Import mojo

'center of mass variables
Global cmx:Int=0
Global cmy:Int=0

'counter to redraw
Global redrawcounter:Int=Millisecs()+4000

Class agents
    Field x:Float, y:Float
    Method New(x:Float,y:Float)
        Self.x = x
        Self.y = y        
    End Method
    Method draw()
        SetColor 255,255,255
        DrawOval x,y,16,16
    End Method
End Class

Global a:List<agents> = New List<agents>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        For Local i=0 Until 10
            Local x1:Int=Rnd(0,100)+320-50
            Local y1:Int=Rnd(0,50)+240-25
            a.AddLast(New agents(x1,y1))
        Next
        setcenterofmass()
    End Method
    Method OnUpdate()     
        If redrawcounter < Millisecs() 
            redrawcounter = Millisecs() + 4000
            a.Clear()
            For Local i=0 Until 10
                Local x1:Int=Rnd(0,100)+320-50
                Local y1:Int=Rnd(0,50)+240-25
                a.AddLast(New agents(x1,y1))
            Next
            setcenterofmass()
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        For Local i:=Eachin a
            i.draw
        Next
        SetColor 255,255,0
        DrawOval cmx,cmy,32,32
        SetColor 255,255,255
        DrawText "Center of mass",cmx+16,cmy+16,0.5,0.5
        SetColor 255,255,255
        DrawText "Center of mass example.",0,0
    End Method
End Class

Function setcenterofmass:Void()
    Local cnt:Int=0
    Local x:Int=0,y:Int=0
    For Local i:=Eachin a
        x+=i.x
        y+=i.y
        cnt+=1
    Next
    cmx = x/cnt
    cmy = y/cnt
End Function

Function Main()
    New MyGame()
End Function
