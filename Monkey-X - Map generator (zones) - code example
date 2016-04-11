Import mojo

Global tilewidth:Int=10
Global tileheight:Int=10
Global mapwidth:Int=640/tilewidth
Global mapheight:Int=480/tileheight
Global map:Int[][] = New Int[mapwidth][]
 
Class openlist
    Field x:Int,y:Int,delete:Bool=False
    Field val:Int
    Method New(x:Int,y:Int,val:Int)
        Self.x = x
        Self.y = y
        Self.val = val
    End Method
End Class 

Global nextmaptime:Int = Millisecs()+6000
 
Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
          map = New Int[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        createmap(Rnd(10)+5)
    End Method        
    Method OnUpdate()
        Seed = Millisecs()
        If Millisecs() > nextmaptime
            createmap(Rnd(10)+5)
            nextmaptime = Millisecs()+6000
        End If
    End Method
    Method OnRender()
        Cls 0,0,0
        SetColor 255,255,255
        drawmap
    End Method
End Class

Function drawmap:Void()
    SetColor 255,255,255
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        SetColor 200,map[x][y]*10,0
        If map[x][y] = 1 Then SetColor 0,0,200
        If map[x][y] = 7 Then SetColor 0,0,200
        If map[x][y] > 0
            DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
        End If
    Next
    Next
End Function

Function createmap:Void(numrooms:Int=5)
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        map[x][y] = 0
    Next
    Next    
    Local ol:List<openlist> = New List<openlist>
    For Local i=0 To numrooms
        Local exitloop:Bool=False
        While exitloop = False
            Local x:Int = Rnd(mapwidth)
            Local y:Int = Rnd(mapheight)
            Local set:Bool=True
            For Local ii:=Eachin ol
                If ii.x = x And ii.y = y Then set=False
                If distance(ii.x,ii.y,x,y) < 7 Then set=False                
            Next
            If set = True Then
                ol.AddLast(New openlist(x,y,i+1))
                exitloop = True
            End If
        Wend
    Next
    Local exitloop = False
    Local cx:Int,cy:Int
    While ol.IsEmpty() = False
        For Local i:=Eachin ol
            If Rnd(1000)<2
                For Local y=-1 To 1
                For Local x=-1 To 1
                    Local x1=i.x+x
                    Local y1=i.y+y                    
                    If x1>=0 And y1>=0 And x1<mapwidth And y1<mapheight
                    If map[x1][y1] = 0
                        ol.AddLast(New openlist(x1,y1,i.val))
                        map[x1][y1] = i.val
                    End If
                    End If
                Next
                Next
                i.delete = True
            End If 
        Next
        For Local i:=Eachin ol
            If i.delete = True Then ol.Remove i
        Next
    Wend
End Function

Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return Abs(y2-y1)+Abs(x2-x1)
End Function

Function Main()
    New MyGame()
End Function
