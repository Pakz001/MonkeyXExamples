'Is this the breath first search? Not to familiar with it.

Import mojo

Class search
	Field screenwidth:Int,screenheight:Int
	Field mapwidth:Int,mapheight:Int
	Field tilewidth:Float,tileheight:Float
	Field sx:Int,sy:Int
	Field ex:Int,ey:Int
	Field map:Int[][]
	Field myopenlist:List<node>
	Field myclosedlist:List<node>
	Field mypath:List<path>
	Field mx:Int[]=[0,-1,1,0]
	Field my:Int[]=[-1,0,0,1]
	Method New(screenwidth:Int,screenheight:Int,mapwidth:Int,mapheight:Int)
		Self.screenwidth = screenwidth
		Self.screenheight = screenheight
		Self.mapwidth = mapwidth
		Self.mapheight = mapheight
		Self.tilewidth = Float(screenwidth) / Float(mapwidth)
		Self.tileheight = Float(screenheight) / Float(mapheight)
		map = New Int[mapwidth][]
		For Local i:Int=0 Until mapwidth
			map[i] = New Int[mapheight]
		Next
	End Method
	Method search(sx:Int,sy:Int,ex:Int,ey:Int)
		If sx=ex And sy=ey Then Return
		Self.sx = sx
		Self.sy = sy
		Self.ex = ex
		Self.ey = ey
		myopenlist = New List<node>
		myclosedlist = New List<node>
		mypath = New List<path>
		myopenlist.AddFirst(New node(sx,sy,sx,sy))
		While Not myopenlist.IsEmpty
			Local cx:Int=myopenlist.First.x
			Local cy:Int=myopenlist.First.y
			Local px:Int=myopenlist.First.parentx
			Local py:Int=myopenlist.First.parenty
			myclosedlist.AddFirst(New node(cx,cy,px,py))
			If cx = ex And cy = ey Then Exit
			myopenlist.RemoveFirst()

			For Local i:Int=0 Until mx.Length
				Local nx:Int=cx+mx[i]
				Local ny:Int=cy+my[i]
				If nx<0 Or ny<0 Or nx>=mapwidth Or ny>=mapheight Then Continue
				If map[nx][ny] = 0
				If isonclosedlist(nx,ny) = False And isonopenlist(nx,ny) = False
				myopenlist.AddLast(New node(nx,ny,cx,cy))				
				End If
				End If
			Next
		Wend
		findpathback
	End Method
	
    ' Here we calculate back from the end back to the
    ' start and create the path list.
    Method findpathback:Bool()
        Local x:Int=ex
        Local y:Int=ey
        mypath.AddFirst(New path(x,y))
        Repeat
            For Local i:=Eachin myclosedlist
                If i.x = x And i.y = y
                    x = i.parentx
                    y = i.parenty
                    mypath.AddFirst(New path(x,y))
                End If
            Next
            If x = sx And y = sy Then Return True
        Forever    
    End Method

	Method drawpath()
		For Local i:=Eachin mypath
			SetColor 255,0,0
			DrawOval i.x*tilewidth+20,i.y*tileheight,20,20
		Next
	End Method
	
	Method drawclosedlist()
		For Local i:=Eachin myclosedlist
			DrawText "loc:"+i.x+","+i.y,				i.x*tilewidth,i.y*tileheight+15
			DrawText "par:"+i.parentx+","+i.parenty,	i.x*tilewidth,i.y*tileheight+30
		Next
	End Method

	Method isonopenlist:Bool(x:Int,y:Int)
		For Local i:=Eachin myopenlist
			If x = i.x And y = i.y Then 
			Return True
			End If
		Next
		Return False
	End Method

	Method isonclosedlist:Bool(x:Int,y:Int)
		For Local i:=Eachin myclosedlist
			If x = i.x And y = i.y Then 
			Return True
			End If
		Next
		Return False
	End Method
	Method draw()
		SetColor 255,255,255
		For Local y:Int = 0 Until mapheight
		For Local x:Int = 0 Until mapheight
			SetColor 255,255,255
			If sx = x And sy = y
				SetColor 255,0,0
				DrawOval x*tilewidth+10,y*tileheight,10,10
			End If
			If ex = x And ey = y
				SetColor 255,255,0
				DrawOval x*tilewidth+10,y*tileheight,10,10
			End If
		Next
		Next
	End Method
End Class

Class node
	Field x:Int
	Field y:Int
	Field parentx:Int
	Field parenty:Int
	Method New(x:Int,y:Int,parentx:Int,parenty:Int)
		Self.x = x
		Self.y = y
		Self.parentx = parentx
		Self.parenty = parenty
	End Method
End Class

Class path
	Field x:Int
	Field y:Int
	Method New(x:Int,y:Int)
		Self.x = x
		Self.y = y
	End Method
End Class

Class MyGame Extends App

	Field mysearch:search
	Field cnt:Int=0
    Method OnCreate()
        SetUpdateRate(60)
        mysearch = New search(DeviceWidth,DeviceHeight,10,10)
        mysearch.search(2,2,6,6)
    End Method
    Method OnUpdate()  
    	cnt+=1
    	If KeyHit(KEY_SPACE) Or cnt>150
    		cnt=0
    		Local w:Int=Rnd(10,50)
    		mysearch = New search(DeviceWidth,DeviceHeight,w,w)
    		mysearch.search(Rnd(w),Rnd(w),Rnd(w),Rnd(w))
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mysearch.draw
        mysearch.drawclosedlist
        mysearch.drawpath
    End Method
End Class


Function Main()
    New MyGame()
End Function
