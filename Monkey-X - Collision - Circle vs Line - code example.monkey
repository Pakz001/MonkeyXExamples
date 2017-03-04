' From the book '2d game collision detection'
' circle vs line collision

Import mojo

' This is the collision class.
'
Class collision
	' Collision function
	' the circle vs line collision

	Method circle_line_collide:Bool(c:circle,l:line)
		Local lc:vector2d = subtract_vector(c.center,l.base)
		Local p:vector2d = project_vector(lc,l.direction)
		Local nearest:vector2d = add_vector(l.base,p)
		Return circle_point_collide(c,nearest)
	End Method

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
		Local base:vector2d = New vector2d(0,0)
		Local direction:vector2d = New vector2d(MouseX,MouseY)
		Local l:line = New line(base,direction)
		
		If col.circle_line_collide(circle1,l)
			DrawText "Circle and Line Colliding",0,0
		Else
			DrawText "Circle and Line NOT Colliding",0,0
		End If
		
		circle1.draw
		l.draw
		
		DrawText "Circle vs Line Collision",DeviceWidth/2,0
		DrawText "Info : Lines are infinite in length.",DeviceWidth/2,20
		
    End Method
End Class

Function Main()
    New MyGame()
End Function
	
