'
' Circle Line Segment Collision 
'
Import mojo

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(30)        
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255        
        ' the mouse location for circle to line collision
        Local cx:Float=MouseX(),cy:Float=MouseY()
        Local cr:Int=20 'circle radius
        'draw the circle
        DrawCircle cx,cy,cr
        ' line coordinates
        Local l1:Int[]=[100,100,200,200] ' line x1,y1,x2,y2
        Local l2:Int[]=[250,100,290,300]
        ' draw the lines
        SetColor 100,100,100
    	DrawLine l1[0],l1[1],l1[2],l1[3] 'x1,y1,x2,y2
    	DrawLine l2[0],l2[1],l2[2],l2[3] ',,
 	
 		' check the collisions
 		If circlelinecollide(l1[0],l1[1],l1[2],l1[3],cx,cy,cr)
 			DrawText "Collide line 1",0,20
 		Else
 			DrawText "No Collide line 1",0,20
 		End If
 		If circlelinecollide(l2[0],l2[1],l2[2],l2[3],cx,cy,cr)
 			DrawText "Collide line 2",0,40
 		Else
 			DrawText "No Collide line 2",0,40
 		End If
 		
    End Method
End Class

'
' Line(segment) to Circle Collision
'
Function circlelinecollide:Bool(sx1:Int, sy1:Int, sx2:Int, sy2:Int, cx:Int, cy:Int,cr:Float)
    Local xDelta:Float = sx2 - sx1
    Local yDelta:Float = sy2 - sy1
    Local px:Int,py:Int
    Local u:Float

    If ((xDelta = 0) And (yDelta = 0))    
      Error("Segment start equals segment end")
    End If

    u = ((cx - sx1) * xDelta + (cy - sy1) * yDelta) / (xDelta * xDelta + yDelta * yDelta)

    If (u < 0)
     	px = sx1
      	py = sy1
    Else If (u > 1)
    	px = sx2
    	py = sy2
    Else
    	px = Int(Floor(sx1 + u * xDelta))
    	py = Int(Floor(sy1 + u * yDelta))
    End If
	' If the distance of the circle to the closest point in the line
	' is less then the radius then there is a collision
	Local d:Int= Sqrt( Pow(px - cx,2) + Pow(py - cy,2))
	If d<=(cr) Then Return True
	Return False
End Function


Function Main()
    New MyGame()
End Function
