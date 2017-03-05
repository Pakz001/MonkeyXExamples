''''''''Currently Not working correctly !!!!!!!!!!!!!!!!!!


' From the book '2d game collision detection'
' line vs oriented rectangle collision


Import mojo

' This is the collision class.
'
Class collision
	' Collision function

	Function oriented_rectangle_segment_collide:Bool(	r:orientedrectangle,
														s:segment)
		Local lr:rectangle
		lr = New rectangle(	New vector2d(0,0),
							multiply_vector(r.halfextend,2))
		
		Local ls:segment = New segment(	New vector2d(0,0),																					
										New vector2d(0,0))
		ls.point1 = subtract_vector(s.point1,r.center)
		ls.point1 = rotate_vector(ls.point1,-r.rotation)
		ls.point1 = add_vector(ls.point1,r.halfextend)
		ls.point2 = subtract_vector(s.point2,r.center)
		ls.point2 = rotate_vector(ls.point2,-r.rotation)
		ls.point2 = add_vector(ls.point2,r.halfextend)
		
		Return rectangle_segment_collide(lr,ls)
	End Function											
	
    ' Rectangle vs Line Segment Function
    ' needed for oriented rectangle segment collide
    Function rectangle_segment_collide:Bool(r:rectangle,s:segment)
        ' First we test the line vs rectangle collision
        Local sline:line
        sline = New line(New vector2d(0,0),New vector2d(0,0))
        sline.base = s.point1
        sline.direction = subtract_vector(    s.point2,
                                            s.point1)        
        If (Not line_rectangle_collide(sline,r)) Then
            Return False
        End If
        
        ' Here we test the ranges of the line
        ' with the rectangle
        
        Local rrange:range = New range()
        Local srange:range = New range()
        rrange.minimum = r.origin.x
        rrange.maximum = r.origin.x + r.size.x
        srange.minimum = s.point1.x
        srange.maximum = s.point2.x
        srange = sort_range(srange)
        If(Not overlapping_ranges(rrange,srange)) Then
            Return False
        End If

        rrange.minimum = r.origin.y
        rrange.maximum = r.origin.y + r.size.y
        srange.minimum = s.point1.y
        srange.maximum = s.point2.y
        srange = sort_range(srange)
        Return overlapping_ranges(rrange,srange)
                
    End Function
    
    ' The rectangle vs Line Collision
    ' needed for rectangle vs line segment
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

#rem
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
#end
	'
	' helper functions
	'
    Function rotate_vector_90:vector2d(v:vector2d)
        Local r:vector2d = New vector2d()
        r.x = -v.y
        r.y = v.x
        Return r
    End Function
    	
    Function overlapping_ranges:Bool(a:range,b:range)
        Return overlapping(    a.minimum,
                            a.maximum,
                            b.minimum,
                            b.maximum)
    End Function

    Function overlapping:Bool(mina:Float,maxa:Float,minb:Float,maxb:Float)
        Return minb <= maxa And mina <= maxb
    End Function  
    	
    Function sort_range:range(r:range)
        Local sorted:range = r
        If (r.minimum > r.maximum)
            sorted.minimum = r.maximum
            sorted.maximum = r.minimum
        End If
        Return sorted
    End Function  
    
    Function dot_product:Float(a:vector2d,b:vector2d)
        Return a.x * b.x + a.y * b.y 
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

Class range
    Field minimum:Float
    Field maximum:Float
    Method New(minimum:Float,maximum:Float)
        Self.minimum = minimum
        Self.maximum = maximum
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

		'set up the line segment
		Local seg1:segment 
		seg1 = New segment(	New vector2d(MouseX,MouseY),
								New vector2d(MouseX+100,MouseY+100))
		'set up the oriented rectangle (base, halfextend(size),angle)
		Local orect1:orientedrectangle
		orect1 = New orientedrectangle(	New vector2d(320,200),
										New vector2d(100,50),
										angle)

		' Here we test for collision
		If col.oriented_rectangle_segment_collide(orect1,seg1)
			DrawText "Line Segment vs Oriented Rectangle Collision",0,0
		Else
			DrawText "Line Segment vs Oriented Rectangle NO Collision",0,0
		End If

		seg1.draw
		orect1.draw

		
		DrawText "Move the Mouse to test for Collision",DeviceWidth/2,20
		
    End Method
End Class

Function Main()
    New MyGame()
End Function
