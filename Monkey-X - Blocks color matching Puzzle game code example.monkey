Import mojo

Global bca:Int=-1
Const mapwidth:Int=8
Const mapheight:Int=14
Const blockwidth:Int=64
Const blockheight:Int=22
Global blockactive:Int[mapwidth*mapheight]
Global blockcolor:Int[mapwidth*mapheight]
Global padx:Int=320
Global pady:Int=480-22
Const padwidth:Int=64
Const padheight:Int=22
Global padblock:Int[6] 'Blocks ontop of the pad (colors)

Class MyGame Extends App
   
    Method OnCreate()
        SetUpdateRate(60)
        For Local i:Int=0 Until mapwidth*(mapheight-6)
            blockactive[i] = 1
            blockcolor[i] = Rnd(0,4)
        Next        
    End Method
    Method OnUpdate()
        If Rnd(20)<2 Then moveblocksdown()
        'Pad movement
        If padx+padwidth/2 < MouseX() Then padx+=5
        If padx+padwidth/2 > MouseX() Then padx-=5
        If padx>(mapwidth-1)*blockwidth Then padx=(mapwidth-1)*blockwidth
        If padx<0 Then padx = 0
        'Pad pickup
        bca = getblockcolorabove()
        If KeyHit(KEY_Q)
            If bca+1 = padblock[0] Or padblock[0] = 0
            If padblock[5] = 0
                For Local i=0 Until 6
                    If padblock[i] = 0
                        padblock[i] = bca+1
                        removeblockabove()
                        Exit
                    End If
                Next
            End If
            End If
        End If
        If KeyHit(KEY_W)
            releaseblocks()
        End If
    End Method    
    Method OnRender()
        Cls
        SetColor 25,25,55
        DrawRect padx,0,padwidth,DeviceHeight
        'Draw pad
        SetColor 255,255,255
        DrawRect padx,pady,padwidth,padheight
        'blocks on the pad
        For Local i=0 Until 6
            If padblock[i] > 0
                Select padblock[i]
                    Case 1 ; SetColor(255,0,0)
                        Case 2 ; SetColor(0,255,0)
                        Case 3 ; SetColor(0,0,255)
                        Case 4 ; SetColor(255,255,0)            
                End Select
                DrawRect padx,pady-(i*blockheight)-blockheight,blockwidth,blockheight
            End If
        Next

        'Draw blocks
        For Local i:Int=0 Until mapwidth*mapheight
               If blockactive[i] = 1
                   Select blockcolor[i]
                       Case 0 ; SetColor(255,0,0)
                       Case 1 ; SetColor(0,255,0)
                       Case 2 ; SetColor(0,0,255)
                       Case 3 ; SetColor(255,255,0)
                  End Select
                   DrawRect getx(i)*blockwidth,gety(i)*blockheight,blockwidth,blockheight
               End If
        Next
        SetColor 255,255,255
        DrawText "Q to Grab",640-120,10
        DrawText "W to Return",640-120,30
    End Method
    
End

Function Main:Int()
    New MyGame()
End

Function getx:Int(i:Int)
    Return i Mod mapwidth 
End Function
Function gety:Int(i:Int)
    Return i / mapwidth
End Function
Function blockvalue:Int(x:Int,y:Int)
    Return y * mapwidth + x
End Function
Function maxpadblocks:Bool()
    Local cnt:Int=0
    For Local i=0 Until 6
        If padblock[i] > 0 Then cnt+=1
    Next
    If cnt=5 Then Return True
    Return False
End Function
Function getblockcolorabove:Int()
    Local px:Int = padx+padwidth/2
    Local py:Int = pady-padheight
    For Local y=py Until -20 Step -blockheight/2
        For Local i=0 Until mapwidth*mapheight
            If blockactive[i] = 1
            Local x1 = getx(i)*blockwidth
            Local y1 = gety(i)*blockheight
            If rectsoverlap(px,y,5,5,x1,y1,blockwidth,blockheight) = True Then
                Return blockcolor[i]
            End If
            End If
        Next
    Next
    Return -1
End Function
Function removeblockabove:Bool()
    Local px:Int = padx+padwidth/2
    Local py:Int = pady-padheight
    For Local y=py Until -20 Step -blockheight/2
        For Local i=0 Until mapwidth*mapheight
            If blockactive[i] = 1
            Local x1 = getx(i)*blockwidth
            Local y1 = gety(i)*blockheight
            If rectsoverlap(px,y,5,5,x1,y1,blockwidth,blockheight) = True Then
                blockactive[i] = 0
                Return True
            End If
            End If
        Next        
    Next
    Return False
End Function

Function padblockcount:Int()
    Local cnt:Int=0
    For Local i=0 Until 6
        If padblock[i] > 0 Then cnt+=1
    Next
    Return cnt
End Function

Function releaseblocks:Bool()
    If padblock[0] = 0 Then Return False
    Local px:Int = padx+padwidth/2
    Local py:Int = pady-padheight
    For Local y=py Until -20 Step -blockheight/2
        For Local i=0 Until mapwidth*mapheight
            If blockactive[i] = 1
            Local bc = blockcolor[i]
            Local x1 = getx(i)*blockwidth
            Local y1 = gety(i)*blockheight
            If rectsoverlap(px,y,5,5,x1,y1,blockwidth,blockheight) = True Then
                If gety(i) + padblockcount() >= mapheight-1 Then Return False
                If padblock[0]-1 = bc Then
                    For Local ii=0 Until 6
                        padblock[ii] = 0
                        blockactive[i] = 0
                    Next
                    Return
                End If                
                For Local ii=0 Until 6
                    If padblock[ii] > 0
                        blockactive[i+(ii*mapwidth+(mapwidth))] = 1
                        blockcolor[i+(ii*mapwidth+(mapwidth))] = padblock[ii]-1                        
                        padblock[ii] = 0
                    End If
                Next
                Return
            End If
            End If
        Next        
    Next
End Function

Function rectsoverlap:Int(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 > (x2 + w2) Or (x1 + w1) < x2 Then Return False
    If y1 > (y2 + h2) Or (y1 + h1) < y2 Then Return False
    Return True
End

Function moveblocksdown:Bool()
    Local y:Int=mapheight-6
    Local erase:Bool = True
    For Local x=0 Until mapwidth
        If blockactive[blockvalue(x,y)] = 1 Then erase = False
    Next
    If erase = True
        For Local y1=mapheight-1 To 1 Step -1
        For Local x1=0 Until mapwidth
            Local i = blockvalue(x1,y1)
            blockactive[i] = blockactive[blockvalue(x1,y1-1)]
            blockcolor[i] = blockcolor[blockvalue(x1,y1-1)]
        Next
        Next
        For Local x1=0 Until mapwidth
            Local i = blockvalue(x1,0)
            blockactive[i] = 1
            blockcolor[i] = Rnd(0,4)
        Next
    End If
End Function
