
Import mojo2

Global canvas:Canvas
Global image:Image
Global imagecanvas:Canvas

Class MyApp Extends App
	Field refresh:Int
	Method OnCreate()
		Seed = GetDate[5]
		canvas=New Canvas
		image=New Image(640,480)
		imagecanvas=New Canvas(image)		
		createimage()
		SetUpdateRate(60)
	End Method
	Method OnUpdate()
		refresh+=1
		If refresh>100
			createimage
			refresh=0
		End If
	End Method
	Method OnRender()
		canvas.Clear 0,0,0
		canvas.DrawImage image,DeviceWidth()/2,DeviceHeight()/2
		canvas.Flush
	End
End Class

Function createimage()
	imagecanvas.Clear
	'1st center of the lines inwards
	Local cx1:Float=(image.Width()/100)*Rnd(10,80)
	Local cy1:Float=(image.Height()/100)*Rnd(10,80)
		
	'2nd center of the lines inwards	
	Local cx2:Float=(image.Width()/100)*Rnd(10,80)
	Local cy2:Float=(image.Height()/100)*Rnd(10,80)

	'make a blue copperisch background
	Local c:Float=0
	Local cs:Float=1/Float(image.Width())	
	For Local x=0 Until image.Width()
		imagecanvas.SetColor 0,0,c,.5
		imagecanvas.DrawLine x,0,x,image.Height()
		c+=cs
	Next

	' make the lines inwards
	imagecanvas.SetColor 1,1,1,0.2
	For Local i=0 Until 360 Step 10
		Local x1:Float=cx1+Cos(i)*image.Width
		Local y1:Float=cy1+Sin(i)*image.Width
		Local x2:Float=cx1+Cos(i+4)*image.Width
		Local y2:Float=cy1+Sin(i+4)*image.Width
		imagecanvas.DrawPoly([x1,y1,x2,y2,cx1,cy1])
	Next	

	imagecanvas.SetColor 1,1,1,0.1
	For Local i=0 Until 360 Step 10
		Local x1:Float=cx2+Cos(i)*image.Width
		Local y1:Float=cy2+Sin(i)*image.Width
		Local x2:Float=cx2+Cos(i+4)*image.Width
		Local y2:Float=cy2+Sin(i+4)*image.Width
		imagecanvas.DrawPoly([x1,y1,x2,y2,cx2,cy2])
	Next	


	
	imagecanvas.Flush
End Function

Function Main()
	New MyApp
End
