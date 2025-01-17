﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 2301 "Tenant License State Impl."
{

    trigger OnRun()
    begin
    end;

    var
        TenantLicenseStatePeriodProvider: DotNet TenantLicenseStatePeriodProvider;
        TenantLicenseStateProvider: DotNet TenantLicenseStateProvider;

    [Scope('OnPrem')]
    procedure GetPeriod(TenantLicenseState: Enum "Tenant License State"): Integer
    var
        TenantLicenseStateValue: Integer;
    begin
        TenantLicenseStateValue := TenantLicenseState;
        exit(TenantLicenseStatePeriodProvider.ALGetPeriod(TenantLicenseStateValue));
    end;

    [Scope('OnPrem')]
    procedure GetStartDate(): DateTime
    var
        TenantLicenseState: Record "Tenant License State";
    begin
        if TenantLicenseState.FindLast() then
            exit(TenantLicenseState."Start Date");
        exit(0DT);
    end;

    [Scope('OnPrem')]
    procedure GetEndDate(): DateTime
    var
        TenantLicenseState: Record "Tenant License State";
    begin
        if TenantLicenseState.FindLast() then
            exit(TenantLicenseState."End Date");
        exit(0DT);
    end;

    [Scope('OnPrem')]
    procedure IsEvaluationMode(): Boolean
    begin
        exit(GetLicenseState() = "Tenant License State"::Evaluation);
    end;

    [Scope('OnPrem')]
    procedure IsTrialMode(): Boolean
    begin
        exit(GetLicenseState() = "Tenant License State"::Trial);
    end;

    [Scope('OnPrem')]
    procedure IsTrialSuspendedMode(): Boolean
    var
        CurrentState: Enum "Tenant License State";
        PreviousState: Enum "Tenant License State";
    begin
        CurrentState := GetLicenseState();
        PreviousState := GetPreviousLicenseState(CurrentState);
        exit((CurrentState = "Tenant License State"::Suspended) and (PreviousState = "Tenant License State"::Trial));
    end;

    [Scope('OnPrem')]
    procedure IsTrialExtendedMode(): Boolean
    begin
        exit((GetTrialExtensions() > 1) and IsTrialMode());
    end;

    [Scope('OnPrem')]
    procedure IsTrialExtendedSuspendedMode(): Boolean
    begin
        exit((GetTrialExtensions() > 1) and IsTrialSuspendedMode());
    end;

    [Scope('OnPrem')]
    procedure IsPaidMode(): Boolean
    begin
        exit(GetLicenseState() = "Tenant License State"::Paid);
    end;

    [Scope('OnPrem')]
    procedure IsPaidWarningMode(): Boolean
    var
        CurrentState: Enum "Tenant License State";
        PreviousState: Enum "Tenant License State";
    begin
        CurrentState := GetLicenseState();
        PreviousState := GetPreviousLicenseState(CurrentState);
        exit((CurrentState = "Tenant License State"::Warning) and (PreviousState = "Tenant License State"::Paid));
    end;

    [Scope('OnPrem')]
    procedure IsPaidSuspendedMode(): Boolean
    var
        CurrentState: Enum "Tenant License State";
        PreviousState: Enum "Tenant License State";
    begin
        CurrentState := GetLicenseState();
        PreviousState := GetPreviousLicenseState(CurrentState);
        exit((CurrentState = "Tenant License State"::Suspended) and (PreviousState = "Tenant License State"::Paid));
    end;

    local procedure GetTrialExtensions(): Integer
    var
        TenantLicenseState: Record "Tenant License State";
    begin
        TenantLicenseState.SetRange(State, "Tenant License State"::Trial);
        exit(TenantLicenseState.Count());
    end;

    [Scope('OnPrem')]
    procedure ExtendTrialLicense()
    begin
        TenantLicenseStateProvider.ALExtendTrialLicense();
    end;

    [Scope('OnPrem')]
    procedure GetLicenseState(): Enum "Tenant License State"
    var
        TenantLicenseState: Record "Tenant License State";
    begin
        if TenantLicenseState.FindLast() then
            exit(TenantLicenseState.State);
        exit(TenantLicenseState.State::Evaluation);
    end;

    local procedure GetPreviousLicenseState(CurrentTenantLicenseState: Enum "Tenant License State"): Enum "Tenant License State"
    var
        TenantLicenseState: Record "Tenant License State";
        PreviousTenantLicenseState: Enum "Tenant License State";
    begin
        PreviousTenantLicenseState := "Tenant License State"::Evaluation;

        if CurrentTenantLicenseState in ["Tenant License State"::Warning, "Tenant License State"::Suspended] then begin
            TenantLicenseState.SetAscending("Start Date", false);
            if TenantLicenseState.FindSet() then
                while TenantLicenseState.Next() <> 0 do begin
                    PreviousTenantLicenseState := TenantLicenseState.State;
                    if PreviousTenantLicenseState in [TenantLicenseState.State::Trial, TenantLicenseState.State::Paid] then
                        exit(PreviousTenantLicenseState);
                end;
        end;

        exit(PreviousTenantLicenseState);
    end;
}
