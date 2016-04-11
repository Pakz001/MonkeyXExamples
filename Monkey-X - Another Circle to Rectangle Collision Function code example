
Import mojo

Global cx:Int=200
Global cy:Int=200
Global cr:Int=75
Global rw:Int=30
Global rh:Int=40

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    
    Method OnUpdate()
        
    End Method
    
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Move the rectangle in the circle to see collision.",0,0
        Local coll:Bool=circlerectcollide(cx,cy,cr,MouseX(),MouseY(),rw,rh)
        If coll=True
            DrawText "Collision",2,16
        End If
        DrawRect MouseX()-rw/2,MouseY()-rh/2,rw,rh
        DrawCircle cx,cy,cr
    End Method
End Class

Function circlerectcollide:Bool(cx:Int,cy:Int,cr:Int, rx:Int,ry:Int,rw:Int,rh:Int)
    Local circledistancex = Abs(cx - rx)
    Local circledistancey = Abs(cy - ry)

    If (circledistancex > (rw/2 + cr)) Then Return False
    If (circledistancey > (rh/2 + cr)) Then Return False

    If (circledistancex <= (rw/2)) Then Return True 
    If (circledistancey <= (rh/2)) Then Return True

    Local cornerdistancesq = Pow(circledistancex - rw / 2, 2) + Pow(circledistancey - rh / 2, 2)
    Return (cornerdistancesq <= Pow(cr,2))
End Function

Function Main()
    New MyGame()
End Function
