' From the book '2d game collision detection'
' circle vs line segment collision

Import mojo

' This is the collision class.
'
Class collision
	' Collision function
	' the circle vs line segment collision

	Method circle_segment_collide:Bool(c:circle,s:segment)
		If (circle_point_collide(c,s.point1)) Then Return True
		If (circle_point_collide(c,s.point2)) Then Return True
		
		Local d:vector2d = subtract_vector(s.point2,s.point1)
		Local lc:vector2d = subtract_vector(c.center,s.point1)
		Local p:vector2d = project_vector(lc,d)
		Local nearest:vector2d = add_vector(s.point1,p)
		
		Return 	circle_point_collide(c,nearest) And
				vector_length(p) <= vector_length(d) And
				0 <= dot_product(p,d)	
	End Method

	' Needed for circle_segment_collide
    Method circle_point_collide:Bool(c:circle,p:vector2d)
        Local distance:vector2d = subtract_vector(c.center,p)
        Return vector_length(distance) <= c.radius
    End Method

	' Helper Functions ........
	'
	'
    Function vector_length:Float(v:vector2d)
        Return Sqrt(v.x * v.x + v.y * v.y)
    End Function

	Function project_vector:vector2d(project:vector2d, onto:vector2d)
	    ' d is a float variable that holds the dot product
	    ' of onto,onto
	    Local d:Float = dot_product(onto,onto)
	    If (0<d)
 	       ' dp is a variable that holds the dot product
 	       ' of project and onto
 	       Local dp:Float = dot_product(project, onto)
	        Return multiply_vector(onto,dp/d)
	    End If
	    Return onto
	End Function
	
	Function multiply_vector:vector2d(v:vector2d,scalar:Float)
	    Local r:vector2d = New vector2d()
	    r.x = v.x * scalar
	    r.y = v.y * scalar
	    Return r
	End Function

    Function dot_product:Float(a:vector2d,b:vector2d)
        Return a.x * b.x + a.y * b.y 
    End Function

    Function subtract_vector:vector2d(a:vector2d,b:vector2d)
        Local r:vector2d = New vector2d()
        r.x = a.x - b.x
        r.y = a.y - b.y
        Return r
    End Function

	Function add_vector:vector2d(a:vector2d,b:vector2d)
	    Local r:vector2d = New vector2d(0,0)
	    r.x = a.x + b.x
	    r.y = a.y + b.y
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

Class circle
	Field center:vector2d
	Field radius:Float
	Method New(center:vector2d,radius:Float)
		Self.center = center
		Self.radius = radius
	End Method
	Method draw()
		DrawCircle center.x,center.y,radius
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
End Class

' col is the caller of the class collision. 
' we use it to use the collision methods.
Global col:collision = New collision

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(30)
    End Method
    Method OnUpdate()  
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255

		Local cc:vector2d = New vector2d(320,200)
		Local r:Float = 50
		Local circle1:circle = New circle(cc,r)
		
        Local a:vector2d = New vector2d(MouseX,MouseY)
        Local b:vector2d = New vector2d(MouseX+100,MouseY+100)
	    Local s1:segment = New segment(a,b)

		If col.circle_segment_collide(circle1,s1)
			DrawText "Circle Line Collision",0,0
		Else
			DrawText "Circle Line NO Collision",0,0
		End If
	
		
		DrawLine a.x,a.y,b.x,b.y	
		circle1.draw
		
		DrawText "Move the Mouse to test for Collision",DeviceWidth/2,0
		
    End Method
End Class

Function Main()
    New MyGame()
End Function
	
