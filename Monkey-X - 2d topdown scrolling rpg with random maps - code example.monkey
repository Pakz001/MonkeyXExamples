Import mojo

' map things
' 1 = wal, 2 = door, 3 = health, 4 = coin,
' 5 = tree, 6 = water, 7 = rock

'map gen part
Global mapwidth:Int = 70
Global mapheight:Int= 60
Global sx:Int 'path start x
Global sy:Int 'path start y
Global ex:Int=mapwidth/2 'path end x
Global ey:Int=mapheight/2 'path end y
Global monmap:Int[mapwidth][]
Global map:Int[mapwidth][]
Global olmap:Int[mapwidth][]
Global clmap:Int[mapwidth][]
Global pmap:Int[mapwidth][]
' this one refreshes maps
Global waittime:Int=0
'  scrolling rpg part
Const tilewidth:Int=20
Const tileheight:Int=20
Global mapx:Int=0
Global mapy:Int=0
Global mapsx:Int=0
Global mapsy:Int=0

Global showmap:Bool=False
Global remakemap:Bool=False

Class tiles
    Field walltile:Image
    Field rocktile:Image
    Field groundtile:Image
    Field moneytile:Image
    Field pixels:Int[tilewidth*tileheight]
    Method New()
        DebugLog "creating images"
        walltile = CreateImage(tilewidth,tileheight)
        rocktile = CreateImage(tilewidth,tileheight)
        groundtile = CreateImage(tilewidth,tileheight)
        moneytile = CreateImage(tilewidth,tileheight)
        DebugLog "drawing in image"
        Local s:Int=255/tileheight
        Local ss:Int=tileheight/125
        For Local y=0 Until tileheight
            drawr(0,y,tilewidth,y,y*s,y*s,y*s)
        Next        
        DebugLog "finishing image wall"
        walltile.WritePixels(pixels, 0, 0, tilewidth, tileheight, 0)
        For Local y=0 Until tileheight
            Local col:Int=0
            If y<tileheight/2
                col=0+((y*s))
            Else
                col=(255)-((y*s))
            End If
            drawr(0,y,tilewidth,y,col,col/3,0)
        Next        
        DebugLog "finishing image rock"
        rocktile.WritePixels(pixels, 0, 0, tilewidth, tileheight, 0)

        For Local y=0 Until tileheight
            Local col:Int=0
            If y<tileheight/2
                col=0+((y*s)/6)
            Else
                col=(255/6)-((y*s)/6)
            End If
            drawr(0,y,tilewidth,y,col,col,col)
        Next        
        DebugLog "finishing image ground"
        groundtile.WritePixels(pixels, 0, 0, tilewidth, tileheight, 0)
        drawo(tilewidth/3,tileheight/3,tilewidth/3,$FFFF0000)
        DebugLog "finishing image money"        
        moneytile.WritePixels(pixels, 0, 0, tilewidth, tileheight, 0)
    End Method
    Method drawo(x1,y1,radius,col)
        For Local y2=-radius To radius
        For Local x2=-radius To radius
            If (y2*y2+x2*x2) <= radius*radius+radius*0.8
                Local x3 = x2+x1
                Local y3 = y2+y1
                Local pc = y3*tilewidth+x3
                If pc>=0 And pc < tilewidth*tileheight
                    pixels[pc] = col
                End If
            End If
        Next
        Next    
    End Method    
    Method drawr(x1,y1,w1,h1,r:Int,g:Int,b:Int)
        For Local y2=y1 Until y1+h1
        For Local x2=x1 Until x1+w1
            Local pc = y2*tilewidth+x2
            If pc >= 0 And pc < tilewidth*tileheight
                pixels[pc] = argb(r,g,b)
            End If
        Next
        Next        
    End Method 
    Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
        Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
    End Function    
End Class    


Class monster
    Field lmap:Int[][]
    Field x:Int,y:Int
    Field mdelay:Int=0
    Field monsterspeed:Int
    Field offx:Int,offy:Int
    Field offxt:Int,offyt:Int
    Field mnx:Int,mny:Int
    Method New()
        lmap = makearray()
        ' find place for monster
        Local exitloop:Bool=False
        While exitloop = False
            Local x1:Int=Rnd(5,mapwidth-5)
            Local y1:Int=Rnd(5,mapheight-5)
            If monmap[x1][y1] = 1 Then
                exitloop = True
                lmap[x1][y1]=1
                Self.x = x1
                Self.y = y1
            End If
        Wend
        mnx = Self.x
        mny = Self.y
        offxt = 0
        offyt = 0
        offx = 0
        offy = 0      
        monsterspeed = Rnd(1,15)  
    End Method
    Method update()
        'Return
        mdelay+=1
        If mdelay< monsterspeed Then Return
        mdelay=0
        If offx<offxt
            offx+=1            
        End If
        If offx>offxt
            offx-=1
        End If
        If offy<offyt
            offy+=1
        End If
        If offy>offyt
            offy-=1
        End If
        Local set:Bool=False
        If     offx=offxt And
            offy=offyt Then
            set=True
        End If
        If set=False Then Return
'        DebugLog offx+":"+offxt+","+offy+":"+offyt
        x = mnx
        y = mny

        lmap[x][y]+=1
        If lmap[x][y] > 1000
            For Local y1=0 Until mapheight
            For Local x1=0 Until mapwidth
                lmap[x1][y1] = 0
            Next
            Next
            lmap[x][y]=1
        End If
        Local exitloop:Bool=False
        Local db:Int=0
        While exitloop = False            
            db+=1
            If db>200 Then exitloop=True
            Local y2:Int=Rnd(-2,2)
            Local x2:Int=Rnd(-2,2)
            If monmap[x+x2][y+y2] = 1
                If lmap[x+x2][y+y2] <= lmap[x][y]
                    offx = 0
                    offy = 0
                    offxt = 0
                    offyt = 0
                    If x2<0
                        offxt -= tilewidth
                    Elseif x2>0
                        offxt += tilewidth
                    End If
                    If y2<0
                        offyt -= tileheight
                    Elseif y2>0
                        offyt += tileheight                    
                    End If
                    'offxt=x2*tilewidth
                    'offyt=y2*tileheight                    
                    mnx=x+x2
                    mny=y+y2                    
                    exitloop=True
                    Return
                End If
            End If            
        Wend
    End Method
    Method draw()
        SetColor 255,0,0
        Local x1 = (x*tilewidth)
        Local y1 = (y*tileheight)
        x1-=(mapx*tilewidth)
        y1-=(mapy*tileheight)
        x1+=mapsx
        y1+=mapsy
        x1+=offx
        y1+=offy
        DrawRect     x1-tilewidth,
                    y1,
                    tilewidth,tileheight
        SetColor 255,255,255
        DrawText     "M",
                    (x1-tilewidth)+(tilewidth/2),
                    y1+tileheight/2,
                    0.5,0.5
    End Method
End Class


Class player
    Field x:Float=3*tilewidth
    Field y:Float=3*tileheight
    Field width:Int = tilewidth
    Field height:Int = tileheight
    Field keys:Int = 0
    Field coins:Int = 0
    Field health:Int = 3
    Field maxhealth:Int=10
End Class

Class mapgen
    Field gmap:Int[mapwidth][]
    Field hmap:Int[mapwidth][]
    Field twidth:Float,theight:Float
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
        DebugLog "make map"
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            map[x][y] = hmap[x][y]
        Next
        Next
        ex = Rnd(10,mapwidth-10)
        ey = Rnd(10,mapheight-10)
        Local numpaths:Int = (mapwidth*mapheight)/700
        DebugLog "make area's"
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
                     End If
                Next
                Next
            Next
        Next        

        ' make monster map
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            If gmap[x][y] = 1
                monmap[x][y] = 1
            End If
        Next
        Next

           DebugLog "add walls"
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
            End If
        Next
        Next
        DebugLog "set player on map and placecoins"
        ' set player on maptile
        setplayerposition
        DebugLog "place coins"
        placecoins((mapwidth*mapheight)/260)
        DebugLog "place life"
        placehealth((mapwidth*mapheight)/1000)
        ' map conversion
        DebugLog "turn walkable into rock"
        ' turn walkable into rock
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            If gmap[x][y] = 0 Then gmap[x][y] = 7
        Next
        Next
        DebugLog "Turn floor into walkable"
        ' turn floor into walkable
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            If gmap[x][y] = 1 Then
                gmap[x][y] = 0
            End If
            If gmap[x][y] = 2
                gmap[x][y] = 1
            End If
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
        SetColor 255,255,0
        drawboxedrect(    mapx*twidth,mapy*theight,
                        (DeviceWidth/tilewidth)*twidth,
                        (DeviceHeight/tileheight)*theight)        
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
    Method placehealth(amount:Int)
        For Local i=0 Until amount
            Local exitloop:Bool=False
            Local exloop:Int=0
            While exitloop = False
                Local x:Int=Rnd(0,mapwidth)
                Local y:Int=Rnd(0,mapheight)
                If gmap[x][y] = 1
                    gmap[x][y] = 3 
                    exitloop = True                
                End If
                exloop+=1
                If exloop>100 Then exitloop=True
            Wend                
        Next
    End Method

    Method placecoins(amount:Int)
        For Local i=0 Until amount
            Local exitloop:Bool=False
            Local exloop:Int=0
            While exitloop = False
                Local x:Int=Rnd(0,mapwidth)
                Local y:Int=Rnd(0,mapheight)
                If gmap[x][y] = 1
                    gmap[x][y] = 4 
                    exitloop = True                
                End If
                exloop+=1
                If exloop>100 Then exitloop=True
            Wend                
        Next
    End Method
    Method setplayerposition()
        Local exitloop:Bool=False
        Local eo:Int=0
        While exitloop = False
            eo+=1
            If eo>500 Then
                remakemap = True
                Return
            End If
            Local x:Int=Rnd(mapwidth)
            Local y:Int=Rnd(mapheight)
            If gmap[x][y] = 1
                mapx = x-(DeviceWidth/tilewidth)/2
                mapy = y-(DeviceHeight/tileheight)/2
                p.x = (DeviceWidth)/2
                p.y = (DeviceHeight)/2
                mapsx = 0
                mapsy = 0
                exitloop = True
            End If
        Wend
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

Global mytiles:tiles
Global ol:List<openlist> = New List<openlist>
Global cl:List<closedlist> = New List<closedlist>
Global path:List<pathnode> = New List<pathnode>
Global mymonster:List<monster> = New List<monster>

Global mymapgen:mapgen

' the player class in p
Global p:player = New player

Class MyGame Extends App
    Method OnCreate()
        mytiles = New tiles
        SetUpdateRate(60)
        For Local i=0 Until mapwidth
            monmap[i] = New Int[mapheight]
            map[i] = New Int[mapheight]
            olmap[i] = New Int[mapheight]
            clmap[i] = New Int[mapheight]
            pmap[i] = New Int[mapheight]
        Next        
        mymapgen = New mapgen()
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            map[x][y] = mymapgen.gmap[x][y]
        Next
        Next
        For Local i=0 Until 5
            mymonster.AddLast(New monster())
           Next
    End Method
    Method OnUpdate()
        waittime+=1
'        If waittime>120
'        If Rnd(0,100)>98 Then remakemap=True

        For Local i:=Eachin mymonster
            i.update
        Next        


        showmap=False
        If KeyDown(KEY_M)
            showmap=True
        End If
        If     KeyHit(KEY_T) Or 
            remakemap=True' Or
            'waittime>180 Then
            mymonster.Clear            
             waittime=0
            remakemap=False
            Seed=Millisecs()
            mapwidth=Rnd(30,200)
            mapheight=Rnd(30,200)
            monmap = makearray()
            map = makearray()
            olmap = makearray()
            clmap = makearray()
            pmap = makearray()
            mymapgen = New mapgen()
            For Local y=0 Until mapheight
            For Local x=0 Until mapwidth
                map[x][y] = mymapgen.gmap[x][y]
            Next
            Next
               For Local i=0 Until (mapwidth*mapheight)/500
                mymonster.AddLast(New monster())
               Next            
            If ptc(0,0)
                remakemap=True
            End If
        End If            
'            waittime = 0
'        End If
        ' scrolling rpg part
        For Local i=0 Until 2
        If p.x > DeviceWidth / 2
            If mapx+(DeviceWidth/tilewidth) < mapwidth-1
                mapsx-=1
                If mapsx < 0 Then 
                    mapsx = tilewidth-1
                    mapx += 1
                Endif
                p.x-=1
            End If
        End If
        Next

        For Local i=0 Until 2
        If p.x < DeviceWidth / 2
            If mapx > 0
                mapsx+=1
                If mapsx > tilewidth Then 
                    mapsx = 0
                    mapx -= 1
                Endif
                p.x+=1
            End If
        End If
        Next
        ' scrolling down
        For Local i=0 Until 2
        If p.y > DeviceHeight / 2
            If mapy+(DeviceHeight/tileheight) < mapheight-1
                mapsy-=1
                If mapsy < 0 Then 
                    mapsy = tileheight-1
                    mapy += 1
                Endif
                p.y-=1
            End If
        End If
        Next
        ' scrolling up
        For Local i=0 Until 2
        If p.y < DeviceHeight / 2
            If mapy > 0
                mapsy+=1                
                If mapsy > tileheight-1 Then 
                    mapsy = 0
                    mapy -= 1
                Endif
                p.y+=1
            End If
        End If
        Next

        
        If KeyDown(KEY_RIGHT)
            ptcs(1,0)
            For Local i=0 Until 2
                If ptc(1,0) = False
                p.x+=1
                End If
            Next
        End If
        If KeyDown(KEY_LEFT)
            ptcs(-1,0)
            For Local i=0 Until 2
                If ptc(-1,0) = False
                p.x-=1
                End If
            Next
        End If
        If KeyDown(KEY_UP)
            ptcs(0,-1)
            For Local i=0 Until 2
                If ptc(0,-1) = False
                p.y-=1
                End If
            Next
        End If
        If KeyDown(KEY_DOWN)
            ptcs(0,1)
            For Local i=0 Until 2
                If ptc(0,1) = False
                p.y+=1
                End If
            Next
        End If        
    End Method
    Method OnRender()
        Cls(0,0,0)
        If remakemap=True Then Return
          If showmap=True Then
            mymapgen.drawmap
        End If
        If showmap = False        
            SetColor 255,255,255        
            drawmap
            SetColor 255,255,0
            DrawOval p.x,p.y,p.width,p.height
            For Local i:=Eachin mymonster
                i.draw
            Next         
            SetColor 0,0,0
            DrawRect 0,0,DeviceWidth,32
            SetColor 255,255,255
            DrawText "Keys : "+p.keys,10,0
            DrawText "Coins : "+p.coins,10,16
            DrawText     "Health : "+p.health+
                        " of "+p.maxhealth,96,0
            DrawText     "Use Cursor keys to move.",
                        DeviceWidth/2,0
            DrawText     "Collect coins, press t = Teleport"+
                        " to new cavern.",DeviceWidth/2,16
            DrawText     "Press m for mapscreen.",
                        DeviceWidth/2,DeviceHeight-20
         End If
    End
End


' player collide with special blocks.
Function ptcs:Int(offsetx:Int=0,offsety:Int=0)
    Local cx = (p.x+offsetx)/tilewidth+mapx
    Local cy = (p.y+offsety)/tileheight+mapy
    For Local y2=cy-1 Until cy+4
    For Local x2=cx-1 Until cx+4
        If     x2>=0 And x2<mapwidth And 
            y2>=0 And y2<mapheight
            If map[x2][y2] > 0
                Local x3 = (x2-mapx)*tilewidth-tilewidth+mapsx
                Local y3 = (y2-mapy)*tileheight+mapsy
                If rectsoverlap(    p.x+offsetx,
                                    p.y+offsety,
                                    p.width,
                                    p.height,
                                    x3,y3,
                                    tilewidth,
                                    tileheight) = True
                    Select map[x2][y2]
                        Case 2
                        If p.keys > 0 
                            map[x2][y2] = 0
                            p.keys-=1
                        End If
                        Case 3 'health
                        If p.health < p.maxhealth
                            map[x2][y2] = 0
                            p.health+=1
                            Else
                            map[x2][y2] = 0
                            p.maxhealth+=1
                            p.health+=1
                        End If
                        Case 4 'coins
                        map[x2][y2] = 0
                        p.coins+=1
                    End Select
                End If
            End If
        End If
    Next
    Next
    Return 0
End Function

'player collide with solid blocks true/false
Function ptc:Bool(offsetx:Int=0,offsety:Int=0)
    Local cx = (p.x+offsetx)/tilewidth+mapx
    Local cy = (p.y+offsety)/tileheight+mapy
    For Local y2=cy-1 Until cy+4
    For Local x2=cx-1 Until cx+4
        If     x2>=0 And x2<mapwidth And y2>=0 And 
            y2<mapheight
            If     map[x2][y2] = 1 Or map[x2][y2] = 2 Or 
                map[x2][y2] = 5 Or map[x2][y2] = 6 Or 
                map[x2][y2] = 7
                Local x3 = (x2-mapx)*tilewidth-tilewidth+mapsx
                Local y3 = (y2-mapy)*tileheight+mapsy
                If rectsoverlap(p.x+offsetx,p.y+offsety,
                                p.width,p.height,x3,y3,
                                tilewidth,tileheight) = True
                    Return True
                End If
            End If
        End If
    Next
    Next
    Return False
End Function



Function drawmap:Void()
    For Local y=0 To DeviceHeight/tileheight
    For Local x=0 To DeviceWidth/tilewidth
        Local x1 = ((x*tilewidth)+mapsx)-tilewidth
        Local y1 = ((y*tileheight)+mapsy)
        Local mw:Int=mapwidth
        Local mh:Int=mapheight
        Local mx:Int=mapx
        Local my:Int=mapy
        If     x+mapx<mapwidth And
            x+mapx>0 And
            y+mapy<mapheight And
            y+mapy>0
            Select map[x+mapx][y+mapy]
                Case 0 'ground
                DrawImage mytiles.groundtile,x1,y1
                Case 1'Wall
'                SetColor 100,100,100
'                DrawRect x1,y1,tilewidth,tileheight
                DrawImage mytiles.walltile,x1,y1
                Case 2'Door
                SetColor 200,100,0
                DrawRect x1,y1,tilewidth,tileheight
                Case 3'Health
                SetColor 200,0,0
                DrawOval x1+4,y1+4,tilewidth-8,tileheight-8
                SetColor 255,255,255
                DrawText "H",x1+tilewidth/2,y1+tileheight/2,0.5,0.5
                Case 4'Coin
                'SetColor 255,255,0
                'DrawOval x1+4,y1+4,tilewidth-8,tileheight-8
                'SetColor 255,255,255
                DrawImage mytiles.moneytile,x1,y1
                DrawText "$",x1+tilewidth/2,y1+tileheight/2,0.5,0.5
                Case 5'tree
                SetColor 0,200,0
                DrawPoly(    [Float(x1+16),y1 ,x1+tilewidth,
                        y1+tileheight , x1,y1+tileheight])
                Case 6'water
                SetColor 0,0,200
                DrawRect x1,y1,tilewidth,tileheight
                Case 7'rock
                'SetColor 150,50,0
                'DrawRect x1,y1+10,tilewidth,tileheight-10
                DrawImage mytiles.rocktile,x1,y1
                'DrawPoly([Float(x1+tilewidth/2),y1,x1+tilewidth,
                '            y1+tileheight,x1,y1+tileheight])
                            
            End Select        
        End If
    Next
    Next
End Function

Function rectsoverlap:Bool(    x1:Int, y1:Int, w1:Int, 
                            h1:Int, x2:Int, y2:Int, 
                            w2:Int, h2:Int)
    If     x1 >= (x2 + w2) Or 
        (x1 + w1) <= x2 Then Return False
    If     y1 >= (y2 + h2) Or 
        (y1 + h1) <= y2 Then Return False
    Return True
End Function

Function drawboxedrect:Void(x:Int,y:Int,w:Int,h:Int)
    DrawLine x,y,x+w,y
    DrawLine x,y,x,y+h
    DrawLine x,y+h,x+w,y+h
    DrawLine x+w,y,x+w,y+h
End Function

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
                If     newx>=0 And newy>=0 And 
                    newx<mapwidth And newy<mapheight
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
                    ol.AddLast(New openlist(newx,
                                            newy,ff,
                                            gg,hh,
                                            tx,ty))
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
