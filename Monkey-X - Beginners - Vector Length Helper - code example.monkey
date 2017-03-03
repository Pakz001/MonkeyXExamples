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
        a = New vectorf(Rnd(-10,10),Rnd(10,10))
    End Method
    Method OnUpdate()        
    	time+=1
    	If time>5 Then
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
		'
        ' Here we draw the vector a.
        SetColor 255,255,0
        pointx = (a.x*13) + cx
        pointy = (a.y*13) + cy
        DrawCircle pointx,pointy,7
        DrawLine cx,cy,pointx,pointy
        DrawText "a",pointx,pointy,.5,.5
        DrawText String(a.x)[0..4]+","+String(a.y)[0..4],pointx+5,pointy+10,.5,.5
		'
		SetColor 155,155,155
		DrawLine pointx,pointy,pointx,cy
		
		' Here we draw the Screen info
		SetColor 255,255,255
        Scale 1.2,1.2
        SetAlpha 1
        '
        ' String(mystring)[0..4] creates a string with 4 
        ' characters. [ 0,1,2,3 ] Left to right.
        '
        DrawText "Vector Length is : "+String(vector_length(a))[0..4],0,0
        DrawText "The length of a vector is from",0,20
        DrawText "the origin to its tip.",0,40
        SetAlpha 0.6
        DrawText "Vector Length :",cx-30,DeviceHeight-160
        DrawText "d = Sqrt(a.x * a.x + a.y * a.y)",cx-30,DeviceHeight-140
    End Method
End Class

' Here is the function that returns the length of
' the origin(0,0) to it's tip.
'
Function vector_length:Float(v:vectorf)
	Return Sqrt(v.x * v.x + v.y * v.y)
End Function

Function Main()
    New MyGame()
End Function
