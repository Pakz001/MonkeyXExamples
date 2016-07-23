Import mojo2

Class arrow
	Field image:Image
	Field imagecanvas:Canvas
	Method New(width:Int,height:Int)
		image = New Image(width,height)
		imagecanvas = New Canvas(image)
		createimage()
	End Method
	Method createimage()
		imagecanvas.SetColor 1,1,1
		Local w:Float=image.Width()
		Local h:Float=image.Height()
		Local pol:Float[14]
		pol[0] = 0
		pol[1] = h/2		
		pol[2] = w/3
		pol[3] = h		
		pol[4] = w/3
		pol[5] = h/1.5		
		pol[6] = w
		pol[7] = h/1.5		
		pol[8] = w
		pol[9] = h/3		
		pol[10] = w/3
		pol[11] = 0+h/3		
		pol[12] = w/3
		pol[13] = 0
		imagecanvas.DrawPoly(pol)
		imagecanvas.Flush
	End Method

End Class

Global myarrow:arrow

Class MyApp Extends App
	Field canvas:Canvas
	Field angle:Int
	Method OnCreate()
		SetUpdateRate(60)
		myarrow = New arrow(200,100)
		canvas=New Canvas
	End Method
	Method OnUpdate()
		angle+=1
		If angle>359 Then angle=0
	End Method
	Method OnRender()
		canvas.Clear 0,0,0
		canvas.DrawImage(myarrow.image,DeviceWidth()/2,DeviceHeight()/2,0+angle)
		
		canvas.DrawImage(myarrow.image,64,64,0+angle,0.5,0.5)
		canvas.DrawImage(myarrow.image,64,DeviceHeight()-64,0+angle,0.5,0.5)
		canvas.DrawImage(myarrow.image,DeviceWidth()-64,64,360-angle,0.5,0.5)
		canvas.DrawImage(myarrow.image,DeviceWidth()-64,DeviceHeight()-64,360-angle,0.5,0.5)

		canvas.Flush
	End
End Class


Function Main()
	New MyApp
End
