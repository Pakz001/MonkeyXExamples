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
	' Here we create a 'a,b,c' variable using the
	' vectorf class
	Field a:vectorf
	Field b:vectorf
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
        a = New vectorf(Rnd(-100,100),Rnd(-100,100))
        b = New vectorf(Rnd(-100,100),Rnd(-100,100))
    End Method
    Method OnUpdate()        
    	time+=1
    	If time>3 Then
    		time=0
    		a = New vectorf(Rnd(-100,100),Rnd(-100,100))
    		b = New vectorf(Rnd(-100,100),Rnd(-100,100))
    	End If
    End Method
    Method OnRender()
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
		
		SetColor 255,255,255
		DrawLine a.x+cx,a.y+cy,b.x+cx,b.y+cy
		DrawText "p1",a.x+cx,a.y+cy
		DrawText "p2",b.x+cx,b.y+cy		
		SetColor 255,255,0

		Local an:Float = ATan2(b.y-a.y,b.x-a.y)

        '
        Scale 1.2,1.2
        SetAlpha .5
        DrawText "The angle between point1 and point2.",0,0
        DrawText "angle = Atan2(b.x-a.x,b.y-a.y)",240,340
        DrawText "angle in degrees = " +an,240,350
        DrawText "angle in Radians = "+an*(PI/180),240,360
        DrawText "degrees = radians*(180/PI) - radians = degrees*(PI/180)",120,370
        

    End Method
End Class

Function add_vector:vectorf(a:vectorf,b:vectorf)
	Local r:vectorf = New vectorf(0,0)
	r.x = a.x + b.x
	r.y = a.y + b.y
	Return r
End Function

Function Main()
    New MyGame()
End Function
