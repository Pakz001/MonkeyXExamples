'
' Tile generator 
' Lighting/shadow from (angle) side
'


Import mojo

Class tiles
	'base color
	Field r:Int,g:Int,b:Int
	'tile width and height
	Field tw:Int,th:Int
	' angle light
	Field angle:Float
	' image array
	Field im:Int[][]
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
		createtile()
	End Method
	Method createtile()
		'grow some area
		im[Rnd(tw/2-tw/9,tw/2+tw/9)][Rnd(th/2-th/9,th/2+th/9)] = 1
		im[Rnd(tw/2-tw/9,tw/2+tw/9)][Rnd(th/2-th/9,th/2+th/9)] = 1
		grow
		edgelight
		edgenoise()
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
		
		For Local a:Int=angle Until angle+360
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
		Local amountnoise:Float=Rnd(1.5,4)
		For Local i:Int=0 Until tw*th*amountnoise
			Local x:Int=Rnd(2,tw-3)
			Local y:Int=Rnd(2,th-3)
			Local v:Int=im[x][y]
			If v=2 Or v=3
				Local x2:Int=x+Rnd(-1,2)
				Local y2:Int=y+Rnd(-1,2)
				' if current position on array is base color
				' then add noise(current light or dark color)
				If im[x2][y2] = 1 Or im[x2][y2] = v
					im[x2][y2] = v+2
				End If
			End If
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
			setcolor(im[x][y])
'			DrawRect sx+x*3,sy+y*3,3,3
			DrawRect sx+x,sy+y,1,1			
		Next
		Next
	End Method
	Method setcolor(col:Int)
		Select col
			Case 0;SetColor 0,0,0
			Case 1;SetColor r,g,b
			Case 2'base color dark
				SetColor r/3,g/3,b/3
			Case 3'base color light
				Local r2:Int,g2:Int,b2:Int
				r2 = r*1.2 ; If r2>255 Then r2=255
				g2 = g*1.2 ; If g2>255 Then g2=255
				b2 = b*1.2 ; If b2>255 Then b2=255
				SetColor r2,g2,b2
			Case 4'base color slighly darker
				SetColor r/1.5,g/1.5,b/1.5
			Case 5'base color slightly lighter
				Local r2:Int,g2:Int,b2:Int
				r2 = r*1.7 ; If r2>255 Then r2=255
				g2 = g*1.7 ; If g2>255 Then g2=255
				b2 = b*1.7 ; If b2>255 Then b2=255
				SetColor r2,g2,b2
				
		End Select
		
	End Method
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
        Cls 0,0,0 
        SetColor 255,255,255
		Local cnt:Int=0
		For Local y:Int=0 Until 4
		For Local x:Int=0 Until 4
			tile[cnt].drawarray(x*130,y*100)
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
