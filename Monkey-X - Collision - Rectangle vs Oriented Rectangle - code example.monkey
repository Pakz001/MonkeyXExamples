' From the book '2d game collision detection'
' rectangle vs oriented rectangle collision

Import mojo

' This is the collision class.
'
Class collision
    ' Collision function
    Function oriented_rectangle_rectangle_collide:Bool(	oor:orientedrectangle,
    													aar:rectangle)
    	Local orhull:rectangle = oriented_rectangle_rectangle_hull(oor)
    	If(Not rectangles_collide(orhull,aar)) Then Return False
    	
    	Local edge:segment = oriented_rectangle_edge(oor,0)
    	If(seperating_axis_for_rectangle(edge,aar)) Then Return False
    	
    	edge = oriented_rectangle_edge(oor,1)
    	Return Not seperating_axis_for_rectangle(edge,aar) 
	End Function
	' needed for rectangle vs oriented rectangle collision
    Function rectangles_collide:Bool(a:rectangle,b:rectangle)
        Local aleft:Float    = a.origin.x
        Local aright:Float    = aleft + a.size.x
        Local bleft:Float    = b.origin.x
        Local bright:Float    = bleft + b.size.x
        
        Local abottom:Float    = a.origin.y
        Local atop:Float    = abottom + a.size.y
        Local bbottom:Float    = b.origin.y
        Local btop:Float    = bbottom + b.size.y
        
        Return overlapping(	aleft,aright,
                            bleft,bright) And 
                            overlapping(	abottom,
                            				atop,
                                            bbottom,
                                            btop)
    End Function
    
    #rem
    ' Rectangle vs Line Segment Function
    Function rectangle_segment_collide:Bool(r:rectangle,s:segment)
        ' First we test the line vs rectangle collision
        Local sline:line = New line()
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
#end
    '
    ' helper functions
    '
    'from broken
	Function oriented_rectangle_edge:segment(r:orientedrectangle,nr:Int)

		Local edge:segment = New segment()
		Local a:vector2d = r.halfextend
		Local b:vector2d = r.halfextend
		Select (nr Mod 4)
			Case 0'top edge
				a.x = -a.x
			Case 1'right edge
				b.y = -b.y
			Case 2'bottom edge
				a.y = -a.y
				b = negate_vector(b)
			Default'left edge
				a = negate_vector(a)
				b.x = -b.x
		End Select


		a = rotate_vector(a,r.rotation)
		a = add_vector(a,r.center)
		
		b = rotate_vector(b,r.rotation)
		b = add_vector(b,r.center)
				
		edge.point1 = a
		edge.point2 = b
				
		Return edge
	End Function    
    Function range_hull:range(a:range,b:range)
		Local hull:range = New range()

		If a.minimum<b.minimum Then
			hull.minimum = a.minimum 
			Else
			hull.minimum = b.minimum
		End If
		If a.maximum > b.maximum Then
			hull.maximum = a.maximum
			Else
			hull.maximum = b.maximum
		End If

		Return hull
	End Function

	'from broken	
	Function negate_vector:vector2d(v:vector2d)
		Local n:vector2d = New vector2d()
		n.x = -v.x
		n.y = -v.y
		Return n
	End Function
	
	Function oriented_rectangle_rectangle_hull:rectangle(r:orientedrectangle)
		Local h:rectangle = New rectangle()
		h.origin = r.center
		h.size = New vector2d(0,0)
		Local nr:Int
		Local corner:vector2d
		For nr = 0 To 4
			corner = oriented_rectangle_corner(r,nr)
			h = enlarge_rectangle_point(h,corner)
		Next
		Return h
	End Function
	
	Function enlarge_rectangle_point:rectangle(r:rectangle,p:vector2d)
		Local enlarged:rectangle = New rectangle()
		enlarged.origin = New vector2d(0,0)
		enlarged.size = New vector2d(0,0)
		enlarged.origin.x = minimum(r.origin.x,p.x)
		enlarged.origin.y = minimum(r.origin.y,p.y)
		enlarged.size.x = maximum(r.origin.x + r.size.x,p.x)
		enlarged.size.y = maximum(r.origin.y + r.size.y,p.y)
		enlarged.size = subtract_vector(enlarged.size,
										enlarged.origin)
		Return enlarged
	End Function	
	
	Function oriented_rectangle_corner:vector2d(r:orientedrectangle,nr:Int)
		Local c:vector2d = r.halfextend
		Select(nr Mod 4)
			Case 0
			c.x = -c.x
			Case 1
			'c = r.halfextend
			Case 2
			c.y = -c.y
			Default
			c = negate_vector(c)			
		End Select
		c = rotate_vector(c,r.rotation)
		Return add_vector(c,r.center)
	End Function
    
    Function seperating_axis_for_rectangle:Bool(axis:segment,r:rectangle)
    	Local redgea:segment = New segment()
    	Local redgeb:segment = New segment()
    	Local axisrange:range = New range()
    	Local redgearange:range = New range()
    	Local redgebrange:range = New range()
    	Local rprojection:range = New range()
		Local n:vector2d = subtract_vector(axis.point1,axis.point2)
		
		redgea.point1 = rectangle_corner(r,0)
		redgea.point2 = rectangle_corner(r,1)
		redgeb.point1 = rectangle_corner(r,2)
		redgeb.point2 = rectangle_corner(r,3)				
    	redgearange = project_segment(redgea,n)
    	redgebrange = project_segment(redgeb,n)    
    	rprojection = range_hull(redgearange,redgebrange)
    	
    	axisrange = project_segment(axis,n)
    	
    	Return Not overlapping_ranges(axisrange,rprojection)
    End Function
 
    Function rectangle_corner:vector2d(r:rectangle,nr:Int)
    	Local corner:vector2d = r.origin
    	Select (nr Mod 4)
    		Case 0
    		corner.x += r.size.x
    		Case 1
    		corner = add_vector(corner,r.size)
    		Case 2
    		corner.y += r.size.y
    		Default
    		'corner = r.origin
    	End Select
    	Return corner
    End Function
    
    ' tested below here
    Function overlapping:Bool(mina:Float,maxa:Float,minb:Float,maxb:Float)
        Return minb <= maxa And mina <= maxb
    End Function

    Function overlapping_ranges:Bool(a:range,b:range)
        Return overlapping(    a.minimum,
                            a.maximum,
                            b.minimum,
                            b.maximum)
    End Function

    Function project_segment:range(s:segment,onto:vector2d)
        Local ontounit:vector2d = unit_vector(onto)
        Local r:range = New range()
        r.minimum = dot_product(ontounit,s.point1)
        r.maximum = dot_product(ontounit,s.point2)
        r = sort_range(r)
        Return r        
    End Function
#rem    
    Function sort_range:range(r:range)
        Local sorted:range = r
        If (r.minimum > r.maximum)
            sorted.minimum = r.maximum
            sorted.maximum = r.minimum
        End If
        Return sorted
    End Function    
#end    
#rem    
    Function rotate_vector_90:vector2d(v:vector2d)
        Local r:vector2d = New vector2d()
        r.x = -v.y
        r.y = v.x
        Return r
    End Function
#end

    Function sort_range:range(r:range)
        Local sorted:range = r
        If (r.minimum > r.maximum)
            sorted.minimum = r.maximum
            sorted.maximum = r.minimum
        End If
        Return sorted
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

    Function vector_length:Float(v:vector2d)
        Return Sqrt(v.x * v.x + v.y * v.y)
    End Function

    Function divide_vector:vector2d(v:vector2d,divisor:Float)
        Local r:vector2d = New vector2d()
        r.x = v.x / divisor
        r.y = v.y / divisor
        Return r
	End Function

    Function dot_product:Float(a:vector2d,b:vector2d)
        Return a.x * b.x + a.y * b.y 
    End Function    
   
    Function unit_vector:vector2d(v:vector2d)
        Local length:Float = vector_length(v)
        If (0 < length)
            Return divide_vector(v,length) 
        End If    
        Return v
    End Function      
       
	Function rotate_vector:vector2d(v:vector2d,degrees:Float)
	    Local r:vector2d = New vector2d()
   		r.x = v.x * Cos(degrees) - v.y * Sin(degrees)
   	 	r.y = v.x * Sin(degrees) + v.y * Cos(degrees)
    	Return r
	End Function	
	
	Function minimum:Float(a:Float,b:Float)
		If a<b Then Return a Else Return b
	End Function

	Function maximum:Float(a:Float,b:Float)
		If a>b Then Return a Else Return b
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
        
        ' this is a oriented rectangle
		
        '
        ' This is the rectangle
        Local origin:vector2d = New vector2d(320,200)
        Local size:vector2d = New vector2d(100,50)
        Local rect1:rectangle = New rectangle(origin,size)

        ' Here we set up the oriented rectangle
        Local orc:vector2d = New vector2d(MouseX,MouseY)
        Local ors:vector2d = New vector2d(100,50) 'size of the oriented rectangle
        Local orect:orientedrectangle = New orientedrectangle(orc,ors,angle)
		
        ' Here we test for collision
        If col.oriented_rectangle_rectangle_collide(orect,rect1)
            DrawText "Rectangle vs Line Segment Collision",0,0
        Else
            DrawText "Rectangle vs Line Segment NO Collision",0,0
        End If

        rect1.draw
        orect.draw
                        
        DrawText "Move the Mouse to test for Collision",DeviceWidth/2,0
        
    End Method
End Class

Function Main()
    New MyGame()
End Function
