Import mojo

Global screenwidth:Int=640
Global screenheight:Int=480

Class particle
	Field x:Float
	Field y:Float
	Field incx:Float
	Field incy:Float
	Field modincx:Float
	Field modincy:Float
	Field sx:Float
	Field sy:Float
	Field sxinc:Float
	Field syinc:Float
	Field timeout:Float
	Field time:Float
	Field alpha:Float
	Field deleteme:Bool=False	
	Method New(x:Int,y:Int,angle:Int)
		Self.x = x
		Self.y = y
		incx = Cos(angle+Rnd(-5,5))
		incy = Sin(angle+Rnd(-5,5))
		timeout = 50+Rnd(20)
		alpha = 1
		modincx = (Cos(angle+Rnd(-5,5)))/100
		modincy = (Sin(angle+Rnd(-5,5)))/100
		Local sc:Float=Rnd(0.5,1)
		sx = sc
		sy = sc
		sxinc = Rnd()/timeout
		syinc = Rnd()/timeout
	End Method
End Class

Class particleeffect
	Field sw:Int,sh:Int
	Field p:List<particle> = New List<particle>
    Field image:Image
    Field iw:Int=32
    Field ih:Int=32
    Field pixels:Int[]
    Field angle:Int
    Field x:Int,y:Int
	Method New(x:Int,y:Int,angle:Int)
		Self.x = x
		Self.y = y
		Self.sw = screenwidth
		Self.sh = screenheight
		Self.angle = angle
		pixels = New Int[iw*ih]
		image = CreateImage(iw,ih,image.MidHandle)
		makeimage()
		p.AddFirst(New particle(x,y,angle))
	End Method
	Method update()
		If Rnd() < 0.4
			p.AddFirst(New particle(x,y,angle))
		End If
		For Local i:=Eachin p
			i.x += i.incx
			i.y += i.incy
			i.incx += i.modincx
			i.incy += i.modincy
			i.alpha -= 1/i.timeout
			i.time += 1
			i.sx += i.sxinc
			i.sy += i.syinc
			If i.time > i.timeout Then i.deleteme = True
		Next
		For Local i:=Eachin p
			If i.deleteme = True Then p.Remove(i)
		Next
	End Method
	Method makeimage()
		For Local i=0 To iw		
			Local c:Int = 0+((255/iw)*i)
			drawo(iw/2,ih/2,(iw/2)-(i),argb(c,c,c,255))
		Next
		image.WritePixels(pixels, 0, 0, iw, ih, 0)
	End Method
    Method drawo(x1,y1,radius:Float,col)
        For Local y2=-radius To radius
        For Local x2=-radius To radius
            If (y2*y2+x2*x2) <= radius*radius+radius*0.8
                Local x3 = x2+x1
                Local y3 = y2+y1
                Local pc = y3*iw+x3
                If pc>=0 And pc < iw*ih
                    pixels[pc] = col
                End If
            End If
        Next
        Next    

    End Method

	Method draw()
		SetBlend AdditiveBlend
		For Local i:=Eachin p
			SetAlpha i.alpha
			Local sc:Float=(1/i.timeout)*i.time
			DrawImage(mype.image,i.x,i.y,1,i.sx,i.sy)
		Next
		SetAlpha 1
	End Method
	Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
	   Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
	End Function
	Function getred:Int(rgba:Int)    
	    Return((rgba Shr 16) & $FF)    
	End Function              
	Function getgreen:Int(rgba:Int)    
	    Return((rgba Shr 8) & $FF)    
	End Function    
	Function getblue:Int(rgba:Int)    
	    Return(rgba & $FF)    
	End Function    
	Function getalpha:Int(rgba:Int)    
	    Return ((rgba Shr 24) & $FF)    
	End Function	
End Class

Global mype:particleeffect
Global mype2:particleeffect
Global mype3:particleeffect


Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        mype = New particleeffect(100,200,270)
        mype2 = New particleeffect(320,200,270)
        mype3 = New particleeffect(640-100,200,270)
    End Method
    Method OnUpdate()
    	mype.update()
    	mype2.update()
    	mype3.update()
    End Method
    Method OnRender()
        Cls 50,50,50
        mype.draw()
        mype2.draw()
        mype3.draw()                
        DrawImage mype.image,0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
