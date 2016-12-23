Import mojo

Global sw:Int=640
Global sh:Int=480
Global mapwidth:Int=19
Global mapheight:Int=15
Global smooth1:Int=10
Global minsmooth1:Int=3
Global maxsmooth1:Int=30
Global smooth2:Int=20
Global minsmooth2:Int=3
Global maxsmooth2:Int=30
Global myseed:Int=300
Global tilewidth:Int=32
Global tileheight:Int=32
Global maxsize:Int=tilewidth/2
Global size:Int=tilewidth/2

Class map
	Field image:Image[][]
	Field imagepixels:Int[]
	Field imagemap:Int[][]
	Field map1:Int[][]
	Field map2:Int[][]
	Field map3:Int[][][]
	Field mazex:Stack<Int> = New Stack<Int>
	Field mazey:Stack<Int> = New Stack<Int>			
	Method New()
		imagemap = New Int[tilewidth][]
		For Local i=0 Until tilewidth
			imagemap[i] = New Int[tileheight]
		Next		
		map1 = New Int[mapwidth][]
		For Local i=0 Until mapwidth
			map1[i] = New Int[mapheight]
		Next		
		
		map2 = New Int[mapwidth][]
		map3 = New Int[mapwidth][][]	
		For Local i=0 Until mapwidth
			map2[i] = New Int[mapheight]
			map3[i] = New Int[mapheight][]
            For Local z = 0 Until mapheight
            	map3[i][z] = New Int[4]
            Next			
		Next
		image = New Image[100][]
		For Local i=0 Until mapwidth
			image[i] = New Image[mapheight]
		Next
		For Local y=0 Until mapheight
		For Local x=0 Until mapwidth
			image[x][y] = CreateImage(tilewidth,tileheight)
		Next
		Next
		imagepixels = New Int[tilewidth*tileheight]
		Seed = myseed
		makemaze()
		tilesonmap()
		'maketile()
		'map1[0][0]=1
		'finalizeimage(0,0)


	End Method
	Method tilesonmap()
		Local top:Bool=False
		Local right:Bool=False
		Local bottom:Bool=False
		Local left:Bool=False
		For Local y=1 Until mapheight-1
		For Local x=1 Until mapwidth-1
			If map1[x][y] = 1
			If map1[x][y-1] = 1 Then top=True Else top=False
			If map1[x+1][y] = 1 Then right=True Else right=False
			If map1[x][y+1] = 1 Then bottom=True Else bottom=False
			If map1[x-1][y] = 1 Then left=True Else left = False
			maketile(top,right,bottom,left)
			finalizeimage(x,y)
			End If
		Next
		Next

		For Local x=1 Until mapwidth-1
			top=False
			If map1[x][0] = 1
			If map1[x+1][0] = 1 Then right = True Else right=False
			If map1[x][1] = 1 Then bottom = True Else bottom=False
			If map1[x-1][0] = 1 Then left = True Else left=False
			maketile(top,right,bottom,left)
			finalizeimage(x,0)			
			End If
			bottom=False
			If map1[x][mapheight-1] = 1
			If map1[x][mapheight-2] = 1 Then top=True Else top=False
			If map1[x+1][mapheight-1] = 1 Then right=True Else right =False
			If map1[x-1][mapheight-1] = 1 Then left = True Else left=False
			maketile(top,right,bottom,left)
			finalizeimage(x,mapheight-1)			
			End If			
		Next


		For Local y=1 Until mapheight-1
			left=False
			If map1[0][0] = 1
			If map1[0][y-1] = 1 Then top = True Else top=False
			If map1[1][y] = 1 Then right=True Else right=False
			If map1[0][y+1] = 1 Then bottom=True Else bottom=False
			maketile(top,right,bottom,left)
			finalizeimage(0,y)			
			End If
			right=False
			If map1[mapwidth-1][y] = 1
			If map1[mapwidth-1][y-1] = 1 Then top=True Else top=False
			If map1[mapwidth-1][y+1] = 1 Then bottom = True Else bottom=False
			If map1[mapwidth-2][y] = 1 Then left=True Else left = False
			maketile(top,right,bottom,left)
			finalizeimage(mapwidth-1,y)			
			End If			
		Next

		
		If map1[mapwidth-1][mapheight-1] = 1
			bottom=False
			right=False
			If map1[mapwidth-2][mapheight-1] = 1 Then left=True Else left=False
			If map1[mapwidth-1][mapheight-2] = 1 Then top=True Else top=False
			maketile(top,right,bottom,left)
			finalizeimage(mapwidth-1,mapheight-1)			

		End If

	End Method
	Method maketile(top:Bool=False,right:Bool=False,bottom:Bool=False,left:Bool=False)
		For Local y=0 Until tileheight
		For Local x=0 Until tilewidth
			imagemap[x][y] = 0
		Next
		Next
		smooth1 = Rnd(minsmooth1,maxsmooth1)
		smooth2 = Rnd(minsmooth2,maxsmooth2)
		If Rnd()<.8 Then smooth1 = Rnd(minsmooth1,10)
        Local ang:Int=0
        Local x:Int=tilewidth/2
        Local y:Int=tileheight/2
        Local d:Int=size-1
		Local linex:Stack<Int> = New Stack<Int>
		Local liney:Stack<Int> = New Stack<Int>
		Local drawme:Stack<Bool> = New Stack<Bool>
		Local ex:Bool=False
		Local topset:Bool=False
		Local rightset:Bool=False
		Local bottomset:Bool=False
		Local leftset:Bool=False
		If right=True Then ang=17
        linex.Push(x+Cos(ang)*d)
        liney.Push(y+Sin(ang)*d)
    	drawme.Push(True)
        While ang<(360-smooth2)
        	ang+=smooth2
        	If bottom=True And bottomset=False
        	If (ang>70 And ang<120) Then 
        		bottomset=True
	        	ang=90-20
	        	linex.Push(x+Cos(ang)*d)'
     	    	liney.Push(y+tileheight/2)
     	    	drawme.Push(True)
				ang=90+21
			   	linex.Push(x+Cos(ang)*d)'
     	    	liney.Push(y+tileheight/2)
     	    	drawme.Push(False)
				ang+=smooth2
  	     	End If
  	     	End If
        	If left=True And leftset=False
        	If (ang>160-smooth2 And ang<200) Then 
        		leftset=True
	        	ang=180-20
	        	linex.Push(x-tilewidth/2)'
     	    	liney.Push(y+Sin(ang)*d)
     	    	drawme.Push(True)     	    	
				ang=180+21
	        	linex.Push(x-tilewidth/2)'
     	    	liney.Push(y+Sin(ang)*d)
     	    	drawme.Push(False)     	    	
				ang+=smooth2
  	     	End If
  	     	End If
        	If top=True And topset=False
        	If (ang>250 And ang<290) Then 
        		topset=True
	        	ang=270-20
	        	linex.Push(x+Cos(ang)*d)'
     	    	liney.Push(y-tileheight/2)
     	    	drawme.Push(True)
				ang=270+21
	        	linex.Push(x+Cos(ang)*d)'
     	    	liney.Push(y-tileheight/2)
     	    	drawme.Push(False)     	    	
				ang+=smooth2
  	     	End If
  	     	End If
        	If right=True And rightset=False
        	If (ang>340-smooth2) Then
        		rightset=True
	        	ang=360-20
	        	linex.Push(x+tilewidth/2)'
     	    	liney.Push(y+Sin(ang)*d)
     	    	drawme.Push(True)
				ang=21
	        	linex.Push(x+tilewidth/2)'
     	    	liney.Push(y+Sin(ang)*d)
     	    	drawme.Push(False)     	    	
				ang+=smooth2
				ang=360
				ex=True
  	     	End If
  	     	End If
  	     	If ex=False
        	d = size-1
        	Local d2:Int=d+Rnd(-d/smooth1,d/smooth1)
			If d2>maxsize Then d2=maxsize
        	linex.Push(x+Cos(ang)*d2)
        	liney.Push(y+Sin(ang)*d2)
   	    	drawme.Push(True)        	
        	'linex.Push(x+Cos(ang)*d)'
        	'liney.Push(y+Sin(ang)*d)
        	End If
		Wend

		linex.Push(linex.Get(0))
		liney.Push(liney.Get(0))
    	drawme.Push(True)		
		For Local i=1 Until linex.Length
			Local x1:Int=linex.Get(i-1)
			Local y1:Int=liney.Get(i-1)
			Local x2:Int=linex.Get(i)
			Local y2:Int=liney.Get(i)			
			If drawme.Get(i) = True Then
			'If drawme.Get(i) = True
			line x1,y1,x2,y2
			'End if
			End If
		Next
        '	
        floodimagemap(2) 'walkable tiles is no 2
	End Method
	Method floodimagemap(fillval:Int)
		Local fx:Stack<Int> = New Stack<Int>
		Local fy:Stack<Int> = New Stack<Int>
		Local mx:Int[] = [0,1,0,-1]
		Local my:Int[] = [-1,0,1,0]
		fx.Push(tilewidth/2)
		fy.Push(tileheight/2)
		While fx.Length > 0
			Local x1:Int=fx.Top
			Local y1:Int=fy.Top
			fx.Pop
			fy.Pop
			For Local i=0 Until 4
				Local x2:Int=x1+mx[i]
				Local y2:Int=y1+my[i]
				If x2>=0 And x2<tilewidth And y2>=0 And y2<tileheight
				If imagemap[x2][y2] = 0
					imagemap[x2][y2] = fillval
					fx.Insert(0,x2)
					fy.Insert(0,y2)
				End If
				End If
			Next
		Wend
	End Method
	Method finalizeimage(tx:Int,ty:Int)
		For Local i=0 Until tilewidth*tileheight
			imagepixels[i] = 0
		Next
		Local cnt:Int=0
		For Local y=0 Until tileheight
		For Local x=0 Until tilewidth
		If imagemap[x][y] = 1
		imagepixels[cnt] = argb(255,255,255)
		End If
		If imagemap[x][y] = 2
		imagepixels[cnt] = argb(55,55,55)
		End If

		cnt+=1
		Next
		Next
		image[tx][ty].WritePixels(imagepixels, 0, 0, tilewidth, tileheight, 0)		
	End Method
	
	Method makemaze()
		Local ax:Int[] = [0,1,0,-1]
		Local ay:Int[] = [-1,0,1,0]
		mazex.Push(Rnd(mapwidth/2))
		mazey.Push(Rnd(mapheight/2))								
		While mazex.IsEmpty = False			
			Local x:Int=mazex.Top
			Local y:Int=mazey.Top
			Local d:Int[] = New Int[4]
			Local deadend:Bool=True
			For Local i:=0 Until ax.Length
				Local x2:Int=x+ax[i]
				Local y2:Int=y+ay[i]
				If x2>=0 And x2<mapwidth/2 And y2>=0 And y2<mapheight/2
					If map2[x2][y2] = 0 
						d[i] = 1
						deadend=False
					End If
				End If
			Next
			
			If deadend = False				
				Local eloop:Bool=False
				While eloop = False
					Local r:Int=Rnd(0,4)
					If d[r] = 1 Then						
						eloop = True
						Local nx:Int=x+ax[r]
						Local ny:Int=y+ay[r]
						map3[x][y][r] = 1																		
						mazex.Push(nx)
						mazey.Push(ny)						
						map2[x][y] = 1
						map2[nx][ny] = 1
					End If
				Wend
			Else	' if nothing happened than backtrace
				mazex.Pop()
				mazey.Pop()
			End If
		Wend
		' convert the map into a tilemap
		For Local y:=0 Until mapheight/2
		For Local x:=0 Until mapwidth/2
			Local x2:Int=x*2
			Local y2:Int=y*2
			If map2[x][y] = 1 Then map1[x2+1][y2+1] = 1
			If map3[x][y][0] = 1 Then map1[x2+1][y2] = 1
			If map3[x][y][1] = 1 Then map1[x2+2][y2+1] = 1
			If map3[x][y][2] = 1 Then map1[x2+1][y2+2] = 1
			If map3[x][y][3] = 1 Then map1[x2][y2+1] = 1			
		Next
		Next				
	End Method	
    Method line:Void(x1:Int,y1:Int,x2:Int,y2:Int)
        Local dx:Int, dy:Int, sx:Int, sy:Int, e:Int
        dx = Abs(x2 - x1)
          sx = -1
          If x1 < x2 Then sx = 1      
          dy = Abs(y2 - y1)
          sy = -1
          If y1 < y2 Then sy = 1
          If dx < dy Then 
              e = dx / 2 
          Else 
              e = dy / 2          
          End If
          Local exitloop:Bool=False
          While exitloop = False
          	If x1>=0 And x1<tilewidth And y1>=0 And y1<tileheight
            imagemap[x1][y1] = 1
            End If
			
            If x1 = x2 
                If y1 = y2
                    exitloop = True
                End If
            End If
            If dx > dy Then
                x1 += sx ; e -= dy 
                  If e < 0 Then e += dx ; y1 += sy
            Else
                y1 += sy ; e -= dx 
                If e < 0 Then e += dy ; x1 += sx
            Endif
          Wend
    End Method	
    Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
        Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
    End Function     
	Method draw()	
		Scale 1,1
		SetColor 255,255,255
		For Local y=0 Until mapheight
		For Local x=0 Until mapwidth
			If map1[x][y] = 1
				'DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
				DrawImage image[x][y],x*tilewidth,y*tileheight
			End If
		Next
		Next
		Scale 1,1
	End Method
End Class

Global mymap:map

Class MyGame Extends App
	Field cnt:Int=0
    Method OnCreate()
        SetUpdateRate(60)
        myseed=1
        mymap = New map
    End Method
    Method OnUpdate()
		cnt+=1
		If MouseDown(MOUSE_LEFT) Or cnt>120
			cnt=0
			myseed = Millisecs()
			mymap = New map
		End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymap.draw
        SetColor 255,255,255
        DrawText "Press mouse to draw new map or wait",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
