﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

table 1754 "Field Content Buffer"
{

    fields
    {
        field(1;Value;Text[250])
        {
            DataClassification = SystemMetadata;
            Description = 'The value of the field in the database';
        }
    }

    keys
    {
        key(Key1;Value)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

