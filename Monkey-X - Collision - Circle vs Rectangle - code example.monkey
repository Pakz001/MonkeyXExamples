' From the book '2d game collision detection'
' circle vs rectangle collision

Import mojo

' This is the collision class.
'
Class collision
	' Collision function
	' the circle vs rectangle segment collision
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
		
		' Here we set up the circle where we test
		' the collision with
		Local cc:vector2d = New vector2d(320,200)
		Local r:Float = 50
		Local circle1:circle = New circle(cc,r)
		' Here we set up the rectangle where we test
		' the collision with
		Local origin:vector2d = New vector2d(MouseX,MouseY)
		Local size:vector2d = New vector2d(100,100)
		Local rect1:rectangle = New rectangle(origin,size)
		
		' Here we call the collision function
		If col.circle_rectangle_collide(circle1,rect1)
			DrawText "Circle Rectangle Colliding",0,0
		Else
			DrawText "Circle Rectangle NOT Colliding",0,0
		End If
		
		' Draw the circle and rectangle
		circle1.draw
		rect1.draw
		
		DrawText "Move the Mouse to test for Collision",DeviceWidth/2,0
		
    End Method
End Class

Function Main()
    New MyGame()
End Function
	
