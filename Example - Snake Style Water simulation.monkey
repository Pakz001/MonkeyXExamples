'snake(style) 2d water
Import mojo

Global mapwidth:Int=200
Global mapheight:Int=100

Class watertest
    Field map:Int[][]
 	Field w:Float,h:Float
 	Field tw:Float,th:Float
	Field flowx:Int,flowy:Int
	Field dir:String="down"
    Method New()
        Self.w = mymaptest.w*4
        Self.h = mymaptest.h*4
        Self.tw = 640/w
        Self.th = 480/h

        map = New Int[w][]
        For Local i=0 Until w
            map[i] = New Int[h]
        Next
        flowx = 10
        flowy = 10
		For Local y:Int=0 Until mymaptest.h
		For Local x:Int=0 Until mymaptest.w
			If mymaptest.map[x][y] = 1
			For Local y2:Int=0 Until 4
			For Local x2:Int=0 Until 4
				map[x*4+x2][y*4+y2] = 1
			Next
			Next
			End If
		Next
		Next
	End Method
	Method update()
		Local a:Bool=False
		dir = "new"
		If map[flowx][flowy+1] = 1 Then dir="down" ; a=True
		If a=False And map[flowx+1][flowy] = 1 Then dir="right"; a=True
		If a=False And map[flowx-1][flowy] = 1 Then dir="left" ; a = True
		If a=False And map[flowx][flowy-1] = 1 Then dir="up" ; a = True
		
		If dir="left" And map[flowx-2][flowy] = 10 Then map[flowx-2][flowy] = 1
		If dir="right" And map[flowx+2][flowy] = 10 Then map[flowx+2][flowy] = 1		

		

		map[flowx][flowy]=10
		If dir="left" 
		If map[flowx-1][flowy-1]=10 Then map[flowx-1][flowy-1]=1
		Elseif dir="right"
		If map[flowx+1][flowy-1]=10 Then map[flowx+1][flowy-1]=1
		End If

		Select dir
			Case "up"
			flowy-=1
			Case "left"
			flowx-=1
			Case "right"
			flowx+=1
			Case "down"
			flowy+=1			
		End Select
		
		If dir="new" Or Rnd(60*20) < 2 Then ' if the snake got stuck then
						  ' find a new spot
			dir = "done"
			For Local y:Int=h-1 Until 1 Step -1
			For Local x:Int=0 Until w
				If map[x][y] = 1 And map[x][y+1] = 10 Then
					flowx = x
					flowy = y
					Return
				End If
			Next
			Next
		End If
	End Method
	Method draw()
        For Local y:Int=0 Until h
        For Local x:Int=0 Until w
            Local x1:Float=x*tw
            Local y1:Float=y*th
            If map[x][y] = 10
                SetColor 0,0,255                
                DrawRect x1,y1,tw+1,th+1
            End If
        Next
        Next
	End Method
End Class

Class maptest
    Field tw:Float,th:Float
    Field w:Int,h:Int
    'bottom x and y contain the coords of the next
    'shaft to be created. center of room last pass
    Field bottomy:Int
    Field bottomx:Int
    Field map:Int[][]
    Method New(w:Int,h:Int)
        Self.w = w
        Self.h = h
        tw = DeviceWidth()/w
        th = DeviceHeight()/h
        map = New Int[w][]
        For Local i=0 Until w
            map[i] = New Int[h]
        Next
        drawmaprect(0,0,w-1,15)
        For Local i=0 Until h
            map[1][i] = 0
            map[w-2][i] = 0
        Next
        ' x,y,number of tunnels>>
        makemine(w/2,15,Rnd(1,3))
        makemine(bottomx,bottomy,Rnd(1,3))
        If bottomy<(Float(mapheight)/2)
            makemine(bottomx,bottomy,Rnd(1,3))
        End If
    End Method
    Method makemine(x:Int,y:Int,depth:Int)
        Local vy:Int=y
        For Local mydepth=0 Until depth
            Local d1:Int=Rnd(8,16)'depth
            tunneldown(x,y,d1)
            y+=d1
            Local d2:Int=Rnd(1,4)'direction
            If d2=1 Then 
                sidetunnel(x,y,"left")
            End If
            If d2=2 Then 
                sidetunnel(x,y,"right")
            End If
            If d2=3 Then 
                sidetunnel(x,y,"left")
                sidetunnel(x,y,"right")
            End If
        Next
'        For Local y1=vy Until bottomy+2
 '           map[x][y1] = 2
  '      Next
    End Method
    Method sidetunnel(x:Int,y:Int,d:String)
        If d="left"
            Local width:Int=Rnd(5,15)
            drawmaprect(x-width+2,y,width,3)
            Local roomw:Int=Rnd(5,15)
            drawmaprect(x-width+2-roomw,y-1,roomw,5)
            For Local x1=0 Until roomw/3
                map[(x-width+2-roomw)+x1][y+4] = 3
            Next
            bottomx = x-width-(roomw/2)
            bottomy = y
        End If
        If d="right"
            Local width:Int=Rnd(5,15)
            drawmaprect(x-1,y,width,3)
            Local roomw:Int=Rnd(5,15)
            drawmaprect(x+width,y-1,roomw,5)        
            For Local x1=roomw Until roomw/1.5 Step -1
                map[(x+width)+x1][y+4] = 3
            Next
            bottomx = x+width+(roomw/2)            
            bottomy = y
        End If
    End Method
    Method tunneldown(x:Int,y:Int,d:Int)
        drawmaprect(x-2,y,4,d)
    End Method
    Method drawmaprect(x:Int,y:Int,w:Int,h:Int)
        For Local y1=y To y+h
        For Local x1=x To x+w
            map[x1][y1] = 1
        Next
        Next        
    End Method
    Method draw()
        For Local y=0 Until h
        For Local x=0 Until w
            Local x1:Float=DeviceWidth()/Float(mapwidth)*Float(x)
            Local y1:Float=DeviceHeight/Float(mapheight)*Float(y)
            If map[x][y] = 1
                SetColor 255,255,255                
                DrawRect x1,y1,tw+1,th+1
            End If
            If map[x][y] = 3
                SetColor 200,200,10
                DrawOval x1,y1,tw+1,th+1
            End If            
        Next
        Next
    End Method
End Class

' -----------------------------------------------------------------------------------------------

Global mymaptest:maptest
Global mywatertest:watertest

Class MyGame Extends App
    Field nmap:Int=0
    Method OnCreate()
        Local date := GetDate()
        Seed = date[5]
        SetUpdateRate(60)
        restartgame
    End Method
    Method OnUpdate()    
		For Local i:Int=0 Until 6
        mywatertest.update()
        Next           
		If levelfilled() Then restartgame
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymaptest.draw()
        mywatertest.draw()
        SetColor 255,255,0
        DrawText "MonkeyX - 2d Mining map and snake style water.",20,0
    End Method
End Class



Function Main()
    New MyGame()
End Function

Function levelfilled:Bool()
	If Rnd(120)>2 Then Return False
	Local cnt:Int=0
	For Local y:Int=10 Until 60
	For Local x:Int= 0 Until mywatertest.w
	If mywatertest.map[x][y] = 10 Then cnt+=1
	If cnt>100 Then Return True
	Next
	Next

	Return False
End Function

Function restartgame()
    mymaptest = New maptest(mapwidth,mapheight)
    mywatertest = New watertest()
End Function

Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return Abs(x2-x1)+Abs(y2-y1)
End Function 
    
Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function
