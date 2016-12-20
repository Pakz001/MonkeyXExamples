Import mojo

Global screenwidth:Int=640
Global screenheight:Int=480


Class texture

	Field mapimage:Image
	Field mappixels:Int[]
	Field map:Int[][]
    Field iw:Int=screenwidth
    Field ih:Int=screenheight

	Field sc:Int=1'Rnd(1,3)
    Method New()   
        mappixels = New Int[iw*ih]
        mapimage = CreateImage(iw,ih)
		map = New Int[iw][]
        For Local i = 0 Until iw
            map[i] = New Int[ih]
        Next

		render1()

    End Method
	Method render1()        
		'noisey layer
		noisylayer()
		If Rnd()<.5 Then cellularlayer()



		' lines down
		If Rnd()<.5
		Local c:Int=Rnd(1,5)
		For Local i=0 Until c
		Local val:Int=Rnd(-60,60)
		If Rnd()<.5 Then val = Rnd(2,10)
		Local y:Int=0
		Local v1:Int=Rnd(6,20)
		Local v2:Int=Rnd(2,v1)
		While y<ih
		For Local x=0 To iw
			For Local i=0 To v2
			decmappixel(x,y+i,val)
			Next
		Next
		y+=v1
		Wend
		Next
		End If
		' line right
		If Rnd()<.5
		Local c:Int=Rnd(1,5)
		For Local i=0 Until c
		Local val:Int=Rnd(-60,60)
		If Rnd()<.5 Then val = Rnd(2,10)
		'For Local x=0 To iw Step 8
		Local v1:Int=Rnd(3,iw/20)
		Local v2:Int=Rnd(2,v1)
		Local x=0
		While x<iw
		For Local y=0 To ih 
			For Local i=0 To v2
			decmappixel(x+i,y,val)
			Next
		Next
		x+=v1
		Wend
		Next
		End If
		'lines right
		If Rnd()<.5
		Local c:Int=Rnd(1,5)
		For Local i=0 Until c
		Local val:Int=Rnd(-60,60)
		If Rnd()<.5 Then val = Rnd(2,10)
		Local y:Int=0
		Local v1:Int=Rnd(3,ih/10)
		Local v2:Int=Rnd(2,v1)
		'For Local y=0 To ih Step 8
		While y<ih
		For Local x=0 To iw
			For Local i=0 To v2
			addmappixel(x,y+i,val)
			If Rnd()<.5 Then addmappixel(x+i,y,val)
			Next
		Next
		y+=v1
		Wend
		Next
		End If
		' lines down
		If Rnd()<.5
		Local c:Int=Rnd(1,5)
		For Local i=0 Until c
		Local t:Int=Rnd(1,5)
		For Local i=0 Until t
		Local val:Int=Rnd(-60,60)
		If Rnd()<.5 Then val = Rnd(2,10)
		Local v1:Int=Rnd(3,iw/5)
		Local v2:Int=v1/2
		Local x:Int=0
		While x<iw
		For Local y=0 To ih 
			For Local i=0 To v2
			addmappixel(x+i,y,val)
			If Rnd()<.5 Then addmappixel(x+i,y,val)
			Next
		Next
		x+=v1
		Wend
		Next
		Next
		End If
		'diagonal lines
		If Rnd()<.5
		Local c:Int=Rnd(1,5)
		For Local i=0 Until c
		Local val:Int=Rnd(-60,60)
		If Rnd()<.5 Then val = Rnd(2,10)
		Local x:Int=0
		Local x1:Int=-iw
		Local v1:Int=Rnd(8,iw/5)
		Local v2:Int=Rnd(3,v1)
		While x1<iw 
		For Local y=0 To ih
			For Local i=0 To v2
				addmappixel(x1+(x+i),y,val)
				'If Rnd()<.5 Then addmappixel(x1+(x+i),y)
			Next
			x+=1
		Next
		x=0
		x1+=v1
		Wend
		Next
		End If

		'blocks
		If Rnd()<.5
			Local x1:Int=0
			Local y1:Int=0
			Local sw:Int=Rnd(15,iw/10)
			Local sh:Int=Rnd(15,ih/10)
			Local sx:Int=Rnd(sw,sw*2)
			Local sy:Int=Rnd(sh,sh*2)
			Local t:Int
			If Rnd()<.5 Then 
				t=Rnd(-80,-30)
				Else 
				t=Rnd(30,80)
			End if
			While y1<ih
				addr2(x1,y1,sw,sh,t)
				x1+=sx
				If x1>iw
				x1=0
				y1+=sy
				End If				
			Wend
		End If


		'triangle up
		If Rnd()<.2 Then addtriangleup
		
		'triangle down
		If Rnd()<.2 Then addtriangledown


		'triangle left
		If Rnd()<.2 Then addtriangleleft
		'triangle Right
		If Rnd()<.2 Then addtriangleright
		If Rnd()<.2 Then addoval()			
		If Rnd()<.5 Then addheightmap
		tintmap
		mapimage.WritePixels(mappixels, 0, 0, iw, ih, 0)
	End Method

    Method update()
		
    End Method

	Method cellularlayer()
		'cellular layer
		For Local y=0 Until ih
		For Local x=0 Until iw
			If Rnd()<.5 Then
				map[x][y] = 1
			Else			
				map[x][y] = 0
			End If
		Next
		Next
    	For Local i=0  Until 2
	    ' loop through the map
	    For Local y=0 Until ih
	    For Local x=0 Until iw
	        'count the neigbouring 1's 
	        Local cnt = 0
	        For Local y1=-1 To 1
	        For Local x1=-1 To 1
	            Local x2=x+x1
	            Local y2=y+y1
	            If x2>=0 And y2>=0 And x2<iw And y2<ih
	                If map[x][y] = 1 Then cnt+=1
	            End If
	        Next
	        Next
	        ' if 3 walls and map is a wall then map x,y is not a wall anymore
	        If cnt < 4	        	
	                map[x][y] = 0
	        End If
	        ' if more then 4 walls then map x,y is wall
	        If cnt >= 5 Then map[x][y] = 1
	    Next
	    Next
    	Next

		For Local x=0 Until iw
		For Local y=0 Until ih
			If map[x][y] = 1 Then 
			addr2(x,y,1,1,100)
			Else
			addr2(x,y,1,1,40)
			End If
		Next
		Next
	End Method


	Method noisylayer()	
		Local var1:Int=Rnd(3,130)
		Local var2:Int=Rnd(20,200)
		Local depth:Int=Rnd(1,25)
		For Local i=0 To iw*ih*depth
			Local x1:Int=Rnd(iw)
			Local y1:Int=Rnd(ih)
			Local cnt:Int=0
			For Local y2=-5 To 5
			For Local x2=-5 To 5
				Local x3:Int=x1+x2
				Local y3:Int=y1+y2
				If x3>=0 And x3<iw And y3>=0 And y3<ih
				If getred(getmappixel(x3,y3)) > var2 Then
					'addmappixel(x3,y3)
					cnt+=1	
				End If
				End If
			Next
			Next
			If cnt<var1
				addmappixel(x1,y1,Rnd(2,20))
			End If
			cnt=0
		Next
	End Method
	Method addtriangleup()
		Local val:Int=Rnd(-120,120)
		If Rnd()<.5 Then val = Rnd(2,10)
		Local wa:Float=0
		Local wb:Float=iw 
		Local s:Float=Float(ih)/Float(iw)
		For Local y=0 To ih
		For Local x=wa To wb
			addmappixel(x,y,val)			
		Next
			wa+=s
			wb-=s	
		Next
	End Method


	Method addtriangledown()
		Local val:Int=Rnd(-120,120)
		If Rnd()<.5 Then val = Rnd(2,10)
		Local wa:Float=0
		Local wb:Float=iw 
		Local s:Float=Float(ih)/Float(iw)
		For Local y=ih To 0 Step -1
		For Local x=wa To wb
			addmappixel(x,y,val)			
		Next
			wa+=s
			wb-=s	
		Next
	End Method

	Method addtriangleleft()	
		Local val:Int=Rnd(-120,120)
		If Rnd()<.5 Then val = Rnd(2,10)
		Local ha:Float=0
		Local hb:Float=ih
		Local s:Float=((Float(iw)/Float(ih))/3.5)
		For Local x=iw To 0 Step -1
		For Local y=ha To hb
			addmappixel(x,y,val)			
		Next
			ha+=s
			hb-=s	
		Next
	End Method

	Method addoval()
		'oval
		Local val:Int=Rnd(-100,100)
		If Rnd()<.5 Then val=Rnd(-15,15)
		addo(iw/2,ih/2,ih/2,val)
	End Method

	Method addtriangleright()
		Local val:Int=Rnd(-120,120)
		If Rnd()<.5 Then val = Rnd(2,10)
		Local ha:Float=0
		Local hb:Float=ih
		Local s:Float=((Float(iw)/Float(ih))/3.5)
		For Local x=0 To iw
		For Local y=ha To hb
			addmappixel(x,y,val)			
		Next
			ha+=s
			hb-=s	
		Next
	End Method


	Method addheightmap()
		'heightmap
		Local mw:Int=Rnd(5,iw/10)
		Local mh:Int=Rnd(5,ih/10)
		Local cnt:Float=Rnd(1,4)
		For Local i:Int=0 To iw*ih*cnt
			Local x:Int=Rnd(-10,iw)
			Local y:Int=Rnd(-10,ih)
			Local w:Int=Rnd(3,mw)
			Local h:Int=Rnd(3,mh)
			Local val:Int
			If Rnd()<.5 Then val=-1 Else val=1
			addr(x,y,w,h,val)
		Next		
	End Method

	Method tintmap()
		'tint random
		Local r1:Int=Rnd(0,125)
		Local g1:Int=Rnd(0,125)
		Local b1:Int=Rnd(0,125)
		For Local y=0 Until ih
		For Local x=0 Until iw	
			Local r2:Int=getred(getmappixel(x,y))
			Local g2:Int=r2
			Local b2:Int=r2
			setmappixel(x,y,argb(r1+r2/2,g1+g2/2,b1+b2/2))
		Next
		Next
	End Method

    Method decmappixel(x:Int,y:Int,val:Int=10)
    	Local pos:Int=(y*iw)+x
    	If pos<0 Or pos>=iw*ih Then Return
    	Local r:Int=getred(mappixels[pos])-val
    	Local g:Int=getgreen(mappixels[pos])-val
    	Local b:Int=getblue(mappixels[pos])-val    	
    	Local nr:Int=Clamp(r,0,255)
    	Local ng:Int=Clamp(g,0,255)
    	Local nb:Int=Clamp(b,0,255)     	
    	mappixels[pos] = argb(nr,ng,nb)
    End Method
    Method addmappixel(x:Int,y:Int,val:Int=10)
    	Local pos:Int=(y*iw)+x
    	If pos<0 Or pos >=iw*ih Then Return
    	Local r:Int=getred(mappixels[pos])+val
    	Local g:Int=getgreen(mappixels[pos])+val
    	Local b:Int=getblue(mappixels[pos])+val    	
    	Local nr:Int=Clamp(r,0,255)
    	Local ng:Int=Clamp(g,0,255)
    	Local nb:Int=Clamp(b,0,255)    	    	
    	mappixels[pos] = argb(nr,ng,nb)
    End Method


    Method setmappixel:Int(x:Int,y:Int,col)
    	Local pos:Int=(y*iw)+x
    	If pos<0 Or pos>=iw*ih Then Return 0
    	mappixels[pos] = col
    End Method

    Method getmappixel:Int(x:Int,y:Int)
    	Local pos:Int=(y*iw)+x
    	If pos<0 Or pos>=iw*ih Then Return 0
    	Return mappixels[pos]
    End Method

    Method getpixel2:Int(x:Int,y:Int)
    	Local pos:Int=(y*iw)+x
    	If pos<0 Or pos>=iw*ih Then Return 0    	
    	Return mappixels[pos]
    End Method


    Method draw()
		DrawImage mapimage,0,0,0,sc,sc
		SetColor 0,0,0
		DrawRect iw-200,ih-200,200,200
		SetColor 255,255,255
		DrawImage mapimage,iw-200+1,ih-200+1,0,198.0/Float(iw),198.0/Float(ih)
		SetColor 0,0,0
		DrawRect iw-64,ih-64,64,64
		SetColor 255,255,255
		DrawImage mapimage,iw-64+1,ih-64+1,0,62.0/Float(iw),62.0/Float(ih)

    End Method
    Method addr2(x1,y1,w1,h1,val:Int)
        For Local y2=y1 Until y1+h1
        For Local x2=x1 Until x1+w1
            Local pc = y2*iw+x2
            If pc >= 0 And pc < iw*ih
            	Local r1:Int=getred(mappixels[pc])+val
            	Local g1:Int=getgreen(mappixels[pc])+val
            	Local b1:Int=getblue(mappixels[pc])+val
            	r1 = Clamp(r1,0,255)            	            	
            	g1 = Clamp(g1,0,255)
            	b1 = Clamp(b1,0,255)
            	mappixels[pc] = argb(r1,g1,b1)
            End If
        Next
        Next    
   	End Method

    Method addr(x1,y1,w1,h1,val:Int)
        For Local y2=y1 Until y1+h1
        For Local x2=x1 Until x1+w1
            Local pc = y2*iw+x2
            If pc >= 0 And pc < iw*ih
            	Local r1:Int=getred(mappixels[pc])+val
            	Local g1:Int=getgreen(mappixels[pc])+val
            	Local b1:Int=getblue(mappixels[pc])+val
            	r1 = Clamp(r1,0,255)            	            	
            	g1 = Clamp(g1,0,255)
            	b1 = Clamp(b1,0,255)
            	If r1>20 Then mappixels[pc] = argb(r1,g1,b1)
            End If
        Next
        Next    
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
    Method addo(x1,y1,radius:Float,val:Int=10)
        For Local y2=-radius To radius
        For Local x2=-radius To radius
            If (y2*y2+x2*x2) <= radius*radius+radius*0.8
                Local x3 = x2+x1
                Local y3 = y2+y1
                Local pc = y3*iw+x3
                If pc>=0 And pc < iw*ih
                    Local r1:Int=getred(mappixels[pc])
                    Local g1:Int=getgreen(mappixels[pc])
                    Local b1:Int=getblue(mappixels[pc])                                        
                    Local r2:Int=r1+val
                    Local g2:Int=g1+val
                    Local b2:Int=b1+val
                    r2 = Clamp(r2,0,255)
                    g2 = Clamp(g2,0,255)
                    b2 = Clamp(b2,0,255)                                        
                    mappixels[pc] = argb(r2,g2,b2)
                End If
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

Global mytexture:texture

Class MyGame Extends App
	Field cnt:Int=0
    Method OnCreate()
        SetUpdateRate(1)
       	Seed = GetDate[5]
		mytexture = New texture()
    End Method
    Method OnUpdate()
    	cnt+=1
    	If cnt>6 Then
    		mytexture = New texture()
    		cnt=0
    	End If
    End Method
    Method OnRender()
        Cls 50,50,50
		mytexture.draw
		SetColor 255,255,255
 	End Method
End Class


Function Main()
    New MyGame()
End Function
