﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 4100 "Temp Blob"
{

    trigger OnRun()
    begin
    end;

    var
        TempBlobImpl: Codeunit "Temp Blob Impl.";

    /// <summary>
    /// Creates an InStream object with default encoding for the TempBlob. This enables you to read data from the TempBlob.
    /// </summary>
    /// <param name="InStream">The InStream variable passed as a VAR to which the BLOB content will be attached.</param>
    procedure CreateInStream(var InStream: InStream)
    begin
        TempBlobImpl.CreateInStream(InStream)
    end;

    /// <summary>
    /// Creates an InStream object with the specified encoding for the TempBlob. This enables you to read data from the TempBlob.
    /// </summary>
    /// <param name="InStream">The InStream variable passed as a VAR to which the BLOB content will be attached.</param>
    /// <param name="Encoding">The text encoding to use.</param>
    procedure CreateInStreamWithEncoding(var InStream: InStream;Encoding: TextEncoding)
    begin
        TempBlobImpl.CreateInStreamWithEncoding(InStream,Encoding)
    end;

    /// <summary>
    /// Creates an OutStream object with default encoding for the TempBlob. This enables you to write data to the TempBlob.
    /// </summary>
    /// <param name="OutStream">The OutStream variable passed as a VAR to which the BLOB content will be attached.</param>
    procedure CreateOutStream(var OutStream: OutStream)
    begin
        TempBlobImpl.CreateOutStream(OutStream)
    end;

    /// <summary>
    /// Creates an OutStream object with the specified encoding for the TempBlob. This enables you to write data to the TempBlob.
    /// </summary>
    /// <param name="OutStream">The OutStream variable passed as a VAR to which the BLOB content will be attached.</param>
    /// <param name="Encoding">The text encoding to use.</param>
    procedure CreateOutStreamWithEncoding(var OutStream: OutStream;Encoding: TextEncoding)
    begin
        TempBlobImpl.CreateOutStreamWithEncoding(OutStream,Encoding)
    end;

    /// <summary>
    /// Determines whether the TempBlob has a value.
    /// </summary>
    /// <returns>True if the TempBlob has a value.</returns>
    procedure HasValue(): Boolean
    begin
        exit(TempBlobImpl.HasValue())
    end;

    /// <summary>
    /// Determines the length of the data stored in the TempBlob.
    /// </summary>
    /// <returns>The number of bytes stored in the BLOB.</returns>
    procedure Length(): Integer
    begin
        exit(TempBlobImpl.Length())
    end;

    /// <summary>
    /// Copies the value of the BLOB field on the RecordVariant in the specified field to the TempBlob.
    /// </summary>
    /// <param name="RecordVariant">Any Record variable.</param>
    /// <param name="FieldNo">The field number of the BLOB field to be read.</param>
    procedure FromRecord(RecordVariant: Variant;FieldNo: Integer)
    begin
        TempBlobImpl.FromRecord(RecordVariant,FieldNo);
    end;

    /// <summary>
    /// Copies the value of the BLOB field on the RecordRef in the specified field to the TempBlob.
    /// </summary>
    /// <param name="RecordRef">A RecordRef variable attached to a Record.</param>
    /// <param name="FieldNo">The field number of the BLOB field to be read.</param>
    procedure FromRecordRef(RecordRef: RecordRef;FieldNo: Integer)
    begin
        TempBlobImpl.FromRecordRef(RecordRef,FieldNo)
    end;

    /// <summary>
    /// Copies the value of the TempBlob to the specified field on the RecordRef.
    /// </summary>
    /// <param name="RecordRef">A RecordRef variable attached to a Record.</param>
    /// <param name="FieldNo">The field number of the Blob field to be written.</param>
    procedure ToRecordRef(var RecordRef: RecordRef;FieldNo: Integer)
    begin
        TempBlobImpl.ToRecordRef(RecordRef,FieldNo);
    end;
}

