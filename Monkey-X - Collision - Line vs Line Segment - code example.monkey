
' From the book '2d game collision detection'
' line vs line segment collision

#rem
If a line collides with a segment you only need to know
if the segments end points lie on the same side 
of the line. If they do then a collision is
impossible.
#end

Import mojo

' This is the collision class.
'
Class collision
	' Collision function
	Function line_segment_collide:Bool(l:line,s:segment)
		Return Not on_one_side(l,s)
	End Function	

	'
	' helper functions
	'
    Function on_one_side:Bool(axis:line,s:segment)
        Local d1:vector2d = subtract_vector(s.point1,axis.base)
        Local d2:vector2d = subtract_vector(s.point2,axis.base)
        Local n:vector2d = rotate_vector_90(axis.direction)
        Return dot_product(n,d1) * dot_product(n,d2) > 0
    End Function

    Function subtract_vector:vector2d(a:vector2d,b:vector2d)
        Local r:vector2d = New vector2d()
        r.x = a.x - b.x
        r.y = a.y - b.y
        Return r
    End Function

    Function dot_product:Float(a:vector2d,b:vector2d)
        Return a.x * b.x + a.y * b.y 
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
    ' base is a vector which holds the origin
    ' of the line
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

Class segment
    ' point1 and point2 are two vectors.
    ' A vector has a x and y coordinate.
    Field point1:vector2d
    Field point2:vector2d
    Method New(point1:vector2d,point2:vector2d)
        Self.point1 = point1
        Self.point2 = point2
    End Method
    Method draw()
        DrawLine point1.x,point1.y,point2.x,point2.y
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
										New vector2d(MouseX,MouseY))
		Local segline1:segment = New segment(	New vector2d(100,200),
												New vector2d(400,100))

		' Here we test for collision
		If col.line_segment_collide(line1,segline1)
			DrawText "Line vs Line Segment Collision",0,0
		Else
			DrawText "Line vs Line Segment NO Collision",0,0
		End If

		line1.draw
		segline1.draw
		
		DrawText "Move the Mouse to test for Collision",DeviceWidth/2,0
		
    End Method
End Class

Function Main()
    New MyGame()
End Function
