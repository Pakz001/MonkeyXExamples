
' From the book '2d game collision detection'
' line vs oriented rectangle collision


Import mojo

' This is the collision class.
'
Class collision
	' Collision function
	' Here the line vs oriented rectangle collision 
	Function line_oriented_rectangle_collide:Bool(	l:line,
													r:orientedrectangle)
		Local lr:rectangle
		lr = New rectangle(	New vector2d(0,0),	
							multiply_vector(r.halfextend,2))
		
		Local l1:line = New line(	New vector2d(0,0),
									New vector2d(0,0))
		l1.base = subtract_vector(l.base,r.center)
		l1.base = rotate_vector(l1.base,-r.rotation)
		l1.base = add_vector(l1.base,r.halfextend)
		l1.direction = rotate_vector(l.direction,-r.rotation)
		
		Return line_rectangle_collide(l1,lr)
	End Function
    ' The rectangle vs Line Collision
    ' needed for line vs oriented rectangle collion
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
        
        Return     (dp1 * dp2 <= 0) Or
                (dp2 * dp3 <= 0) Or
                (dp3 * dp4 <= 0)
    End Function	
	'
	' helper functions
	'

    Function dot_product:Float(a:vector2d,b:vector2d)
        Return a.x * b.x + a.y * b.y 
    End Function  
    	
    Function rotate_vector_90:vector2d(v:vector2d)
        Local r:vector2d = New vector2d()
        r.x = -v.y
        r.y = v.x
        Return r
    End Function
    	
    Function multiply_vector:vector2d(v:vector2d,scalar:Float)
        Local r:vector2d = New vector2d()
        r.x = v.x * scalar
        r.y = v.y * scalar
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
	Field angle:Float=0
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
    	angle+=1
    	If angle > 360 Then angle=0
    End Method
    Method OnRender()
        Cls 0,0,0
        SetColor 255,255,255

		'set up the line
		Local line1:line = New line(	New vector2d(0,0),
										New vector2d(MouseX,MouseY))
		'set up the oriented rectangle (base, halfextend(size),angle)
		Local orect1:orientedrectangle
		orect1 = New orientedrectangle(	New vector2d(320,200),
										New vector2d(100,50),
										angle)

		' Here we test for collision
		If col.line_oriented_rectangle_collide(line1,orect1)
			DrawText "Line vs Oriented Rectangle Collision",0,0
		Else
			DrawText "Line vs Oriented Rectangle NO Collision",0,0
		End If

		' Here we draw the line and oriented
		' rectangle.
		line1.draw
		orect1.draw
		
		DrawText "Move the Mouse to test for Collision",DeviceWidth/2,0
		
    End Method
End Class

Function Main()
    New MyGame()
End Function
