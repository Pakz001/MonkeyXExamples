Import mojo

Global screenwidth:Int=640
Global screenheight:Int=480


Class texture

	Field mapimage:Image
	Field mappixels:Int[]

    Field iw:Int=screenwidth
    Field ih:Int=screenheight

	Field sc:Int=Rnd(1,3)
    Method New()   
        mappixels = New Int[iw*ih]
        mapimage = CreateImage(iw,ih)
		render1(Rnd(3,130),Rnd(20,200),Rnd(1,25))
    End Method

	Method render1(var1:Int,var2:Int,depth:Int)        
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
		'
		If Rnd()<.5
		Local val:Int=Rnd(2,120)
		If Rnd()<.5 Then val = Rnd(2,10)
		Local y:Int=0
		Local v1:Int=Rnd(6,20)
		Local v2:Int=v1/2
		While y<ih
		For Local x=0 To iw
			For Local i=0 To v2
			decmappixel(x,y+i,val)
			Next
		Next
		y+=v1
		Wend
		End If
		'
		If Rnd()<.5
		Local val:Int=Rnd(2,120)
		If Rnd()<.5 Then val = Rnd(2,10)
		For Local x=0 To iw Step 8
		For Local y=0 To ih 
			For Local i=0 To 4
			decmappixel(x+i,y,val)
			Next
		Next
		Next
		End If

		If Rnd()<.5
		Local val:Int=Rnd(2,120)
		If Rnd()<.5 Then val = Rnd(2,10)
		For Local y=0 To ih Step 8
		For Local x=0 To iw
			For Local i=0 To 4
			addmappixel(x,y+i,val)
			If Rnd()<.5 Then addmappixel(x+i,y,val)
			Next
		Next
		Next
		End If
		'
		If Rnd()<.5
		Local val:Int=Rnd(2,120)
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
		End If

		If Rnd()<.5
		Local val:Int=Rnd(2,120)
		If Rnd()<.5 Then val = Rnd(2,10)
		Local x:Int=0
		Local x1:Int=-iw
		Local v1:Int=Rnd(8,iw/5)
		Local v2:Int=v1/2
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
		End If


		'triangle down
		If Rnd()<.2
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
	
		End If		
		
		'triangle down
		If Rnd()<.2
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
	
		End If		


		'triangle left
		If Rnd()<.2
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
	
		End If			

		'triangle Right
		If Rnd()<.5
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
	
		End If			

		'oval
		If Rnd()<.2 Then
			Local val:Int=Rnd(-100,100)
			If Rnd()<.5 Then val=Rnd(-15,15)
			addo(iw/2,ih/2,ih/2,val)
		End If

		mapimage.WritePixels(mappixels, 0, 0, iw, ih, 0)
	End Method

    Method update()

    End Method

    Method decmappixel(x:Int,y:Int,val:Int=10)
    	Local pos:Int=(y*iw)+x
    	If pos<0 Or pos>iw*ih Then Return
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
    	If pos<0 Or pos >iw*ih Then Return
    	Local r:Int=getred(mappixels[pos])+val
    	Local g:Int=getgreen(mappixels[pos])+val
    	Local b:Int=getblue(mappixels[pos])+val    	
    	Local nr:Int=Clamp(r,0,255)
    	Local ng:Int=Clamp(g,0,255)
    	Local nb:Int=Clamp(b,0,255)    	    	
    	mappixels[pos] = argb(nr,ng,nb)
    End Method


    Method getmappixel:Int(x:Int,y:Int)
    	Local pos:Int=(y*iw)+x
    	If pos<0 Or pos>iw*ih Then Return 0
    	Return mappixels[pos]
    End Method

    Method getpixel2:Int(x:Int,y:Int)
    	Local pos:Int=(y*iw)+x
    	If pos<0 Or pos>iw*ih Then Return 0    	
    	Return mappixels[pos]
    End Method


    Method draw()
		DrawImage mapimage,0,0,0,sc,sc
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
    	If cnt>5 Then
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
