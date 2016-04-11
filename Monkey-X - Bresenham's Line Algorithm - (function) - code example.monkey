Import mojo

Class MyApp Extends App
    
    Method OnCreate()
        SetUpdateRate(60)
        Local date := GetDate()
        Seed = date[5]        
    End Method
    Method OnUpdate()
    End Method    
    Method OnRender()
        Cls 0,0,0
        SetColor 255,255,255
        DrawText "Monkey-X Bresenham's line algorithm - function.",10,10
        For Local i=0 Until 32
            bline Rnd(0,640),Rnd(0,480),Rnd(0,640),Rnd(0,480)
        Next
    End Method
    
End Class

Function bline:Void(x1:Int,y1:Int,x2:Int,y2:Int)
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
        SetColor 255,255,255
        DrawPoint x1,y1
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
End Function

Function Main()
    New MyApp
End Function
