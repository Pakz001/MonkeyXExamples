Import mojo

Global screenwidth:Int=640
Global screenheight:Int=480


Class texture

	Field mapimage:Image
	Field mappixels:Int[]

    Field iw:Int=screenwidth
    Field ih:Int=screenheight

    Method New()
    	Seed = GetDate[5]

        mappixels = New Int[iw*ih]
        mapimage = CreateImage(iw,ih)
		render1(Rnd(5,30),Rnd(20,100),Rnd(1,15))
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
				addmappixel(x1,y1)
			End If
			cnt=0
		Next
		mapimage.WritePixels(mappixels, 0, 0, iw, ih, 0)
	End Method

    Method update()

    End Method

    Method decmappixel(x:Int,y:Int)
    	Local pos:Int=(y*iw)+x
    	Local r:Int=getred(mappixels[pos])-10
    	Local g:Int=getgreen(mappixels[pos])-10
    	Local b:Int=getblue(mappixels[pos])-10	    	
    	Local nr:Int=Clamp(r,0,255)
    	Local ng:Int=Clamp(g,0,255)
    	Local nb:Int=Clamp(b,0,255)     	
    	mappixels[pos] = argb(nr,ng,nb)
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


    Method getmappixel:Int(x:Int,y:Int)
    	Local pos:Int=(y*iw)+x
    	Return mappixels[pos]
    End Method

    Method getpixel2:Int(x:Int,y:Int)
    	Local pos:Int=(y*iw)+x
    	Return mappixels[pos]
    End Method


    Method draw()
		DrawImage mapimage,0,0,0
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

Global mytexture:texture

Class MyGame Extends App
	Field cnt:Int=0
    Method OnCreate()
        SetUpdateRate(1)
		mytexture = New texture()
    End Method
    Method OnUpdate()
    	cnt+=1
    	If cnt>3 Then
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
