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
	' Here we create a 'a,b,c' variable using the
	' vectorf class
	Field a:vectorf
	Field b:vectorf
	Field c:vectorf
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
        a = New vectorf(Rnd(-10,10),Rnd(-10,10))
        b = New vectorf(Rnd(-10,10),Rnd(-10,10))
    End Method
    Method OnUpdate()        
    	time+=1
    	If time>5 Then
    		time=0
    		a = New vectorf(Rnd(-10,10),Rnd(-10,10))
    		b = New vectorf(Rnd(-10,10),Rnd(-10,10))
    	End If
    End Method
    Method OnRender()
    	' pointx and y hold the coordinates
    	' that are used to draw on the screen.
    	Local pointx:Int
    	Local pointy:Int
    	Local point2x:Int
    	Local point2y:Int
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
		c = subtract_vector(a,b)
		'
        ' Here we draw the vector a.
        pointx = (a.x*13) + cx
        pointy = (a.y*13) + cy
        DrawCircle pointx,pointy,7
        DrawLine cx,cy,pointx,pointy
        DrawText "a",pointx,pointy,.5,.5
        ' Here we draw the vector b.
        point2x = pointx + (b.x * 13)
        point2y = pointy + (b.y * 13)
        DrawCircle point2x,point2y,7
        DrawLine pointx,pointy,point2x,point2y
        DrawText "b",point2x,point2y,.5,.5
        ' Here we draw the vector c.
        SetColor 255,255,0
        pointx = (c.x*13) + cx
        pointy = (c.y*13) + cy
        DrawCircle pointx,pointy,7
        DrawLine cx,cy,pointx,pointy
        DrawText "c",pointx,pointy,.5,.5
		SetColor 255,255,255
		'
		SetAlpha .3
		DrawLine pointx,pointy,point2x,point2y
        '
        Scale 1.2,1.2
        SetAlpha .5
        DrawText "With vector subtraction we have 2 vectors that",0,0
        DrawText "get subtracted from each other. vector b is drawn.",0,20
        DrawText "from vector a. Vector c is the line from the origin (0,0)",0,40
        DrawText "to the negative of the line from b To a.",0,60
        DrawText "Vector Subtraction :",cx,DeviceHeight-200
        DrawText "c.x = a.x - b.x",cx,DeviceHeight-180
        DrawText "c.y = a.y - b.y",cx,DeviceHeight-160
    End Method
End Class

Function subtract_vector:vectorf(a:vectorf,b:vectorf)
	Local r:vectorf = New vectorf()
	r.x = a.x - b.x
	r.y = a.y - b.y
	Return r
End Function

Function Main()
    New MyGame()
End Function
