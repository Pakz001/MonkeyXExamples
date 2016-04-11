Import mojo

Global mapwidth:Int = 50
Global mapheight:Int= 50
Global sx:Int 'path start x
Global sy:Int 'path start y
Global ex:Int=mapwidth/2 'path end x
Global ey:Int=mapheight/2 'path end y
Global map:Int[mapwidth][]
Global olmap:Int[mapwidth][]
Global clmap:Int[mapwidth][]
Global pmap:Int[mapwidth][]
' this one refreshes maps
Global waittime:Int=0

Class mapgen
    Field gmap:Int[mapwidth][]
    Field hmap:Int[mapwidth][]
    Field twidth:float,theight:float
    Method New()
        For Local i = 0 Until mapwidth
            gmap[i] = New Int[mapheight]
            hmap[i] = New Int[mapheight]
        Next        
        twidth=640/mapwidth
        theight=480/mapheight
        makehmap
        makemap
    End Method
    Method makemap()
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            map[x][y] = hmap[x][y]
        Next
        Next
        ex = Rnd(10,mapwidth-10)
        ey = Rnd(10,mapheight-10)
        Local numpaths:Int = (mapwidth*mapheight)/700
        For Local i=0 Until numpaths            
            sx = ex
            sy = ey
            Local exitloop:Bool=False
            While exitloop = False
                ex = Rnd(10,mapwidth-10)            
                ey = Rnd(10,mapheight-10)
                If sx<>ex And sy<>ey Then
                    exitloop = True
                End If
            Wend
            findpath    
            For Local ii:=Eachin path
                Local s:Int=2
                If Int(Rnd(1,5)) = 2
                    s=Rnd(2,5)
                    Elseif Int(Rnd(1,9)) = 2
                    s=8
                End If
                For Local y=-s/2 Until s/2
                For Local x=-s/2 Until s/2
                    If     ii.x+x >= 0 And ii.x+x <mapwidth And
                        ii.y+y >= 0 And ii.y+y < mapheight
                      gmap[ii.x+x][ii.y+y] = 1
                      pmap[ii.x+x][ii.y+y] = 1
                     End if
                Next
                Next
            Next
        Next
        ' here add the walls
        For Local y=1 Until mapheight-1
        For Local x=1 Until mapwidth-1
            If gmap[x][y] = 0 
            If gmap[x+1][y] = 1
            gmap[x][y]=2
            End If
            End If
            If gmap[x][y] = 1
            If gmap[x+1][y] = 0
            gmap[x+1][y] = 2
            End If
            End If
            If gmap[x][y] = 0
            If gmap[x][y+1] = 1
            gmap[x][y] = 2
            End If
            End If
            If gmap[x][y] = 1
            If gmap[x][y+1] = 0
            gmap[x][y+1] = 2
            End If
            End if
        Next
        Next
    End Method
    Method drawmap()
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            If gmap[x][y] = 1
                SetColor 150,150,150
                DrawRect     x*twidth,y*theight,
                            twidth,theight
            End If
            If gmap[x][y] = 2
                SetColor 200,200,200
                DrawRect     x*twidth,y*theight,
                            twidth,theight
            End If            
        Next
        Next 
    End Method
    Method makehmap()
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            hmap[x][y] = 3
        Next
        Next
        For Local i=0 To (mapwidth*mapheight)/10
            Local w:Int=Rnd(3,8)
            Local h:Int=Rnd(3,8)
            Local x:Int=Rnd(3,mapwidth-8)
            Local y:Int=Rnd(3,mapheight-8)
            For Local y1=-w/2 To w/2
            For Local x1=-h/2 To h/2
                hmap[x+x1][y+y1]+=1
            Next
            Next
        Next
    End Method
    Method drawhmap()        
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            SetColor hmap[x][y]*10,0,0
            DrawRect     x*twidth,y*theight,
                        twidth,theight
        Next
        Next
    End Method
End Class

Class openlist
    Field x:Int
    Field y:Int
    Field f:Int
    Field g:Int
    Field h:Int
    Field px:Int
    Field py:Int
    Method New(    x:Int=0,y:Int=0,f:Int=0,
                g:Int=0,h:Int=0,px:Int=0,
                py:Int=0)
        Self.x=x
        Self.y=y
        Self.f=f
        Self.g=g
        Self.h=h
        Self.px=px
        Self.py=py
    End Method
End Class
Class closedlist
    Field x:Int
    Field y:Int
    Field px:Int
    Field py:Int 
    Method New(x:Int,y:Int,px:Int,py:Int)
        Self.x = x
        Self.y = y
        Self.px = px
        Self.py = py
    End Method
End Class
Class pathnode
    Field x:Int
    Field y:Int
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
    End Method
End Class

Global ol:List<openlist> = New List<openlist>
Global cl:List<closedlist> = New List<closedlist>
Global path:List<pathnode> = New List<pathnode>
Global mymapgen:mapgen

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        For Local i=0 Until mapwidth
            map[i] = New Int[mapheight]
            olmap[i] = New Int[mapheight]
            clmap[i] = New Int[mapheight]
            pmap[i] = New Int[mapheight]
        Next        
        mymapgen = New mapgen()
    End Method
    Method OnUpdate()
        waittime+=1
        If waittime>120
            mapwidth=Rnd(50,150)
            mapheight=mapwidth
            map = makearray()
            olmap = makearray()
            clmap = makearray()
            pmap = makearray()
            mymapgen = New mapgen()
            waittime = 0
        End If
    End Method
    Method OnRender()
        Cls(0,0,0)
        mymapgen.drawmap
        SetColor 255,255,255        
    End
End

Function makearray:Int[][]()
    Local aa:Int[mapwidth][]
    For Local i=0 Until mapwidth
        aa[i] = New Int[mapheight]
    Next
    Return aa
End Function

Function findpath:Bool()
    If sx = ex And sy = ey Then Return False
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        olmap[x][y] = 0
        clmap[x][y] = 0
    Next
    Next
    ol.Clear
    cl.Clear
    path.Clear
    ol.AddFirst(New openlist(sx,sy))
    Local tx:Int
    Local ty:Int
    Local tf:Int
    Local tg:Int
    Local th:Int
    Local tpx:Int
    Local tpy:Int
    Local newx:Int
    Local newy:Int
    Local lowestf:Int
    olmap[sx][sy] = 1
    While ol.IsEmpty() = False
        lowestf = 100000
        For Local i:=Eachin ol
            If i.f < lowestf
                lowestf = i.f
                tx = i.x
                ty = i.y
                tf = i.f
                tg = i.g
                th = i.h
                tpx = i.px
                tpy = i.py
            End If
        Next
        If tx = ex And ty = ey
            cl.AddLast(New closedlist(tx,ty,tpx,tpy))
            findpathback
            Return True
        Else
            removefromopenlist(tx,ty)
            olmap[tx][ty] = 0
            clmap[tx][ty] = 1
            cl.AddLast(New closedlist(tx,ty,tpx,tpy))
            For Local y=-1 To 1
            For Local x=-1 To 1
                newx = tx+x
                newy = ty+y
                If newx>=0 And newy>=0 And newx<mapwidth And newy<mapheight
                If olmap[newx][newy] = 0
                If clmap[newx][newy] = 0
                    olmap[newx][newy] = 1
                    Local gg:Int
                    If pmap[newx][newy] = 1
                        gg=1
                        Else
                        gg = map[newx][newy]+1
                    End If
                    Local hh = distance(newx,newy,ex,ey)
                    Local ff = gg+hh
                    ol.AddLast(New openlist(newx,newy,ff,gg,hh,tx,ty))
                End If
                End If
                End If
            Next
            Next
        End If
    Wend
    Return False
End Function

Function findpathback:Bool()
    Local x=ex
    Local y=ey
    path.AddFirst(New pathnode(x,y))
    Repeat
        For Local i:=Eachin cl
            If i.x = x And i.y = y
                x = i.px
                y = i.py
                path.AddFirst(New pathnode(x,y))
            End If
        Next
        If x = sx And y = sy Then Return True
    Forever    
End Function

Function removefromopenlist:Void(x1:Int,y1:Int)
    For Local i:=Eachin ol
        If i.x = x1 And i.y = y1
            ol.Remove i
            Exit
        End If
    Next
End Function

Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return Abs(x2-x1)+Abs(y2-y1)
End Function

Function Main()
    New MyGame()
End
