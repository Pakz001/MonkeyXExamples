
Import mojo2

Global canvas:Canvas
Global image:Image
Global imagecanvas:Canvas

Class MyApp Extends App
	Field z:Float=0
	Field zs:Float=0.05
	Method OnCreate()
		canvas=New Canvas
		image=New Image(100,48)
		imagecanvas=New Canvas(image)		
		createimage()
	End Method
	Method OnUpdate()
	z+=zs
	zs+=0.005
	If z>10 Then z=0 ; zs=0.05
	End Method
	Method OnRender()
		canvas.Clear 0,0,0
		canvas.DrawImage image,DeviceWidth()/2,DeviceHeight()/2,0,z,z
		canvas.Flush
	End
End Class

Function createimage()
	imagecanvas.SetColor 1,1,1
	imagecanvas.DrawRect(0,0,image.Width(),image.Height())
	imagecanvas.Flush
End Function

Function Main()
	New MyApp
End
