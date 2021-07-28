${SegmentFile}

Var UnlockSvcExists
Var UnlockExists # 32-bit
Var Unlock64Exists # 0: Not exists 1: Exists

${SegmentPrePrimary}
    # Get if the service already exists
    SimpleSC::ExistsService "WiseUnlock"
    Pop $UnlockSvcExists

    ${DebugMsg} "Service exists status $UnlockSvcExists"

    # Get if WiseUnlock.sys (or WiseUnlock64.sys) already exists
    ${If} ${FileExists} $WINDIR\WiseUnlock64.sys
        StrCpy $Unlock64Exists 1
    ${ElseIf} ${FileExists} $WINDIR\WiseUnlock.sys
        StrCpy $UnlockExists 1
    ${EndIf}

    ${DebugMsg} "File exists status 64 $Unlock64Exists"
    ${DebugMsg} "File exists status $UnlockExists"
!macroend

${SegmentPostPrimary}
    # If service exists, do nothing
    ${DebugMsg} "Service status $UnlockSvcExists"
    ${IfNot} $UnlockSvcExists == 0
        SimpleSC::GetServiceStatus "WiseUnlock"
        Pop $0 # Errorcode
        Pop $1 # Status
        ${DebugMsg} "Status: $1 (errorcode $0)"

        ${IfNot} $1 == 1
            # Service not stopped
            SimpleSC::StopService "WiseUnlock" 0 0
            Pop $2
            ${DebugMsg} "Stop service (errorcode $2)"
        ${EndIf}

        # Remove service
        SimpleSC::RemoveService "WiseUnlock"
        Pop $3
        ${DebugMsg} "Remove Service error code $3"

        # Remove WiseUnlock.sys (or 64-bit)
        ${DebugMsg} "File exists status 64 $Unlock64Exists"
        ${DebugMsg} "File exists status $UnlockExists"

        ${If} $Unlock64Exists != 1
        ${AndIf} ${FileExists} $WINDIR\WiseUnlock64.sys
            Delete $WINDIR\WiseUnlock64.sys
        ${ElseIf} $UnlockExists != 1
        ${AndIf} ${FileExists} $WINDIR\WiseUnlock.sys
            Delete $WINDIR\WiseUnlock.sys
        ${EndIf}
    ${EndIf}
!macroend
