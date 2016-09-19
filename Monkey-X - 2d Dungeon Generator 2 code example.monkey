Import mojo

Const screenwidth:Int=640
Const screenheight:Int=480
Global mapwidth:Int=100
Global mapheight:Int=100
Global tilewidth:Float=640/Float(mapwidth)
Global tileheight:Float=480/Float(mapheight)
Const isnothing:Int=0
Const iswall:Int=1
Const isfloor:Int=2
Const isdoor:Int=3
Const minroomw:Int=5
Const minroomh:Int=5
Const maxroomw:Int=10
Const maxroomh:Int=10

Global map:Int[mapwidth][]
Global lightmap:Int[mapwidth][]
Global backmap:Int[mapwidth][]

Global rcount:Int=0

Class debug
    Field x:Int
    Field y:Int
    Method New(_x:Int,_y:Int)
        x=_x
        y=_y
    End Method
End Class
Class dooropenlist
    Field x:Int
    Field y:Int
    Method New(_x:Int,_y:Int)
        x=_x
        y=_y
    End Method
End Class
Class doorclosedlist
    Field x:Int
    Field y:Int
    Method New(_x:Int,_y:Int)
        x=_x
        y=_y
    End Method
End Class

Global dol:List<dooropenlist> = New List<dooropenlist>
Global dcl:List<doorclosedlist> = New List<doorclosedlist>
Global d:List<debug> = New List<debug>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(1)
        Seed = Millisecs()
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
            lightmap[i] = New Int[mapheight]
            backmap[i] = New Int[mapheight]
        Next
        createmap(25,mapwidth/2,mapheight/2)
        createlightmap
        createbackmap
    End Method
    Method OnUpdate()  
        createmap(Rnd(10,125),mapwidth/2,mapheight/2)
   		createlightmap
   		createbackmap
	End Method
    Method OnRender()
        Cls 0,0,0
        SetColor 255,255,255
        drawmap
        drawbackmap
        drawlightmap
    End Method
End Class


Function createmap:Bool(numrooms:Int,sx:Int,sy:Int)
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        map[x][y] = isnothing
        lightmap[x][y] = 0
        backmap[x][y] = 0
    Next
    Next
    d.Clear
    dol.Clear
    dcl.Clear
    dol.AddLast(New dooropenlist(sx,sy))
    Local roomcount:Int=0
    Local tx:Int
    Local ty:Int
    While roomcount<numrooms And dol.IsEmpty() = False
        Local founddoor:Bool=False
        While founddoor=False
            For Local i:=Eachin dol
                If Rnd(100)<2
                    founddoor = True
                    tx = i.x
                    ty = i.y
                    Exit
                End If
            Next
        Wend
        If makeroomondoor(tx,ty) = True Then 
            roomcount+=1
            removedoorfromopenlist(tx,ty)
            dcl.AddLast(New doorclosedlist(tx,ty))
        Else
            removedoorfromopenlist(tx,ty)
        End If
    Wend
    For Local i:=Eachin dcl
        If i.x = sx And i.y = sy Then dcl.Remove i
    Next
    rcount = roomcount
    For Local i:=Eachin dcl
    	map[i.x][i.y] = isdoor
    Next
End Function


Function makeroomondoor:Bool(x:Int,y:Int)
    Local makeroom:Bool=False
    Local cnt:Int=0
    Local x1:Int
    Local y1:Int
    Local w1:Int
    Local h1:Int
    Local facing:String
    If x+maxroomw > mapwidth Then Return False
    If y+maxroomh > mapheight Then Return False
    If x-maxroomw < 0 Then Return False
    If y-maxroomh < 0 Then Return False    
    If map[x+1][y]=isnothing Then facing = "right"
    If map[x][y-1]=isnothing Then facing = "up"
    If map[x][y+1]=isnothing Then facing = "down"
    If map[x-1][y]=isnothing Then facing = "left"
    If facing="" Then Return False
    While cnt<100
        w1 = Rnd(minroomw,maxroomw)
        h1 = Rnd(minroomh,maxroomh) 
        Select facing
            Case "left"
                x1=x-w1
                y1=y-Rnd(h1/2)
            Case "right"
                x1=x+1
                y1=y-Rnd(h1/2)
            Case "up"
                x1=x-Rnd(w1/2)
                y1=y-h1
            Case "down"
                x1=x-Rnd(w1/2)
                y1=y+1
        End Select
        If spaceisempty(x1,y1,w1,h1) = True Then
            For Local y2=0 Until h1
            For Local x2=0 Until w1
                map[x2+x1][y2+y1] = isfloor
                If y2 = 0 Or x2 = 0 Or y2 = h1-1 Or x2 = w1-1 Then map[x2+x1][y2+y1] = 1  ' wall
            Next
            Next    
            ' shift map
            Select facing
                Case "left"        
                    For Local y2=0 Until h1
                    For Local x2=w1 Until 0 Step -1
                        map[x2+x1][y2+y1] = map[x2+x1-1][y2+y1]
                    Next
                    Next
                    For Local y2=0 Until h1
                        map[x1][y2+y1] = isnothing
                    Next
                    'make doors
                    makedoors(x1,y1,w1,h1,True,False,True,True)
                Case "right"        
                    For Local y2=0 Until h1
                    For Local x2=0 Until w1
                        map[x2+x1-1][y2+y1] = map[x2+x1][y2+y1]
                    Next
                    Next
                    For Local y2=0 Until h1
                        map[x1+w1-1][y2+y1] = isnothing
                    Next
                    'make doors
                    makedoors(x1-1,y1,w1,h1,False,True,True,True)                        
                Case "up"        
                    For Local y2=h1 Until 0 Step -1
                    For Local x2=0 Until w1
                        map[x2+x1][y2+y1] = map[x2+x1][y2+y1-1]
                    Next
                    Next
                    For Local x2=0 Until w1
                        map[x1+x2][y1] = isnothing
                    Next
                    'make doors
                    makedoors(x1,y1+1,w1,h1,True,True,True,False)
                Case "down"        
                    For Local y2=0 Until h1
                    For Local x2=0 Until w1
                        map[x2+x1][y2+y1-1] = map[x2+x1][y2+y1]
                    Next
                    Next
                    For Local x2=0 Until w1
                        map[x1+x2][y1+h1-1] = isnothing
                    Next
                    'make doors
                    makedoors(x1-1,y1-1,w1+1,h1,True,True,False,True)                        
            End Select            
            Return True                
        End If
        cnt+=1
    Wend
    Return False
End Function

Function makedoors:Void(x:Int,y:Int,w:Int,h:Int,l:Bool,r:Bool,u:Bool,d:Bool)
    Local dx:Int
    Local dy:Int
    If l=True Then 'left side
        dx = x+1
        dy = y+Rnd(h-4)+2
        dol.AddLast(New dooropenlist(dx,dy))
    End If
    If r=True Then 'right side
        dx = x+w-1
        dy = y+Rnd(h-4)+2
        dol.AddLast(New dooropenlist(dx,dy))
    End If
    If u=True Then 'up side
        dx = x+Rnd(w-4)+2
        dy = y
        dol.AddLast(New dooropenlist(dx,dy))
       End If
    If d=True Then ' down side
        dx = x+Rnd(w-4)+2
        dy = y+h-1
        dol.AddLast(New dooropenlist(dx,dy))
    End If
End Function

Function spaceisempty:Bool(x:Int,y:Int,w:Int,h:Int)
    For Local y1=0 Until h
    For Local x1=0 Until w
        If map[x1+x][y1+y] <> isnothing Then Return False
    Next
    Next
    Return True
End Function

Function makeroom(x:Int,y:Int,w:Int,h:Int)
    For Local y1=0 Until h
    For Local x1=0 Until w
        map[x1+x][y1+y] = 2  ' floor
        If y1 = 0 Or x1 = 0 Or y1 = h-1 Or x1 = w-1 Then map[x1+x][y1+y] = 1  ' wall
    Next
    Next
End Function

Function drawmap:Bool()
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        Select map[x][y]
            Case isnothing ; 
            Case iswall ; SetColor 150,150,150 ' wall
            Case isfloor ; SetColor 50,50,50 ' floor
            Case isdoor ; SetColor 170,170,170 ' door
        End Select
        If map[x][y]<>isnothing Then DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
    Next
    Next
    'SetColor 255,255,0
    'For Local i:=Eachin dcl
    '    DrawRect i.x*tilewidth,i.y*tileheight,tilewidth,tileheight
    'Next
    SetColor 255,255,255
    DrawText "Number of rooms :"+rcount,0,0
    #rem
    SetColor 255,0,0
    For Local i:=Eachin d
        DrawRect i.x*tilewidth,i.y*tileheight,tilewidth,tileheight
    Next
    #End
End Function

Function removedoorfromopenlist:Void(x:Int,y:Int)
    For Local i:=Eachin dol
        If i.x = x And i.y = y Then 
            dol.Remove i 
            d.AddLast(New debug(x,y))
            Return
        End If
    Next
End Function

Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
	Return Abs(x2-x1)+Abs(y2-y1)
End Function

Function drawlightmap()
	For Local y=0 Until mapheight
	For Local x=0 Until mapwidth
		Local col=lightmap[x][y]
		If col>0
			SetColor col,col,col
			DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
		End If
	Next
	Next
End Function

Function createlightmap()
	For Local y=1 Until mapheight-1
	For Local x=1 Until mapwidth-1
		If map[x][y] = iswall
		If map[x][y+1] = iswall
		If map[x+1][y] = iswall
		If map[x+1][y+1] = isfloor
			Local col:Int=250
			For Local y1=0 To 5
				If y+y1 >= 0 And y+y1 <= mapheight
				If map[x][y+y1] = iswall
				lightmap[x][y+y1] = col
				End If
				End If
				col-=22
			Next
			col = 250
			For Local y1=0 To -5 Step -1
				If y+y1 >= 0 And y+y1 <= mapheight
				If map[x][y+y1] = iswall
				lightmap[x][y+y1] = col
				End If
				End If
				col-=22
			Next
			col = 250
			For Local x1=0 To 5
				If x+x1 >= 0 And x+x1<=mapwidth
				If map[x+x1][y] = iswall
				lightmap[x+x1][y] = col
				End If
				End If
				col-=22
			Next
			col = 250
			For Local x1=0 To -5 Step -1
				If x+x1>=0 And x+x1<=mapwidth
				If map[x+x1][y] = iswall
				lightmap[x+x1][y] = col
				End If
				end if
				col-=22
			Next

		End If
		End If
		End If
		End If
		'
		If map[x][y] = isfloor
		If map[x-1][y] = isfloor
		If map[x+1][y] = iswall
		If map[x][y+1] = iswall
		If map[x+1][y+1] = iswall
			For Local y1=-5 To 5
			For Local x1=-5 To 5
				If x+x1 >= 0 And y+y1 >= 0 And x+x1 < mapwidth And y+y1 <mapheight
				Local l:Int=0
				l+=distance(x+x1,y+y1,x,y)*3
				If map[x+x1][y+y1] = isfloor
				lightmap[x+x1][y+y1] = 30+l
				End If
				End if
			Next
			Next
		End If
		End If
		End If
		End If
		End If
	Next
	Next
End Function


Function drawbackmap()
	For Local y=0 Until mapheight
	For Local x=0 Until mapwidth
		Local val:Int=backmap[x][y]
		If val > 0
			SetColor val,val,val
			DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
		End If
	Next
	Next
End Function

Function createbackmap()
	Local val=0
	For Local x=0 Until mapwidth
	For Local y=0 Until mapheight
		If map[x][y] = 0
			backmap[x][y] = val
		Endif
		If x+1 < mapwidth And x-1 >= 0 And y-1 >=0 And y+1 <mapheight
		If map[x+1][y] = iswall Or 
			map[x-1][y] = iswall Or
			map[x][y-1] = iswall Or
			map[x][y+1] = iswall
		If map[x][y] = isnothing
			backmap[x][y] /= 2
		Endif
		End If
		End If
	Next
	If x<mapwidth/2
	val+=Rnd(0,4)
	Else
	val-=Rnd(0,4)
	End If
	Next
End Function

Function Main()
    New MyGame()
End Function
