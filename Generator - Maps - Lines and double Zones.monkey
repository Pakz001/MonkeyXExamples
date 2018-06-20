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
	' screen width and height and map width and height.
	Field sw:Int,sh:Int,mw:Int,mh:Int
	' tilewidth and height
	Field tw:Float,th:Float
	' map data array
	Field map:Int[][]
	'
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		tw = Float(sw)/Float(mw)
		th = Float(sh)/Float(mh)
		' set up the map array
		map = New Int[mw][]
		For Local i:Int=0 Until mw
			map[i] = New Int[mh]
		Next
		' generate the map
		generatemap()
	End Method
	Method generatemap()
		' Create Lines
		' x and y and angle and length of lines
		Local xp:Stack<Float> = New Stack<Float>
		Local yp:Stack<Float> = New Stack<Float>
		Local ap:Stack<Int> = New Stack<Int>
		Local lp:Stack<Int> = New Stack<Int>
		'push the first line on the stack
		xp.Push(mw/3+Rnd(mw/4))
		yp.Push(mh/3+Rnd(mh/4))
		ap.Push(Rnd(360))
		lp.Push(Rnd(20,30))
		' maximum number of lines
		Local maxl:Int=Rnd(5,15)
		' current amount of lines
		Local curl:Int=0
		' while the stack is not empty
		While xp.Length>0
			' loop through the x stack
			For Local i:Int=0 Until xp.Length
				' if length of line is not zero yet
				If lp.Get(i) > 0 Then
					' decrease line length
					lp.Set(i,lp.Get(i)-1)
					' set local values
					Local a:Int=ap.Get(i)
					Local x:Float=xp.Get(i)
					Local y:Float=yp.Get(i)
					' update the line
					x+=Cos(a)*1
					y+=Sin(a)*1
					' if the line is near edge then end line
					If x<1 Then lp.Set(i,0) ; Continue
					If x>=mw Then lp.Set(i,0) ; Continue
					If y<1 Then lp.Set(i,0) ; Continue
					If y>=mh Then lp.Set(i,0) ; Continue
					' set the new x and y value in stack
					xp.Set(i,x)
					yp.Set(i,y)
					' update the map array
					map[x][y] = 1
					' every now and then create new line if possible
					If Rnd(10)<1 And curl<maxl
						' current amount of lines
						curl+=1
						' create new line in stack
						xp.Insert(0,x)
						yp.Insert(0,y)
						ap.Insert(0,Rnd(360)) ' angle
						lp.Insert(0,Rnd(15,40)) ' line length
					End If
				' if the line length is 0 then remove it from the stack
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
		' Loop x amount of times
		For Local i:Int=0 Until mw*mh*5
			' get random x and y
			Local x:Int=Rnd(3,mw-3)
			Local y:Int=Rnd(3,mh-3)
			' if the value there in the map is 1
			If map[x][y] = 1
				' put another 1 near that x and y
				map[x+Rnd(-1,2)][y+Rnd(-1,2)] = 1
			End If
		Next
		
		'
		' Second zones fill
		'
		' first add zone numbers (biomes)
		Local numzones:Int=Rnd(5,15)
		' current zone variable
		Local cd:Int=numzones
		' while not all zones have been added
		While cd>0
			' get x and y random coordinates
			Local x:Int=Rnd(1,mw-1)
			Local y:Int=Rnd(1,mh-1)
			' if the x and y in map is 1
			If map[x][y] = 1
				' add zone(biome)
				map[x][y] = cd
				' decrease biomes
				cd-=1
			End If
		Wend
		' then increase zones size
		' certain zones may grow larger then the current landmass
		Local zonegrow:Bool[] = New Bool[numzones+1]
		For Local i:Int=0 Until numzones+1
			If Rnd(1)<.5 Then zonegrow[i] = False Else zonegrow[i] = True
		Next
		' loop x amount of times
		For Local i:Int=0 Until mw*mh*20
			' create random x and y
			Local x:Int=Rnd(1,mw-1)
			Local y:Int=Rnd(1,mh-1)
			' if this map coordinate is a biome number
			If map[x][y] > 1
				' near that biome(zone) number grow that zone
				Local zn:Int=map[x][y]
				Local nx:Int=x+Rnd(-1,2)
				Local ny:Int=y+Rnd(-1,2)
				' if the current zone is enlargable
				If zonegrow[zn] = True Then
					map[nx][ny] = zn
				' stay on the original landmass
				Else
					If map[nx][ny] > 0
						map[nx][ny] = zn
					End If
				End If
			End If			
		Next
	End Method
	' draw the map array on the screen
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
