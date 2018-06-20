'
' Map generator using lines and zones.

 
' The generator first creates lines on a map. It starts with one
' line somewhere in the middle of the map and while drawing this line it 
' sometimes starts a new line into a random direction from
' this line its place. They all are connected to each other
'
' Then A fill is done. Here a random point is chosen and if this is a 
' line value of filled value it fills nearby (-1,1xy) This a certain amount
' of times so that a landmass is created.
'
' After that a second zones fill is done. Here a number of land values
' are changed into new values and these are grown creating biomes.
'

Import mojo

Class map
	Field sw:Int,sh:Int,mw:Int,mh:Int
	Field tw:Float,th:Float
	Field map:Int[][]
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		tw = Float(sw)/Float(mw)
		th = Float(sh)/Float(mh)
		map = New Int[mw][]
		For Local i:Int=0 Until mw
			map[i] = New Int[mh]
		Next
		generatemap()
	End Method
	Method generatemap()
		' Create Lines
		Local xp:Stack<Float> = New Stack<Float>
		Local yp:Stack<Float> = New Stack<Float>
		Local ap:Stack<Int> = New Stack<Int>
		Local lp:Stack<Int> = New Stack<Int>
		xp.Push(mw/3+Rnd(mw/4))
		yp.Push(mh/3+Rnd(mh/4))
		ap.Push(Rnd(360))
		lp.Push(Rnd(20,30))
		Local maxl:Int=Rnd(5,15)
		Local curl:Int=0
		While xp.Length>0
			For Local i:Int=0 Until xp.Length
				If lp.Get(i) > 0 Then
					lp.Set(i,lp.Get(i)-1)
					Local a:Int=ap.Get(i)
					Local x:Float=xp.Get(i)
					Local y:Float=yp.Get(i)
					x+=Cos(a)*1
					y+=Sin(a)*1
					If x<1 Then x=1
					If x>=mw Then x = mw-1
					If y<1 Then y=1
					If y>=mh Then y=mh-1
					xp.Set(i,x)
					yp.Set(i,y)
					map[x][y] = 1
					If Rnd(10)<1 And curl<maxl
						curl+=1
						xp.Insert(0,x)
						yp.Insert(0,y)
						ap.Insert(0,Rnd(360))
						lp.Insert(0,Rnd(15,40))
					End If
				Else
					xp.Remove(i)
					yp.Remove(i)
					ap.Remove(i)
					lp.Remove(i)
				End If
			Next
		Wend
		'
		' Zones fill
		' 
		For Local i:Int=0 Until mw*mh*5
			Local x:Int=Rnd(3,mw-3)
			Local y:Int=Rnd(3,mh-3)
			If map[x][y] = 1
				map[x+Rnd(-1,2)][y+Rnd(-1,2)] = 1
			End If
		Next
		
		'
		' Second zones fill
		'
		' first add zone numbers
		Local numzones:Int=Rnd(5,15)
		Local cd:Int=numzones
		While cd>0
			Local x:Int=Rnd(1,mw-1)
			Local y:Int=Rnd(1,mh-1)
			If map[x][y] = 1
				map[x][y] = cd
				cd-=1
			End If
		Wend
		' then increase zones size
		For Local i:Int=0 Until mw*mh*20
			Local x:Int=Rnd(1,mw-1)
			Local y:Int=Rnd(1,mh-1)
			If map[x][y] > 1
				Local zn:Int=map[x][y]
				map[x+Rnd(-1,2)][y+Rnd(-1,2)] = zn
			End If			
		Next
	End Method
	Method draw()
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			If map[x][y] = 0 'water
				SetColor 5,5,155
				DrawRect x*tw,y*th,tw+1,th+1
			End If
		
			If map[x][y] = 1'rock/mountain
				SetColor 155,155,155
				DrawRect x*tw,y*th,tw+1,th+1
			End If
			If map[x][y] = 2'desert/sand
				SetColor 155,155,5
				DrawRect x*tw,y*th,tw+1,th+1
			End If
			If map[x][y] > 2'trees/grass
				Local c:Int=map[x][y]*13
				SetColor c,255,c
				DrawRect x*tw,y*th,tw+1,th+1								
			End If
		Next
		Next
	End Method
End Class



Class MyGame Extends App
	Field mymap:map
    Method OnCreate()
        SetUpdateRate(60)
        Seed = GetDate[4]+GetDate[5]
        mymap = New map(640,480,80,80)
    End Method
    Method OnUpdate()   
    	If MouseHit(MOUSE_LEFT)
			mymap = New map(640,480,80,80)
    	Endif
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mymap.draw()
    End Method
End Class


Function Main()
    New MyGame()
End Function
