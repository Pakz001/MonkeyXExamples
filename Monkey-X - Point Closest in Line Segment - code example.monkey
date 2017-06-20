' Example on how to get the closest point in a line segment
' to another point.
'
'

Import mojo

Class point
	Field x:Float
	Field y:Float
	Method New(x:Float,y:Float)
		Self.x = x
		Self.y = y
	End Method
End Class

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(30)        
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255        
        DrawText "Mouse the mouse around to see the closest point",0,0
        DrawText "of the line segment..",0,20
        Local mypoint:point = New point(0,0)
        ' the mouse location for point x and y closest to line point
        Local cx:Float=MouseX(),cy:Float=MouseY()
        ' line coordinates
        Local lx1:Float=100
        Local ly1:Float=100
        Local lx2:Float=200
        Local ly2:Float=200
        ' draw the line
        SetColor 100,100,100
        DrawLine lx1,ly1,lx2,ly2
        ' get the closest point on the line segment
        mypoint = getclosestpointonsegment(lx1,ly1,lx2,ly2,cx,cy)
        ' draw this point
       	SetColor 255,255,0
       	DrawCircle mypoint.x,mypoint.y,10

    End Method
End Class

Function getclosestpointonsegment:point(sx1:Int, sy1:Int, sx2:Int, sy2:Int, px:Int, py:Int)
	Local xDelta:Float = sx2 - sx1
	Local yDelta:Float = sy2 - sy1
	Local u:Float

	If ((xDelta = 0) And (yDelta = 0))    
      Error("Segment start equals segment end")
    End If

    u = ((px - sx1) * xDelta + (py - sy1) * yDelta) / (xDelta * xDelta + yDelta * yDelta)

   	Local closestPoint:point = New point(0,0)
    If (u < 0)
      closestPoint = New point(sx1, sy1)
    Else If (u > 1)
      closestPoint = New point(sx2, sy2)
    Else
      closestPoint = New point(Int(Floor(sx1 + u * xDelta)), Int(Floor(sy1 + u * yDelta)))
	End If
	
    Return closestPoint
End Function


Function Main()
    New MyGame()
End Function
