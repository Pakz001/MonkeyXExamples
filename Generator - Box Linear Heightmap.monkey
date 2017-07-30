'
' I tried to create this box linear filter after reading about it. I did not
' really understand the whole descripton so this might not be the correct way
' of coding this.
'
'

Import mojo

' here we create the heightmap
Class boxlinearfilter
	' map width/height screen width/height
	Field mw:Int,mh:Int,sw:Int,sh:Int
	' tile width/height
	Field tw:Float,th:Float
	' the heightmap array
	Field map:Int[][]
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		' set up variables for map and tiles and screen
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		Self.tw = Float(sw) / Float(mw)
		Self.th = Float(sh) / Float(mh)
		' create the heightmap array
		map = New Int[mw][]
		For Local i:=0 Until mw
			map[i] = New Int[mh]
		Next
		makeheightmap()
	End Method
	' Here we create the box linear filter heightmap
	' it works by creating peak values on the map and then
	' avaraging them out on the map.
	' We do this by randomly picking a x,y location and 
	' then reading the surrounding map values and then turn
	' the x,y position in the avarage one.
	Method makeheightmap()
		' create peak values on the map.
		Local amount1:Int=Rnd(10,100)
		For Local i:=0 Until (mw*mh)/amount1
			Local x:Int=Rnd(0,mw)
			Local y:Int=Rnd(0,mh)
			For Local y2:=-3 To 3
			For Local x2:=-3 To 3
			Local x3:Int=x+x2
			Local y3:Int=y+y2
			If x3<0 Or y3<0 Or x3>=mw Or y3>=mh Then Continue
				map[x3][y3] = Rnd(200,255)			
			Next
			Next
		Next
		' avarage them out
		Local amount2:Int=Rnd(8,30)
		For Local i:=0 Until (mw*mh)*amount2
			Local x1:Int=Rnd(0,mw)
			Local y1:Int=Rnd(0,mh)
			Local c:Int[] = New Int[10]
			Local cnt:Int=0
			For Local y2:=-1 To 1
			For Local x2:=-1 To 1
			Local x3:Int=x1+x2
			Local y3:Int=y1+y2
			If x3<0 Or y3<0 Or x3>=mw Or y3>=mh Then Continue
			c[cnt] = map[x3][y3]
			cnt+=1
			Next
			Next
			Local ac:Int=0
			For Local i:=0 Until cnt
				ac+=c[i]
			Next
			ac/=cnt
			map[x1][y1] = ac
		Next
	End Method
	' Draw the heightmap
	Method draw()
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			SetColor map[x][y],map[x][y],map[x][y]
			DrawRect x*tw,y*th,tw+1,th+1
		Next
		Next
	End Method
End Class

Class MyGame Extends App
	Field myheightmap:boxlinearfilter
	Field s:Int
    Method OnCreate()
        SetUpdateRate(1)
        Seed = GetDate[4] + GetDate[5]
    End Method
    Method OnUpdate()        
    	Local ss:Int=Rnd(10)
    	If ss<7 Then s = 512 Elseif s<5 Then s=256 Else s=100
	    myheightmap = New boxlinearfilter(DeviceWidth(),DeviceHeight(),s,s)
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        myheightmap.draw()
    End Method
End Class


Function Main()
    New MyGame()
End Function
