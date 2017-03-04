'  From the book '2d game collision detection'

Import mojo

' This is the collision class. In this example with
' the point vs point method.
'
'
Class collision
	Method points_collide:Bool(a:vector2d,b:vector2d)
		Return a.x = b.x And a.y = b.y
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
		Local a:vector2d = New vector2d(100,100)
		Local b:vector2d = New vector2d(100,100)
		Local c:vector2d = New vector2d(101,100)
		'
		DrawText "point a : "+a.x+","+a.y,0,100
		DrawText "point b : "+b.x+","+b.y,0,120
		DrawText "point c : "+c.x+","+c.y,0,140
		'
		If col.points_collide(a,b)
			DrawText "Points a vs b - Collision",0,0
			Else
			DrawText "Points a vs b - No Collision",0,0
		End If
		If col.points_collide(a,c)
			DrawText "Points a vs c - Collision",0,20		
			Else
			DrawText "Points a vs c - No Collision",0,20
		End If		
		
    End Method
End Class

Function Main()
    New MyGame()
End Function
	
