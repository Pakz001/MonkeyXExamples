' Currently not working!!!!!!!!!!!!!!!!!!!!!!!!!!!!
'

' From the book '2d game collision detection'
' Oriented rectangle vs Oriented rectangle Collision

Import mojo

' This is the collision class. In this example with
' the oriented rectangle vs oriented rectangle collision.
'
'
Class collision
	' Collision function
	' This is the oriented rectangles collision function

	Function oriented_rectangles_collide:Bool(	a:orientedrectangle,
												b:orientedrectangle)
		Local edge:segment		
		edge = oriented_rectangle_edge(a,0)
		If (separating_axis_for_oriented_rectangle(edge,b))
			Return False
		End If
		edge = oriented_rectangle_edge(a,1)
		If (separating_axis_for_oriented_rectangle(edge,b))
			Return False
		End If
		edge = oriented_rectangle_edge(b,0)
		If (separating_axis_for_oriented_rectangle(edge,a))
			Return False
		End If
		edge = oriented_rectangle_edge(b,1)
		Return Not separating_axis_for_oriented_rectangle(edge,a)
	End Function

	' Helper Functions ........
	'
	'
		
	Function separating_axis_for_oriented_rectangle:Bool(	axis:segment,
															r:orientedrectangle)

		Local axisrange:range,r0range:range
		Local r2range:range,rprojection:range
		Local redge0:segment = oriented_rectangle_edge(r,0)
		Local redge2:segment = oriented_rectangle_edge(r,2)
		
		Local n:vector2d = subtract_vector(axis.point1,axis.point2)

		axisrange = project_segment(axis,n)
		r0range = project_segment(redge0,n)
		r2range = project_segment(redge2,n)
		rprojection = range_hull(r0range,r2range)
				
		Return Not overlapping_ranges(axisrange,rprojection)		
	End Function
	
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

		Print "cnt:"+nr+","+a.x+","+b.x

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
'		Print b.minimum+","+b.maximum
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
	'	Print hull.minimum+","+hull.maximum

		Return hull
	End Function

    Function project_segment:range(s:segment,onto:vector2d)
        Local ontounit:vector2d = unit_vector(onto)
        Local r:range = New range()
        r.minimum = dot_product(ontounit,s.point1)
        r.maximum = dot_product(ontounit,s.point2)
        r = sort_range(r)
        Return r        
    End Function
	
	Function negate_vector:vector2d(v:vector2d)
		Local n:vector2d = New vector2d()
		n.x = -v.x
		n.y = -v.y
		Return n
	End Function
	
	Function rotate_vector:vector2d(v:vector2d,degrees:Float)
	    Local r:vector2d = New vector2d()
   		r.x = v.x * Cos(degrees) - v.y * Sin(degrees)
   	 	r.y = v.x * Sin(degrees) + v.y * Cos(degrees)
    	Return r
	End Function	
	
	Function add_vector:vector2d(a:vector2d,b:vector2d)
	    Local r:vector2d = New vector2d()
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

    Function unit_vector:vector2d(v:vector2d)
        Local length:Float = vector_length(v)
        If (0 < length)
            Return divide_vector(v,length) 
        End If    
        Return v
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

    Function sort_range:range(r:range)
        Local sorted:range = r
        If (r.minimum > r.maximum)
            sorted.minimum = r.maximum
            sorted.maximum = r.minimum
        End If
        Return sorted
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
	Field angle1:Float=0
	Field angle2:Float=0
    Method OnCreate()
        SetUpdateRate(2)
    End Method
    Method OnUpdate()  
    	angle1+=1
    	angle2+=1
    	If angle1>360 Then angle1=0
    	If angle2>360 Then angle2=0      
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
		' Create the first oriented rectangle
		Local center1:vector2d = New vector2d(320,200)
		Local halfextend1:vector2d = New vector2d(100,50)
		Local orect1:orientedrectangle
		orect1 = New orientedrectangle(center1,halfextend1,0)					
		' Create the second oriented rectangle
		Local center2:vector2d = New vector2d(MouseX,MouseY)
		Local halfextend2:vector2d = New vector2d(25,75)
		Local orect2:orientedrectangle
		orect2 = New orientedrectangle(center2,halfextend2,0)
		' Draw the oriented rectangles
		orect1.draw
		orect2.draw
		'
		If col.oriented_rectangles_collide(orect1,orect2)
			DrawText "Oriented Rects Collide",0,0
		Else
			DrawText "Oriented Rects No Collision",0,0
		End If
		'
    End Method
End Class

Function Main()
    New MyGame()
End Function
	
