Import mojo

Const mapwidth:Int=640/16
Const mapheight:Int=480/16
Const tilewidth:Int=16
Const tileheight:Int=16
Global map:Int[mapwidth][]
Global islandmap:Int[mapwidth][]
Global shoarmap:String[mapwidth][]
Global numland:Int = 0
Global percland:Float = 1.7
Global remakecnt:Int=0
Global maptype:Int=2
Global debug:String=""
Class Openlist
    Field x:Int, y:Int
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
    End Method
End Class

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(5)
        Seed = Millisecs()
        'Set up the map array to be multi dimensional
        For Local i=0 Until mapwidth
            map[i] = New Int[mapheight]
            islandmap[i] = New Int[mapheight]
            shoarmap[i] = New String[mapheight]
        Next
        ' make the map the first time
        makegamemap
        makeshoarmap
    End Method
    Method OnUpdate()
        ' how much land must it have numoflandtiles </mapsize/percland
        'debug = shoarmap[MouseX()/tilewidth][MouseY()/tileheight]
        '#rem
        remakecnt+=1
        If remakecnt > 20
            makegamemap()
            makeshoarmap
        End If
        '#end
    End Method
    Method OnRender()
        Cls 0,0,0 
        If remakecnt < 9
            drawmap
            drawshoarmap        
            SetColor 255,255,255
            DrawText debug,0,100
              Local numislands=getnumberislands()
                SetColor 10,10,10
                SetAlpha 0.6
            DrawRect 0,0,200,numislands*15+15
            SetAlpha 1
            SetColor 255,255,255
            DrawText "Different types of maps / 2 cont, 3 cont, islands.",0,0
            For Local y=1 To numislands
                DrawText "Landmass "+y+" is "+getlandmass(y)+" tiles.",0,y*15
            Next
        Else
            drawmap
            drawshoarmap
            SetColor 255,255,255
            If maptype < 4 Then DrawText "Please wait.... Generating "+maptype+" continents.",0,0
            If maptype = 4 Then DrawText "Please wait.... Generating islands..",0,0
        End If
        
    End Method
End Class

Function makegamemap:Void()
     Local exitloop:Bool=False
     While exitloop = False
        remakecnt=0
        percland = Rnd(2.0,3.5)
        makemap
        makeislandmap
        If maptype = 4 And createislandsmap() = True Then exitloop = True
        If maptype = 3 And create3landmasses() = True Then exitloop = True
        If maptype = 2 And create2landmasses() = True Then exitloop = True
    Wend
    maptype+=1
    If maptype > 4 Then maptype=2
End Function

Function makeislandmap:Void()
    'first clear the array
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        islandmap[x][y] = 0
    Next
    Next
    ' create an open list
    Local openlist:List<Openlist> = New List<Openlist>
    Local currentisland:Int=0
    ' loop through the array
    For Local y1=0 Until mapheight
    For Local x1=0 Until mapwidth
        ' if land tile and not indexed as island
        If map[x1][y1]>=5 And islandmap[x1][y1] = 0
            currentisland+=1
            openlist.Clear()
            'move this position onto the openlist
            openlist.AddLast(New Openlist(x1,y1))
            Local tx:Int=0, ty:Int=0            
            While openlist.IsEmpty() = False
                ' get a x,y value from the open list
                For Local i:=Eachin openlist
                    tx = i.x
                    ty = i.y
                    openlist.Remove i
                    Exit
                Next
                ' get 8 new positions
                For Local y2=-1 To 1
                For Local x2=-1 To 1
                    Local x3:Int=tx+x2
                    Local y3:Int=ty+y2
                    If x3>=0 And y3>=0 And x3<mapwidth And y3<mapheight
                    ' if land tile and not assisgned before a island
                    If map[x3][y3]>=5
                    If islandmap[x3][y3] = 0
                        ' add to open list
                        openlist.AddLast(New Openlist(x3,y3))
                        ' set current connected landmass
                        islandmap[x3][y3] = currentisland
                    End If
                    End If
                    End If
                Next
                Next
            Wend
        End If
    Next
    Next
End Function

Function drawmap:Void()
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        Local val:Int=map[x][y]
        ' tile 1,2,3,4 is sea
        If val<5 Then SetColor 0,0,val*10+100
        ' tile 5 6 7 8 is grasslands/trees
        If val>=5 And val <9 Then SetColor 0,val*15,0
        'tiles 9 10 11 12 13 is mountains
        If val>=9 Then SetColor val*15,val*4,0
        ' draw the tile
        DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
    Next
    Next
End Function

Function drawshoarmap:Void()
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        Local s:String=shoarmap[x][y]
        Local x1:Int=x*tilewidth
        Local y1:Int=y*tileheight
        ' tile 1,2,3,4 is sea
        SetColor 0,150,0
        If s[0..1] = "1" Then DrawRect x1+(tilewidth/4),y1-2,tilewidth/2,2

        If s[1..2] = "1" Then DrawRect x1+tilewidth,y1+tileheight/4,2,tileheight/2    

        If s[2..3] = "1" Then DrawRect x1+(tilewidth/4),y1+tileheight,tilewidth/2,2

        If s[3..4] = "1" Then DrawRect x1-2,y1+tileheight/4,2,tileheight/2

    Next
    Next
End Function

Function makeshoarmap:Void()
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth        
        shoarmap[x][y]="0000"                  
    Next
    Next
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth        
        If islandmap[x][y] > 0 
            If y-1>=0
                If islandmap[x][y-1] = 0
                    Local sm:String=shoarmap[x][y]                    
                    sm = "1"+sm[1..4]
                    shoarmap[x][y] = sm
                End If
            End If
            If x+1 < mapwidth
                If islandmap[x+1][y] = 0
                    Local sm:String=shoarmap[x][y]                    
                    sm = sm[0..1]+"1"+sm[2..4]                     
                    shoarmap[x][y] = sm
                End If
            End If
            If y+1 < mapheight
                If islandmap[x][y+1] = 0
                    Local sm:String=shoarmap[x][y]                    
                    sm = sm[0..2]+"1"+sm[3..4]                
                    shoarmap[x][y] = sm
                End If
            End If
            If x-1 >= 0
                If islandmap[x-1][y] = 0
                    Local sm:String=shoarmap[x][y]                    
                    sm = sm[0..3]+"1"
                    shoarmap[x][y] = sm
                End If
            End If
        End If
    Next
    Next
End Function


Function makemap:Void()
    numland=0
    ' exit loop if conditions on land percentage is good
       While numland<(mapwidth*mapheight/percland)
        ' erase the old data
        For Local y=0 Until mapheight
           For Local x=0 Until mapwidth
               map[x][y] = 0
        Next
        Next
        'lowest hold the highest tile value
        Local lowest = 0
        ' while land height is below 13
        While lowest < 13
            Local x1 = Rnd(mapwidth)
               Local y1 = Rnd(mapheight)
               ' create a radius for draw oval
            Local radius = Rnd(3,6)
            ' loop and create oval
            For Local y2=-radius To radius
            For Local x2=-radius To radius
                If ((x2*x2)+(y2*y2)) <= radius*radius+radius*0.8
                    Local x3 = x1+x2
                    Local y3 = y1+y2
                    If x3>=0 And y3>=0 And x3<mapwidth And y3<mapheight
                        ' add current position with added older tile value 
                        map[x3][y3]=map[x3][y3]+1
                        ' if current value is higher then lowest loop value
                        ' then store it in the loop exit variable
                        If map[x3][y3] > lowest Then lowest = map[x3][y3]
                    End If
                End If
            Next
            Next
        Wend
        'Count the number of land tiles
        numland=0
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            ' if the value is above 4 then add landtile counter
            If map[x][y] >= 5 Then numland+=1
        Next
        Next
    Wend
End Function

Function createislandsmap:Bool()
    Local nislands:Int=getnumberislands()
    Local c:Int=0
    If nislands<7 Then Return False
    For Local i=1 To nislands
        Local v:Int=getlandmass(i)
        If v>25 Then c+=1
    Next
    If c>5 Then Return True    
    Return False
End Function


Function create3landmasses:Bool()
    Local nislands:Int=getnumberislands()
    Local c:Int=0
    If nislands<>3 Then Return False
    For Local i=1 To nislands
        Local v:Int=getlandmass(i)
        If v>100 Then c+=1
    Next
    If c>2 Then Return True    
    Return False
End Function


Function create2landmasses:Bool()
    Local nislands:Int=getnumberislands()
    Local c:Int=0
    If nislands<>2 Then Return False
    For Local i=1 To nislands
        Local v:Int=getlandmass(i)
        If v>200 Then c+=1
    Next
    If c>1 Then Return True    
    Return False
End Function

Function getlandmass:Int(islandnumber:Int=1)
    Local totaltiles:Int=0
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        If islandmap[x][y] = islandnumber Then totaltiles+=1
    Next
    Next
    Return totaltiles
End Function

Function getnumberislands:Int()
    Local highestnumber:Int=0
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        If islandmap[x][y] > highestnumber Then highestnumber = islandmap[x][y]
    Next
    Next
    Return highestnumber
End Function

Function Main()
    New MyGame()
End Function
