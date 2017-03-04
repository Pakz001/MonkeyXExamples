'  From the book '2d game collision detection'

Import mojo

' This is the collision class. In this example with
' the circles collide method.
'
'
Class collision
	Method circles_collide:Bool(a:circle,b:circle)
		Local radiussum:Float = a.radius+b.radius
		Local distance:vector2d = subtract_vector(a.center,b.center)
		Return vector_length(distance) <= radiussum
	End Method
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
	' Center is a vector that holds the center of a circle.
	Field center:vector2d
	' Radius is a float variable that holds the distance from
	' the center of the circle to the edge.
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
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
		'
		Local center1:vector2d = New vector2d(320,200)
		Local radius1:Float = 50
		Local c1:circle = New circle(center1,radius1)
		'
		Local center2:vector2d = New vector2d(MouseX(),MouseY())
		Local radius2:Float = 50
		Local c2:circle = New circle(center2,radius2)
		
		If col.circles_collide(c1,c2)
			DrawText "Circles Collision - Collision",0,0
		Else
			DrawText "Circles Collision - No Collision",0,0
		End If
		
		DrawText "Move the Mouse to see if collision occurs",DeviceWidth/2,0
		
		DrawText "Two Circles intersect when the distance between",0,DeviceHeight-60
		DrawText "their centers is less then the sum of their radii.",0,DeviceHeight-40
		
		c1.draw
		c2.draw
    End Method
End Class

Function subtract_vector:vector2d(a:vector2d,b:vector2d)
	Local r:vector2d = New vector2d()
	r.x = a.x - b.x
	r.y = a.y - b.y
	Return r
End Function

Function vector_length:Float(v:vector2d)
	Return Sqrt(v.x * v.x + v.y * v.y)
End Function

Function Main()
    New MyGame()
End Function
	
