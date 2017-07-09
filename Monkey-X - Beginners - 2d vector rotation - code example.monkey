Import mojo

Class vector
	' A vector has a origin of 0,0. The length and direction
	' is the x and y variables. 
	Field x:Float
	Field y:Float
	Method New(x:Float=0.0,y:Float=0.0)
		' Fill in the x and y
		Self.x = x
		Self.y = y
	End Method
	' This method rotates the input vector by a value(degrees)
	Method rotate:vector(v:vector,val:Int)
		' create a temporary vector
		Local u:vector = New vector()
		' rotate the inputted vector and put the data in u.
		u.x = v.x * Cos(val) - v.y * Sin(val)
		u.y = v.x * Sin(val) + v.y * Cos(val)
		' return the new vector
		Return u
	End Method
End Class

Class MyGame Extends App
	' some local variables.
	Field alienx:Float=100,alieny:Float=100
	Field myvec:vector
    Method OnCreate()
        SetUpdateRate(60)
        ' create the new vector (2,2)
        myvec = New vector(2,2)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        ' Move the alien based on the vector's x,y
        alienx+=myvec.x
        alieny+=myvec.y
        ' rotate the vector.
        myvec = myvec.rotate(myvec,10)
        ' draw the alien.
        DrawCircle(alienx,alieny,10)
        '
        DrawText "2D Vector Rotation",0,0
    End Method
End Class

Function Main()
    New MyGame()
End Function
