CSC = $(DO)csc -nologo -nullable:enable -o+ -out:$@ $(if $(filter %.dll,$@),-t:library) $^

# no user-configurable paths below this line

ifndef DO
$(error Use "Makefile" instead of "csharp.mk")
endif

csharp: csharp/asap2wav.exe csharp/asapplay.exe
.PHONY: csharp

csharp/asap2wav.exe: $(call src,csharp/asap2wav.cs csharp/filesystemloader.cs) csharp/asap.cs
	$(CSC)
CLEAN += csharp/asap2wav.exe

csharp/asapplay.exe: $(call src,csharp/asapplay.cs csharp/filesystemloader.cs) csharp/asap.cs
	$(CSC)
CLEAN += csharp/asapplay.exe

csharp/asap.cs: $(call src,asap.fu asap6502.fu asapinfo.fu cpu6502.fu pokey.fu) $(ASM6502_PLAYERS_OBX)
	$(FUT) -n Sf.Asap
CLEAN += csharp/asap.cs

csharp/Help/index.html: csharp/asap.shfbproj csharp/doc/ASAP.dll
	msbuild $<
CLEANDIR += csharp/Help

csharp/doc/ASAP.dll: csharp/asap.cs
	$(CSC) -t:library -doc:csharp/doc/ASAP.xml
CLEAN += csharp/doc/ASAP.dll csharp/doc/ASAP.xml
