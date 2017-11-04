' Based somewhat on http://www.squidi.net/three/entry.php?id=164

Import mojo

Class map
	Field sw:Int,sh:Int
	Field tw:Float,th:Float
	Field mw:Int,mh:Int
	Field map:Int[][]
	Field grassmap:Int[][]
	Field bridgemap:Int[][]
	Field tileroad:Int=999
	Field numzones:Int
	Method New(sw:Int,sh:Int,mw:Int,mh:Int,numzones:Int)
		Self.numzones = numzones
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		Self.tw = Float(sw) / Float(mw)
		Self.th = Float(sh) / Float(mh)		
		map = New Int[mw][]
		grassmap = New Int[mw][]		
		bridgemap = New Int[mw][]
		For Local i:Int=0 Until mw
			map[i] = New Int[mh]
			grassmap[i] = New Int[mh]
			bridgemap[i] = New Int[mh]			
		Next
		createmap()
	End Method
	Method createmap()
		'Create a number of zones (area's)
		For Local zone:Int=0 Until numzones
			map[Rnd(mw)][Rnd(mh)] = zone+1
		Next
		'Grow the zones
		Local cangrow:Bool=True
		Local mx:Int[]=[-1,0,1,0]
		Local my:Int[]=[-1,0,0,1]
		While cangrow=True
			Local x:Int=Rnd(mw)
			Local y:Int=Rnd(mh)
			If map[x][y] > 0
				Local tile:Int=map[x][y]
				For Local i:Int=0 Until mx.Length
					Local x2:Int=mx[i]+x
					Local y2:Int=my[i]+y
					If x2<0 Or y2<0 Or x2>=mw Or y2>=mh Then Continue
					If Rnd(10)<2 And map[x2][y2] = 0
						map[x2][y2] = tile
					End If
				Next
			End If
			' Every now and then check if every spot is taken
			If Rnd(mw)<mw/10
				cangrow = False
				For Local y2:Int=0 Until mh
				For Local x2:Int=0 Until mw
					If map[x2][y2] = 0 Then cangrow = True;Exit
				Next
				Next
			End If			
		Wend
		' Create the roads
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			Local t:Int=map[x][y]
			If x+1 < mw And map[x+1][y] <> t And grassmap[x+1][y] = 0 Then grassmap[x][y] = 1
			If y+1 < mh And map[x][y+1] <> t And grassmap[x][y+1] = 0 Then grassmap[x][y] = 1
			If x+1 < mw And y+1 < mh And map[x+1][y+1] <> t And grassmap[x+1][y+1] = 0 Then grassmap[x][y] = 1
		Next
		Next
		'create the bridges
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			If grassmap[x][y] <> 1 Then Continue
			Local cnt:Int=0
			For Local y2:Int=y-1 To y+1
			For Local x2:Int=x-1 To x+1
				If x2<0 Or y2<0 Or x2>=mw Or y2>=mh Then Continue
				If map[x2][y2] >= numzones/3 Then cnt+=1
			Next
			Next
			If cnt=0 Then bridgemap[x][y] = 1
		Next
		Next
	End Method
	Method draw()
		' map pass 1		
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			If map[x][y] = 0 Then Continue			
			Local x2:Int = x*tw
			Local y2:Int = y*th
			If map[x][y] < numzones/3 Or map[x][y] = 1 Then
			' water
			SetColor 44,140,200
			DrawRect x2,y2,tw+1,th+1
			SetColor 46,165,225
			DrawOval x2+tw/3,y2+th/5,tw/4,th/2
			SetColor 56,195,255
			DrawOval x2+tw/3,y2+th/4,tw/5,th/7

			Else
			'grass
			SetColor 160,200,105
			DrawRect x2,y2,tw+1,th+1
			'treebase dark
			SetColor 10,45,0
			DrawOval x2+tw/3,y2+th/2,tw/2,th/1.5

			'treebase light
			SetColor 200,55,0
			DrawOval x2+tw/2.2,y2+th/2,tw/4,th/1.5
			' tree top dark			
			SetColor 0,55,0
			DrawOval x2+tw/8,y2+th/10,tw/1.1,th/1.3
			' tree top 
			SetColor 0,190,0
			DrawOval x2+tw/8+1,y2+th/10,tw/1.2-2,th/1.3
			

			' highlight top 
			SetColor 200,255,200
			DrawOval x2+tw/4+1,y2+th/5,tw/3,th/3
			
			End If

		Next
		Next
		'grass
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			If grassmap[x][y] = 0 Then Continue			
			Local x2:Int = x*tw
			Local y2:Int = y*th
			SetColor 80,230,20
			DrawRect x2,y2,tw+1,th+1
		Next
		Next

		'bridges
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			If bridgemap[x][y] = 0 Then Continue			
			Local x2:Int = x*tw
			Local y2:Int = y*th
			SetColor 150,120,15
			DrawRect x2,y2,tw+1,th+1
			'plank
			SetColor 200,170,20
			DrawRect x2+tw/10,y2,tw/3,th+1
			DrawRect x2+tw/1.8,y2,tw/3,th+1
			'plank shadow and light
			SetColor 240,200,200
			DrawRect x2+tw/10,y2,1,th+1
			DrawRect x2+tw/1.8,y2,1,th+1
			SetColor 0,0,0
			DrawRect x2+tw/10+tw/3,y2,1,th+1
			DrawRect x2+tw/1.8+tw/3,y2,1,th+1
		Next
		Next


		' map pass 2 (shadow under trees/grass and highlight up water)		
		For Local y:Int=1 Until mh
		For Local x:Int=0 Until mw
			If map[x][y] = 0 Then Continue			
			Local x2:Int = x*tw
			Local y2:Int = y*th
			'shadow under trees
			If grassmap[x][y] = 1 And grassmap[x][y-1] = 0 And map[x][y] > numzones/3
			SetColor 40,160,30
			DrawRect x2+tw/4,y2,tw-th/2,th/3
			End If
			'shadow under water
			If grassmap[x][y] = 0 And grassmap[x][y-1] = 1 And map[x][y] < numzones/3
			SetColor 0,0,0
			DrawRect x2,y2,tw+1,th/8
			End If
		Next
		Next


	End Method
End Class

Class MyGame Extends App
	Field refresh:Int
	Field mymap:map
	Field plumps
    Method OnCreate()
        SetUpdateRate(1)
        Seed = GetDate[4] * GetDate[5]
   	  	Local s:Int=Rnd(30,100)
   	  	If s<40 Then plumps = s/1.5 Else plumps = s*2
    	mymap = New map(DeviceWidth,DeviceHeight,s,s,plumps)
		refresh = Millisecs()+3000
    End Method
    Method OnUpdate()
    	If Millisecs() > refresh 
    	  	Local s:Float=Rnd(30,100)
    	  	If Rnd(10)<8 Then s = Rnd(20,40)
  	   	  	If s<40 Then plumps = s/1.5 Else plumps = s*2
	    	mymap = New map(DeviceWidth,DeviceHeight,s,s,plumps)
    	  	refresh = Millisecs()+3000
    	End If        
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
