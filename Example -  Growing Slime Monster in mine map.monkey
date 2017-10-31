Import mojo

Global mapwidth:Int=200
Global mapheight:Int=100

'
' This is a growing slime entity.
' 
'
Class growslime
	Field map:Int[][]
	Field w:Float,h:Float
	Field tw:Float,th:Float
	Field openx:Stack<Int>
	Field openy:Stack<Int>
	Field slimetile:Int=10
	Field slimestartx:Int,slimestarty:Int
	Method New()
		w = mymaptest.w * 2
		h = mymaptest.h * 2
		tw = 640 / w
		th = 480 / h
		map = New Int[w][]
		For Local i:Int=0 Until w
			map[i] = New Int[h]
		Next
		'copy the map from the game into this map
		For Local y:Int=0 Until mymaptest.h
		For Local x:Int=0 Until mymaptest.w
		For Local y2:Int=0 Until 2
		For Local x2:Int=0 Until 2
			map[(x*2)+x2][(y*2)+y2] = mymaptest.map[x][y]
		Next
		Next
		Next
		Next
		'create the active slime list
		openx = New Stack<Int>
		openy = New Stack<Int>
		findslimestartpos()
		openx.Push(slimestartx)
		openy.Push(slimestarty)
		map[slimestartx][slimestarty]=slimetile
	End Method
	Method findslimestartpos()
		For Local y:Int=h-1 To 0 Step -1
		For Local x:Int=0 Until w
			If map[x][y] = 1 Then 
				slimestartx = x
				slimestarty = y
				Return
			End If
		Next
		Next
	End Method
	Method update(speed:String)
		Local freq:Int
		If speed = "slow" Then freq = 120 Else freq = 20
		' Expand Slime
		For Local i:Int=0 Until openx.Length
			If Rnd(freq) > 2 Then Continue
			Local x2:Int=openx.Get(i)
			Local y2:Int=openy.Get(i)
			'bottom bleft or bright first
			Local r:Int=Rnd(0,6)
			If r=0 And y2+1<h And map[x2][y2+1] = 1 Then addslime(x2,y2+1) ; Continue
			If r=1 And x2-1 >=0 And y2+1 <h And map[x2-1][y2+1] = 1 Then addslime(x2-1,y2+1) ; Continue
			If r=2 And y2+1<h And map[x2+1][y2+1] = 1 Then addslime(x2+1,y2+1) ; Continue
			' left Or right Then
			r = Rnd(0,2)
			If r=0 And x2-1>=0 And map[x2-1][y2] = 1 Then addslime(x2-1,y2) ; Continue
			If r=1 And x2+1<w And map[x2+1][y2] = 1 Then addslime(x2+1,y2) ; Continue
			' up lup and rup
			r = Rnd(0,23)
			If r=0 And y2-1>=0 And map[x2][y2-1] = 1 Then addslime(x2,y2-1);Continue
			If r=1 And x2-1>=0 And y2-1>=0 And map[x2-1][y2-1] = 1 Then addslime(x2-1,y2-1);Continue
			If r=2 And x2+1<w And y2-1>=0 And map[x2+1][y2-1] = 1 Then addslime(x2+1,y2-1);Continue
		Next
		' Remove Obsolete slime
		For Local i:Int=0 Until openx.Length
			Local cnt:Int=0
			For Local y:Int=-1 To 1
			For Local x:Int=-1 To 1
				Local x2:Int=openx.Get(i)+x
				Local y2:Int=openy.Get(i)+y
				If x2<0 Or y2<0 Or x2>=w Or y2>=h Then 
					cnt+=1
					Continue
				End If
				If map[x2][y2] = slimetile Then cnt+=1
			Next
			Next		
			If cnt=9 Then
				openx.Remove(i)
				openy.Remove(i)
			End If
		Next
	End Method

	Method addslime(sx:Int,sy:Int)
		openx.Push(sx)
		openy.Push(sy)
		map[sx][sy] = slimetile
	End Method

	Method update_vine(speed:String)
		Local freq:Int
		If speed = "slow" Then freq = 200 Else freq = 20
		' Expand Slime
		For Local i:Int=0 Until openx.Length
			For Local y:Int=-1 To 1
			For Local x:Int=-1 To 1
				If Rnd(freq)>2 Then Continue
				Local x2:Int=openx.Get(i)+x
				Local y2:Int=openy.Get(i)+y
				If x2<0 Or y2<0 Or x2>=w Or y2>=h Then Continue
				If map[x2][y2] = 1 Then
					openx.Push(x2)
					openy.Push(y2)
					map[x2][y2] = slimetile
				End If
			Next
			Next
		Next
		' Remove Obsolete slime
		For Local i:Int=0 Until openx.Length
			Local cnt:Int=0
			For Local y:Int=-1 To 1
			For Local x:Int=-1 To 1
				Local x2:Int=openx.Get(i)+x
				Local y2:Int=openy.Get(i)+y
				If x2<0 Or y2<0 Or x2>=w Or y2>=h Then 
					cnt+=1
					Continue
				End If
				If map[x2][y2] = slimetile Then cnt+=1
			Next
			Next		
			If cnt=9 Then
				openx.Remove(i)
				openy.Remove(i)
			End If
		Next
	End Method
	Method draw()
		' Draw the solid slimes ()
        For Local y:Float=0 Until h
        For Local x:Float=0 Until w
            Local x1:Float=x*tw
            Local y1:Float=y*th
            If map[x][y] = slimetile
                SetColor 20,200,10
                DrawOval x1,y1,tw+1,th+1
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
        'For Local y1=vy Until bottomy+2
        '    map[x][y1] = 2
        ' Next
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
Global mygrowslime:growslime

Class MyGame Extends App
    Field nmap:Int=0
    Method OnCreate()
        Local date := GetDate()
        Seed = date[5]
        SetUpdateRate(60)
        restartgame
    End Method
    Method OnUpdate()    
        nmap+=1
        If KeyDown(KEY_SPACE)=True Or nmap>2660
            restartgame
            nmap=0
        End If
        mygrowslime.update("fast")
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymaptest.draw()
        mygrowslime.draw()
        SetColor 255,255,0
        DrawText "MonkeyX - Growing Slime in the Mines Example",20,0
    End Method
End Class



Function Main()
    New MyGame()
End Function


Function restartgame()
    mymaptest = New maptest(mapwidth,mapheight)
    mygrowslime = New growslime()
End Function

Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return Abs(x2-x1)+Abs(y2-y1)
End Function 
    
Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function
