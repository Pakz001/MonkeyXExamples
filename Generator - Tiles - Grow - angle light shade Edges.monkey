'
' Tile generator 
' Lighting/shadow from (angle) side
'


Import mojo

Class tiles

	Field r:Int,g:Int,b:Int

	Field tw:Int,th:Int
	Field angle:Float
	Field im:Int[][]
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
		im[Rnd(tw/2-tw/4,tw/2+th/4)][Rnd(th/2-th/4,th/2+th/4)] = 1
		im[Rnd(tw/2-tw/4,tw/2+tw/4)][Rnd(th/2-th/4,th/2+th/4)] = 1
		grow
		edgelight
	End Method
	Method grow()
		For Local i:Int=0 Until tw*th*6
			Local x:Int=Rnd(7,tw-7)
			Local y:Int=Rnd(7,th-7)
			If im[x][y] = 1 Then
				im[Rnd(x-1,x+2)][Rnd(y-1,y+2)] = 1
			End If
		Next
	End Method
	Method edgelight()
		Local tim:Int[][]
		tim = New int[tw][]
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
	Method drawarray(sx:Int,sy:Int)
		'0 = black
		'1 = base color
		'2 = base color dark
		'3 = base color light
		For Local y:Int=0 Until th
		For Local x:Int=0 Until tw
			setcolor(im[x][y])
			DrawRect sx+x*3,sy+y*3,3,3
		Next
		Next
	End Method
	Method setcolor(col:Int)
		Select col
			Case 0;SetColor 0,0,0
			Case 1;SetColor r,g,b
			Case 2'base color dark
				SetColor r/2,g/2,b/2
			Case 3'base color light
				Local r2:Int,g2:Int,b2:Int
				r2 = r*1.5 ; If r2>255 Then r2=255
				g2 = g*1.5 ; If g2>255 Then g2=255
				b2 = b*1.5 ; If b2>255 Then b2=255
				SetColor r2,g2,b2
		End Select
		
	End Method
End Class

Class MyGame Extends App
	Field tile:tiles
    Method OnCreate()
        SetUpdateRate(1)
        tile = New tiles(32,32,100,100,100,0)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
		'tile.drawarray(100,100)
		For Local y:Int=0 Until 4
		For Local x:Int=0 Until 4
			Local t:tiles = New tiles(32,32,100+Rnd(100),100+Rnd(100),100+Rnd(100),Rnd(360))
			t.drawarray(x*80,y*80)
		Next
		Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
