Import mojo

' This is the vector class. It has a 
' x and y float variable.
'
Class vectorf
	Field x:Float,y:Float
	Method New(x:Float = 0,y:Float = 0)
		Self.x = x
		Self.y = y
	End Method
End Class

Class MyGame Extends App
	' Here we create a 'a,b' variable using the
	' vectorf class
	Field a:vectorf
	Field b:vectorf
	' Scale is used to scale a vector
	Field scale:Float
	' cx and cy contain the center x and center y
	' coordinates of the screen.
	Field cx:Int
	Field cy:Int
	' time is a variable used to change(refresh)
	' the information on the screen.
	Field time:Int
    Method OnCreate()
        SetUpdateRate(1)
        Seed = GetDate[4] + GetDate[5]
        cx = DeviceWidth()/2
        cy = DeviceHeight()/2
        ' Here we create a new vector in
        ' a with a new value(x and y)
        a = New vectorf(Rnd(-5,5),Rnd(-5,5))
        ' here we create the scale (multiplier)
        scale = Rnd(2,3)
    End Method
    Method OnUpdate()        
    	time+=1
    	If time>5 Then
    		time=0
    		a = New vectorf(Rnd(-5,5),Rnd(-5,5))
			scale = Rnd(2,3)
    	End If
    End Method
    Method OnRender()
    	' pointx and y hold the coordinates
    	' that are used to draw on the screen.
    	Local pointx:Int
    	Local pointy:Int
        Cls 0,0,0 
        SetColor 255,255,255
        ' Here we draw the helper screen part.
        DrawLine cx,0,cx,DeviceHeight
        DrawLine 0,cy,DeviceWidth,cy
 		DrawText "-X",0,cy
 		DrawText "+X",DeviceWidth()-30,cy
 		DrawText "-Y",cx,0
 		DrawText "+Y",cx,DeviceHeight()-30
 		DrawText "0,0",cx,cy,.5,.5
 		DrawText "Origin",cx+5,cy-20
		'
		b = multiply_vector(a,scale)
		'
        ' Here we draw the vector a.
        pointx = (a.x*13) + cx
        pointy = (a.y*13) + cy
        DrawCircle pointx,pointy,7
        DrawLine cx,cy,pointx,pointy
        DrawText "a",pointx,pointy,.5,.5
        ' Here we draw the vector b.
        SetColor 255,255,0
        pointx = (b.x * 13) + cx
        pointy = (b.y * 13) + cy
        DrawCircle pointx,pointy,7
        DrawLine cx,cy,pointx,pointy
        DrawText "b = a * "+String(scale)[0..4],pointx,pointy
		'
		SetColor 255,255,255
        Scale 1.2,1.2
        SetAlpha .5
        DrawText "With vector multiplication we multiply",0,0
        DrawText "a vector's x and y by a value.",0,20
        DrawText "The scaling can only change the length and not",0,40
        DrawText "the direction.",0,60
        DrawText "Vector Multiplication :",cx,DeviceHeight-200
        DrawText "b.x = a.x * scale",cx,DeviceHeight-180
        DrawText "b.y = a.y * scale",cx,DeviceHeight-160
    End Method
End Class

Function multiply_vector:vectorf(v:vectorf,scalar:Float)
	Local r:vectorf = New vectorf()
	r.x = v.x * scalar
	r.y = v.y * scalar
	Return r
End Function

Function Main()
    New MyGame()
End Function
