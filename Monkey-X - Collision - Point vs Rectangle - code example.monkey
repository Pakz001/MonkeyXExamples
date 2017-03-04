' From the book '2d game collision detection'
' point vs rectangle collision

Import mojo

' This is the collision class.
'
Class collision
	' Collision function
	' The point vs rectangle Collision
	Function point_rectangle_collide:Bool(p:vector2d,r:rectangle)
		Local left:Float = r.origin.x
		Local right:Float = left + r.size.x
		Local bottom:Float = r.origin.y
		Local top:Float = bottom + r.size.y		
		Return 	left <= p.x And
				bottom <= p.y And
				p.x <= right And
				p.y <= top	
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
		
		' this is a point(vector) with the mouse coordinates
		Local point:vector2d = New vector2d(MouseX,MouseY)
		'
		' This is the rectangle
		Local origin:vector2d = New vector2d(320,200)
		Local size:vector2d = New vector2d(100,100)
		Local rect1:rectangle = New rectangle(origin,size)

		' Here we test for collision
		If col.point_rectangle_collide(point,rect1)
			DrawText "Point vs Rectangle Collision",0,0
		Else
			DrawText "Point vs Rectangle NO Collision",0,0
		End If
		
		rect1.draw
						
		DrawText "Move the Mouse to test for Collision",DeviceWidth/2,0
		
    End Method
End Class

Function Main()
    New MyGame()
End Function
