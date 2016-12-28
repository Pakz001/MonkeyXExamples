Import mojo

Global sw:Int=640
Global sh:Int=480

Class map
	Field mw:Int,mh:Int,sw:Int,sh:Int,tw:Float,th:Float
	Field mypoint:Stack<point> = New Stack<point>
	Field myline:Stack<line> = New Stack<line>
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		Self.tw = Float(sw)/Float(mw)
		Self.th = Float(sh)/Float(mh)
		For Local i=0 Until mw*mh/50
			Local x:Int=Rnd(mw)
			Local y:Int=Rnd(mh)
			mypoint.Push(New point(i,x,y))
		Next
		makemap()
	End Method
	Method makemap()
		'get first point
		Local x:Int=mypoint.Get(0).x
		Local y:Int=mypoint.Get(0).y
		Local id:Int=mypoint.Get(0).id 
		Local closestindex:int=0
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
			End if
		Wend
	End Method
	Method draw()
		SetColor 255,255,0
		For Local i:=Eachin myline
			For Local y=-3 To 3
			For Local x=-3 To 3
				Local x1:Int=i.x1*tw+x
				Local y1:Int=i.y1*th+y
				Local x2:Int=i.x2*tw+x
				Local y2:Int=i.y2*th+y		
				DrawLine x1,y1,x2,y2
			Next
			Next
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
        SetUpdateRate(60)
        mymap = New map(640,480,20,20)
    End Method
    Method OnUpdate()        
    	cnt+=1
    	If cnt>60 Then 
			cnt=0
			mymap = New map(640,480,20,20)
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mymap.draw
    End Method
End Class


Function Main()
    New MyGame()
End Function
