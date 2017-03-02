Import mojo

' The dot product is used for instance
' in collision functions.
' The dot product is also known as
' a scalar product or inner product.
' It describes the relation between
' two vectors with a single number.

' A vector describes a straight movement in 2d
' space.
' Here with two dimensions (x and y) 
'
Class vectorf
	Field x:Float,y:Float
	Method New(x:Float,y:Float)
		Self.x = x
		Self.y = y
	End Method
End Class

Class MyGame Extends App
	Field a:vectorf = New vectorf(8,-2)
	Field b:vectorf = New vectorf(-5,5)
	' cx and cy contain the center x and y coordinates
	' of the screen
	Field cx:Int
	Field cy:Int
	' time is a variable that is used
	' to see when we need to renew the
	' screen with new info
	'
	Field time:Int
    Method OnCreate()
        SetUpdateRate(1)
        cx = DeviceWidth() / 2
        cy = DeviceHeight() / 2
    End Method
    Method OnUpdate()  
	    time+=1
	    If time>3
			time=0
 	   		a = New vectorf(Rnd(-10,10),Rnd(-10,10))    	
  		  	b = New vectorf(Rnd(-10,10),Rnd(-10,10))
    	End If      
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawLine cx,0,cx,DeviceHeight
        DrawLine 0,cy,DeviceWidth,cy
        ' pointx and y are the vector coordinates
        ' multiplied with a value
        Local pointx:Int=(a.x*10)+cx
        Local pointy:Int=(a.y*10)+cy        
        DrawCircle pointx,pointy,10
        DrawLine cx,cy,pointx,pointy
 		DrawText "a",pointx,pointy
        pointx = (b.x*10) + cx
        pointy = (b.y*10) + cy
        DrawCircle pointx,pointy,10
        DrawLine cx,cy,pointx,pointy
        DrawText "b",pointx,pointy
		' dp is a variable that contains
		' the dot product of a and b
		Local dp:Float=dot_product(a,b)
		Scale 1.2,1.2
		DrawText "Dot product of a and b = "+dp,0,0
		DrawText "If the value is 0 then the angle between",0,20
		DrawText "the vectors is 90 Degrees",0,40
		DrawText "When the value is positive then the",0,60
		DrawText "angle is less then 90 degrees",0,80
		DrawText "When the value is negative then the",0,100
		DrawText "angle is greater then 90 degrees",0,120	
		'
		DrawText "dot product is : ",cx,DeviceHeight()-180
		DrawText "a.x * b.x + a.y * b.y",cx,DeviceHeight()-160
    End Method
End Class

Function dot_product:Float(a:vectorf,b:vectorf)
	Return a.x * b.x + a.y * b.y 
End Function

Function Main()
    New MyGame()
End Function
