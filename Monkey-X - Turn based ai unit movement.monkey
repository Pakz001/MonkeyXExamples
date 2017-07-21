Import mojo

Class floodmap
	Field mw:Int,mh:Int
	Field tw:Float,th:Float
	Field map:Int[][]
	Method New(x:Int,y:Int)
	    ' get the mapwidth and height variables
	    ' from mymap mapwidth and height
		mw = mymap.mw
		mh = mymap.mh 
		' Get the tilewidth and height
		tw = mymap.tw
		th = mymap.th
		' create the flowfieldmap array
		map = New Int[mw][]
		For Local i:=0 Until mw
			map[i] = New Int[mh]
		Next
		'fill the flowmap
		floodfill(x,y)
	End Method
	Method floodfill(x:Int,y:Int)
		Local openlistx:List<Int> = New List<Int>
		Local openlisty:List<Int> = New List<Int>
		openlistx.AddFirst(x)
		openlisty.AddFirst(y)
		map[x][y] = 1

		While openlistx.Count <> 0
			Local x1:Int=openlistx.First
			Local y1:Int=openlisty.First
			openlistx.RemoveFirst
			openlisty.RemoveFirst
			For Local y2:=-1 To 1
			For Local x2:=-1 To 1
				Local nx:Int=x1+x2
				Local ny:Int=y1+y2
				If nx>=0 And ny>=0 And nx<mw And ny<mh
				If map[nx][ny] = 0
					openlistx.AddLast(nx)
					openlisty.AddLast(ny)
					map[nx][ny] = map[x1][y1] + 1					
				End If			
				End If
			Next
			Next


		Wend
	End Method
	Method draw()
		SetColor 255,255,255
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			DrawText map[x][y],tw*x,th*y
		Next
		Next
	End Method
End Class

Class themap
	Field Width:Int,Height:Int
	Field mw:Int,mh:Int
	Field tw:Int,th:Int 'tilewidth and height
	Field map:Int[][]
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		' get the width and height of the screen into these
		' variables
		Width = sw
		Height = sh
		' get the map width and height (tiles)
		' into these variables
		Self.mw = mw
		Self.mh = mh
		' Get the tilewidth and height into
		' these variables
		tw = Float(Width) / Float(mw)
		th = Float(Height) / Float(mh)
		' Setup the map array
		map = New Int[mw][]
        For Local i = 0 Until mw
            map[i] = New Int[mh]
        Next
	End Method
	Method draw()
		For Local y1:=0 Until mh
		For Local x1:=0 Until mw
			Local x2:Int=x1*tw
			Local y2:Int=y1*th

		Next
		Next
	End Method
End Class

'Unit class
Class unit
	Field tw:Float,th:Float
	Field mw:Int,mh:Int
	Field x:Int,y:Int
	Field player:Int
	Field defence:Float
	Field attack:Float
	Field hasmoved:Bool=False
	Method New(x:Int,y:Int,player:Int)
		' set the player 
		Self.player = player
		' set the tile position x and y
		Self.x = x
		Self.y = y
		' get the mapwidth and height
		mw = mymap.mw
		mh = mymap.mh
		tw = mymap.tw
		th = mymap.th
		' set the defence rate
		defence = 2.0
		attack = 2.0
	End Method
	'
	Method followfloodmap()
		Local currentdist:Int=myfloodmap.map[x][y]
		If currentdist<2 Then return
		Local exitloop:Bool=False
		While exitloop = False
		Local cnt:Int=0
		For Local y1:=-1 To 1
		For Local x1:=-1 To 1
			Local nx:Int=x+x1
			Local ny:Int=y+y1
			If nx>=0 And ny>=0 And nx<mw And ny<mh
				If Rnd(10)<2 And myfloodmap.map[nx][ny] < currentdist
					x = nx
					y = ny
					return
				End If
			End If
			cnt+=1
			If cnt>100 Then return
		Next
		Next
		Wend
	End Method
	' Draw the unit to the screen
	Method draw()
		Select player
			Case 1
			SetColor 255,0,0
			Case 2
			SetColor 255,0,255
		End Select
		DrawRect x*tw,y*th,tw,th
	End Method
End Class

Global myfloodmap:floodmap
Global myunit:List<unit> = New List<unit>
Global mymap:themap


Class MyGame Extends App

    Method OnCreate()
    	newgame()
        SetUpdateRate(1)

    End Method
    Method OnUpdate()        
		Local reset:Bool=True
        For Local i:=Eachin myunit
        	If i.hasmoved = False Then reset=False
        Next
        If reset=True Then 
        For Local i:=Eachin myunit
        	i.hasmoved=False
       	Next
        End If        
        For Local i:=Eachin myunit
	        If i.hasmoved = False
        	i.followfloodmap
        	i.hasmoved = True
        	exit
        	End If
        Next

    End Method
    Method OnRender()
        Cls 0,0,0 

       	myfloodmap.draw
        
        For Local i:=Eachin myunit
        	i.draw
        Next
        
        SetColor 255,255,255
    End Method
End Class

Function newgame()
	mymap = New themap(DeviceWidth,DeviceHeight,20,20)
	myfloodmap = New floodmap(10,10)
	For Local i:=0 Until 10
		myunit.AddFirst(New unit(Rnd(2,18),Rnd(2,18),1))
	Next
End Function

Function Main()
    New MyGame()
End Function
