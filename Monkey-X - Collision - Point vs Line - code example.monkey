' Not to sure if this one works. SOmetimes it looks
' like it but most of the times it gives no collision
' respons

' From the book '2d game collision detection'
' point vs line collision

Import mojo

' This is the collision class.
'
Class collision
	' Collision function
	' Point vs line collision
	Function line_point_collide:Bool(l:line,p:vector2d)
		If points_collide(l.base,p) Then Return True
		Local lp:vector2d = subtract_vector(p,l.base)
		Return parallel_vectors(lp,l.direction)
	End Function

	' points collide needed for point vs line collision
    Function points_collide:Bool(a:vector2d,b:vector2d)
        Return a.x = b.x And a.y = b.y
    End Function
	'
	' helper functions
	'
    Function dot_product:Float(a:vector2d,b:vector2d)
        Return a.x * b.x + a.y * b.y 
    End Function

    Function subtract_vector:vector2d(a:vector2d,b:vector2d)
        Local r:vector2d = New vector2d()
        r.x = a.x - b.x
        r.y = a.y - b.y
        Return r
    End Function

    Function parallel_vectors:Bool(a:vector2d,b:vector2d)    	
        Local na:vector2d = rotate_vector_90(a)    
	    Return (equal_floats(0,dot_product(na,b)))
    End Function 
    
    Function equal_floats:Bool(a:Float,b:Float)
    	Local treshold:float = 1.0 / 8192
    	Return Abs(a-b) < treshold
    End Function
    
    Function rotate_vector_90:vector2d(v:vector2d)
        Local r:vector2d = New vector2d()
        r.x = -v.y
        r.y = v.x
        Return r
    End Function
    

End Class

Class vector2d
	' x and y hold the position of the vector
	Field x:Int,y:Int
	Method New(x:Int,y:Int)
		Self.x = x
		Self.y = y
	End Method
End Class

Class line
    Field base:vector2d
    Field direction:vector2d
    Method New(base:vector2d,direction:vector2d)
        Self.base = base
        Self.direction = direction
    End Method
    Method draw()
        DrawLine base.x,base.y,direction.x,direction.y
    End Method
End Class


' col is the caller of the class collision. 
' we use it to use the collision methods.
Global col:collision = New collision

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
    End Method
    Method OnRender()
        Cls 0,0,0
        SetColor 255,255,255

		Local line1:line = New line(	New vector2d(0,0),
										New vector2d(	DeviceWidth,
														DeviceHeight))

		Local point:vector2d = New vector2d(MouseX,MouseY)		

		' Here we test for collision
		If col.line_point_collide(line1,point)
			DrawText "Point vs Line Collision",0,0
		Else
			DrawText "Point vs Line NO Collision",0,0
		End If

		' Here we draw the line and rectangle
		line1.draw
					
		DrawText "Move the Mouse to test for Collision",DeviceWidth/2,0
		
    End Method
End Class

Function Main()
    New MyGame()
End Function
