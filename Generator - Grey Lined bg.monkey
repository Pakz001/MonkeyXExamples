Import mojo

Class level
	Field mapwidth:Int,mapheight:Int
	Field map:Int[][]
	Field map2:Int[][]
	Field tilewidth:Int,tileheight:Int
	Method New(w:Int,h:Int)
		Self.mapwidth = w
		Self.mapheight = h
        tilewidth = DeviceWidth()/Float(mapwidth)
        tileheight = DeviceHeight()/Float(mapheight)		
		map = New Int[mapwidth][]
		map2= New Int[mapwidth][]
        For Local i=0 Until mapwidth
            map[i] = New Int[mapheight]
            map2[i] = New Int[mapheight]
        Next
		
		' make sets of lines across the canvas
		For Local d = 0 Until mapwidth*mapheight/30
		
			For Local y=0 Until mapheight
			For Local x=0 Until mapwidth
				map[x][y] = 0
			Next
			Next
		
			map[Rnd(5,mapwidth-5)][Rnd(5,mapheight-5)] = 1
			For Local i=0 Until 10
				Local exitloop:Bool=False
				While exitloop = False
					Local x:Int=Rnd(0,mapwidth)
					Local y:Int=Rnd(0,mapheight)
					If map[x][y] = 1
						Local cnt:Int=0
						For Local y1=-1 To 1
						For Local x1=-1 To 1
							If map[x+x1][y+y1] = 1 Then cnt+=1
						Next
						Next
		 				If cnt<4
						exitloop = True
						createlevel(x,y)
						Endif
					End If
				Wend
			Next
			' add another line set onto the map2
			For Local y=0 Until mapheight
			For Local x=0 Until mapwidth
				If map2[x][y] < 255
				map2[x][y] += map[x][y]
				Endif
			Next
			Next


	Next

	End Method
	Method createlevel(x:Int,y:Int)
		Local x1:Int=x
		Local y1:Int=y
		Local dx:Int[] = [0,1,0,-1]
		Local dy:Int[] = [-1,0,1,0]
		Local d:Int=Rnd(0,4)
		For Local i=0 Until (mapwidth*mapheight)/10
			If x1<3 Or y1<3 Or x1>mapwidth-4 Or y1>mapheight-4
				Return
			End If
			If Rnd(0,10) < 2
			d = Rnd(0,4)
			End If
			Local x2:Int=x1+dx[d]
			Local y2:Int=y1+dy[d]
			Select d
				Case 0 ' up
				If map[x2-1][y2] = 0
				If map[x2+1][y2] = 0
				If map[x2][y2-1] = 0
				If map[x2-2][y2] = 0
				If map[x2+2][y2] = 0
				If map[x2][y2-2] = 0
					x1 = x2
					y1 = y2
				End If
				End If
				End If
				End If
				End If
				End If

				Case 1 ' right
				If map[x2][y2-1] = 0
				If map[x2][y2+1] = 0
				If map[x2+1][y2] = 0
				If map[x2][y2-2] = 0
				If map[x2][y2+2] = 0
				If map[x2+2][y2] = 0
					x1 = x2
					y1 = y2
				End If
				End If
				End If
				End If
				End If
				End If

				Case 2 ' down 
				If map[x2-1][y2] = 0
				If map[x2+1][y2] = 0
				If map[x2][y2+1] = 0
				If map[x2-2][y2] = 0
				If map[x2+2][y2] = 0
				If map[x2][y2+2] = 0
					x1 = x2
					y1 = y2
				End If
				End If
				End If
				End If
				End If
				End If
				Case 3 ' left
				If map[x2][y2-1] = 0
				If map[x2][y2+1] = 0
				If map[x2-1][y2] = 0
				If map[x2][y2-2] = 0
				If map[x2][y2+2] = 0
				If map[x2-2][y2] = 0
					x1 = x2
					y1 = y2
				End If
				End If
				End If
				End If
				End If
				End If

			End Select
			map[x1][y1] = 1 
		Next
	End Method
    Method drawmap()
    	SetColor(255,255,255)
        For Local y:Float=0 Until mapheight Step 1
        For Local x:Float=0 Until mapwidth Step 1
        	If map[x][y] = 1
            DrawRect     x*tilewidth,
                        y*tileheight,
                        tilewidth+1,
                        tileheight+1
            End If
        Next
        Next
    End Method	

    Method drawmap2()

        For Local y:Float=0 Until mapheight Step 1
        For Local x:Float=0 Until mapwidth Step 1
        	Local c:Int=map2[x][y]
        	SetColor (c,c,c)
            DrawRect     x*tilewidth,
                        y*tileheight,
                        tilewidth+1,
                        tileheight+1
        Next
        Next

    End Method	

End Class


Global mylevel:level

Class MyGame Extends App
	Field cnt:Int=0
    Method OnCreate()
        SetUpdateRate(1)
        mylevel = New level(150,150)
    End Method
    Method OnUpdate()
    	cnt+=1
    	If cnt=5
    		cnt=0
    		mylevel=New level(150,150)
    	Endif
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mylevel.drawmap2
    End Method
End Class


Function Main()
    New MyGame()
End Function
