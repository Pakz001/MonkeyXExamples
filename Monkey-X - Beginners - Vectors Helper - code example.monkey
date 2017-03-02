Import mojo

' This is the vector class. It has a 
' x and y float variable.
'
Class vectorf
	Field x:Float,y:Float
	Method New(x:Float,y:Float)
		Self.x = x
		Self.y = y
	End Method
End Class

Class MyGame Extends App
	' Here we create a 'a' variable using the
	' vectorf class
	Field a:vectorf
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
    End Method
    Method OnUpdate()        
    	time+=1
    	If time>3 Then
    		time=0
    		a = New vectorf(Rnd(-10,10),Rnd(-10,10))
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
        ' Here we draw the vector.
        pointx = (a.x*10) + cx
        pointy = (a.y*10) + cy
        DrawCircle pointx,pointy,10
        DrawLine cx,cy,pointx,pointy
        DrawText "a",pointx,pointy,.5,.5
        DrawText String(a.x)[0..4]+","+String(a.y)[0..4],pointx,pointy+10
        '
        Scale 1.2,1.2
        SetAlpha .5
        DrawText "A vector describes a straight movement in 2D space",0,0
        DrawText "The two dimensions are called X and Y.",0,20
        DrawText "The origin(starting point of vector) is always 0,0",0,40
        DrawText "The words point or vector are the same.",0,60
    End Method
End Class


Function Main()
    New MyGame()
End Function
