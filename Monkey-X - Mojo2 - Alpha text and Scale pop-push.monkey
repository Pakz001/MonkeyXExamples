
Import mojo2

Global canvas:Canvas

Class MyApp Extends App
	
	Field x,y
	Field sx:Int=3
	Field sy:Int=3
	Field alpha:Float=0
	Field alphastep:Float=0.1
	Field textscale:Float=2
	
	Method OnCreate()
		canvas=New Canvas
		x = DeviceWidth()/2
		y = DeviceHeight()/2
	End Method
	Method OnUpdate()
		' update the alpha variable
		alpha+=alphastep
		If alpha<0.1 Or alpha>0.9 
			alphastep=-alphastep
		End If
		'update the text position
		x+=sx;
		y+=sy;		
		If x>(DeviceWidth()/100)*75 Or x<(DeviceWidth()/100)*25
			sx = -sx
		End If
		If y>(DeviceHeight()/100)*75 Or y<(DeviceHeight()/100)*25
			sy = -sy
		End If
	End Method
	Method OnRender()
		canvas.Clear 0,0,0
		' draw the background
		drawbackground				
		' Draw the text
		canvas.SetColor 1,1,1,alpha
		canvas.PushMatrix()
		canvas.Scale textscale,textscale
		canvas.DrawText "Test....",x/textscale,y/textscale
		canvas.PopMatrix()
		canvas.Flush
	End
End Class

Function drawbackground()
		Local c:Float = 0.0
		Local cs:Float = 1/Float(DeviceHeight())
		For Local i=0 To DeviceHeight()
			' set the color with the c float
			canvas.SetColor c,0,0,1
			' increase the c float variable with the cs step
			c+=cs
			' draw a line
			canvas.DrawLine 0,i,DeviceWidth(),i
		Next
End Function


Function Main()
	New MyApp
End
