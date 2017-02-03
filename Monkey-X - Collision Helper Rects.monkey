Import mojo

Class line
	Field x1:Int,y1:Int
	Field x2:Int,y2:Int
	Field w:Int,h:Int
	Field r:Int,g:Int,b:Int
	Method New(x1:Int,y1:Int,w:Int,h:Int)
		Self.x1 = x1
		Self.y1 = y1
		Self.w = w
		Self.h = h
		Self.x2 = x1+w
		Self.y2 = y1+h
	End Method
	Method newpos(x:Int,y:Int)
		x1=x
		y1=y
		x2=x1+w
		y2=y1+h
	End Method
	Method mysetcolor(r:Int,g:Int,b:Int)
		Self.r = r
		Self.g = g
		Self.b = b		
	End Method
	Method draw()
		SetColor r,g,b
		DrawRect x1,y1,w,h
	End Method
End Class

Class MyGame Extends App
	Field line1:line = New line(150,150,100,100)
	Field line2:line = New line(200,200,100,100)
    Method OnCreate()
        SetUpdateRate(60)
        line1.mysetcolor(200,0,0)
        line2.mysetcolor(0,200,0)
    End Method
    Method OnUpdate()    
		line1.newpos(MouseX(),MouseY())
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        drawthickline 10,10,10,DeviceHeight-10
        drawthickline 10,DeviceHeight-10,DeviceWidth-10,DeviceHeight-10
		line1.draw
		line2.draw
		' draw the sidelines
		'left
		Local y1:Int=line1.y1
		Local y2:Int=line1.y2
		SetColor 200,50,0
		drawthickline 11,y1,11,y2		
		y1=line2.y1
		y2=line2.y2
		SetColor 50,200,0
		drawthickline 15,y1,15,y2
		'bottom
		Local x1:Int=line1.x1
		Local x2:Int=line1.x2
		SetColor 200,50,0
		drawthickline x1,DeviceHeight-11,x2,DeviceHeight-11
		x1=line2.x1
		x2=line2.x2
		SetColor 50,200,0
		drawthickline x1,DeviceHeight-15,x2,DeviceHeight-15
		'info
		Scale 2,2
		SetColor 255,255,255
		DrawText "When 2 sets of lines are overlapping then",30,0
		DrawText "a rectangular collision is happening...",30,20
		DrawText "Move block with mouse",30,(DeviceHeight-50)/2
		SetColor 255,255,0
		If rectsoverlap(	line1.x1,line1.y1,line1.w,line1.h,
							line2.x1,line2.y1,line2.w,line2.h)
			DrawText "Collision is happening",30,40
		End If
    End Method
End Class

Function drawthickline(x1:Int,y1:Int,x2:Int,y2:Int)
	For Local y=-2 To 2
	For Local x=-2 To 2
		DrawLine x1+x,y1+y,x2+x,y2+y
	Next
	Next
End Function

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End

Function Main()
    New MyGame()
End Function
