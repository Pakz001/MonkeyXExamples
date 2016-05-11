
Import mojo2

Global canvas:Canvas

Class MyApp Extends App
	
	Method OnCreate()
		canvas=New Canvas
	End
	
	Method OnRender()
		canvas.Clear 0,0,0
		' draw the background
		drawbackground				
		' Draw the text
		canvas.SetColor 1,1,1,1
		canvas.DrawText "Test....",10,10
		
		
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
