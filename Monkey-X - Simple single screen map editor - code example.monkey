Import mojo

Class mapeditor
    Field tilewidth:Int,tileheight:Int
    Field mapwidth:Int,mapheight:Int
    Field map:Int[][],shoremap:String[][]
    Field ctile:Int=1 'current drawing tile
    Method New(mapwidth:Int,mapheight:Int,tilewidth:Int,tileheight:Int)
        Self.tilewidth = tilewidth
        Self.tileheight = tileheight
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        map = New Int[mapwidth][]
        shoremap = New String[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
            shoremap[i] = New String[mapheight]
        Next
    End Method
    Method update()
        Local x1 = MouseX() / tilewidth
        Local y1 = MouseY() / tileheight
        If MouseDown(MOUSE_LEFT)
            setmap(x1,y1,ctile)
            makeshoremap
        End If
        If KeyDown(KEY_0) Then ctile = 0
        If KeyDown(KEY_1) Then ctile = 1
        If KeyDown(KEY_2) Then ctile = 2
        If KeyDown(KEY_3) Then ctile = 3
        If KeyDown(KEY_4) Then ctile = 4                                
    End Method
    Method setmap:Void(x:Int,y:Int,val:Int)
        If x>=0 And y>=0 And x<mapwidth And y<mapheight
            map[x][y] = val
        End If
    End Method
    Method drawmap:Void()
        For Local y1=0 Until mapheight
        For Local x1=0 Until mapwidth
            drawtile(map[x1][y1],x1*tilewidth,y1*tileheight)
        Next
        Next
        drawshoremap
        SetColor 255,255,255
        Local mx:Int=MouseX()/tilewidth
        Local my:Int=MouseY()/tileheight
        Local x1:Int=mx*tilewidth
        Local y1:Int=my*tileheight
        drawboxedrect x1,y1,tilewidth,tileheight
        If KeyDown(KEY_SPACE)
            SetColor 0,0,0
            DrawRect 0,0,640,36
            Local y1:Int=1
            Local x1:Int=1            
            For Local i:Int=0 To 4
                If ctile = i
                    SetColor 255,255,0
                    DrawRect x1-1,y1-1,34,34                
                End If
                drawtile(i,x1,y1)
                SetColor 255,255,255
                Select i
                    Case 0;DrawText "0",x1,y1
                    Case 1;DrawText "1",x1,y1
                    Case 2;DrawText "2",x1,y1
                    Case 3;DrawText "3",x1,y1
                    Case 4;DrawText "4",x1,y1                                          
                End Select
                x1+=34
            Next
        End If
    End Method
    Method drawtile(val:Int,x1:Int,y1:Int)
        Select val
            Case 0'water
                SetColor 0,0,255
                DrawRect x1,y1,tilewidth,tileheight
            Case 1'land
                SetColor 0,200,0
                DrawRect x1,y1,tilewidth,tileheight
            Case 2'forrest
                drawtile(1,x1,y1)
                SetColor 0,255,0
                DrawOval x1+5,y1+5,tilewidth-10,tileheight/2
                SetColor 150,10,0
                DrawRect x1+12,y1+tileheight-10,tilewidth-24,tileheight/2-5
            Case 3'hill
                drawtile(1,x1,y1)
                SetColor 0,255,0
                DrawOval x1+5,y1+10,tilewidth-10,tileheight-15
                SetColor 0,200,0
                DrawRect x1,y1+tileheight/1.5,tilewidth,10
            Case 4'mountain
                drawtile(1,x1,y1)
                SetColor 200,200,200
                DrawPoly(    [Float(x1+tilewidth/2),Float(y1),
                            Float(x1+tilewidth-5),Float(y1+tileheight-5),
                            Float(x1+5),Float(y1+tileheight-5)])
        End Select
    End Method
    Method drawshoremap:Void()
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            Local s:String=shoremap[x][y]
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
    End Method

    Method makeshoremap:Void()
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth        
            shoremap[x][y]="0000"                  
        Next
        Next
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth        
            If map[x][y] > 0 
                If y-1>=0
                    If map[x][y-1] = 0
                           Local sm:String=shoremap[x][y]                    
                        sm = "1"+sm[1..4]
                        shoremap[x][y] = sm
                    End If
                End If
                If x+1 < mapwidth
                    If map[x+1][y] = 0
                        Local sm:String=shoremap[x][y]                    
                        sm = sm[0..1]+"1"+sm[2..4]                     
                        shoremap[x][y] = sm
                    End If
                End If
                If y+1 < mapheight
                    If map[x][y+1] = 0
                        Local sm:String=shoremap[x][y]                    
                        sm = sm[0..2]+"1"+sm[3..4]                
                        shoremap[x][y] = sm
                    End If
                End If
                If x-1 >= 0
                    If map[x-1][y] = 0
                        Local sm:String=shoremap[x][y]                    
                        sm = sm[0..3]+"1"
                        shoremap[x][y] = sm
                    End If
                End If
                End If
           Next
        Next
    End Method

End Class

Global mymapeditor:mapeditor = New mapeditor(20,14,32,32)

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()      
        mymapeditor.update  
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymapeditor.drawmap
        SetColor 255,255,255
        DrawText "Spacebar = tileview, 0 to 4 = tiles, Lmb = place tile",320,480-15,0.5,0.5
        Local x:Int=640-32
        Local y:Int=480-10
        PushMatrix()
        Translate x,y
        Rotate(45)
        Scale 0.7,0.7
        Translate -x,-y                
        DrawText "Editor",x,y
        PopMatrix()
    End Method
End Class


Function Main()
    New MyGame()
End Function


Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function

Function drawboxedrect:Void(x:Int,y:Int,w:Int,h:Int)
    DrawLine x,y,x+w,y
    DrawLine x,y,x,y+h
    DrawLine x,y+h,x+w,y+h
    DrawLine x+w,y,x+w,y+h
End Function
