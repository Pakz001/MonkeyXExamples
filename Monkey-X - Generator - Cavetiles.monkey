Import mojo

Global sw:Int=640
Global sh:Int=480
Global smooth1:Int=10
Global smooth2:Int=20
Global myseed:Int=300
Global tilewidth:Int=265
Global tileheight:Int=265
Global maxsize:Int=tilewidth/2
Global size:Int=tilewidth/2

Class map
	Field image:Image[]
	Field imagepixels:Int[]
	Field imagemap:Int[][]
	Method New()
		imagemap = New Int[tilewidth][]
		For Local i=0 Until tilewidth
			imagemap[i] = New Int[tileheight]
		Next
		image = New Image[10]
		image[0] = CreateImage(tilewidth,tileheight)
		imagepixels = New Int[tilewidth*tileheight]
'		line 0,0,tilewidth,tileheight
		maketile()
		finalizeimage
	End Method
	Method maketile(top:Bool=False,right:Bool=False,bottom:Bool=False,left:Bool=False)
		Seed = myseed
 '       Local bottom:Bool=True
''         Local left:Bool=True
 '       Local top:Bool=True
  '      Local right:Bool=True
        Local ang:Int=0
        Local x:Int=tilewidth/2
        Local y:Int=tileheight/2
        Local d:Int=size
		Local linex:Stack<Int> = New Stack<Int>
		Local liney:Stack<Int> = New Stack<Int>
		If right=True Then ang=36
        linex.Push(x+Cos(ang)*d)
        liney.Push(y+Sin(ang)*d)
        While ang<(360-smooth2)
        	ang+=smooth2
        	If bottom=True
        	If (ang>70 And ang<120) Then 
	        	ang=90-20
	        	linex.Push(x+Cos(ang)*d)'
     	    	liney.Push(y+tileheight/2)
				ang=90+31
			   	linex.Push(x+Cos(ang)*d)'
     	    	liney.Push(y+tileheight/2)
				ang+=smooth2
  	     	End If
  	     	End If
        	If left=True
        	If (ang>160 And ang<200) Then 
	        	ang=180-20
	        	linex.Push(x-tilewidth/2)'
     	    	liney.Push(y+Sin(ang)*d)
				ang=180+31
	        	linex.Push(x-tilewidth/2)'
     	    	liney.Push(y+Sin(ang)*d)
				ang+=smooth2
  	     	End If
  	     	End If
        	If top=True
        	If (ang>250 And ang<290) Then 
	        	ang=270-20
	        	linex.Push(x+Cos(ang)*d)'
     	    	liney.Push(y-tileheight/2)
				ang=270+31
	        	linex.Push(x+Cos(ang)*d)'
     	    	liney.Push(y-tileheight/2)
				ang+=smooth2
  	     	End If
  	     	End If
        	If right=True
        	If (ang>340) Then
	        	ang=360-20
	        	linex.Push(x+tilewidth/2)'
     	    	liney.Push(y+Sin(ang)*d)
				ang=31
	        	linex.Push(x+tilewidth/2)'
     	    	liney.Push(y+Sin(ang)*d)
				ang+=smooth2
				ang=360
				Exit
  	     	End If
  	     	End If
  	     	
        	d = size
        	Local d2:Int=d+Rnd(-d/smooth1,d/smooth1)
			If d2>maxsize Then d2=maxsize
        	linex.Push(x+Cos(ang)*d2)
        	liney.Push(y+Sin(ang)*d2)
        	'linex.Push(x+Cos(ang)*d)'
        	'liney.Push(y+Sin(ang)*d)
		Wend

		linex.Push(linex.Get(0))
		liney.Push(liney.Get(0))
		For Local i=1 Until linex.Length
			Local x1:Int=linex.Get(i-1)
			Local y1:Int=liney.Get(i-1)
			Local x2:Int=linex.Get(i)
			Local y2:Int=liney.Get(i)			
			line x1,y1,x2,y2
		Next
        '	
	End Method
	Method finalizeimage()
		Local cnt:Int=0
		For Local y=0 Until tileheight
		For Local x=0 Until tilewidth
		If imagemap[x][y] = 1
		imagepixels[cnt] = argb(255,255,255)
		End If
		cnt+=1
		Next
		Next
		image[0].WritePixels(imagepixels, 0, 0, tilewidth, tileheight, 0)		
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
		SetColor 255,255,255
		DrawImage image[0],0,0
	End Method
End Class

Global mymap:map

Class MyGame Extends App
	
    Method OnCreate()
        SetUpdateRate(10)
        mymap = New map
    End Method
    Method OnUpdate()
		If KeyDown(KEY_RIGHT) Then smooth1+=1
		If KeyDown(KEY_LEFT) Then smooth1-=1
		If smooth1 <3 Then smooth1 = 3
		If smooth1 >100 Then smooth1 = 100
		If KeyDown(KEY_UP) Then smooth2+=1
		If KeyDown(KEY_DOWN) Then smooth2-=1
		If smooth2 <3 Then smooth2 = 3
		If smooth2 >20 Then smooth2 = 20
		If KeyDown(KEY_EQUALS) Then myseed+=1
		If KeyDown(KEY_MINUS) Then myseed-=1
		If KeyDown(KEY_9) Then size-=1
		If KeyDown(KEY_0) Then size+=1
		If size<5 Then size = 5
		If size>200 Then size=200
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymap.draw
        SetColor 50,50,50
        DrawRect sw/2-tilewidth/2,sh/2-tileheight/2,tilewidth,tileheight
        SetColor 255,255,255
		'
		Seed = myseed
        Local bottom:Bool=True
        Local left:Bool=True
        Local top:Bool=True
        Local right:Bool=True
        Local ang:Int=0
        Local x:Int=320
        Local y:Int=240
        Local d:Int=size
		Local linex:Stack<Int> = New Stack<Int>
		Local liney:Stack<Int> = New Stack<Int>
		If right=True Then ang=36
        linex.Push(x+Cos(ang)*d)
        liney.Push(y+Sin(ang)*d)
        While ang<(360-smooth2)
        	ang+=smooth2
        	If bottom=True
        	If (ang>70 And ang<120) Then 
	        	ang=90-20
	        	linex.Push(x+Cos(ang)*d)'
     	    	liney.Push(y+tileheight/2)
				ang=90+31
			   	linex.Push(x+Cos(ang)*d)'
     	    	liney.Push(y+tileheight/2)
				ang+=smooth2
  	     	End If
  	     	End If
        	If left=True
        	If (ang>160 And ang<200) Then 
	        	ang=180-20
	        	linex.Push(x-tilewidth/2)'
     	    	liney.Push(y+Sin(ang)*d)
				ang=180+31
	        	linex.Push(x-tilewidth/2)'
     	    	liney.Push(y+Sin(ang)*d)
				ang+=smooth2
  	     	End If
  	     	End If
        	If top=True
        	If (ang>250 And ang<290) Then 
	        	ang=270-20
	        	linex.Push(x+Cos(ang)*d)'
     	    	liney.Push(y-tileheight/2)
				ang=270+31
	        	linex.Push(x+Cos(ang)*d)'
     	    	liney.Push(y-tileheight/2)
				ang+=smooth2
  	     	End If
  	     	End If
        	If right=True
        	If (ang>340) Then
	        	ang=360-20
	        	linex.Push(x+tilewidth/2)'
     	    	liney.Push(y+Sin(ang)*d)
				ang=31
	        	linex.Push(x+tilewidth/2)'
     	    	liney.Push(y+Sin(ang)*d)
				ang+=smooth2
				ang=360
				Exit
  	     	End If
  	     	End If
  	     	
        	d = size
        	Local d2:Int=d+Rnd(-d/smooth1,d/smooth1)
			If d2>maxsize Then d2=maxsize
        	linex.Push(x+Cos(ang)*d2)
        	liney.Push(y+Sin(ang)*d2)
        	'linex.Push(x+Cos(ang)*d)'
        	'liney.Push(y+Sin(ang)*d)
		Wend

		linex.Push(linex.Get(0))
		liney.Push(liney.Get(0))
		For Local i=1 Until linex.Length
			Local x1:Int=linex.Get(i-1)
			Local y1:Int=liney.Get(i-1)
			Local x2:Int=linex.Get(i)
			Local y2:Int=liney.Get(i)			
			DrawLine x1,y1,x2,y2
		Next
        '
    End Method
End Class

   	Function maketile()
        Local sx:Int
        Local sy:Int
        Local ex:Int
        Local ey:Int
        Local ang:Int=0
        Local x:Int=320
        Local y:Int=240
        Local d:Int=size
        Local x1:Int=x+Cos(ang)*d
        Local y1:Int=y+Sin(ang)*d
        sx=x1
        sy=y1
        Seed = myseed

        While ang<(360-smooth2)
        	ang+=smooth2
        	d = size
        	Local x2:Int=x+Cos(ang)*d
        	Local y2:Int=y+Sin(ang)*d
        	Local d2:Int=d+Rnd(-d/smooth1,d/smooth1)
			If d2>maxsize Then d2=maxsize
        	Local x3:Int=x+Cos(ang-10)*d2
        	Local y3:Int=y+Sin(ang-10)*d2
	       	DrawLine x1,y1,x3,y3
        	DrawLine x3,y3,x2,y2
'        	DrawLine x1,y1,x3,y3
        	x1=x2
        	y1=y2
		Wend
		DrawLine x1,y1,sx,sy
        '
    End Function

Function Main()
    New MyGame()
End Function
