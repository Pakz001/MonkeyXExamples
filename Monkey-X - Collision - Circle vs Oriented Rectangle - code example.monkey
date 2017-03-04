' From the book '2d game collision detection'
' circle vs oriented rectangle collision

Import mojo

' This is the collision class.
'
Class collision
	' Collision function
	' the circle vs oriented rectangle collision
	
	Function circle_oriented_rectangle_collide:Bool(c:circle,
													r:orientedrectangle)
		Local origin:vector2d = New vector2d(0,0)
		Local size:vector2d = New vector2d(0,0)
		Local lr:rectangle = New rectangle(origin,size)
		
		lr.size = multiply_vector(r.halfextend,2)
		
		Local center:vector2d = New vector2d(0,0)		 
		Local lc:circle = New circle(center,c.radius)
		Local distance:vector2d = subtract_vector(c.center,r.center)
		distance = rotate_vector(distance,-r.rotation)
		lc.center = add_vector(distance,r.halfextend)
		
		Return circle_rectangle_collide(lc,lr)
		
	End Function
	
	' needed for circle vs oriented rectangle collision
	Function circle_rectangle_collide:Bool(c:circle,r:rectangle)
		Local clamped:vector2d = clamp_on_rectangle(c.center,r)
		Return circle_point_collide(c,clamped)
	End Function

	' Needed for circle_segment_collide
    Function circle_point_collide:Bool(c:circle,p:vector2d)
        Local distance:vector2d = subtract_vector(c.center,p)
        Return vector_length(distance) <= c.radius
    End Function

	' Helper Functions ........
	'
	'
    Function multiply_vector:vector2d(v:vector2d,scalar:Float)
        Local r:vector2d = New vector2d()
        r.x = v.x * scalar
        r.y = v.y * scalar
        Return r
    End Function

	Function clamp_on_rectangle:vector2d(p:vector2d,r:rectangle)
		Local clamp:vector2d = New vector2d()
		clamp.x = Clamp(p.x,r.origin.x,r.origin.x+r.size.x)
		clamp.y = Clamp(p.y,r.origin.y,r.origin.y+r.size.y)
		Return clamp
	End Function
	
    Function vector_length:Float(v:vector2d)
        Return Sqrt(v.x * v.x + v.y * v.y)
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

	' Here is the function that rotates a vector. It returns the
	' new rotated vector.
	'
	Function rotate_vector:vector2d(v:vector2d,degrees:Float)
	    Local r:vector2d = New vector2d()
	    r.x = v.x * Cos(degrees) - v.y * Sin(degrees)
	    r.y = v.x * Sin(degrees) + v.y * Cos(degrees)
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

Class rectangle
    ' origin is a vector that holds the x and y coordinates
    ' of the rectangle
    Field origin:vector2d
    ' size is a vector that holds the x(width) and 
    ' y(height) of the rectangle
    Field size:vector2d
    Method New(origin:vector2d,size:vector2d)
        Self.origin = origin
        Self.size = size
    End Method
    Method draw()
        ' x1,y1,w,h are used to hold the rectangle
        ' location and size.
        Local x1:Int=origin.x
        Local y1:Int=origin.y
        Local w:Int=size.x
        Local h:Int=size.y
        DrawRect x1,y1,w,h
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

Class orientedrectangle
	Field center:vector2d
	Field halfextend:vector2d

	Field rotation:Float
	Method New(center:vector2d,halfextend:vector2d,rotation:Float)
		Self.center = center
		Self.halfextend = halfextend
		Self.rotation = rotation
	End Method
	Method draw()
		Local v1:vector2d,v2:vector2d,v3:vector2d,v4:vector2d
		'topside
		v1 = New vector2d(-halfextend.x,-halfextend.y)
		v2 = New vector2d(halfextend.x,-halfextend.y)
		v1 = rotate_vector(v1,rotation)
		v2 = rotate_vector(v2,rotation)
		v1.x += center.x
		v1.y += center.y
		v2.x += center.x
		v2.y += center.y
		' rightside
		v3 = New vector2d(halfextend.x,halfextend.y)
		v3 = rotate_vector(v3,rotation)
		v3.x += center.x
		v3.y += center.y
		' bottom side
		v4 = New vector2d(-halfextend.x,halfextend.y)
		v4 = rotate_vector(v4,rotation)
		v4.x += center.x
		v4.y += center.y
		DrawLine v1.x,v1.y,v2.x,v2.y
		DrawLine v2.x,v2.y,v3.x,v3.y
		DrawLine v3.x,v3.y,v4.x,v4.y
		DrawLine v4.x,v4.y,v1.x,v1.y
	End Method	
	Function rotate_vector:vector2d(v:vector2d,degrees:Float)
	    Local r:vector2d = New vector2d()
   		r.x = v.x * Cos(degrees) - v.y * Sin(degrees)
   	 	r.y = v.x * Sin(degrees) + v.y * Cos(degrees)
    	Return r
	End Function	
End Class

' col is the caller of the class collision. 
' we use it to use the collision methods.
Global col:collision = New collision

Class MyGame Extends App
	Field angle:Float
    Method OnCreate()
        SetUpdateRate(30)
    End Method
    Method OnUpdate()
    	angle+=1
    	If angle > 360 Then angle = 0  
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
		
		' Here we set up the circle where we test
		' the collision with
		Local cc:vector2d = New vector2d(320,200)
		Local r:Float = 50
		Local circle1:circle = New circle(cc,r)
		' Here we set up the oriented rectangle
		Local orc:vector2d = New vector2d(MouseX,MouseY)
		Local ors:vector2d = New vector2d(100,50) 'size of the oriented rectangle
		Local orect:orientedrectangle = New orientedrectangle(orc,ors,angle)
		
		' Collision test
		If col.circle_oriented_rectangle_collide(circle1,orect)
			DrawText "Circle vs Oriented rect Collide",0,0
		Else
			DrawText "Circle vs Oriented rect NO Collision",0,0
		End If
		
		orect.draw
		circle1.draw
		
		DrawText "Move the Mouse to test for Collision",DeviceWidth/2,0
		
    End Method
End Class

Function Main()
    New MyGame()
End Function
	
