' From the book '2d game collision detection'
' circle vs point collision

Import mojo

' This is the collision class.
'
Class collision
	' Collision function
	' the circle vs point collision
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

		' c is a vector where we create the circle with
		Local c:vector2d = New vector2d(320,200)
		' r is a float variable that is the radius of the circle
		Local r:Float = 100
		' here we create a circle
		Local circle:circle = New circle(c,r)
		
		' draw the circle
		circle.draw
		
		' create a vector at the mouse pointer coordinates
		Local mousevector:vector2d = New vector2d(MouseX,MouseY)
		
		' test collision
		If col.circle_point_collide(circle,mousevector)
			DrawText "Point Collision with circle",0,0
		Else
			DrawText "Point NO Collision with circle",0,0
		End If
		
		DrawText "Move the mouse around to test collision",DeviceWidth/2,0
    End Method
End Class

Function Main()
    New MyGame()
End Function
	
