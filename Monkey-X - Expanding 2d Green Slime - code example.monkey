Import mojo

Global screenwidth:Int=640
Global screenheight:Int=480


Class slime	
    Field sx:Stack<Int> = New Stack<Int>
    Field sy:Stack<Int> = New Stack<Int>
	Field mapimage:Image
	Field mappixels:Int[]
    Field image:Image
    Field iw:Int=screenwidth
    Field ih:Int=screenheight
    Field pixels:Int[]
    Method New(x:Int,y:Int)
    	Seed = GetDate[5]
        pixels = New Int[iw*ih]
        image = CreateImage(iw,ih)
        sx.Push(x)
        sy.Push(y)
        setpixel(x,y)
        mappixels = New Int[iw*ih]
        mapimage = CreateImage(iw,ih)
        Local x2:Int=0
        For Local x1=-100 Until iw Step 96
		For Local y1=0 To ih
			x2+=1
			drawr(x1+x2,y1,5,5,argb(100,100,100))
		Next
		x2=0
		Next
		For Local y1=0 To ih Step 20
			drawr(0,y1,iw,10,argb(0,0,0,0))
		Next
		For Local x1=0 To iw Step 32
		For Local y1=0 To ih Step 32
			drawr(x1,y1,16,16,argb(100,100,100))
		Next
		Next
		For Local i=0 Until 50
		Local x1:Float=Rnd(50,iw-50)	
		Local y1:Float=Rnd(50,ih-50)
		Local l:Int=Rnd(0,200)
		Local h:Int=l+Rnd(100)
		If Rnd()<.5
		For Local i=l To h
			x1+=Cos(i)*2
			y1+=Sin(i)*2
			drawr(x1,y1,6,6,argb(100,100,100))
		Next
		Else
		For Local i=h To l Step -1
			x1+=Cos(i)*2
			y1+=Sin(i)*2
			drawr(x1,y1,6,6,argb(100,100,100))
		Next
		End if		
		Next
		For Local i=0 To iw*ih*2
			Local x1:Int=Rnd(iw)
			Local y1:Int=Rnd(ih)
			Local cnt:Int=0
			For Local y2=-5 To 5
			For Local x2=-5 To 5
				Local x3:Int=x1+x2
				Local y3:Int=y1+y2
				If x3>=0 And x3<iw And y3>=0 And y3<ih
				If getred(getmappixel(x3,y3)) > 70 Then
					'addmappixel(x3,y3)
					cnt+=1
					
				End If
				End If
			Next
			Next
			If cnt>80

				addmappixel(x1,y1)

			End If
			cnt=0
		Next
		mapimage.WritePixels(mappixels, 0, 0, iw, ih, 0)
    End Method
    Method addmappixel(x:Int,y:Int)
    	Local pos:Int=(y*iw)+x
    	Local r:Int=getred(mappixels[pos])+10
    	Local g:Int=getgreen(mappixels[pos])+10
    	Local b:Int=getblue(mappixels[pos])+10	    	
    	Local nr:Int=Clamp(r,0,255)
    	Local ng:Int=Clamp(g,0,255)
    	Local nb:Int=Clamp(b,0,255)    	    	
    	mappixels[pos] = argb(nr,ng,nb)
    End Method

    Method setpixel(x:Int,y:Int)
    	Local pos:Int=(y*iw)+x
    	pixels[pos] = argb(0,255,0)
    End Method
    Method getmappixel:Int(x:Int,y:Int)
    	Local pos:Int=(y*iw)+x
    	Return mappixels[pos]
    End Method
    Method getpixel:Int(x:Int,y:Int)
    	Local pos:Int=(y*iw)+x
    	Return pixels[pos]
    End Method
    Method getpixel2:Int(x:Int,y:Int)
    	Local pos:Int=(y*iw)+x
    	Return mappixels[pos]
    End Method
    Method update()
		If Rnd()<0.1
   			sx.Push(Rnd(0,iw))
       		sy.Push(Rnd(0,ih))
       	End If
    
    	Local xs:Int[]=[0,1,0,-1]
    	Local ys:Int[]=[-1,0,1,0]
    	Local nx:Stack<Int> = New Stack<Int>
    	Local ny:Stack<Int> = New Stack<Int>    	
    	For Local i=0 Until sx.Length
    		Local x:Int=sx.Top
    		Local y:Int=sy.Top
    		'setpixel(x,y)

			For Local i=0 Until 4
    			Local x3:Int=x+xs[i]
    			Local y3:Int=y+ys[i]
    			If x3>=0 And x3<iw And y3>= 0 And y3<ih
    				If getgreen(getpixel(x3,y3)) = 0 And getred(getpixel2(x3,y3)) = 0
    					If Rnd()>.2
    					If i=0 And Rnd()<.6
    					Else
	    					setpixel(x3,y3)
    						nx.Push(x3)
    						ny.Push(y3)
    					End If
    					End If
    				End If
    			End If
    		Next
			sx.Pop()
			sy.Pop()
    	Next
    	For Local i = 0 Until nx.Length
    		sx.Push(nx.Get(i))
    		sy.Push(ny.Get(i))
    	Next
    	updateimage
    End Method
    Method updateimage()
        image.WritePixels(pixels, 0, 0, iw, ih, 0)
    End Method

    Method draw()
		DrawImage image,0,0,0,2,2
		DrawImage mapimage,0,0,0,2,2
    End Method
    Method drawr(x1,y1,w1,h1,col)
        For Local y2=y1 Until y1+h1
        For Local x2=x1 Until x1+w1
            Local pc = y2*iw+x2
            If pc >= 0 And pc < iw*ih
                mappixels[pc] = col
            End If
        Next
        Next    
   	End Method
    Method drawo(x1,y1,radius:Float,col:Int)
        For Local y2=-radius To radius
        For Local x2=-radius To radius
            If (y2*y2+x2*x2) <= radius*radius+radius*0.8
                Local x3 = x2+x1
                Local y3 = y2+y1
                Local pc = y3*iw+x3
                If pc>=0 And pc < iw*ih
                    mappixels[pc] = col
                End If
            End If
        Next
        Next    
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

Global myslime:slime

Class MyGame Extends App
	Field cnt:Int=0
    Method OnCreate()
        SetUpdateRate(60)
		myslime = New slime(160,120)
    End Method
    Method OnUpdate()
    	cnt+=1
    	If cnt>400 Then
    		myslime = New slime(160,120)
    		cnt=0
    	End If
		myslime.update
    End Method
    Method OnRender()
        Cls 50,50,50
		myslime.draw
    End Method
End Class


Function Main()
    New MyGame()
End Function
