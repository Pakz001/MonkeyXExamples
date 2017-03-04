' From the book '2d game collision detection'
' Line vs Line Collision

Import mojo

' This is the collision class. In this example with
' the point vs point method.
'
'
Class collision
	' Collision function
	Method lines_collide:Bool(a:line,b:line)
		If (parallel_vectors(a.direction,b.direction))
			Return equivalent_lines(a,b)
		Else
			Return True
		End If
	End Method
	' Helper Functions ........
	'
	'
	Function subtract_vector:vector2d(a:vector2d,b:vector2d)
		Local r:vector2d = New vector2d()
		r.x = a.x - b.x
		r.y = a.y - b.y
		Return r
	End Function

	Function equivalent_lines:Bool(a:line,b:line)
		If (Not parallel_vectors(a.direction,b.direction)) Then Return False
		Local d:vector2d = subtract_vector(a.base,b.base)
		Return parallel_vectors(d,a.direction)
	End Function

	Function equal_vectors:Bool(a:vector2d,b:vector2d)
		Return a.x-b.x = 0 And a.y-b.y = 0
	End Function

	Function parallel_vectors:Bool(a:vector2d,b:vector2d)
		Local na:vector2d = rotate_vector_90(a)	
		Return (0 = Floor(dot_product(na,b)))
	End Function

	Function rotate_vector_90:vector2d(v:vector2d)
		Local r:vector2d = New vector2d()
		r.x = -v.y
		r.y = v.x
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
		' a,b and c are variables that are turned into vectors
		' using the vector2d class
		Local a:vector2d = New vector2d(30,50)
		Local b:vector2d = New vector2d(30,20)
		Local c:vector2d = New vector2d(80,40)
		Local down:vector2d = New vector2d(50,-10)
		Local up:vector2d = New vector2d(50,20)
		Local l1:line = New line(a,down)
		Local l2:line = New line(a,up)
		Local l3:line = New line(b,up)
		Local l4:line = New line(c,down)

		If col.lines_collide(l1,l2)
			DrawText "Lines 1 and 2 Collide",0,0
			Else
			DrawText "Lines 1 and 2 do not Collide",0,0	
		End If
		If col.lines_collide(l1,l3)
			DrawText "Lines 1 and 3 Collide",0,20
			Else
			DrawText "Lines 1 and 3 do not Collide",0,20
		End If
		If col.lines_collide(l2,l3)
			DrawText "Lines 2 and 3 Collide",0,40
			Else
			DrawText "Lines 2 and 3 do not Collide",0,40
		End If
		If col.lines_collide(l1,l4)
			DrawText "Lines 1 and 4 Collide",0,60
			Else
			DrawText "Lines 1 and 4 do not Collide",0,60
		End If
		'
		DrawText "Line 1 base = "+l1.base.x+","+l1.base.y,100,100
		DrawText "Line 1 direction = "+l1.direction.x+","+l1.direction.y,320,100
		DrawText "Line 2 base = "+l2.base.x+","+l2.base.y,100,120
		DrawText "Line 2 direction = "+l2.direction.x+","+l2.direction.y,320,120
		DrawText "Line 3 base = "+l3.base.x+","+l3.base.y,100,140
		DrawText "Line 3 direction = "+l3.direction.x+","+l3.direction.y,320,140
		DrawText "Line 4 base = "+l4.base.x+","+l4.base.y,100,160
		DrawText "Line 4 direction = "+l4.direction.x+","+l4.direction.y,320,160
		
		'
		DrawText "Line vs Line Collision",DeviceWidth/2,0
		DrawText "Info : Lines are infinite in length",DeviceWidth/2,20
		DrawText "in every direction...",DeviceWidth/2,40
		'					
    End Method
End Class

Function Main()
    New MyGame()
End Function
	
