' From the book '2d game collision detection'
' rectangle vs Line collision

Import mojo

' This is the collision class.
'
Class collision
	' Collision function
	' The rectangle vs Line Collision
	Function line_rectangle_collide:Bool(l:line,r:rectangle)
		Local n:vector2d = rotate_vector_90(l.direction)
		
		Local dp1:Float,dp2:Float
		Local dp3:Float,dp4:Float
		
		Local c1:vector2d = r.origin
		Local c2:vector2d = add_vector(c1,r.size)
		Local c3:vector2d = New vector2d(c2.x,c1.y)
		Local c4:vector2d = New vector2d(c1.x,c2.y)
		
		c1 = subtract_vector(c1,l.base)
		c2 = subtract_vector(c2,l.base)
		c3 = subtract_vector(c3,l.base)
		c4 = subtract_vector(c4,l.base)						
		
		dp1 = dot_product(n,c1)
		dp2 = dot_product(n,c2)
		dp3 = dot_product(n,c3)
		dp4 = dot_product(n,c4)
		
		Return 	(dp1 * dp2 <= 0) Or
				(dp2 * dp3 <= 0) Or
				(dp3 * dp4 <= 0)
	End Function

	'
	' helper functions
	'
    Function rotate_vector_90:vector2d(v:vector2d)
        Local r:vector2d = New vector2d()
        r.x = -v.y
        r.y = v.x
        Return r
    End Function

    Function add_vector:vector2d(a:vector2d,b:vector2d)
        Local r:vector2d = New vector2d(0,0)
        r.x = a.x + b.x
        r.y = a.y + b.y
        Return r
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
		
		' this is a line setup
		Local base:vector2d = New vector2d(0,0)
		Local direction:vector2d = New vector2d(MouseX,MouseY)
		Local line1:line = New line(base,direction)
		'
		' This is the rectangle
		Local origin:vector2d = New vector2d(320,200)
		Local size:vector2d = New vector2d(100,100)
		Local rect1:rectangle = New rectangle(origin,size)

		' Here we test for collision
		If col.line_rectangle_collide(line1,rect1)
			DrawText "Line vs Rectangle Collision",0,0
		Else
			DrawText "Line vs Rectangle NO Collision",0,0
		End If
		line1.draw
		rect1.draw
						
		DrawText "Move the Mouse to test for Collision",DeviceWidth/2,0
		DrawText "Info : Lines are infinite in length.",DeviceWidth/2,20
		
    End Method
End Class

Function Main()
    New MyGame()
End Function
