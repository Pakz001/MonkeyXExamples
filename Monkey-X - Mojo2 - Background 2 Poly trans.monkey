
Import mojo2

Global canvas:Canvas
Global image:Image
Global imagecanvas:Canvas
' movement variables
Global mx1:Int,my1:Int
Global mx2:Int,my2:Int
Global mx1m:Int=3,my1m:Int=3
Global mx2m:Int=-3,my2m:Int=-3

Class MyApp Extends App
	Field refresh:Int
	Method OnCreate()
		Seed = GetDate[5]
		canvas=New Canvas
		image=New Image(640,480)
		imagecanvas=New Canvas(image)		
		'set the start position
		'of the lines
		mx1 = image.Width/2
		my1 = image.Height/2
		mx2 = image.Width/2
		my2 = image.Height/2
		
		createimage()
		SetUpdateRate(60)
	End Method
	Method OnUpdate()
		'bounce the polygons
		mx1+=mx1m
		my1+=my1m
		mx2+=mx2m
		my2+=my2m
		Local left:Int=DeviceWidth()/100*20
		Local right:Int=DeviceWidth()/100*80
		Local top:Int=DeviceHeight()/100*20
		Local bottom:Int=DeviceHeight()/100*80
		If mx1<left Or mx1>right Then mx1m=-mx1m
		If mx2<left Or mx2>right Then mx2m=-mx2m		
		If my1<top Or my1>bottom Then my1m=-my1m
		If my2<top Or my2>bottom Then my2m=-my2m
		'recreate the image
		createimage
	End Method
	Method OnRender()
		canvas.Clear 0,0,0
		canvas.DrawImage image,DeviceWidth()/2,DeviceHeight()/2
		canvas.Flush
	End
End Class

Function createimage()
	imagecanvas.Clear

	Local cx1:Float = mx1
	Local cy1:Float = my1
	Local cx2:Float = mx2
	Local cy2:Float = my2

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

	imagecanvas.PushMatrix
	imagecanvas.Scale 3,3
	imagecanvas.SetColor 0,0,0,1
	imagecanvas.DrawText 	"Monkey-X - Mojo2",
							(image.Width()/2)/3+1,
							(image.Height()/2)/3+1,
							0.5,0.5
	imagecanvas.SetColor 1,1,1,1
	imagecanvas.DrawText 	"Monkey-X - Mojo2",
							(image.Width()/2)/3,
							(image.Height()/2)/3,
							0.5,0.5

	imagecanvas.PopMatrix
	
	imagecanvas.Flush
End Function

Function Main()
	New MyApp
End
