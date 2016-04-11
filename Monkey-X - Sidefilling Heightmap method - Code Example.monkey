Import mojo

Class openlist
    Field x:Int,y:Int
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
    End Method
End Class


Class heightmap
    Field ol:List<openlist> = New List<openlist>
    Field h:Int,w:Int
    ' hold the heightmap
    Field hmap:Int[][]
    'hold the fillmap
    Field fmap:Int[][]
    Field x3:Int,y3:Int
    Field x4:Int,y4:Int
    Method New(w:Int,h:Int)
        Self.w = w
        Self.h = h
        hmap = New Int[w][]
        fmap = New Int[w][]
        For Local i = 0 Until w
            hmap[i] = New Int[h]
            fmap[i] = New Int[h]            
        Next
        makeheightmap        
    End Method
    Method makeheightmap()
        For Local i=0 Until 255
        Local startside:Int
        Local endside:Int
         Local exitloop:Bool=False
         While exitloop = False
             endside = Rnd(1,5)
             startside = Rnd(1,5)
             If endside<>startside Then
                 exitloop = True
             End If
         Wend         
         x3=Rnd(w)
         y3=Rnd(h)
         x4=Rnd(w)
         y4=Rnd(h)
         Select startside
             Case 1
             y3=0
             Case 2
             x3=w-1
             Case 3
             y3=h-1
             Case 4
             x3=0
         End Select
         Select endside
             Case 1
             y4=0
             Case 2
             x4=w-1
             Case 3
             y4=h-1
             Case 4
             x4=0
         End Select
         clearfmap()
         line(x3,y3,x4,y4)
         fillfmap()
         addhmap()
        Next
    End Method
    Method addhmap()
        For Local y=0 Until h
        For Local x=0 Until w
            hmap[x][y]+=fmap[x][y]
        Next
        Next
    End Method
    Method fillfmap()
        Local exitloop:Bool=False
        Local x1:Int,y1:Int
        While exitloop = False
            x1=Rnd(w)
            y1=Rnd(h)
            If fmap[x1][y1] = 0
                exitloop = True
            End If
        Wend
        ol.Clear
        ol.AddLast(New openlist(x1,y1))
        fmap[x1][y1]=1
        While ol.IsEmpty() = False
            For Local i:=Eachin ol

                Local tx:Int=i.x
                Local ty:Int=i.y
                
                If tx-1>-1
                If fmap[tx-1][ty] = 0
                    ol.AddLast(New openlist(tx-1,ty))
                    fmap[tx-1][ty] = 1
                End If
                End If

                If tx+1<w
                If fmap[tx+1][ty] = 0
                    ol.AddLast(New openlist(tx+1,ty))
                    fmap[tx+1][ty] = 1
                End If
                End If

                If ty-1>-1
                If fmap[tx][ty-1] = 0
                    ol.AddLast(New openlist(tx,ty-1))
                    fmap[tx][ty-1] = 1
                End If
                End If
                
                If ty+1<h
                If fmap[tx][ty+1] = 0
                    ol.AddLast(New openlist(tx,ty+1))
                    fmap[tx][ty+1] = 1
                End If
                End If
                ol.Remove i 
            Next
        Wend
    End Method
    Method line:Void(x1:Int,y1:Int,x2:Int,y2:Int)
        Local dx:Int, dy:Int, sx:Int, sy:Int, e:Int
         dx = Abs(x2 - x1)
          sx = -1
          If x1 < x2 Then sx = 1      
          dy = Abs(y2 - y1)
          sy = -1
          If y1 < y2 Then sy = 1
          If dx < dy Then 
              e = dx / 2 
          Else 
              e = dy / 2          
          End If
          Local exitloop:Bool=False
          While exitloop = False
            fmap[x1][y1] = 1
            If x1 = x2 
                If y1 = y2
                    exitloop = True
                End If
            End If
            If dx > dy Then
                x1 += sx ; e -= dy 
                  If e < 0 Then e += dx ; y1 += sy
            Else
                y1 += sy ; e -= dx 
                If e < 0 Then e += dy ; x1 += sx
            Endif
          Wend
    End Method
    Method clearfmap()
        For Local y=0 Until h
        For Local x=0 Until w
            fmap[x][y] = 0
        Next
        Next
    End Method
    Method draw()
        Local sx:Float=DeviceWidth()/Float(w)
        Local sy:Float=DeviceHeight()/Float(h)
        For Local y=0 Until h
        For Local x=0 Until w
            Local g:Int=hmap[x][y]
            SetColor g/1.5,g/1.5,g
            DrawRect x*sx,y*sy,sx+1,sy+1
        Next
        Next
    End Method
End Class

Global myhmap:heightmap = New heightmap(100,100)

Class MyGame Extends App
    Field refreshtime:Int=0
    Method OnCreate()
        SetUpdateRate(10)
    End Method
    Method OnUpdate()
        refreshtime+=1
        If refreshtime>10
            myhmap = New heightmap(100,100)
            refreshtime=0
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        myhmap.draw
    End Method
End Class


Function Main()
    New MyGame()
End Function
