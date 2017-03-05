
' From the book '2d game collision detection'
' point vs oriented rectangle collision

Import mojo

' This is the collision class.
'
Class collision
	' Collision function
	' The point vs oriented rectangle collision
	Function oriented_rectangle_point_collide:Bool(	r:orientedrectangle,
													p:vector2d)
		Local lr:rectangle
		lr = New rectangle(	New vector2d(0,0),
							multiply_vector(r.halfextend,2))		
		Local lp:vector2d = subtract_vector(p,r.center)
		lp = rotate_vector(lp,-r.rotation)
		lp = add_vector(lp,r.halfextend)
		
		Return point_rectangle_collide(lp,lr) 
	End Function													

    ' The point vs rectangle Collision
    ' needed for point in oriented rectangle collision
    Function point_rectangle_collide:Bool(p:vector2d,r:rectangle)
        Local left:Float = r.origin.x
        Local right:Float = left + r.size.x
        Local bottom:Float = r.origin.y
        Local top:Float = bottom + r.size.y        
        Return     left <= p.x And
                bottom <= p.y And
                p.x <= right And
                p.y <= top    
    End Function
	'
	' helper functions
	'
    Function multiply_vector:vector2d(v:vector2d,scalar:Float)
        Local r:vector2d = New vector2d()
        r.x = v.x * scalar
        r.y = v.y * scalar
        Return r
    End Function

    Function subtract_vector:vector2d(a:vector2d,b:vector2d)
        Local r:vector2d = New vector2d()
        r.x = a.x - b.x
        r.y = a.y - b.y
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
	' This variable we use to rotate
	' the oriented rectangle.
	Field angle:Float=0
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
    	angle+=1
    	If angle>359 Then angle = 0
    End Method
    Method OnRender()
        Cls 0,0,0
        SetColor 255,255,255

		Local center:vector2d = New vector2d(320,200)
		Local halfdivide:vector2d = New vector2d(100,50)
		Local orect1:orientedrectangle = New orientedrectangle(	center,
																halfdivide,
																angle)
	
		' Here we create a vector with the mouse it's coordinates.
		' We use this point to test collsion with the orect.
		Local point:vector2d = New vector2d(MouseX,MouseY)		

		' Here we test for collision
		If col.oriented_rectangle_point_collide(	orect1,
													point)
			DrawText "Point vs Oriented Rect Collision",0,0
		Else
			DrawText "Point vs Oriented Rect NO Collision",0,0
		End If
					
		orect1.draw
	
		DrawText "Move the Mouse to test for Collision",DeviceWidth/2,0
		
    End Method
End Class

Function Main()
    New MyGame()
End Function
