Import mojo

' This class holds the code for the metaballs
Class metaball
	' Create our image and pixels array
    Field image:Image
    Field pixels:Int[]
    ' Width and height of the image and pixels array
    Field width:Int,height:Int
    ' Set up our blobs
	Field ball:blob[] = New blob[4]
	' Create a new instance of this metaball class
    Method New(w:Int,h:Int)
    	width = w
    	height = h
    	' Our pixels array holds the pixels that will be inside our image
    	pixels = New Int[w*h]
    	image = CreateImage(width,height)
    	' Create our blobs
        For Local i:Int=0 Until 4
	        ball[i] = New blob(Rnd(width),Rnd(height),width,height)
        Next
	End Method
	' Here we update the blobs and redraw the image
	Method update()
		' Update our blobs	
       	For Local i:=Eachin ball
       		i.update()
       	Next
       	' Here we (re)create our image with the metaballs
       	' Loop through the entire image
        For Local y:Int=0 Until height
        For Local x:Int=0 Until width
        	' Our pixels array has only one index	
	        Local index:Int = x+y*width
	        ' This is our color
        	Local sum:Float = 0
        	' Get the sum of the distance from all the metaballs
        	For Local b:=Eachin ball
        		Local d:Float = distance(x,y,b.x,b.y)
        		sum += 250*b.r / d
        	Next
        	' Keep the sum in bound
        	If sum<0 Then sum=0 
        	If sum>255 Then sum=255
        	' Only 2 colors for the metaballs
        	If sum<128 Then sum = 0 Else sum=255
        	' Put the sum color in our pixels array at the index
        	pixels[index] = argb(sum,0,0)
       	Next
       	Next
       	' Refresh our image(copy the pixels array inside it)
		image.WritePixels(pixels, 0, 0, width, height, 0)
	End Method
	' Draw our metaball image to the screen
	Method draw()
		' Draw with white color
		SetColor 255,255,255
		' Draw image at full screen (640*480)
		DrawImage(image,0,0,0,(1.0/width)*640.0,(1.0/height)*480.0)
	End Method
	' Return the distance between xy1 and xy2
    Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    	Return Sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))
    End Function
    ' Create a integer value holding our color
	Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
	   Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
	End Function
End Class

'
' Here is our blob class. These are the balls on the screen
' that will blend over
'
Class blob
	Field x:Float,y:Float
	Field r:Float  'radius
	Field incx:Float,incy:Float
	Field screenwidth:Int,screenheight:Int
	Method New(x:Int,y:Int,sw:Int,sh:Int)
		Self.x = x
		Self.y = y
		' Create a random radius
		r = Rnd(5,14)
		' Create random movement x and y
		incx = Rnd(-2,2)
		incy = Rnd(-2,2)
		Self.screenwidth = sw
		Self.screenheight = sh
	End Method
	' Update the movement of the blob
	Method update()
		x += incx
		y += incy
		' Keep them inside the screen
		If x<0 Or x>screenwidth Then incx = -incx
		If y<0 Or y>screenheight Then incy = -incy		
	End Method
End Class

Class MyGame Extends App
	' Create our metaball reference
	Field mymetaball:metaball
	' Create a time variable
	Field time:Int = Millisecs()+4000
    Method OnCreate()
    	' 60 frames per second	
        SetUpdateRate(60)
        ' init our metaball
        mymetaball = New metaball(200,200)
    End Method
    ' This is our update method
    Method OnUpdate() 
    	' If Mousehit or time
    	If MouseHit(MOUSE_LEFT) Or Millisecs()>time
    		' update time
    		time=Millisecs()+4000
    		' Random seed (different numbers for rnd())
   	    	Seed =  Millisecs()
   	    	' New metaball initiation(restart)
   	    	mymetaball = New metaball(200,200)
    	End If

		' Update our metaballs
       	mymetaball.update()

    End Method
    ' This method draws everything
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        ' Draw our metaballs
       	mymetaball.draw()
    End Method    
End Class


Function Main()
    New MyGame()
End Function
