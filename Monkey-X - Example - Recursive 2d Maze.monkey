Import mojo

Class maze
	Field sw:Int,sh:Int
	Field mw:Int,mh:Int
	Field tmw:Int,tmh:Int
	Field tw:Float,th:Float
	Field mazex:Stack<Int> = New Stack<Int>
	Field mazey:Stack<Int> = New Stack<Int>	
	Field tilemap:Int[][]
	Field map:Int[][]
	Field map2:Int[][][]
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh	
		tmw = (mw*2)+1
		tmh = (mh*2)+1
		tw = Float(sw)/((Float(tmw)))
		th = Float(sh)/((Float(tmh)))
		map2 = New Int[mw][][]
		map = New Int[mw][]
		tilemap = New Int[tmw][]
        For Local i = 0 Until mw
            map[i] = New Int[mh]
            map2[i] = New Int[mh][]
            For Local z = 0 Until mh
            	map2[i][z] = New Int[4]
            Next
        Next
        For Local i = 0 Until tmw
            tilemap[i] = New Int[tmh]
        Next	
        makemaze()
	End Method 
	Method makemaze()
		Local ax:Int[] = [0,1,0,-1]
		Local ay:Int[] = [-1,0,1,0]
		mazex.Push(Rnd(mw))
		mazey.Push(Rnd(mh))								
		While mazex.IsEmpty = False			
			Local x:Int=mazex.Top
			Local y:Int=mazey.Top
			Local d:Int[] = New Int[4]
			Local deadend:Bool=True
			For Local i:=0 Until ax.Length
				Local x2:Int=x+ax[i]
				Local y2:Int=y+ay[i]
				If x2>=0 And x2<mw And y2>=0 And y2<mh
					If map[x2][y2] = 0 
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
						map2[x][y][r] = 1																		
						mazex.Push(nx)
						mazey.Push(ny)						
						map[x][y] = 1
						map[nx][ny] = 1
					End If
				Wend
			Else	' if nothing happened than backtrace
				mazex.Pop()
				mazey.Pop()
			End If
		Wend		
		' convert the map into a tilemap
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			Local x2:Int=x*2
			Local y2:Int=y*2
			If map[x][y] = 1 Then tilemap[x2+1][y2+1] = 1
			If map2[x][y][0] = 1 Then tilemap[x2+1][y2] = 1
			If map2[x][y][1] = 1 Then tilemap[x2+2][y2+1] = 1
			If map2[x][y][2] = 1 Then tilemap[x2+1][y2+2] = 1
			If map2[x][y][3] = 1 Then tilemap[x2][y2+1] = 1			
		Next
		Next
	End Method
	Method draw()
		Cls 0,0,0
		SetColor 200,100,0
		For Local y:Float=0 Until tmh Step 1
		For Local x:Float=0 Until tmw Step 1
			Local x2:Float=(x*tw)
			Local y2:Float=(y*th)
			If tilemap[x][y] = 1 Then 
				DrawRect(x2,y2,tw,th)
			End If
		Next
		Next	
	End Method	
End Class

Global mymaze:maze

Class MyGame Extends App
	Field cnt:Int=500
	Method New()				
	End Method
	
	Method OnRender()		
		cnt+=1
		'
		If cnt>300 Or (KeyDown(KEY_SPACE) And cnt>20) Or (MouseDown(MOUSE_LEFT) And cnt>20 )Then
			cnt=0
			Seed = Millisecs()
			Local s:Int=Rnd(10,64)				
			mymaze = New maze(DeviceWidth,DeviceHeight,s,s)
		End If
		'
		mymaze.draw()
		'
		SetColor 255,255,255
		DrawText("Press space or tap for new maze",0,0)
	End Method	
	
End	Class


Function Main()
    New MyGame()
End Function
