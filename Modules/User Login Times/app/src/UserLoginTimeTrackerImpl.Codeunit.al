﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 9013 "User Login Time Tracker Impl."
{
    Permissions = TableData "User Login"=rimd;

    trigger OnRun()
    begin
    end;

    [Scope('OnPrem')]
    procedure IsFirstLogin(UserSecurityID: Guid): Boolean
    var
        UserLogin: Record "User Login";
    begin
        // if the user exists in the UserLogin table, they have logged in in the past
        exit(not UserLogin.Get(UserSecurityID));
    end;

    [Scope('OnPrem')]
    procedure AnyUserLoggedInSinceDate(FromDate: Date): Boolean
    var
        UserLogin: Record "User Login";
        FromEventDateTime: DateTime;
    begin
        FromEventDateTime := CreateDateTime(FromDate,0T);

        UserLogin.SetFilter("Last Login Date",'>=%1',FromEventDateTime);

        exit(not UserLogin.IsEmpty());
    end;

    [Scope('OnPrem')]
    procedure UserLoggedInSinceDateTime(FromDateTime: DateTime): Boolean
    var
        UserLogin: Record "User Login";
    begin
        if not UserLogin.Get(UserSecurityId()) then
          exit(false);

        exit(UserLogin."Last Login Date" >= FromDateTime);
    end;

    [Scope('OnPrem')]
    procedure GetPenultimateLoginDateTime(): DateTime
    var
        UserLogin: Record "User Login";
    begin
        if UserLogin.Get(UserSecurityId()) then
          exit(UserLogin."Penultimate Login Date");

        exit(0DT);
    end;

    [Scope('OnPrem')]
    procedure CreateOrUpdateLoginInfo()
    var
        UserLogin: Record "User Login";
    begin
        if UserLogin.Get(UserSecurityId()) then begin
          UserLogin."Penultimate Login Date" := UserLogin."Last Login Date";
          UserLogin."Last Login Date" := CurrentDateTime();
          UserLogin.Modify(true);
        end else begin
          UserLogin.Init();
          UserLogin."User SID" := UserSecurityId();
          UserLogin."First Login Date" := Today();
          UserLogin."Penultimate Login Date" := 0DT;
          UserLogin."Last Login Date" := CurrentDateTime();
          UserLogin.Insert(true);
        end
    end;
}

