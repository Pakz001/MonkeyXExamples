'  From the book '2d game collision detection'

Import mojo

' This is the collision class. In this example with
' the rectangles collide method.
'
'
Class collision
	Method overlapping:Bool(mina:Float,maxa:Float,minb:Float,maxb:Float)
		Return minb <= maxa And mina <= maxb
	End Method
	Method rectangles_collide:Bool(a:rectangle,b:rectangle)
		Local aleft:Float	= a.origin.x
		Local aright:Float	= aleft + a.size.x
		Local bleft:Float	= b.origin.x
		Local bright:Float	= bleft + b.size.x
		
		Local abottom:Float	= a.origin.y
		Local atop:Float	= abottom + a.size.y
		Local bbottom:Float	= b.origin.y
		Local btop:Float	= bbottom + b.size.y
		
		Return overlapping(	aleft,aright,
							bleft,bright) And overlapping(	abottom,
															atop,
															bbottom,
															btop)
	End Method
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
		
		' origin is a vector that we use to create
		' the rectangle. It holds the x and y position.
		Local origin:vector2d=New vector2d(100,200)
		' size is a vector that we use to create
		' the rectangle. It holds the width and height.
		Local size:vector2d=New vector2d(100,100)
		' r1 is a rectangle created with the origin and size
		' vector variables
		Local r1:rectangle = New rectangle(origin,size)
		
		' Here we create another recangle at the 
		' position of the mouse
		origin = New vector2d(MouseX(),MouseY())
		size = New vector2d(50,50)
		Local r2:rectangle = New rectangle(origin,size)
		
		If col.rectangles_collide(r1,r2) = True Then
			DrawText "Collision",0,0
			Else
			DrawText "No Collision",0,0
		End If
		DrawText "Move the mouse to see if something collides",DeviceWidth/2,0
		r1.draw
		r2.draw
    End Method
End Class



Function Main()
    New MyGame()
End Function
	
