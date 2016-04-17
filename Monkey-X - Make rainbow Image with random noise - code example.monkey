Import mojo

Class theimage
    Field image:Image
    Field pixels:Int[]
    Field width:Int
    Field height:Int
    Method New()
    	Self.width = DeviceWidth()
    	Self.height = DeviceHeight()
    	pixels = New Int[width*height]
    	image = CreateImage(width,height)
    	makeimage
    	image.WritePixels(pixels, 0, 0, width, height, 0)
	End Method
	Method makeimage()
		' here we make the 
		' noisy rainbow
		Local x:Int
		Local ty:Int
		Local cnt:Int
		Local sc:Int 'dheight with num of cols
        For Local i:Int = 0 Until width*height
            Local col:Int=sc
            If sc<15
            If Rnd((16-ty)+4) < 2
            	col+=1
            End If
            End If
            pixels[i] = argb(	spread.r[col],
            					spread.g[col],
            					spread.b[col])
			x+=1
            If x>width
            	x=0
            	cnt+=1
            	ty+=1
            	If ty>height/16
            		ty=0
            	End If
            	If cnt>height/16
            		cnt=0
            		sc+=1
            	End If
            End If
        Next	
	End Method
End Class

Class colorspread16
	Field r:Float[16]
	Field g:Float[16]
	Field b:Float[16]
	Method New(	r1:Int,g1:Int,b1:Int,
				r2:Int,g2:Int,b2:Int)
		Local sr:Float
		Local sg:Float
		Local sb:Float
		If r1>r2
			sr = (r1-r2)/16
			For Local i:Float=0 Until 16 Step 1
				r[i] = r1-(i*sr)
			Next
			Else
			sr = (r2-r1)/16
			For Local i:Float=0 Until 16 Step 1
				r[i] = r1+i*sr
			Next
		End If
		If g1>g2
			sg = (g1-g2)/16
			For Local i:Float=0 Until 16 Step 1
				g[i] = g1-(i*sg)
			Next
			Else
			sg = (g2-g1)/16
			For Local i:Float=0 Until 16 Step 1
				g[i] = g1+i*sg
			Next
		End If
		If b1>b2
			sb = (b1-b2)/16
			For Local i:Float=0 Until 16 Step 1
				b[i] = b1-(i*sb)
			Next
			Else
			sb = (b2-b1)/16
			For Local i:Float=0 Until 16 Step 1
				b[i] = b1+i*sb
			Next
		End If

	End Method
End Class

Global spread:colorspread16
Global myimage:theimage

Class MyGame Extends App
	Field cnt:Int
	Field r:Int[2]
	Field g:Int[2]
	Field b:Int[2]
    Method OnCreate()
        SetUpdateRate(60)
        Seed = GetDate[5]
    	For Local i=0 To 1
    		r[i] = Rnd(0,255)
    		g[i] = Rnd(0,255)
    		b[i] = Rnd(0,255)
    	Next
        spread = New colorspread16(	r[0],g[0],b[0],
        							r[1],g[1],b[1])    		
        myimage = New theimage()
    End Method
    Method OnUpdate()        
    	cnt+=1
    	If cnt>200
    		cnt=0
    		For Local i=0 To 1
    			r[i] = Rnd(0,255)
    			g[i] = Rnd(0,255)
    			b[i] = Rnd(0,255)
    		Next
        	spread = New colorspread16(	r[0],g[0],b[0],
        								r[1],g[1],b[1])    		
	        myimage = New theimage()
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawImage myimage.image,0,0
        ' Draw the text
       	SetColor 255,255,255
       	DrawText 	"Monkey-X - Making images from "+
       				"16 colors rainbow palette -"+
       				" (Noisy Rainbow) - Example",0,0   				
    End Method
End Class



Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
   Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
End Function

Function Main()
    New MyGame()
End Function

