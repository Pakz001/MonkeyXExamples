Import mojo

Class metaball
    Field image:Image
    Field pixels:Int[]
    Field width:Int,height:Int
	Field ball:blob[] = New blob[4]
    Method New(w:Int,h:Int)
    	width = w
    	height = h
    	pixels = New Int[w*h]
    	image = CreateImage(width,height)
        For Local i:Int=0 Until 4
	        ball[i] = New blob(Rnd(width),Rnd(height),width,height)
        Next
	End Method
	Method update()
       	For Local i:=Eachin ball
       		i.update()
       	Next
        For Local y:Int=0 Until height
        For Local x:Int=0 Until width
	        Local index:Int = x+y*width
        	Local sum:Float = 0
        	For Local b:=Eachin ball
        		Local d:Float = distance(x,y,b.x,b.y)
        		sum += 250*b.r / d
        	Next
        	If sum<0 Then sum=0 
        	If sum>255 Then sum=255
        	If sum<128 Then sum = 0 Else sum=255
        	pixels[index] = argb(sum,0,0)
       	Next
       	Next
		image.WritePixels(pixels, 0, 0, width, height, 0)
	End Method
	Method draw()
		SetColor 255,255,255
		DrawImage(image,0,0,0,(1.0/width)*640.0,(1.0/height)*480.0)
	End Method
    Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    	Return Sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))
    End Function
	Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
	   Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
	End Function
End Class

Class blob
	Field x:Float,y:Float
	Field r:Float
	Field incx:Float,incy:Float
	Field screenwidth:Int,screenheight:Int
	Method New(x:Int,y:Int,sw:Int,sh:Int)
		Self.x = x
		Self.y = y
		r = Rnd(5,14)
		incx = Rnd(-2,2)
		incy = Rnd(-2,2)
		Self.screenwidth = sw
		Self.screenheight = sh
	End Method
	Method update()
		x += incx
		y += incy
		If x<0 Or x>screenwidth Then incx = -incx
		If y<0 Or y>screenheight Then incy = -incy		
	End Method
End Class

Class MyGame Extends App
	Field mymetaball:metaball
	Field time:Int = Millisecs()+4000
    Method OnCreate()
        SetUpdateRate(60)
        mymetaball = New metaball(200,200)
    End Method
    Method OnUpdate() 
    	If MouseHit(MOUSE_LEFT) Or Millisecs()>time
    		time=Millisecs()+4000
   	    	Seed =  Millisecs()
   	    	mymetaball = New metaball(200,200)
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
       	mymetaball.update()
       	mymetaball.draw()
    End Method    
End Class


Function Main()
    New MyGame()
End Function
