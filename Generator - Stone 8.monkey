Import mojo

Class gridbackground
    Field mapwidth:Int
    Field mapheight:Int
    Field tilewidth:Float
    Field tileheight:Float
    Field mapdepth:Int
    Field mapr:Int[][]
    Field mapg:Int[][]
    Field mapb:Int[][]    
    Field pixels:Int[]
    Field image:Image
    Method New(mapwidth:Int,mapheight:Int)
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        pixels = New Int[mapwidth*mapheight]
        image = CreateImage(mapwidth,mapheight)
        tilewidth = DeviceWidth()/Float(mapwidth)
        tileheight = DeviceHeight()/Float(mapheight)
        mapr = New Int[mapwidth][]
        mapg = New Int[mapwidth][]
        mapb = New Int[mapwidth][]                
        For Local i = 0 Until mapwidth
            mapr[i] = New Int[mapheight]
			mapg[i] = New Int[mapheight]            
			mapb[i] = New Int[mapheight]
        Next 
        'addrectslayer
        'mapsetcolor(255,255,255)
        makepatterns()
        brusheffect2
        invertcolors
        'tintrange(0,256,40,4,1)
        darkenrange(100,255,50)
        makelines
'        smooth
        lightenrange(100,255)
   		'brusheffect3
       	'
        
        'makelines()
        'brusheffect2
        'smooth
		'tintrange(0,50,140,140,140)
        'highsmoothrange(150,255,10)
        'darkenrange(0,71,50)
        'lightenrange(0,100)
        'smoothrange(0,50)
'		makelines()        
        'smooth
		'brusheffect3
        'brusheffect2()
		'
		'smooth		
		'lightenrange(0,30,60)
		'setrangeto(150,200,240,240,240)
		
		'brusheffect2
		'broadenrange(0,55)
        'smooth		
		'avarage
        putinimage
    End Method
    Method invertcolors()
    	For Local y=0 Until mapwidth
    	For Local x=0 Until mapheight
    		mapr[x][y] = 255-mapr[x][y]
    		mapg[x][y] = 255-mapg[x][y]
    		mapb[x][y] = 255-mapb[x][y] 
    		mapr[x][y] = Clamp(mapr[x][y],0,255)
	   		mapg[x][y] = Clamp(mapg[x][y],0,255)
    		mapb[x][y] = Clamp(mapb[x][y],0,255)	   		
    	Next
    	Next
    End Method
    Method makepatterns()
    	For Local ii=0 Until 30
			Local x:Int=Rnd(0,mapwidth)
	  		Local y:Int=Rnd(0,mapheight)
	  		Local w:Int=Rnd(3,10)
	  		Local h:Int=Rnd(3,10)
	  		mapdrawrect(x,y,w,h,255,255,255)
	  		For Local i=0 Until (mapwidth*mapheight)/30
				Local x2:Int=Rnd(0,mapwidth)
				Local y2:Int=Rnd(0,mapheight)
				w=Rnd(3,10)			
				h=Rnd(3,10)
				Local connect:Bool=False
				Local sy:Int=h/4
				Local sx:Int=w/4
				For Local y3=y2 Until y2+h Step 3			
				For Local x3=x2 Until x2+w Step 3
					If x3>-1 And y3>-1 And x3<mapwidth And y3<mapheight
						If mapr[x3][y3] > 254 And mapg[x3][y3] > 254 And mapb[x3][y3] > 254
							connect=True
						End If
					End If
				Next
				Next
	  			If connect=True  				
	  				mapdrawrect(x2,y2,w,h,255,255,255)
	  			End If
	  		Next
		Next    	
    End Method
    Method lightenrange(low:Int,high:Int)
    	For Local i=0 Until (mapwidth*mapheight)*4
    	Local x1:Int=Rnd(1,mapwidth-1)
    	Local y1:Int=Rnd(1,mapheight-1)
    	Local cnt:Int=0
    	For Local y=-1 To 1
    	For Local x=-1 To 1
    		If mapr[x1+x][y1+y] > low And mapr[x1+x][y1+y] < high
    		If mapg[x1+x][y1+y] > low And mapg[x1+x][y1+y] < high
    		If mapb[x1+x][y1+y] > low And mapb[x1+x][y1+y] < high    		    		
    			cnt+=1
				
    		End If
    		End If
    		End If
    	Next
    	Next
     	If cnt>7 Then 
    		mapr[x1][y1] = Clamp(mapr[x1][y1] + 20,0,255)
    		mapg[x1][y1] = Clamp(mapg[x1][y1] + 20,0,255)    	
    		mapb[x1][y1] = Clamp(mapb[x1][y1] + 20,0,255)    	
    	End If
    	Next
    End Method
    Method smoothrange(low:Int,high:Int)
   		For Local i=0 Until (mapwidth*mapheight)/5
			Local x:Int=Rnd(1,mapwidth-1)
			Local y:Int=Rnd(1,mapheight-1)
			Local r1:Int=mapr[x][y]
			Local g1:Int=mapg[x][y]
			Local b1:Int=mapb[x][y]			
			Local r2:Int=mapr[x+1][y]
			Local g2:Int=mapg[x+1][y]
			Local b2:Int=mapb[x+1][y]			
			Local r3:Int=mapr[x][y+1]
			Local g3:Int=mapg[x][y+1]
			Local b3:Int=mapb[x][y+1]			
			Local r4:Int=mapr[x+1][y+1]
			Local g4:Int=mapg[x+1][y+1]
			Local b4:Int=mapb[x+1][y+1]
			If r1<high And g1<high And b1<high			
			If r1>low And g1>low And b1>low
			Local valr:Int=(r2+r3+r4)/3
			Local valg:Int=(g2+g3+g4)/3
			Local valb:Int=(b2+b3+b4)/3
			valr = Clamp(valr,0,255)
			valg = Clamp(valg,0,255)
			valb = Clamp(valb,0,255)
			mapr[x][y] = valr
			mapg[x][y] = valg
			mapb[x][y] = valb			
			End If
			End If
		Next    
    End Method
    Method highsmoothrange(low:Int,high:Int,perc:Float)
   		For Local i=0 Until (mapwidth*mapheight)*perc
			Local x:Int=Rnd(1,mapwidth-1)
			Local y:Int=Rnd(1,mapheight-1)
			Local r1:Int=mapr[x][y]
			Local g1:Int=mapg[x][y]
			Local b1:Int=mapb[x][y]			
			Local r2:Int=mapr[x+1][y]
			Local g2:Int=mapg[x+1][y]
			Local b2:Int=mapb[x+1][y]			
			Local r3:Int=mapr[x][y+1]
			Local g3:Int=mapg[x][y+1]
			Local b3:Int=mapb[x][y+1]			
			Local r4:Int=mapr[x+1][y+1]
			Local g4:Int=mapg[x+1][y+1]
			Local b4:Int=mapb[x+1][y+1]
			If r1<high And g1<high And b1<high
			If r1>low And g1>low And b1>low			
			Local valr:Int=((r1+r2+r3+r4)/4)*1.2
			Local valg:Int=((g1+g2+g3+g4)/4)*1.2
			Local valb:Int=((b1+b2+b3+b4)/4)*1.2						
			valr = Clamp(valr,0,255)
			valg = Clamp(valg,0,255)
			valb = Clamp(valb,0,255)
			mapr[x][y] = valr
			mapg[x][y] = valg
			mapb[x][y] = valb			
			End If
			End if
		Next
    End Method
    Method lightenrange(low:Int,high:Int,perc:Float)
		For Local i=0 Until (mapwidth*mapheight)*perc
			Local x:Int=Rnd(0,mapwidth)
			Local y:Int=Rnd(0,mapheight)
			mapr[x][y] = (mapr[x][y]/100)*perc
			mapg[x][y] = (mapg[x][y]/100)*perc
			mapb[x][y] = (mapb[x][y]/100)*perc
		Next
    End Method
    Method makelines2()
    	For Local i=0 Until (mapwidth*mapheight)/50
    		Local x:Int=Rnd(0,mapwidth)
    		Local y:Int=Rnd(0,mapheight)
    		Local dist:Int=Rnd(1,13)
    			Local col:Int=Rnd(0,55)
    			makelinesolid(x,y,dist,col,col,col)
   		Next
    End Method

    Method makelines()
    	For Local i=0 Until (mapwidth*mapheight)/50
    		Local x:Int=Rnd(0,mapwidth)
    		Local y:Int=Rnd(0,mapheight)
    		Local dist:Int=Rnd(1,3)
    		makelineshade(x,y,dist)
   		Next
    End Method
    Method makelineshade(x:Float,y:Float,dist:Float)
    	Local angle:Float=Rnd(0,360)
    	For Local i:Float = 0 Until dist Step 0.2
    		Local beh:Int=Rnd(10)
    		If beh<5
	    		x+=Cos(angle)
    			y+=Sin(angle)
    		Elseif beh>4 And beh<8
    			angle-=Rnd(1,15)
    			If angle<0 Then angle= 360-angle
    			x+=Cos(angle)
    			y+=Sin(angle)
    		Else
    			angle+=Rnd(1,15)
    			If angle>359 Then angle = 0+angle
    			x+=Cos(angle)
    			y+=Sin(angle)    			
    		End If
    		If x>-1 And y>-1 And x<mapwidth And y<mapheight
    			Local valr:Int=mapr[x][y] / 2
    			Local valg:Int=mapg[x][y] / 2
    			Local valb:Int=mapb[x][y] / 2
    			valr = Clamp(valr,0,255)
    			valg = Clamp(valg,0,255)
    			valb = Clamp(valb,0,255)
    			mapr[x][y] = valr
    			mapg[x][y] = valg
    			mapb[x][y] = valb
    		End If
    	Next
    End Method

    Method makelinesolid(x:Float,y:Float,dist:Float,r:Int,g:Int,b:Int)
    	Local angle:Float=Rnd(0,360)
    	For Local i:Float = 0 Until dist Step 0.2
    		Local beh:Int=Rnd(10)
    		If beh<5
	    		x+=Cos(angle)
    			y+=Sin(angle)
    		Elseif beh>4 And beh<8
    			angle-=Rnd(1,15)
    			If angle<0 Then angle= 360-angle
    			x+=Cos(angle)
    			y+=Sin(angle)
    		Else
    			angle+=Rnd(1,15)
    			If angle>359 Then angle = 0+angle
    			x+=Cos(angle)
    			y+=Sin(angle)    			
    		End If
    		If x>-1 And y>-1 And x<mapwidth And y<mapheight
    			mapr[x][y] = r
    			mapg[x][y] = g
    			mapb[x][y] = b    		    		
    		End If
    	Next
    End Method
    Method mapsetcolor(r:Int,g:Int,b:Int)
    	For Local y=0 Until mapheight
    	For Local x=0 Until mapwidth
    		mapr[x][y] = r
    		mapg[x][y] = g
    		mapb[x][y] = b 
    	Next
    	Next
    End Method
    Method brusheffect3()
    	For Local i=0 Until (mapwidth*mapheight)/100
    		Local x1:Float=Rnd(1,mapwidth-1)
    		Local y1:Float=Rnd(1,mapheight-1)
    		mapr[x1][y1] = 0
    		mapg[x1][y1] = 0
    		mapb[x1][y1] = 0   
    		For Local angle=-180 To 180 Step 20
    			Local dist:Int=Rnd(3,18)
    			For Local ii=0 Until dist
    				Local x2:Float=x1+(Cos(angle)*ii)
    				Local y2:Float=y1+(Sin(angle)*ii)
    				Local x3:Float=x1+(Cos(angle)*(ii+1))	
    				Local y3:Float=y1+(Sin(angle)*(ii+1))
    				If x2>-1 And y2>-1 And x2<mapwidth And y2<mapheight
    				If x3>-1 And y3>-1 And x3<mapwidth And y3<mapheight
    					mapr[x3][y3] = mapr[x2][y2]+dist
    					mapg[x3][y3] = mapg[x2][y2]+dist
    					mapb[x3][y3] = mapb[x2][y2]+dist
    					'mapr[x2][y2] = 255    					
    				End If
    				End If
    			Next
    		Next
    	Next
    End Method
    Method tintrange(low:Int,high:Int,tr:Int,tg:Int,tb:Int)
    	For Local y=0 Until mapheight
    	For Local x=0 Until mapwidth
			Local r:Int=mapr[x][y]
			Local g:Int=mapg[x][y]
			Local b:Int=mapb[x][y]						
			If r>=low And r<=high
			If g>=low And g<=high
			If b>=low And b<=high
				Local m:Int=Rnd(-10,10)
				mapr[x][y] = Clamp(r+tr+m,0,255)
				mapg[x][y] = Clamp(g+tg+m,0,255)				
				mapb[x][y] = Clamp(b+tb+m,0,255)
			End If
			End If
			End If
    	Next
    	Next
    End Method
    Method broadenrange(low:Int,high:Int)
    	For Local i=0 Until (mapwidth*mapheight)/10
    		Local x:Int=Rnd(0,mapwidth-1)
    		Local y:Int=Rnd(0,mapheight-1)
    		Local r1:Int=mapr[x][y]
    		Local g1:Int=mapg[x][y]
    		Local b1:Int=mapb[x][y]    		
    		If r1>low And g1>low And b1>low
    		If r1<high And g1<high And b1<high
    			mapr[x+1][y] = r1
    			mapr[x][y+1] = r1
    			mapr[x+1][y+1] = r1
    			mapg[x+1][y] = g1
    			mapg[x][y+1] = g1
    			mapg[x+1][y+1] = g1
    			mapb[x+1][y] = b1
    			mapb[x][y+1] = b1
    			mapb[x+1][y+1] = b1
    		End If
    		End If
    	Next
    End Method
    Method setrangeto(low:Int,high:Int,r:Int,g:Int,b:Int)
    	For Local y=0 Until mapheight
    	For Local x=0 Until mapwidth
    		If mapr[x][y] >= low And mapr[x][y] <= high
    			mapr[x][y] = r
    		Endif
    		If mapg[x][y] >= low And mapg[x][y] <= high
    			mapg[x][y] = r
    		Endif
    		If mapb[x][y] >= low And mapb[x][y] <= high
    			mapb[x][y] = r
    		Endif

    	Next
    	Next
    End Method
    Method lightenrange(low:Int,high:Int,ranval:Int)
    	For Local y=0 Until mapheight
    	For Local x=0 Until mapwidth
			If mapr[x][y] < high
				mapr[x][y] += Rnd(ranval/2,ranval)
				mapg[x][y] += Rnd(ranval/2,ranval)
				mapb[x][y] += Rnd(ranval/2,ranval)
			End If
			If mapg[x][y] < high
				mapr[x][y] += Rnd(ranval/2,ranval)
				mapg[x][y] += Rnd(ranval/2,ranval)
				mapb[x][y] += Rnd(ranval/2,ranval)
			End If
			If mapb[x][y] < high
				mapr[x][y] += Rnd(ranval/2,ranval)
				mapg[x][y] += Rnd(ranval/2,ranval)
				mapb[x][y] += Rnd(ranval/2,ranval)
			End If

		Next
		Next    	    	
End Method
    Method avarage()
    	For Local i=0 Until (mapwidth*mapheight)/100
    		Local x1:Int=Rnd(0,mapwidth)
    		Local y1:Int=Rnd(0,mapheight)
    		Local col1r:Int=mapr[x1][y1]
    		Local col1g:Int=mapg[x1][y1]
    		Local col1b:Int=mapb[x1][y1]
		   	For Local ii=0 Until (mapwidth*mapheight)/50
	    		Local x2:Int=Rnd(0,mapwidth)
	    		Local y2:Int=Rnd(0,mapheight)
	   			If mapr[x2][y2] < col1r Then mapr[x2][y2] += 1
	   			If mapg[x2][y2] < col1g Then mapg[x2][y2] += 1
	   			If mapb[x2][y2] < col1b Then mapb[x2][y2] += 1

   				If mapr[x2][y2] > col1r Then mapr[x2][y2] -= 1
	   			If mapg[x2][y2] > col1g Then mapg[x2][y2] -= 1
	   			If mapb[x2][y2] > col1b Then mapb[x2][y2] -= 1
			Next
	   	Next
    End Method
    Method darkenrange(low:Int,high:Int,ranval:Int)
    	For Local y=0 Until mapheight
    	For Local x=0 Until mapwidth
			If mapr[x][y] > low
				mapr[x][y] -= Rnd(ranval/2,ranval)
				mapg[x][y] -= Rnd(ranval/2,ranval)
				mapb[x][y] -= Rnd(ranval/2,ranval)
			End If
			If mapg[x][y] > low
				mapr[x][y] -= Rnd(ranval/2,ranval)
				mapg[x][y] -= Rnd(ranval/2,ranval)
				mapb[x][y] -= Rnd(ranval/2,ranval)
			End If
			If mapb[x][y] > low
				mapr[x][y] -= Rnd(ranval/2,ranval)
				mapg[x][y] -= Rnd(ranval/2,ranval)
				mapb[x][y] -= Rnd(ranval/2,ranval)
			End If
			mapr[x][y] = Clamp(mapr[x][y],0,255)
			mapg[x][y] = Clamp(mapg[x][y],0,255)
			mapb[x][y] = Clamp(mapb[x][y],0,255)						
		Next
		Next    	
    End Method
    Method smooth()
    	For Local i=0 Until (mapwidth*mapheight)
    		Local x:Int=Rnd(1,mapwidth-1)
    		Local y:Int=Rnd(1,mapheight-1)

    		Local col1r:Int=mapr[x+1][y]
    		Local col1g:Int=mapg[x+1][y]
    		Local col1b:Int=mapb[x+1][y]    		    		
    		
    		Local col2r:Int=mapr[x+1][y+1]
	   		Local col2g:Int=mapg[x+1][y+1]    		
    		Local col2b:Int=mapb[x+1][y+1]
    		
    		Local col3r:Int=mapr[x][y+1]    		    		
    		Local col3g:Int=mapg[x][y+1]    		    		
    		Local col3b:Int=mapb[x][y+1]    		    		

    		Local col4r:Int=(col1r+col2r+col3r)/3
    		Local col4g:Int=(col1g+col2g+col3g)/3
    		Local col4b:Int=(col1b+col2b+col3b)/3    		    		
    		mapr[x][y] = col4r
    		mapg[x][y] = col4g
    		mapb[x][y] = col4b
    		mapr[x][y] = Clamp(mapr[x][y],0,255)
    		mapg[x][y] = Clamp(mapg[x][y],0,255)
    		mapb[x][y] = Clamp(mapb[x][y],0,255)
    	Next
    End Method
    Method brusheffect() 'explosion effect copy from in area to another part in area in half the brishtness
    	For Local i=0 Until (mapwidth*mapheight)/20
    		Local x:Int=Rnd(-3,mapwidth)
    		Local y:Int=Rnd(-3,mapheight)
    		For Local y1=-5 To 5
    		For Local x1=-5 To 5
    			Local x2:Int=x+x1
    			Local y2:Int=y+y1
				If Rnd(10)<3
				If x2>-1 And y2>-1 And x2<mapwidth And y2<mapheight
					Local colr:Int=mapr[x2][y2]
					Local colg:Int=mapg[x2][y2]
					Local colb:Int=mapb[x2][y2]
					
					Local x3:Int=x2+Rnd(-5,5)
					Local y3:Int=y2+Rnd(-5,5)
					If x3>-1 And y3>-1 And x3<mapwidth And y3<mapheight
						mapr[x3][y3] = (colr)/2
						mapg[x3][y3] = (colg)/2
						mapb[x3][y3] = (colb)/2
					End If
				End If
				End If
    		Next
    		Next
    	Next
    End Method
    Method brusheffect2()
    	For Local i=0 Until (mapwidth*mapheight)/20
    		Local x1:Float=Rnd(0,mapwidth)
    		Local y1:Float=Rnd(0,mapheight)
    		Local angle:Int=Rnd(-180,180)
    		Local dist:Int=Rnd(3,15)
    		For Local iii=0 Until 20
    		For Local ii=0 Until dist
    			Local x4:Float=x1+Rnd(-5,5)
    			Local y4:Float=y1+Rnd(-5,5)
    			Local x2:Float=x4+Cos(angle)*1
    			Local y2:Float=y4+Sin(angle)*1
    			Local x3:Float=x4+Cos(angle)*2
    			Local y3:Float=y4+Sin(angle)*2
    			If x2>-1 And y2>-1 And x2<mapwidth And y2<mapheight
    			If x3>-1 And y3>-1 And x3<mapwidth And y3<mapheight
    				mapr[x3][y3] = mapr[x2][y2]/1.5
    				mapg[x3][y3] = mapg[x2][y2]/1.5
    				mapb[x3][y3] = mapb[x2][y2]/1.5
    			End If
    			End If    			
			Next
			Next
    	Next
    End Method    
    Method addrectslayer()
    	For Local i=0 Until (mapwidth*mapheight)/400
    		Local w:Int=Rnd(10,mapwidth/10)
    		Local h:Int=Rnd(10,mapwidth/10)
    		Local x:Int=Rnd(-3,mapwidth)
    		Local y:Int=Rnd(-3,mapheight)
    		Local colr:Int=255
    		Local colg:Int=255
    		Local colb:Int=255
    		mapdrawrect(x,y,w,h,colr,colg,colb)
    	Next
    End Method
    Method mapdrawrect(x:Int,y:Int,w:Int,h:Int,colr:Int,colg:Int,colb:Int)
    	For Local y1=y Until y+h
    	For Local x1=x Until x+w
    		If x1>-1 And y1>-1 And x1<mapwidth And y1<mapheight
    			mapr[x1][y1] = colr
    			mapg[x1][y1] = colg
    			mapb[x1][y1] = colb
    		End If
    	Next
    	Next
    End Method
    Method draw()
    	Local sx:Float=5
    	Local sy:Float=3.75
		If mapwidth>255 Then sx = 2.5 ; sy=1.9	
		If mapwidth>511 Then sx = 1.25 ; sy=0.9
		
    	DrawImage image,0,0,0,sx,sy
    	Return
        For Local y=0 Until mapheight-1
        For Local x=0 Until mapwidth-1
			Local colr:Int=mapr[x][y]
			Local colg:Int=mapg[x][y]
			Local colb:Int=mapb[x][y]
			SetColor colr,colg,colb
			DrawRect x*tilewidth,y*tileheight,tilewidth+1,tileheight+1
        Next
        Next    
    End Method
    Method distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Method  
	Method argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
	   Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
	End Method
    Method putinimage()
    	Local cnt:Int=0
    	For Local y=0 Until mapheight
    	For Local x=0 Until mapwidth
    		pixels[cnt] = argb(mapr[x][y],mapg[x][y],mapb[x][y])
    		cnt+=1
    	Next
    	Next
        image.WritePixels(pixels, 0, 0, mapwidth, mapheight, 0)
    End Method
End Class

Global mygbg:gridbackground

Class MyGame Extends App
    Field time:Int=0
    Method OnCreate()
    	Seed = GetDate[5]
        SetUpdateRate(1)
        mygbg = New gridbackground(256,256)
    End Method
    Method OnUpdate() 
    	time+=1
    	If time>10 Then
			time=0
	    	Local r:Int=Rnd(3)
	    	Local ts:Int=128
	    	If r=0 Then	ts=128
			If r=1 Then ts=256
			If r=2 Then ts=512
			mygbg = New gridbackground(ts,ts)
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mygbg.draw
    End Method
End Class


Function Main()
    New MyGame()
End Function
