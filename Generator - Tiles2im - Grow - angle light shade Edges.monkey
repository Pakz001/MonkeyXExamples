'
' Tile generator 
' Lighting/shadow from (angle) side
'


Import mojo

Class tiles

	Field image:Image
	Field imaged:Image
	
	'base color
	Field r:Int,g:Int,b:Int
	'tile width and height
	Field tw:Int,th:Int
	' angle light
	Field angle:Float
	' image array
	Field im:Int[][]
	' double array
	Field imd:Int[][]

	' new tile
	Method New(tw:Int,th:Int,r:Int,g:Int,b:Int,angle:Int)
		Self.tw = tw
		Self.th = th
		Self.r = r
		Self.g = g
		Self.b = b
		Self.angle = angle
		im = New Int[tw][]
		For Local i:Int=0 Until tw
			im[i] = New Int[th]
		Next
		imd = New Int[(tw*2)][]
		For Local i:Int=0 Until (tw*2)
			imd[i] = New Int[(th*2)]
		Next

		createtile()
		createdouble()
		blackedge(Rnd(1,5))

        image = CreateImage(tw, th)
'        Local pixels1:Int[tw * th]
        imaged = CreateImage(tw*2, th*2)
'        Local pixels2:Int[(tw*2) * (th*2)]
		createimages()


		'bars()
	End Method

	Method returncolor:Int(col:Int)
		Select col
			Case 0;Return argb(0,0,0,0)
			Case 1;Return argb(r,g,b)
			Case 2'base color dark
				Return argb(r/4,g/4,b/4)
			Case 3'base color light
				Local r2:Int,g2:Int,b2:Int
				r2 = r*1.2 ; If r2>255 Then r2=255
				g2 = g*1.2 ; If g2>255 Then g2=255
				b2 = b*1.2 ; If b2>255 Then b2=255
				Return argb(r2,g2,b2)
			Case 4'base color slighly darker
				Return argb(r/2,g/2,b/2)
			Case 5'base color slightly lighter
				Local r2:Int,g2:Int,b2:Int
				r2 = r*1.4 ; If r2>255 Then r2=255
				g2 = g*1.4 ; If g2>255 Then g2=255
				b2 = b*1.4 ; If b2>255 Then b2=255
				Return argb(r2,g2,b2)
			Case 99;Return argb(11,11,11)
		End Select	
	End Method
	Method createimages()
        Local pixels1:Int[tw * th]
        Local pixels2:Int[(tw*2) * (th*2)]
        For Local i:Int = 0 Until tw * th
            Local x:Int = i Mod th
            Local y:Int = i / tw
            pixels1[i] = returncolor(im[x][y])            	
        Next
        '
        ' blur
        For Local i:Int = 0 Until ((tw) * (th))
            Local x:Int = i Mod (th)
            Local y:Int = i / (tw)
            Local ra:Int,ga:Int,ba:Int,aa:Int
            Local p:Int
			For Local y2:Int=-1 To 1
			For Local x2:Int=-1 To 1
				Local z1:Int=x2*(tw)
				Local z2:Int=y2
				p=i+z1+z1
				If p<0 Or p>=(tw)*(th) Then Continue
				ra+=getr(pixels1[p])
				ga+=getg(pixels1[p])
				ba+=getb(pixels1[p])
				aa=getalpha(pixels1[p])
			Next
			Next            
			pixels1[i] = argb(ra/9,ga/9,ba/9,aa)
		Next        
        '
        '
		image.WritePixels(pixels1, 0, 0, tw, th, 0)
        For Local i:Int = 0 Until ((tw*2) * (th*2))
            Local x:Int = i Mod (th*2)
            Local y:Int = i / (tw*2)
            pixels2[i] = returncolor(imd[x][y])            	
        Next
        ' blur
        For Local i:Int = 0 Until ((tw*2) * (th*2))
            Local x:Int = i Mod (th*2)
            Local y:Int = i / (tw*2)
            Local ra:Int,ga:Int,ba:Int,aa:Int
            Local p:Int
			For Local y2:Int=-1 To 1
			For Local x2:Int=-1 To 1
				Local z1:Int=x2*(tw*2)
				Local z2:Int=y2
				p=i+z1+z1
				If p<0 Or p>=(tw*2)*(th*2) Then Continue
				ra+=getr(pixels2[p])
				ga+=getg(pixels2[p])
				ba+=getb(pixels2[p])
				aa=getalpha(pixels2[p])
			Next
			Next            
			pixels2[i] = argb(ra/9,ga/9,ba/9,aa)
		Next        
        '
		imaged.WritePixels(pixels2, 0, 0, tw*2, th*2, 0)

	End Method
	Method createdouble()
		For Local y:Int=0 Until th
		For Local x:Int=0 Until tw
			For Local y2:Int=0 To 1
			For Local x2:Int=0 To 1
				imd[x*2+x2][y*2+y2] = im[x][y]
			Next
			Next
		Next
		Next
		Local imt[][] = New Int[(tw*2)][]
		For Local i:Int=0 Until (tw*2)
			imt[i] = New Int[(th*2)]
		Next

		For Local y:Int=1 Until th*2-1
		For Local x:Int=1 Until tw*2-1
			If imd[x][y] > 1 
				Local v:Int=imd[x][y]
				If imd[x+1][y+1] = 1 
					imt[x][y] = 1
				End If
				If imd[x-1][y-1] = 1
					imt[x][y] = 1
				End If
				If imd[x+1][y-1] = 1
					imt[x][y] = 1
				End If
				If imd[x-1][y+1] = 1 
					imt[x][y] = 1
				End If

			Endif
		Next
		Next
		For Local y:Int=0 Until th*2
		For Local x:Int=0 Until tw*2
			If imt[x][y] = 1 Then imd[x][y] = 1
		Next
		Next
	End Method
	Method createtile()
		'grow some area
		im[Rnd(tw/2-tw/9,tw/2+tw/9)][Rnd(th/2-th/9,th/2+th/9)] = 1
		im[Rnd(tw/2-tw/9,tw/2+tw/9)][Rnd(th/2-th/9,th/2+th/9)] = 1
		grow
		edgelight
		edgenoise()
'		bars()
	End Method
	'
	Method blackedge(size:Int)
		If size<=0 Or size>=10 Then Return
		'make black edge around double im
		Local imdt:Int[][]
		imdt = New Int[tw*2][]
		For Local i:Int=0 Until tw*2
			imdt[i] = New Int[th*2]
		Next
		For Local y:Int=size Until th*2-size
		For Local x:Int=size Until tw*2-size
			If imd[x][y] = 0
				For Local y2:Int=y-size To y+size
				For Local x2:Int=x-size To x+size
					If imd[x2][y2] > 0
						imdt[x][y] = 1
					End If
				Next
				Next
			End If
		Next
		Next
		For Local y:Int=0 Until th*2
		For Local x:Int=0 Until tw*2
			If imdt[x][y] > 0 Then imd[x][y] = 99
		Next
		Next
		'make black edge around im
		Local imt:Int[][]
		imt = New Int[tw][]
		For Local i:Int=0 Until tw
			imt[i] = New Int[th]
		Next
		For Local y:Int=size Until th-size
		For Local x:Int=size Until tw-size
			If im[x][y] = 0
				For Local y2:Int=y-size To y+size
				For Local x2:Int=x-size To x+size
					If im[x2][y2] > 0
						imt[x][y] = 1
					End If
				Next
				Next
			End If
		Next
		Next
		For Local y:Int=0 Until th
		For Local x:Int=0 Until tw
			If imt[x][y] > 0 Then im[x][y] = 99
		Next
		Next

	End Method
	'
	' Add some light bars ontop of base color
	'
	Method bars()
		For Local x:Int=-50 Until tw+50 Step 10
			Local x2:Int=x+2
			For Local y:Int=0 Until th
				Local xa:Int=x2
				Local ya:Int=y
				x2+=1
				If xa<0 Or ya<0 Or xa>=tw Or ya>=th Then Continue
				For Local z:Int=0 Until 3
					If xa+z<0 Or xa+z>=tw Then Continue
					If im[xa+z][ya] = 1 Then im[xa+z][ya] = 3
				Next
	
			Next
		Next
'
		For Local x:Int=-tw Until (tw*2)+50 Step 16
			Local x2:Int=x+2
			For Local y:Int=0 Until th*2
				Local xa:Int=x2
				Local ya:Int=y
				x2+=1
				If xa<0 Or ya<0 Or xa>=tw*2 Or ya>=th*2 Then Continue
				For Local z:Int=0 Until 8
					If xa+z<0 Or xa+z>=tw*2 Then Continue
					If z=7 And imd[xa+z][ya] = 1 Then imd[xa+z][ya] = 5
					If imd[xa+z][ya] = 1 Then imd[xa+z][ya] = 3
					
				Next
	
			Next
		Next
		
	End Method
	' grow the base a certain amount
	Method grow()
		For Local i:Int=0 Until tw*th*(tw/4)
			Local x:Int=Rnd(7,tw-7)
			Local y:Int=Rnd(7,th-7)
			If im[x][y] = 1 Then
				im[Rnd(x-1,x+2)][Rnd(y-1,y+2)] = 1
			End If
		Next
	End Method
	' add light and shadows to the sides
	' starts from the center and goes to the outside
	' in all angles and finds edge and creates lighter or
	' darker value
	'
	' 
	Method edgelight()
		Local tim:Int[][]
		tim = New Int[tw][]
		For Local i:Int=0 Until tw
			tim[i] = New Int[th]
		Next
		
		For Local a:Float=angle Until angle+360 Step .1
			Local x:Float=tw/2
			Local y:Float=th/2
			While x>1 And y>1 And x<=tw-2 And y<=th-2
				x+=Cos(a)
				y+=Sin(a)
				If im[x][y] = 1
				For Local ia:Int=-1 To 1
				For Local ib:Int=-1 To 1
					If im[x+ia][y+ib] = 0
						If a>angle+180 Then tim[x][y] = 3 Else tim[x][y]=2
					End If
				Next
				Next
				End If
			Wend
		Next
		For Local y:Int=0 Until th
		For Local x:Int=0 Until tw
			If tim[x][y]>0 Then im[x][y] = tim[x][y]
		Next
		Next
		
	End Method
	'
	' Find the edges and adds randomly
	' a extra light or dark value
	'
	Method edgenoise()
		Local amountnoise:Float=Rnd(4,6)
		For Local i:Int=0 Until tw*th*amountnoise
			Local x:Int=Rnd(2,tw-3)
			Local y:Int=Rnd(2,th-3)
			Local v:Int=im[x][y]
			If v=2 Or v=3
				Local x2:Int=x+Rnd(-2,2)
				Local y2:Int=y+Rnd(-2,2)
				' if current position on array is base color
				' then add noise(current light or dark color)
				If im[x2][y2] = 1 'Or im[x2][y2] = v
					im[x2][y2] = v+2
				End If
			End If
		Next
	End Method
	Method drawdoublearray(sx:Int,sy:Int)
		'0 = black
		'1 = base color
		'2 = base color dark
		'3 = base color light
		'4 = base color slightly darker
		'5 = base color slightly ligher
		For Local y:Int=0 Until th*2
		For Local x:Int=0 Until tw*2
			If imd[x][y] = 0 Then Continue
			setcolor(imd[x][y])
'			DrawRect sx+x*3,sy+y*3,3,3
			DrawRect sx+x,sy+y,1,1			
		Next
		Next
	End Method

	Method drawarray(sx:Int,sy:Int)
		'0 = black
		'1 = base color
		'2 = base color dark
		'3 = base color light
		'4 = base color slightly darker
		'5 = base color slightly ligher
		For Local y:Int=0 Until th
		For Local x:Int=0 Until tw
			If im[x][y] = 0 Then Continue
			setcolor(im[x][y])
'		DrawRect sx+x*3,sy+y*3,3,3
			DrawRect sx+x,sy+y,1,1			
		Next
		Next
	End Method
	Method setcolor(col:Int)
		Select col
			Case 0;SetColor 0,0,0
			Case 1;SetColor r,g,b
			Case 2'base color dark
				SetColor r/4,g/4,b/4
			Case 3'base color light
				Local r2:Int,g2:Int,b2:Int
				r2 = r*1.2 ; If r2>255 Then r2=255
				g2 = g*1.2 ; If g2>255 Then g2=255
				b2 = b*1.2 ; If b2>255 Then b2=255
				SetColor r2,g2,b2
			Case 4'base color slighly darker
				SetColor r/2,g/2,b/2
			Case 5'base color slightly lighter
				Local r2:Int,g2:Int,b2:Int
				r2 = r*1.4 ; If r2>255 Then r2=255
				g2 = g*1.4 ; If g2>255 Then g2=255
				b2 = b*1.4 ; If b2>255 Then b2=255
				SetColor r2,g2,b2
			Case 99;SetColor 11,11,11	
				
		End Select
		
	End Method
	Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
		Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
	End Function	
	Function getr:Int(rgba:Int)    
	    Return((rgba Shr 16) & $FF)    
	End Function
	              
	Function getg:Int(rgba:Int)    
	    Return((rgba Shr 8) & $FF)    
	End Function
	    
	Function getb:Int(rgba:Int)    
	    Return(rgba & $FF)    
	End Function
	    
	Function getalpha:Int(rgba:Int)    
	    Return ((rgba Shr 24) & $FF)    
	End Function	
End Class

Class MyGame Extends App
	Field tile:tiles[]
	Field t:Int=0
    Method OnCreate()
        SetUpdateRate(1)
        newtiles()
    End Method
    Method OnUpdate()        
    	t+=1
    	If t>5
    		t=0
    		newtiles()
    	End If
    End Method
    Method OnRender()
        Cls 125,125,125 
        SetColor 255,255,255
		Local cnt:Int=0
		For Local y:Int=1 Until 5
		For Local x:Int=1 Until 5
			'tile[cnt].drawdoublearray(x*100,y*80)
			'tile[cnt].drawarray(x*100,y*80)
			DrawImage(tile[cnt].imaged,x*100,y*80)
			DrawImage(tile[cnt].image,x*100,y*80)
			
			cnt+=1
		Next
		Next

    End Method
    Method newtiles()
		tile = New tiles[16]
		Local angle:Int=Rnd(360)		
		For Local i:Int=0 Until 16
			Local s:Int=Rnd(32,100)
			tile[i] = New tiles(s,s,100+Rnd(100),100+Rnd(100),100+Rnd(100),angle)
		Next		    	
    End Method
End Class


Function Main()
    New MyGame()
End Function
