' From the book '2d game collision detection'
' Line Segment vs Line Segment Collision

Import mojo

' This is the collision class. In this example with
' the line segment vs line segment.
'
'
Class collision
	' Collision function
	Function segments_collide:Bool(a:segment,b:segment)
		Local axisa:line = New line()
		Local axisb:line = New line()
		axisa.base = a.point1
		axisa.direction = subtract_vector(a.point2,a.point1)
		If (on_one_side(axisa,b)) Then Return False
		axisb.base = b.point1
		axisb.direction = subtract_vector(b.point2,b.point1)
		If (on_one_side(axisb,a)) Then Return False
		If (parallel_vectors(axisa.direction,axisb.direction))
			Local rangea:range = project_segment(a,axisa.direction)
			Local rangeb:range = project_segment(b,axisa.direction)
			Return overlapping_ranges(rangea,rangeb)
		Else
			Return true
		End If
	End Function
	' Helper Functions ........
	',
	'
	Function on_one_side:Bool(axis:line,s:segment)
		Local d1:vector2d = subtract_vector(s.point1,axis.base)
		Local d2:vector2d = subtract_vector(s.point2,axis.base)
		Local n:vector2d = rotate_vector_90(axis.direction)
		Return dot_product(n,d1) * dot_product(n,d2) > 0
	End Function

	Function sort_range:range(r:range)
		Local sorted:range = r
		If (r.minimum > r.maximum)
			sorted.minimum = r.maximum
			sorted.maximum = r.minimum
		End If
		Return sorted
	End Function
	
	Function project_segment:range(s:segment,onto:vector2d)
		Local ontounit:vector2d = unit_vector(onto)
		Local r:range = New range()
		r.minimum = dot_product(ontounit,s.point1)
		r.maximum = dot_product(ontounit,s.point2)
		r = sort_range(r)
		Return r		
	End Function

	Function overlapping_ranges:Bool(a:range,b:range)
		Return overlapping(	a.minimum,
							a.maximum,
							b.minimum,
							b.maximum)
	End Function
		
	Function overlapping:Bool(mina:Float,maxa:Float,minb:Float,maxb:Float)
		Return minb <= maxa And mina <= maxb
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

	Function rotate_vector_90:vector2d(v:vector2d)
		Local r:vector2d = New vector2d()
		r.x = -v.y
		r.y = v.x
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
	
	Function parallel_vectors:Bool(a:vector2d,b:vector2d)
		Local na:vector2d = rotate_vector_90(a)	
		Return (0 = Floor(dot_product(na,b)))
	End Function	

	Function divide_vector:vector2d(v:vector2d,divisor:Float)
		Local r:vector2d = New vector2d()
		r.x = v.x / divisor
		r.y = v.y / divisor
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
	Field point1:vector2d
	Field point2:vector2d
	Method New(point1:vector2d,point2:vector2d)
		Self.point1 = point1
		Self.point2 = point2
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
		Local a:vector2d = New vector2d(10,10)
		Local b:vector2d = New vector2d(320,200)
		Local c:vector2d = New vector2d(MouseX,MouseY)
		Local d:vector2d = New vector2d(MouseX+100,MouseY+100)
		
		' segments are two vectors. point1 x and y 
		' and point2 x and y
		'
		Local s1:segment = New segment(a,b)
		Local s2:segment = New segment(c,d)		
		
		If col.segments_collide(s1,s2)
			DrawText "Collision",0,0
			Else
			DrawText "No Collision",0,0
		End If
		
		
		DrawLine a.x,a.y,b.x,b.y
		DrawLine c.x,c.y,d.x,d.y
    End Method
End Class

Function Main()
    New MyGame()
End Function
	
