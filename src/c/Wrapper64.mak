# Microsoft Developer Studio Generated NMAKE File, Based on Wrapper64.dsp
!IF "$(CFG)" == ""
CFG=Wrapper - Win64 Debug
!MESSAGE Build mode not specified.  Defaulting to "Wrapper - Win64 Debug".
!ENDIF 

!IF "$(CFG)" != "Wrapper - Win64 Release" && "$(CFG)" != "Wrapper - Win64 Debug"
!MESSAGE The build target "$(CFG)" is invalid.
!MESSAGE Usage:
!MESSAGE 
!MESSAGE NMAKE /f "Wrapper64.mak" CFG="Wrapper - Win64 Debug"
!MESSAGE 
!MESSAGE Valid build modes:
!MESSAGE 
!MESSAGE "Wrapper - Win64 Release" ("Win64 (x86) Console Application")
!MESSAGE "Wrapper - Win64 Debug" ("Win64 (x86) Console Application")
!MESSAGE 
!ERROR Ivalid build mode.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "Wrapper - Win64 Release"

OUTDIR=.\Release64
INTDIR=.\Release64

ALL : "..\..\bin\wrapper.exe"


CLEAN :
    -@erase "$(INTDIR)\logger.obj"
    -@erase "$(INTDIR)\property.obj"
    -@erase "$(INTDIR)\vc60.idb"
    -@erase "$(INTDIR)\wrapper.obj"
    -@erase "$(INTDIR)\Wrapper.res"
    -@erase "$(INTDIR)\wrapper_unix.obj"
    -@erase "$(INTDIR)\wrapper_win.obj"
    -@erase "$(INTDIR)\wrappereventloop.obj"
    -@erase "$(INTDIR)\wrapperinfo.obj"
    -@erase "..\..\bin\wrapper.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /ML /W3 /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\Wrapper64.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /EHSC /c /D "_CRT_SECURE_NO_DEPRECATE"
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Wrapper.res" /d "NDEBUG" 
BSC64=bscmake.exe
BSC64_FLAGS=/nologo /o"$(OUTDIR)\Wrapper64.bsc" 
BSC64_SBRS= \
    
LINK64=link.exe
LINK64_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib wsock32.lib shlwapi.lib bufferoverflowU.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\wrapper.pdb" /machine:x64 /out:"../../bin/wrapper.exe" 
LINK64_OBJS= \
    "$(INTDIR)\logger.obj" \
    "$(INTDIR)\property.obj" \
    "$(INTDIR)\wrapper.obj" \
    "$(INTDIR)\wrapper_unix.obj" \
    "$(INTDIR)\wrapper_win.obj" \
    "$(INTDIR)\wrappereventloop.obj" \
    "$(INTDIR)\wrapperinfo.obj" \
    "$(INTDIR)\Wrapper.res"

"..\..\bin\wrapper.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK64_OBJS)
    $(LINK64) @<<
  $(LINK64_FLAGS) $(LINK64_OBJS)
<<

!ELSEIF  "$(CFG)" == "Wrapper - Win64 Debug"

OUTDIR=.\Debug64
INTDIR=.\Debug64
# Begin Custom Macros
OutDir=.\Debug64
# End Custom Macros

ALL : "..\..\bin\wrapper.exe" "$(OUTDIR)\Wrapper64.bsc"


CLEAN :
    -@erase "$(INTDIR)\logger.obj"
    -@erase "$(INTDIR)\logger.sbr"
    -@erase "$(INTDIR)\property.obj"
    -@erase "$(INTDIR)\property.sbr"
    -@erase "$(INTDIR)\vc60.idb"
    -@erase "$(INTDIR)\vc60.pdb"
    -@erase "$(INTDIR)\wrapper.obj"
    -@erase "$(INTDIR)\Wrapper.res"
    -@erase "$(INTDIR)\wrapper.sbr"
    -@erase "$(INTDIR)\wrapper_unix.obj"
    -@erase "$(INTDIR)\wrapper_unix.sbr"
    -@erase "$(INTDIR)\wrapper_win.obj"
    -@erase "$(INTDIR)\wrapper_win.sbr"
    -@erase "$(INTDIR)\wrappereventloop.obj"
    -@erase "$(INTDIR)\wrappereventloop.sbr"
    -@erase "$(INTDIR)\wrapperinfo.obj"
    -@erase "$(INTDIR)\wrapperinfo.sbr"
    -@erase "$(OUTDIR)\wrapper.pdb"
    -@erase "$(OUTDIR)\Wrapper64.bsc"
    -@erase "..\..\bin\wrapper.exe"
    -@erase "..\..\bin\wrapper.ilk"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MLd /W3 /Gm /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /D "DEBUG" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Wrapper64.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /EHSC /c /D "_CRT_SECURE_NO_DEPRECATE"
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Wrapper.res" /d "_DEBUG" 
BSC64=bscmake.exe
BSC64_FLAGS=/nologo /o"$(OUTDIR)\Wrapper64.bsc" 
BSC64_SBRS= \
    "$(INTDIR)\logger.sbr" \
    "$(INTDIR)\property.sbr" \
    "$(INTDIR)\wrapper.sbr" \
    "$(INTDIR)\wrapper_unix.sbr" \
    "$(INTDIR)\wrapper_win.sbr" \
    "$(INTDIR)\wrappereventloop.sbr" \
    "$(INTDIR)\wrapperinfo.sbr"

"$(OUTDIR)\Wrapper64.bsc" : "$(OUTDIR)" $(BSC64_SBRS)
    $(BSC64) @<<
  $(BSC64_FLAGS) $(BSC64_SBRS)
<<

LINK64=link.exe
LINK64_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib wsock32.lib shlwapi.lib bufferoverflowU.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\wrapper.pdb" /debug /machine:x64 /out:"../../bin/wrapper.exe" /pdbtype:sept 
LINK64_OBJS= \
    "$(INTDIR)\logger.obj" \
    "$(INTDIR)\property.obj" \
    "$(INTDIR)\wrapper.obj" \
    "$(INTDIR)\wrapper_unix.obj" \
    "$(INTDIR)\wrapper_win.obj" \
    "$(INTDIR)\wrappereventloop.obj" \
    "$(INTDIR)\wrapperinfo.obj" \
    "$(INTDIR)\Wrapper.res"

"..\..\bin\wrapper.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK64_OBJS)
    $(LINK64) @<<
  $(LINK64_FLAGS) $(LINK64_OBJS)
<<

!ENDIF 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Wrapper64.dep")
!INCLUDE "Wrapper64.dep"
!ELSE 
!MESSAGE Warning: cannot find "Wrapper64.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Wrapper - Win64 Release" || "$(CFG)" == "Wrapper - Win64 Debug"
SOURCE=.\logger.c

!IF  "$(CFG)" == "Wrapper - Win64 Release"


"$(INTDIR)\logger.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Wrapper - Win64 Debug"


"$(INTDIR)\logger.obj"	"$(INTDIR)\logger.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\property.c

!IF  "$(CFG)" == "Wrapper - Win64 Release"


"$(INTDIR)\property.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Wrapper - Win64 Debug"


"$(INTDIR)\property.obj"	"$(INTDIR)\property.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\wrapper.c

!IF  "$(CFG)" == "Wrapper - Win64 Release"


"$(INTDIR)\wrapper.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Wrapper - Win64 Debug"


"$(INTDIR)\wrapper.obj"	"$(INTDIR)\wrapper.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\wrapper_unix.c

!IF  "$(CFG)" == "Wrapper - Win64 Release"


"$(INTDIR)\wrapper_unix.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Wrapper - Win64 Debug"


"$(INTDIR)\wrapper_unix.obj"	"$(INTDIR)\wrapper_unix.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\wrapper_win.c

!IF  "$(CFG)" == "Wrapper - Win64 Release"


"$(INTDIR)\wrapper_win.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Wrapper - Win64 Debug"


"$(INTDIR)\wrapper_win.obj"	"$(INTDIR)\wrapper_win.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\wrappereventloop.c

!IF  "$(CFG)" == "Wrapper - Win64 Release"


"$(INTDIR)\wrappereventloop.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Wrapper - Win64 Debug"


"$(INTDIR)\wrappereventloop.obj"	"$(INTDIR)\wrappereventloop.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\wrapperinfo.c

!IF  "$(CFG)" == "Wrapper - Win64 Release"


"$(INTDIR)\wrapperinfo.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Wrapper - Win64 Debug"


"$(INTDIR)\wrapperinfo.obj"	"$(INTDIR)\wrapperinfo.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\Wrapper.rc

!IF  "$(CFG)" == "Wrapper - Win64 Release"


"$(INTDIR)\Wrapper.res" : $(SOURCE) "$(INTDIR)"
    $(RSC) /l 0x409 /fo"$(INTDIR)\Wrapper.res" /d "NDEBUG" $(SOURCE)


!ELSEIF  "$(CFG)" == "Wrapper - Win64 Debug"


"$(INTDIR)\Wrapper.res" : $(SOURCE) "$(INTDIR)"
    $(RSC) /l 0x411 /fo"$(INTDIR)\Wrapper.res" /d "_DEBUG" $(SOURCE)


!ENDIF 


!ENDIF 

