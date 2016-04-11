Function Main:Int()
    If rectsoverlap(10,10,10,10,12,12,10,10) = False Then
    Print("No Collision")
    Else
    Print("Collision")
    End If
    Return 0
End Function

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End
