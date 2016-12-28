' based on a description from the rogue basin forum
' what it does it place random dots with unique id
' connect closest of different id
' make same id of last point
' until all points
' loop through all lines and fill map under the lines.

Import mojo

Global mapwidth:Int=50
Global mapheight:Int=50
Global sw:Int=640
Global sh:Int=480

Class map
	Field mw:Int,mh:Int,sw:Int,sh:Int,tw:Float,th:Float
	Field mypoint:Stack<point> = New Stack<point>
	Field myline:Stack<line> = New Stack<line>
	Field map:Int[][]
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		Self.tw = Float(sw)/Float(mw)
		Self.th = Float(sh)/Float(mh)
		map = New Int[mw][]
		For Local i=0 Until mw
			map[i] = New Int[mh]
		Next
		For Local i=0 Until mw*mh/200
			Local x:Int=Rnd(5,mw-5)
			Local y:Int=Rnd(5,mh-5)
			mypoint.Push(New point(i,x,y))
		Next
		makemap()
	End Method
	Method makemap()
		' connect point to closest point with unique id
		'get first point
		Local x:Int=mypoint.Get(0).x
		Local y:Int=mypoint.Get(0).y
		Local id:Int=mypoint.Get(0).id 
		Local closestindex:Int=0
		While closestindex<>-1
			'find closest
			Local dist:Int=10000		
			closestindex=-1		
			For Local ii=0 Until mypoint.Length
				If mypoint.Get(ii).id <> id
				Local d:Int=distance(x,y,mypoint.Get(ii).x,mypoint.Get(ii).y) 
				If d<dist Then			
					dist=d
					closestindex = ii
				End If
				End If
			Next
			If closestindex>-1
				mypoint.Get(closestindex).id = id
				myline.Push(New line(x,y,mypoint.Get(closestindex).x,mypoint.Get(closestindex).y))
				x = mypoint.Get(closestindex).x
				y = mypoint.Get(closestindex).y
			End If
		Wend
		'make the map
		For Local i:=Eachin myline
			Local x1:Int=i.x1
			Local y1:Int=i.y1
			Local x2:Int=i.x2
			Local y2:Int=i.y2
			Local exitloop:Bool=False
			While exitloop=False
				If x1<x2 Then x1+=1
				If x1>x2 Then x1-=1
				If y1<y2 Then y1+=1
				If y1>y2 Then y1-=1
				If x1=x2 And y1=y2 Then exitloop=True
				' create the tunnel size
				Local s:Int=Rnd(1,3)
				' sometimes make a wider tunnel
				If Rnd(mw*mh)< (mw*mh/7) Then s=Rnd(s,s*3)
				putmap(x1,y1,s)
			Wend
		Next
	End Method
	Method putmap(x:Int,y:Int,s:Int)
		For Local y3=-s To s
		For Local x3=-s To s
			Local x4:Int=x+x3
			Local y4:Int=y+y3
			If x4>=0 And x4<mw And y4>=0 And y4<mh
			map[x4][y4] = 1
			End If
		Next
		Next	
	End Method
	Method draw()
		SetColor 155,50,0
		For Local y=0 Until mh
		For Local x=0 Until mw
			If map[x][y] = 1
				DrawRect x*tw,y*th,tw+1,th+1
			End If
		Next
		Next
		SetColor 255,255,0
		For Local i:=Eachin myline
			Local x1:Int=i.x1*tw
			Local y1:Int=i.y1*th
			Local x2:Int=i.x2*tw
			Local y2:Int=i.y2*th		
			DrawLine x1,y1,x2,y2
		Next
		SetColor 255,0,0
		For Local i:=Eachin mypoint
			DrawRect i.x*tw,i.y*th,5,5
			DrawText i.id,i.x*tw,i.y*th
		Next

	End Method
    Method distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Method	
End Class

Class point
	Field id:Int
	Field x:Int,y:Int
	Method New(id:Int,x:Int,y:Int)
		Self.id = id
		Self.x = x
		Self.y = y
	End Method
End Class
Class line
	Field x1:Int,y1:Int
	Field x2:Int,y2:Int
	Method New(x1:Int,y1:Int,x2:Int,y2:Int)
		Self.x1 = x1
		Self.y1 = y1
		Self.x2 = x2
		Self.y2 = y2
	End Method
End Class

Global mymap:map

Class MyGame Extends App
	Field cnt:Int=0
    Method OnCreate()
        SetUpdateRate(10)
        mymap = New map(640,480,mapwidth,mapheight)
    End Method
    Method OnUpdate()        
    	cnt+=1
    	If cnt>100 Or KeyDown(KEY_SPACE) Or MouseDown(MOUSE_LEFT) Then 
			Seed = Millisecs()
			cnt=0
			Local w:Int=Rnd(50,200)
			Local h:Int=w
			mymap = New map(640,480,w,h)
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymap.draw
        SetColor 255,255,255
        DrawText "RogueLike maps - Press Space or Mouse Button for new map or wait",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
