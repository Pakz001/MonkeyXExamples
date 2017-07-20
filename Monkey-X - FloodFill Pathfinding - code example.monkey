Import mojo

Class pathnode
	Field x:Int,y:Int
	Method New(x:Int,y:Int)
		Self.x = x
		Self.y = y
	End Method
End Class

Class MyGame Extends App
	Field cmap:Int[][]
	Field mw:Int=20,mh:Int=20
	Field tw:Float=22,th:Float=18
	Field sx:Int,sy:Int,ex:Int,ey:Int
	Field path:List<pathnode>
    Method OnCreate()
        SetUpdateRate(1)
        cmap = New Int[mw][]
        For Local i:=0 Until mw
        	cmap[i] = New Int[mh]
        Next
        tw = DeviceWidth() / Float(mw)
        th = DeviceHeight() / Float(mh)
        Seed = GetDate[4] + GetDate[5]
    End Method
    Method OnUpdate()
    	'erase the map
    	For Local y:=0 Until mh
    	For Local x:=0 Until mw
    		cmap[x][y] = 0
    	Next
    	Next        
 
    	'draw some contents on the map
    	For Local x:=0 Until mw Step 5
    	For Local y:=2 Until mh-2
    		cmap[x][y] = -1
    	Next
    	Next
    	For Local i:=0 Until 5
    		Local x1:Int=Rnd(0,mw-4)
    		Local y1:Int=Rnd(0,mh-4)
    		For Local x2:=0 Until 4
    		For Local y2:=0 Until 4
    			cmap[x1+x2][y1+y2] = -1
    		Next
    		Next
    	Next
    	For Local y:=0 Until mh Step 5
    		For Local x:=0 Until mw
    			cmap[x][y] = 0
    		Next
    	Next
 
 		'find start and end position
 		Repeat
 			sx = Rnd(0,mw)
 			sy = Rnd(0,mh)
 			ex = Rnd(0,mw)
 			ey = Rnd(0,mh)
 			If cmap[sx][sy] = 0 And cmap[ex][ey] = 0 
 				If sx<>ex And sy<>ey
 					Exit
 				End If
 			End If
 		Forever
 
 		'flood the map with distance from
 		'sx and sy
 		Local ol:List<pathnode> = New List<pathnode>
 		ol.AddLast(New pathnode(sx,sy))
 		cmap[sx][sy] = 1
 		Local dx:Int[] = [0,1,0,-1]
 		Local dy:Int[] = [-1,0,1,0]
 		While ol.Count <> 0
 			Local x1:Int=ol.First.x
 			Local y1:Int=ol.First.y
 			ol.RemoveFirst
			For Local i:=0 Until 4
				Local nx:Int=x1+dx[i]
				Local ny:Int=y1+dy[i]
				If nx>=0 And ny>=0 And nx<mw And ny<mh
 				If cmap[nx][ny] = 0 
 					cmap[nx][ny] = cmap[x1][y1] + 1
 					ol.AddLast(New pathnode(nx,ny))
 				End If
 				End If
			Next
 		Wend
 		
 		' Make the path
 		Local x1:Int=ex,y1:Int=ey
 		path = New List<pathnode>
 		path.AddLast(New pathnode(x1,y1))
 		Local cnt:Int=0
		While cmap[x1][y1] > 1		
			Local lowest:Int=cmap[x1][y1]
			Local nx:Int,ny:Int
			If x1-1>=0 And cmap[x1-1][y1]>-1 And cmap[x1-1][y1] < lowest Then 
				nx=x1-1
				ny=y1
				lowest = cmap[nx][ny]
			End If
			If x1+1<mw And cmap[x1+1][y1]>-1 And cmap[x1+1][y1] < lowest
				nx=x1+1
				ny=y1
				lowest = cmap[nx][ny]
			End If
			If y1-1>=0 And cmap[x1][y1-1]>-1 And cmap[x1][y1-1] < lowest
				nx=x1
				ny=y1-1
				lowest = cmap[nx][ny]
			End If
			If y1+1 < mh And cmap[x1][y1+1]>-1 And cmap[x1][y1+1] < lowest
				nx=x1
				ny=y1+1
				lowest = cmap[nx][ny]
			End If
			x1 = nx
			y1 = ny
			path.AddLast(New pathnode(x1,y1))
			cnt+=1
			If cnt>1000 Then Exit
		Wend
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        'draw the map
        For Local y:=0 Until mh
        For Local x:=0 Until mw
        	If cmap[x][y] = -1 Then
        		DrawRect x*tw,y*th,tw,th
        	End If
'        	DrawText cmap[x][y],x*tw,y*th
        Next
        Next
        'draw the path
        If path
        For Local i:=Eachin path
        	SetColor 255,255,0
        	DrawRect i.x*tw,i.y*th,tw,th
        	SetColor 255,255,255
        	DrawText cmap[i.x][i.y],i.x*tw,i.y*th
        Next
        End If
        'Draw the end and start position
        SetColor 255,0,0
        DrawRect sx*tw,sy*th,tw,th
        DrawRect ex*tw,ey*th,tw,th
        
        SetColor 255,255,255
        DrawText "FloodFill pathfinding",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
