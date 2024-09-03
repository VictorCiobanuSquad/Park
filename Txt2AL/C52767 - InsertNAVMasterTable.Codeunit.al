codeunit 52767 InsertNAVMasterTable
{
    Permissions = TableData GeneralTable = rimd,
                  TableData GeneralTableAspects = rimd,
                  TableData MasterTableWEB = rimd;

    trigger OnRun()
    begin
    end;

    var
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;

    //[Scope('OnPrem')]
    procedure InsertEntity(pType: Integer; pCode: Code[20]; pDescription: Text[1024]; pUserID: Text[30]; pPassword: Text[250]; pRCenter: Code[10]; pLanguage: Integer)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_vEntryNo: Integer;
        l_Teacher: Record Teacher;
        l_UsersFamily: Record "Users Family";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        Clear(l_rMasterTableWEB);

        // Associados - Próprio e Familiares
        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Entity);
        l_rMasterTableWEB.SetRange(Typew, pType);
        l_rMasterTableWEB.SetRange(Codew, pCode);
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            if pType = 1 then begin
                if l_Teacher.Get(pCode) then;
                l_Teacher.CalcFields(Picture);
            end;
            if pType = 2 then begin
                if l_UsersFamily.Get(pCode) then;
                l_UsersFamily.CalcFields(Picture);
            end;

            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::Entity;
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.Typew := pType;
            l_rMasterTableWEBINSERT.Codew := pCode;
            l_rMasterTableWEBINSERT.Description := pDescription;
            l_rMasterTableWEBINSERT.UserID := pUserID;
            l_rMasterTableWEBINSERT.Password := pPassword;
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT.Language := pLanguage;
            l_rMasterTableWEBINSERT."Responsibility Center" := pRCenter;
            if pType = 1 then
                l_rMasterTableWEBINSERT.Picture := l_Teacher.Picture;
            if pType = 2 then
                l_rMasterTableWEBINSERT.Picture := l_UsersFamily.Picture;

            l_rMasterTableWEBINSERT.Insert;
        end else begin
            l_rMasterTableWEB.Reset;
            l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Entity);
            l_rMasterTableWEB.SetRange(Typew, pType);
            l_rMasterTableWEB.SetRange(Codew, pCode);
            if l_rMasterTableWEB.FindSet(true, true) then begin
                if pType = 1 then begin
                    if l_Teacher.Get(pCode) then;
                    l_Teacher.CalcFields(Picture);
                end;
                if pType = 2 then begin
                    if l_UsersFamily.Get(pCode) then;
                    l_UsersFamily.CalcFields(Picture);
                end;

                if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
                  (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                    l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
                if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
                  (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                    l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;
                l_rMasterTableWEB."Posting Date" := Today;
                l_rMasterTableWEB."Posting Time" := Time;
                l_rMasterTableWEB.Description := pDescription;
                l_rMasterTableWEB.UserID := pUserID;
                l_rMasterTableWEB.Password := pPassword;
                l_rMasterTableWEB."Responsibility Center" := pRCenter;
                l_rMasterTableWEB.Language := pLanguage;
                if pType = 1 then
                    l_rMasterTableWEBINSERT.Picture := l_Teacher.Picture;
                if pType = 2 then
                    l_rMasterTableWEBINSERT.Picture := l_UsersFamily.Picture;

                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyEntityUsersFamily(pType: Integer; pNewRec: Record "Users Family / Students"; pOldRec: Record "Users Family / Students")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rUsersFamily: Record "Users Family";
        l_rStudents: Record Students;
        l_Name: Text[1024];
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        if not pNewRec."Use WEB" and pOldRec."Use WEB" then begin
            DeleteEntityUsersFamily(pType, pNewRec, pOldRec);
            exit;
        end;

        // Delete the last Education Header
        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Entity);
        l_rMasterTableWEB.SetRange(Typew, pType);
        l_rMasterTableWEB.SetRange(Codew, pNewRec."No.");
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            if (pOldRec.Kinship = pOldRec.Kinship::Himself) or (pOldRec.Kinship = pOldRec.Kinship::"Brother in School") then begin
                if l_rStudents.Get(pNewRec."No.") then begin
                    if pNewRec."Use WEB" then begin
                        if pNewRec."Last Name 2" <> '' then
                            l_Name := pNewRec."Last Name" + ' ' + pNewRec."Last Name 2" + ', ' + pNewRec.Name
                        else
                            l_Name := pNewRec."Last Name" + ', ' + pNewRec.Name;
                        InsertEntity(pType, pNewRec."No.", l_Name,
                          pNewRec."User Name", pNewRec.Password, l_rStudents."Responsibility Center", pNewRec.Language);
                    end;
                end;
            end else begin
                if l_rUsersFamily.Get(pNewRec."No.") then begin
                    if pNewRec."Use WEB" then begin
                        if pNewRec."Last Name 2" <> '' then
                            l_Name := pNewRec."Last Name" + ' ' + pNewRec."Last Name 2" + ', ' + pNewRec.Name
                        else
                            l_Name := pNewRec."Last Name" + ', ' + pNewRec.Name;

                        InsertEntity(pType, pNewRec."No.", l_Name,
                          pNewRec."User Name", pNewRec.Password, l_rStudents."Responsibility Center", l_rStudents.Language);
                    end;
                end;
            end;
        end else begin
            // Insert the new Education Header
            if (pNewRec.Kinship = pNewRec.Kinship::Himself) or (pNewRec.Kinship = pNewRec.Kinship::"Brother in School") then begin
                if l_rStudents.Get(pNewRec."No.") then begin
                    if pNewRec."Use WEB" then begin
                        l_rMasterTableWEB.Reset;
                        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Entity);
                        l_rMasterTableWEB.SetRange(Typew, pType);
                        l_rMasterTableWEB.SetRange(Codew, l_rStudents."No.");
                        if l_rMasterTableWEB.FindSet(true, true) then begin
                            if pNewRec."Last Name 2" <> '' then
                                l_Name := pNewRec."Last Name" + ' ' + pNewRec."Last Name 2" + ', ' + pNewRec.Name
                            else
                                l_Name := pNewRec."Last Name" + ', ' + pNewRec.Name;

                            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
                              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;

                            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
                              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

                            l_rMasterTableWEB."Posting Date" := Today;
                            l_rMasterTableWEB."Posting Time" := Time;
                            l_rMasterTableWEB.Description := l_Name;
                            l_rMasterTableWEB.UserID := pNewRec."User Name";
                            l_rMasterTableWEB.Password := pNewRec.Password;
                            l_rMasterTableWEB."Responsibility Center" := l_rStudents."Responsibility Center";
                            l_rMasterTableWEB.Language := pNewRec.Language;
                            l_rMasterTableWEB.Modify;
                        end else begin
                            if pNewRec."Last Name 2" <> '' then
                                l_Name := pNewRec."Last Name" + ' ' + pNewRec."Last Name 2" + ', ' + pNewRec.Name
                            else
                                l_Name := pNewRec."Last Name" + ', ' + pNewRec.Name;

                            InsertEntity(pType, pNewRec."No.", l_Name,
                             pNewRec."User Name", pNewRec.Password, l_rStudents."Responsibility Center", l_rStudents.Language);
                        end;
                    end else begin
                        if pOldRec."Use WEB" and not pNewRec."Use WEB" then begin
                            l_rMasterTableWEB.Reset;
                            l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Entity);
                            l_rMasterTableWEB.SetRange(Typew, pType);
                            l_rMasterTableWEB.SetRange(Codew, l_rStudents."No.");
                            if l_rMasterTableWEB.FindSet(true, true) then begin
                                if (l_rMasterTableWEB."Action Type" <> l_rMasterTableWEB."Action Type"::Insert) then
                                    l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                                if (l_rMasterTableWEB."Action Type 2" <> l_rMasterTableWEB."Action Type 2"::Insert) then
                                    l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                                l_rMasterTableWEB.Modify;
                                if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
                                  (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then
                                    l_rMasterTableWEB.Delete;
                            end;
                        end;
                    end;
                end;
            end else begin
                if l_rUsersFamily.Get(pNewRec."No.") then begin
                    if pNewRec."Use WEB" then begin
                        l_rMasterTableWEB.Reset;
                        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Entity);
                        l_rMasterTableWEB.SetRange(Typew, pType);
                        l_rMasterTableWEB.SetRange(Codew, l_rUsersFamily."No.");
                        if l_rMasterTableWEB.FindSet(true, true) then begin
                            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
                              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;

                            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
                              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;
                            if pNewRec."Last Name 2" <> '' then
                                l_Name := pNewRec."Last Name" + ' ' + pNewRec."Last Name 2" + ', ' + pNewRec.Name
                            else
                                l_Name := pNewRec."Last Name" + ', ' + pNewRec.Name;

                            l_rMasterTableWEB."Posting Date" := Today;
                            l_rMasterTableWEB."Posting Time" := Time;
                            l_rMasterTableWEB.Description := l_Name;
                            l_rMasterTableWEB.UserID := pNewRec."User Name";
                            l_rMasterTableWEB.Password := pNewRec.Password;
                            l_rMasterTableWEB.Language := pNewRec.Language;
                            l_rMasterTableWEB."Responsibility Center" := l_rStudents."Responsibility Center";
                            l_rMasterTableWEB.Modify;
                        end else begin
                            if pNewRec."Last Name 2" <> '' then
                                l_Name := pNewRec."Last Name" + ' ' + pNewRec."Last Name 2" + ', ' + pNewRec.Name
                            else
                                l_Name := pNewRec."Last Name" + ', ' + pNewRec.Name;

                            InsertEntity(pType, pNewRec."No.", l_Name,
                            pNewRec."User Name", pNewRec.Password, l_rStudents."Responsibility Center", l_rStudents.Language);
                        end;
                    end else begin
                        if pOldRec."Use WEB" and not pNewRec."Use WEB" then begin
                            l_rMasterTableWEB.Reset;
                            l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Entity);
                            l_rMasterTableWEB.SetRange(Typew, pType);
                            l_rMasterTableWEB.SetRange(Codew, l_rStudents."No.");
                            if l_rMasterTableWEB.FindSet(true, true) then begin
                                if (l_rMasterTableWEB."Action Type" <> l_rMasterTableWEB."Action Type"::Insert) then
                                    l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                                if (l_rMasterTableWEB."Action Type 2" <> l_rMasterTableWEB."Action Type 2"::Insert) then
                                    l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                                l_rMasterTableWEB.Modify;
                                if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
                                  (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then
                                    l_rMasterTableWEB.Delete;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyEntityTeacher(pType: Integer; pNewRec: Record "Teacher Class"; pOldRec: Record "Teacher Class")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rTeacher: Record Teacher;
        l_Name: Text[1024];
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        if not pNewRec."Use WEB" and pOldRec."Use WEB" then begin
            DeleteEntityTeacher(pType, pNewRec, pOldRec);
            exit;
        end;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Entity);
        l_rMasterTableWEB.SetRange(Typew, pType);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.User);
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            if l_rTeacher.Get(pNewRec.User) then
                if pNewRec."Use WEB" then begin
                    if pNewRec."Last Name 2" <> '' then
                        l_Name := pNewRec."Last Name" + ' ' + pNewRec."Last Name 2" + ', ' + pNewRec.Name
                    else
                        l_Name := pNewRec."Last Name" + ', ' + pNewRec.Name;

                    InsertEntity(1, pNewRec.User, l_Name,
                    pNewRec."User Name", pNewRec.Password, l_rTeacher."Responsibility Center", 0);
                end else begin
                    if pOldRec."Use WEB" and not pNewRec."Use WEB" then begin
                        if (l_rMasterTableWEB."Action Type" <> l_rMasterTableWEB."Action Type"::Insert) then
                            l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                        if (l_rMasterTableWEB."Action Type 2" <> l_rMasterTableWEB."Action Type 2"::Insert) then
                            l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                        l_rMasterTableWEB.Modify;
                        if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
                          (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then
                            l_rMasterTableWEB.Delete;
                    end;
                end;
        end else begin
            l_rMasterTableWEB.Reset;
            l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Entity);
            l_rMasterTableWEB.SetRange(Typew, pType);
            l_rMasterTableWEB.SetRange(Codew, pNewRec.User);
            if l_rMasterTableWEB.FindSet(true, true) then begin
                if l_rTeacher.Get(pNewRec.User) then begin
                    if pNewRec."Use WEB" then begin
                        if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
                          (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                            l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
                        if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
                          (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                            l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

                        if pNewRec."Last Name 2" <> '' then
                            l_Name := pNewRec."Last Name" + ' ' + pNewRec."Last Name 2" + ', ' + pNewRec.Name
                        else
                            l_Name := pNewRec."Last Name" + ', ' + pNewRec.Name;

                        l_rMasterTableWEB."Posting Date" := Today;
                        l_rMasterTableWEB."Posting Time" := Time;
                        l_rMasterTableWEB.Description := l_Name;
                        l_rMasterTableWEB.UserID := pNewRec."User Name";
                        l_rMasterTableWEB.Password := pNewRec.Password;
                        l_rMasterTableWEB."Responsibility Center" := l_rTeacher."Responsibility Center";
                        l_rMasterTableWEB.Modify;
                    end else begin
                        if pOldRec."Use WEB" and not pNewRec."Use WEB" then begin
                            if (l_rMasterTableWEB."Action Type" <> l_rMasterTableWEB."Action Type"::Insert) then
                                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                            if (l_rMasterTableWEB."Action Type 2" <> l_rMasterTableWEB."Action Type 2"::Insert) then
                                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                            l_rMasterTableWEB.Modify;
                            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
                              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then
                                l_rMasterTableWEB.Delete;
                        end;
                    end;
                end;
            end else begin
                if pNewRec."Use WEB" then begin
                    if pNewRec."Last Name 2" <> '' then
                        l_Name := pNewRec."Last Name" + ' ' + pNewRec."Last Name 2" + ', ' + pNewRec.Name
                    else
                        l_Name := pNewRec."Last Name" + ', ' + pNewRec.Name;

                    InsertEntity(1, pNewRec.User, l_Name,
                    pNewRec."User Name", pNewRec.Password, l_rTeacher."Responsibility Center", 0);
                end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteEntityUsersFamily(pType: Integer; pNewRec: Record "Users Family / Students"; pOldRec: Record "Users Family / Students")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_UsersFamilyStudents: Record "Users Family / Students";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Entity);
        l_rMasterTableWEB.SetRange(Typew, pType);
        l_rMasterTableWEB.SetRange(Codew, pOldRec."No.");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteEntityTeacher(pType: Integer; pNewRec: Record "Teacher Class"; pOldRec: Record "Teacher Class")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Entity);
        l_rMasterTableWEB.SetRange(Typew, pType);
        l_rMasterTableWEB.SetRange(Codew, pOldRec.User);
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertAspects(pNewRec: Record Aspects; pOldRec: Record Aspects)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_vEntryNo: Integer;
    begin
        if pNewRec."Not to WEB" then
            exit;

        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Aspects);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        if pNewRec.Type = pNewRec.Type::Course then
            l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEBINSERT."Type Education"::Multi)
        else
            l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEBINSERT."Type Education"::Simple);
        l_rMasterTableWEB.SetRange(StudyPlanCode, pNewRec."Type No.");
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::Aspects;
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.Codew := pNewRec.Code;
            l_rMasterTableWEBINSERT.Description := pNewRec.Description;
            l_rMasterTableWEBINSERT."School Year" := pNewRec."School Year";
            l_rMasterTableWEBINSERT.PercEvaluation := pNewRec."% Evaluation";
            l_rMasterTableWEBINSERT.Company := CompanyName;
            if pNewRec.Type = pNewRec.Type::Course then
                l_rMasterTableWEBINSERT."Type Education" := l_rMasterTableWEBINSERT."Type Education"::Multi
            else
                l_rMasterTableWEBINSERT."Type Education" := l_rMasterTableWEBINSERT."Type Education"::Simple;
            l_rMasterTableWEBINSERT.StudyPlanCode := pNewRec."Type No.";
            l_rMasterTableWEBINSERT."Responsibility Center" := pNewRec."Responsibility Center";
            l_rMasterTableWEBINSERT.Insert;
        end else begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;

            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB.Codew := pNewRec.Code;
            l_rMasterTableWEB.Description := pNewRec.Description;
            l_rMasterTableWEB."School Year" := pNewRec."School Year";
            l_rMasterTableWEB.PercEvaluation := pNewRec."% Evaluation";
            l_rMasterTableWEB."Responsibility Center" := pNewRec."Responsibility Center";
            if pNewRec.Type = pNewRec.Type::Course then
                l_rMasterTableWEB."Type Education" := l_rMasterTableWEB."Type Education"::Multi
            else
                l_rMasterTableWEB."Type Education" := l_rMasterTableWEB."Type Education"::Simple;
            l_rMasterTableWEB.StudyPlanCode := pNewRec."Type No.";
            l_rMasterTableWEB.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyAspects(pNewRec: Record Aspects; pOldRec: Record Aspects)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_Aspects: Record Aspects;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        if not pOldRec."Not to WEB" and pNewRec."Not to WEB" then begin
            if (pNewRec.Type = pNewRec.Type::Course) or (pNewRec.Type = pNewRec.Type::"Study Plan") then begin
                //Test if have another aspect
                l_Aspects.Reset;
                l_Aspects.SetRange(Type, pNewRec.Type);
                l_Aspects.SetRange("Type No.", pNewRec."Type No.");
                l_Aspects.SetRange("School Year", pNewRec."School Year");
                l_Aspects.SetRange(Code, pNewRec.Code);
                l_Aspects.SetFilter("Schooling Year", '<>%1', pNewRec."Schooling Year");
                l_Aspects.SetRange("Not to WEB", false);
                if l_Aspects.IsEmpty then
                    DeleteAspects(pOldRec, pOldRec);
            end;
        end;

        if pNewRec."Not to WEB" then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Aspects);
        l_rMasterTableWEB.SetRange(Codew, pOldRec.Code);
        if pNewRec.Type = pNewRec.Type::Course then
            l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEB."Type Education"::Multi)
        else
            l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEB."Type Education"::Simple);
        l_rMasterTableWEB.SetRange(StudyPlanCode, pNewRec."Type No.");

        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB.Codew := pNewRec.Code;
            l_rMasterTableWEB.Description := pNewRec.Description;
            l_rMasterTableWEB."School Year" := pNewRec."School Year";
            l_rMasterTableWEB.PercEvaluation := pNewRec."% Evaluation";
            l_rMasterTableWEB."Responsibility Center" := pNewRec."Responsibility Center";
            if pNewRec.Type = pNewRec.Type::Course then
                l_rMasterTableWEB."Type Education" := l_rMasterTableWEB."Type Education"::Multi
            else
                l_rMasterTableWEB."Type Education" := l_rMasterTableWEB."Type Education"::Simple;
            l_rMasterTableWEB.StudyPlanCode := pNewRec."Type No.";
            l_rMasterTableWEB.Modify;
        end else begin
            InsertAspects(pNewRec, pOldRec);
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteAspects(pNewRec: Record Aspects; pOldRec: Record Aspects)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Aspects);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        if pNewRec.Type = pNewRec.Type::Course then
            l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEB."Type Education"::Multi)
        else
            l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEB."Type Education"::Simple);
        l_rMasterTableWEB.SetRange(StudyPlanCode, pNewRec."Type No.");
        if l_rMasterTableWEB.Find('+') then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertClassificationLevel(pNewRec: Record "Classification Level"; pOldRec: Record "Classification Level")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_vEntryNo: Integer;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"Classification Level");
        l_rMasterTableWEB.SetRange(ClassificationGroupCode, pNewRec."Classification Group Code");
        l_rMasterTableWEB.SetRange(ClassificationLevelCode, pNewRec."Classification Level Code");
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::"Classification Level";
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.ClassificationGroupCode := pNewRec."Classification Group Code";
            l_rMasterTableWEBINSERT.ClassificationLevelCode := pNewRec."Classification Level Code";
            l_rMasterTableWEBINSERT.DescriptionLevel := pNewRec."Description Level";
            l_rMasterTableWEBINSERT.MinValuew := pNewRec."Min Value";
            l_rMasterTableWEBINSERT.MaxValuew := pNewRec."Max Value";
            l_rMasterTableWEBINSERT.Valuew := pNewRec.Value;
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT.PrimaryKeyw := Format(pNewRec."Id Ordination");
            l_rMasterTableWEBINSERT.Insert;
        end else begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;

            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB.ClassificationGroupCode := pNewRec."Classification Group Code";
            l_rMasterTableWEB.ClassificationLevelCode := pNewRec."Classification Level Code";
            l_rMasterTableWEB.DescriptionLevel := pNewRec."Description Level";
            l_rMasterTableWEB.MinValuew := pNewRec."Min Value";
            l_rMasterTableWEB.MaxValuew := pNewRec."Max Value";
            l_rMasterTableWEB.PrimaryKeyw := Format(pNewRec."Id Ordination");
            l_rMasterTableWEB.Valuew := pNewRec.Value;
            l_rMasterTableWEB.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyClassificationLevel(pNewRec: Record "Classification Level"; pOldRec: Record "Classification Level")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"Classification Level");
        l_rMasterTableWEB.SetRange(ClassificationGroupCode, pNewRec."Classification Group Code");
        l_rMasterTableWEB.SetRange(ClassificationLevelCode, pNewRec."Classification Level Code");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB.ClassificationGroupCode := pNewRec."Classification Group Code";
            l_rMasterTableWEB.ClassificationLevelCode := pNewRec."Classification Level Code";
            l_rMasterTableWEB.DescriptionLevel := pNewRec."Description Level";
            l_rMasterTableWEB.MinValuew := pNewRec."Min Value";
            l_rMasterTableWEB.MaxValuew := pNewRec."Max Value";
            l_rMasterTableWEB.Valuew := pNewRec.Value;
            l_rMasterTableWEB.PrimaryKeyw := Format(pNewRec."Id Ordination");
            l_rMasterTableWEB.Modify;
        end else begin
            InsertClassificationLevel(pNewRec, pOldRec);
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteClassificationLevel(pNewRec: Record "Classification Level"; pOldRec: Record "Classification Level")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"Classification Level");
        l_rMasterTableWEB.SetRange(ClassificationGroupCode, pNewRec."Classification Group Code");
        l_rMasterTableWEB.SetRange(ClassificationLevelCode, pNewRec."Classification Level Code");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertGenSettingsAsse(pNewRec: Record "Edu. Configuration"; pOldRec: Record "Edu. Configuration")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_vEntryNo: Integer;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"General Settings Assessing");
        l_rMasterTableWEB.SetRange(PrimaryKeyw, pNewRec."Primary Key");
        l_rMasterTableWEB.SetFilter("Action Type", '<>%1', l_rMasterTableWEB."Action Type"::Delete);
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::"General Settings Assessing";
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.AspectsMax := pNewRec."Aspects Max";
            l_rMasterTableWEBINSERT.AssessingMax := pNewRec."Assessing Max";
            l_rMasterTableWEBINSERT.RoundingAspects := pNewRec."Rounding Aspects";
            l_rMasterTableWEBINSERT.RoundingPartial := pNewRec."Rounding Partial";
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT.Insert;
        end else begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB.AspectsMax := pNewRec."Aspects Max";
            l_rMasterTableWEB.AssessingMax := pNewRec."Assessing Max";
            l_rMasterTableWEB.RoundingAspects := pNewRec."Rounding Aspects";
            l_rMasterTableWEB.RoundingPartial := pNewRec."Rounding Partial";
            l_rMasterTableWEB.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyGenSettingsAsse(pNewRec: Record "Edu. Configuration"; pOldRec: Record "Edu. Configuration")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"General Settings Assessing");
        l_rMasterTableWEB.SetRange(PrimaryKeyw, pNewRec."Primary Key");
        if l_rMasterTableWEB.Find('+') then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;


            l_rMasterTableWEB.PrimaryKeyw := pNewRec."Primary Key";
            l_rMasterTableWEB.AspectsMax := pNewRec."Aspects Max";
            l_rMasterTableWEB.AssessingMax := pNewRec."Assessing Max";
            l_rMasterTableWEB.RoundingAspects := pNewRec."Rounding Aspects";
            l_rMasterTableWEB.RoundingPartial := pNewRec."Rounding Partial";
            l_rMasterTableWEB.Modify;
        end else begin
            InsertGenSettingsAsse(pNewRec, pOldRec);
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteGenSettingsAsse(pNewRec: Record "Edu. Configuration"; pOldRec: Record "Edu. Configuration")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;
        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"General Settings Assessing");
        l_rMasterTableWEB.SetRange(PrimaryKeyw, pNewRec."Primary Key");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertStudent(pNewRec: Record Students; pOldRec: Record Students)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_vEntryNo: Integer;
        l_Name: Text[1024];
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Student);
        l_rMasterTableWEB.SetRange(StudentNo, pNewRec."No.");
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            if pNewRec."Last Name 2" <> '' then
                l_Name := pNewRec."Last Name" + ' ' + pNewRec."Last Name 2" + ', ' + pNewRec.Name
            else
                l_Name := pNewRec."Last Name" + ', ' + pNewRec.Name;
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::Student;
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.StudentNo := pNewRec."No.";
            l_rMasterTableWEBINSERT.Name := l_Name;
            if pNewRec.Sex = pNewRec.Sex::Male then
                l_rMasterTableWEBINSERT.male := 1
            else
                l_rMasterTableWEBINSERT.male := 0;
            l_rMasterTableWEBINSERT.Picture := pNewRec.Picture;
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT."Responsibility Center" := pNewRec."Responsibility Center";
            l_rMasterTableWEBINSERT.Language := pNewRec.Language;
            l_rMasterTableWEBINSERT.Insert;
        end else begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            if pNewRec."Last Name 2" <> '' then
                l_Name := pNewRec."Last Name" + ' ' + pNewRec."Last Name 2" + ', ' + pNewRec.Name
            else
                l_Name := pNewRec."Last Name" + ', ' + pNewRec.Name;
            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB.StudentNo := pNewRec."No.";
            l_rMasterTableWEB.Name := l_Name;
            l_rMasterTableWEB."Responsibility Center" := pNewRec."Responsibility Center";
            l_rMasterTableWEB.Language := pNewRec.Language;
            if pNewRec.Sex = pNewRec.Sex::Male then
                l_rMasterTableWEB.male := 1
            else
                l_rMasterTableWEB.male := 0;
            l_rMasterTableWEB.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyStudent(pNewRec: Record Students; pOldRec: Record Students)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_Name: Text[1024];
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Student);
        l_rMasterTableWEB.SetRange(StudentNo, pOldRec."No.");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB.StudentNo := pNewRec."No.";
            if pNewRec."Last Name 2" <> '' then
                l_Name := pNewRec."Last Name" + ' ' + pNewRec."Last Name 2" + ', ' + pNewRec.Name
            else
                l_Name := pNewRec."Last Name" + ', ' + pNewRec.Name;
            l_rMasterTableWEB.Name := l_Name;
            if pNewRec.Sex = pNewRec.Sex::Male then
                l_rMasterTableWEB.male := 1
            else
                l_rMasterTableWEB.male := 0;
            l_rMasterTableWEB."Responsibility Center" := pNewRec."Responsibility Center";
            l_rMasterTableWEB.Language := pNewRec.Language;
            l_rMasterTableWEB.Picture := pNewRec.Picture;
            l_rMasterTableWEB.UserID := pNewRec."User Id";
            l_rMasterTableWEB.Password := pNewRec.Password;
            l_rMasterTableWEB.Modify;
        end else begin
            InsertStudent(pNewRec, pOldRec);
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteStudent(pNewRec: Record Students; pOldRec: Record Students)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Student);
        l_rMasterTableWEB.SetRange(StudentNo, pOldRec."No.");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertMoments(pNewRec: Record "Moments Assessment"; pOldRec: Record "Moments Assessment")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_vEntryNo: Integer;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Moments);
        l_rMasterTableWEB.SetRange(MomentCode, pNewRec."Moment Code");
        l_rMasterTableWEB.SetRange(MomentCode, pOldRec."Moment Code");
        l_rMasterTableWEB.SetRange(SchoolingYear, pNewRec."Schooling Year");
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        l_rMasterTableWEB.SetRange("Responsibility Center", pNewRec."Responsibility Center");
        l_rMasterTableWEB.SetFilter("Action Type", '<>%1', l_rMasterTableWEB."Action Type"::Delete);
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::Moments;
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.MomentCode := pNewRec."Moment Code";
            l_rMasterTableWEBINSERT."School Year" := pNewRec."School Year";
            l_rMasterTableWEBINSERT.SchoolingYear := pNewRec."Schooling Year";
            l_rMasterTableWEBINSERT.Description := pNewRec.Description;
            l_rMasterTableWEBINSERT.EvaluationMoment := pNewRec."Evaluation Moment";
            l_rMasterTableWEBINSERT.Active := pNewRec.Active;
            l_rMasterTableWEBINSERT.Publish := pNewRec.Publish;
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT."Responsibility Center" := pNewRec."Responsibility Center";
            l_rMasterTableWEBINSERT."Sorting ID" := pNewRec."Sorting ID";
            l_rMasterTableWEBINSERT.Insert;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyMoments(pNewRec: Record "Moments Assessment"; pOldRec: Record "Moments Assessment")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetCurrentKey("Table Type", MomentCode);
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Moments);
        l_rMasterTableWEB.SetRange(MomentCode, pOldRec."Moment Code");
        l_rMasterTableWEB.SetRange(SchoolingYear, pNewRec."Schooling Year");
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        l_rMasterTableWEB.SetRange("Responsibility Center", pNewRec."Responsibility Center");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            l_rMasterTableWEB.MomentCode := pNewRec."Moment Code";
            l_rMasterTableWEB."School Year" := pNewRec."School Year";
            l_rMasterTableWEB.SchoolingYear := pNewRec."Schooling Year";
            l_rMasterTableWEB.Description := pNewRec.Description;
            l_rMasterTableWEB.EvaluationMoment := pNewRec."Evaluation Moment";
            l_rMasterTableWEB.Active := pNewRec.Active;
            l_rMasterTableWEB."Responsibility Center" := pNewRec."Responsibility Center";
            l_rMasterTableWEB.Publish := pNewRec.Publish;
            l_rMasterTableWEB."Sorting ID" := pNewRec."Sorting ID";
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;
            l_rMasterTableWEB.Modify;
        end else
            InsertMoments(pNewRec, pOldRec);
    end;

    //[Scope('OnPrem')]
    procedure DeleteMoments(pNewRec: Record "Moments Assessment"; pOldRec: Record "Moments Assessment")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetCurrentKey("Table Type", MomentCode);
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Moments);
        l_rMasterTableWEB.SetRange(MomentCode, pOldRec."Moment Code");
        if l_rMasterTableWEB.Find('+') then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertObservation(pNewRec: Record Observation; pOldRec: Record Observation)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_vEntryNo: Integer;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Observation);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        l_rMasterTableWEB.SetRange(Typew, pNewRec."Observation Type");
        l_rMasterTableWEB.SetRange(LineNow, pNewRec."Line No.");
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::Observation;
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.Typew := pNewRec."Observation Type";
            l_rMasterTableWEBINSERT.Codew := pNewRec.Code;
            l_rMasterTableWEBINSERT."School Year" := pNewRec."School Year";
            l_rMasterTableWEBINSERT.LineNow := pNewRec."Line No.";
            l_rMasterTableWEBINSERT.Description := pNewRec.Descripton;
            l_rMasterTableWEBINSERT.DescriptionMale := pNewRec."Description Male";
            l_rMasterTableWEBINSERT.DescriptionFemale := pNewRec."Description Female";
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT.Insert;
        end else begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB.Typew := pNewRec."Observation Type";
            l_rMasterTableWEB.Codew := pNewRec.Code;
            l_rMasterTableWEB."School Year" := pNewRec."School Year";
            l_rMasterTableWEB.LineNow := pNewRec."Line No.";
            l_rMasterTableWEB.Description := pNewRec.Descripton;
            l_rMasterTableWEB.DescriptionMale := pNewRec."Description Male";
            l_rMasterTableWEB.DescriptionFemale := pNewRec."Description Female";
            l_rMasterTableWEB.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyObservation(pNewRec: Record Observation; pOldRec: Record Observation)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Observation);
        l_rMasterTableWEB.SetRange(Typew, pNewRec."Observation Type");
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        l_rMasterTableWEB.SetRange(LineNow, pNewRec."Line No.");
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB."School Year" := pNewRec."School Year";
            l_rMasterTableWEB.Typew := pNewRec."Observation Type";
            l_rMasterTableWEB.Codew := pNewRec.Code;
            l_rMasterTableWEB.LineNow := pNewRec."Line No.";
            l_rMasterTableWEB.Description := pNewRec.Descripton;
            l_rMasterTableWEB.DescriptionMale := pNewRec."Description Male";
            l_rMasterTableWEB.DescriptionFemale := pNewRec."Description Female";
            l_rMasterTableWEB.Modify;
        end else begin
            InsertObservation(pNewRec, pOldRec);
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteObservation(pNewRec: Record Observation; pOldRec: Record Observation)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Observation);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        l_rMasterTableWEB.SetRange(Typew, pNewRec."Observation Type");
        l_rMasterTableWEB.SetRange(LineNow, pNewRec."Line No.");
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertIncidence(pNewRec: Record "Incidence Type"; pOldRec: Record "Incidence Type")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_vEntryNo: Integer;
        SubType: Record "Sub Type";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::IncidenceType);
        l_rMasterTableWEB.SetRange(IncidenceType, pNewRec."Incidence Type");
        l_rMasterTableWEB.SetRange("Incidence Sub Type", pNewRec."Subcategory Code");
        l_rMasterTableWEB.SetRange("Incidence Code", pNewRec."Incidence Code");
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        l_rMasterTableWEB.SetRange(SchoolingYear, pNewRec."Schooling Year");
        l_rMasterTableWEB.SetRange("Justification Code", pNewRec."Justification Code");
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::IncidenceType;
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT."School Year" := pNewRec."School Year";
            l_rMasterTableWEBINSERT.SchoolingYear := pNewRec."Schooling Year";
            l_rMasterTableWEBINSERT.IncidenceType := pNewRec."Incidence Type";
            l_rMasterTableWEBINSERT.Category := pNewRec.Category;
            l_rMasterTableWEBINSERT."Absence Status" := pNewRec."Absence Status";
            l_rMasterTableWEBINSERT."Incidence Sub Type" := pNewRec."Subcategory Code";
            l_rMasterTableWEBINSERT."Incidence Code" := pNewRec."Incidence Code";
            l_rMasterTableWEBINSERT."Incidence Description" := pNewRec.Description;
            if SubType.Get(pNewRec."Incidence Type", pNewRec."Subcategory Code") then
                l_rMasterTableWEBINSERT."Incidence Sub Type Description" := SubType.Description;
            l_rMasterTableWEBINSERT."Incidence Observations" := pNewRec.Observations;
            l_rMasterTableWEBINSERT."Justification Code" := pNewRec."Justification Code";
            l_rMasterTableWEBINSERT."Responsibility Center" := pNewRec."Responsibility Center";
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT.Insert;
        end else begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB."School Year" := pNewRec."School Year";
            l_rMasterTableWEB.SchoolingYear := pNewRec."Schooling Year";
            l_rMasterTableWEB.IncidenceType := pNewRec."Incidence Type";
            l_rMasterTableWEB.Category := pNewRec.Category;
            l_rMasterTableWEB."Absence Status" := pNewRec."Absence Status";
            l_rMasterTableWEB."Incidence Sub Type" := pNewRec."Subcategory Code";
            l_rMasterTableWEB."Incidence Code" := pNewRec."Incidence Code";
            l_rMasterTableWEB."Incidence Description" := pNewRec.Description;
            if SubType.Get(pNewRec."Incidence Type", pNewRec."Subcategory Code") then
                l_rMasterTableWEB."Incidence Sub Type Description" := SubType.Description;
            l_rMasterTableWEB."Incidence Observations" := pNewRec.Observations;
            l_rMasterTableWEB."Justification Code" := pNewRec."Justification Code";
            l_rMasterTableWEB."Responsibility Center" := pNewRec."Responsibility Center";
            l_rMasterTableWEB.Company := CompanyName;
            l_rMasterTableWEB.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyIncidence(pNewRec: Record "Incidence Type"; pOldRec: Record "Incidence Type")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        SubType: Record "Sub Type";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::IncidenceType);
        l_rMasterTableWEB.SetRange(IncidenceType, pOldRec."Incidence Type");
        l_rMasterTableWEB.SetRange("Incidence Sub Type", pOldRec."Subcategory Code");
        l_rMasterTableWEB.SetRange("Incidence Code", pOldRec."Incidence Code");
        l_rMasterTableWEB.SetRange("School Year", pOldRec."School Year");
        l_rMasterTableWEB.SetRange(SchoolingYear, pOldRec."Schooling Year");
        l_rMasterTableWEB.SetRange("Justification Code", pOldRec."Justification Code");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;
            l_rMasterTableWEB."School Year" := pNewRec."School Year";
            l_rMasterTableWEB.SchoolingYear := pNewRec."Schooling Year";
            l_rMasterTableWEB.IncidenceType := pNewRec."Incidence Type";
            l_rMasterTableWEB.Category := pNewRec.Category;
            l_rMasterTableWEB."Absence Status" := pNewRec."Absence Status";
            l_rMasterTableWEB."Incidence Sub Type" := pNewRec."Subcategory Code";
            l_rMasterTableWEB."Incidence Code" := pNewRec."Incidence Code";
            l_rMasterTableWEB."Incidence Description" := pNewRec.Description;
            if SubType.Get(pNewRec."Incidence Type", pNewRec."Subcategory Code") then
                l_rMasterTableWEB."Incidence Sub Type Description" := SubType.Description;
            l_rMasterTableWEB."Incidence Observations" := pNewRec.Observations;
            l_rMasterTableWEB."Justification Code" := pNewRec."Justification Code";
            l_rMasterTableWEB."Responsibility Center" := pNewRec."Responsibility Center";
            l_rMasterTableWEB.Company := CompanyName;
            l_rMasterTableWEB.Modify;
        end else begin
            InsertIncidence(pNewRec, pOldRec);
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteIncidence(pNewRec: Record "Incidence Type"; pOldRec: Record "Incidence Type")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEB_2: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::IncidenceType);
        l_rMasterTableWEB.SetRange(IncidenceType, pNewRec."Incidence Type");
        l_rMasterTableWEB.SetRange("Incidence Sub Type", pNewRec."Subcategory Code");
        l_rMasterTableWEB.SetRange("Incidence Code", pNewRec."Incidence Code");
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        l_rMasterTableWEB.SetRange(SchoolingYear, pNewRec."Schooling Year");
        l_rMasterTableWEB.SetRange("Justification Code", pNewRec."Justification Code");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB_2.Reset;
                l_rMasterTableWEB_2.SetRange("Table Type", l_rMasterTableWEB."Table Type"::IncidenceType);
                l_rMasterTableWEB_2.SetRange("School Year", l_rMasterTableWEB."School Year");
                l_rMasterTableWEB_2.SetRange(SchoolingYear, l_rMasterTableWEB.SchoolingYear);
                l_rMasterTableWEB_2.SetRange("Incidence Sub Type", l_rMasterTableWEB."Incidence Sub Type");
                l_rMasterTableWEB_2.SetRange(IncidenceType, l_rMasterTableWEB.IncidenceType);
                l_rMasterTableWEB_2.SetRange("Incidence Code", l_rMasterTableWEB."Incidence Code");
                l_rMasterTableWEB_2.SetRange(Category, l_rMasterTableWEB.Category);
                l_rMasterTableWEB_2.DeleteAll;
                l_rMasterTableWEB.Delete;
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB_2.Reset;
                l_rMasterTableWEB_2.SetRange("Table Type", l_rMasterTableWEB."Table Type"::IncidenceType);
                l_rMasterTableWEB_2.SetRange("School Year", l_rMasterTableWEB."School Year");
                l_rMasterTableWEB_2.SetRange(SchoolingYear, l_rMasterTableWEB.SchoolingYear);
                l_rMasterTableWEB_2.SetRange("Incidence Sub Type", l_rMasterTableWEB."Incidence Sub Type");
                l_rMasterTableWEB_2.SetRange(IncidenceType, l_rMasterTableWEB.IncidenceType);
                l_rMasterTableWEB_2.SetRange("Incidence Code", l_rMasterTableWEB."Incidence Code");
                l_rMasterTableWEB_2.SetRange(Category, l_rMasterTableWEB.Category);
                l_rMasterTableWEB_2.ModifyAll("Action Type", l_rMasterTableWEB_2."Action Type"::Delete);
                l_rMasterTableWEB_2.ModifyAll("Action Type 2", l_rMasterTableWEB_2."Action Type 2"::Delete);
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertSubjectGroup(pNewRec: Record "Group Subjects"; pOldRec: Record "Group Subjects")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_vEntryNo: Integer;
    begin
        //NOT USED - Is inserted by the study plan lines

        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"Group Subjects");
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        if pNewRec."Schooling Year" <> '' then
            l_rMasterTableWEB.SetRange(SchoolingYear, pNewRec."Schooling Year");
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::"Group Subjects";
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.Codew := pNewRec.Code;
            l_rMasterTableWEBINSERT.SchoolingYear := pNewRec."Schooling Year";
            l_rMasterTableWEBINSERT.Description := pNewRec.Description;
            l_rMasterTableWEBINSERT.LineNow := pNewRec."Sorting ID";
            l_rMasterTableWEBINSERT.EvaluationType := pNewRec."Evaluation Type";
            l_rMasterTableWEBINSERT.ClassificationLevelCode := pNewRec."Assessment Code";
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT.Insert;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifySubjectGroup(pNewRec: Record "Group Subjects"; pOldRec: Record "Group Subjects")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"Group Subjects");
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        if pNewRec."Schooling Year" <> '' then
            l_rMasterTableWEB.SetRange(SchoolingYear, pNewRec."Schooling Year");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            repeat
                l_rMasterTableWEB."Posting Date" := Today;
                l_rMasterTableWEB."Posting Time" := Time;
                l_rMasterTableWEB.Codew := pNewRec.Code;
                l_rMasterTableWEB.SchoolingYear := pNewRec."Schooling Year";
                l_rMasterTableWEB.Description := pNewRec.Description;
                l_rMasterTableWEB.LineNow := pNewRec."Sorting ID";
                l_rMasterTableWEB.EvaluationType := pNewRec."Evaluation Type";
                l_rMasterTableWEB.ClassificationLevelCode := pNewRec."Assessment Code";
                l_rMasterTableWEB.Company := CompanyName;

                if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
                  (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                    l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
                if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
                  (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                    l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

                l_rMasterTableWEB.Modify;
            until l_rMasterTableWEB.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteSubjectGroup(pNewRec: Record "Group Subjects"; pOldRec: Record "Group Subjects")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"Group Subjects");
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        if pNewRec."Schooling Year" <> '' then
            l_rMasterTableWEB.SetRange(SchoolingYear, pNewRec."Schooling Year");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            repeat
                if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
                  (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                    l_rMasterTableWEB.Delete;
                end else begin
                    l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                    l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                    l_rMasterTableWEB.Modify;
                end;
            until l_rMasterTableWEB.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertSubjectGroupPLClass(pNewRec: Record "Study Plan Lines"; pOldRec: Record "Study Plan Lines")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_GroupSubjects: Record "Group Subjects";
        l_cStudentsRegistration: Codeunit "Students Registration";
        l_vEntryNo: Integer;
    begin
        if not l_GroupSubjects.Get(pNewRec."Option Group", pNewRec."Schooling Year") then
            exit;
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"Group Subjects");
        l_rMasterTableWEB.SetRange(Codew, pNewRec."Option Group");
        l_rMasterTableWEB.SetRange(SchoolingYear, pNewRec."Schooling Year");
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEB."Type Education"::Simple);
        l_rMasterTableWEB.SetRange(StudyPlanCode, pNewRec.Code);
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::"Group Subjects";
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.Codew := pNewRec."Option Group";
            l_rMasterTableWEBINSERT.SchoolingYear := pNewRec."Schooling Year";
            l_rMasterTableWEBINSERT.Description := l_GroupSubjects.Description;
            l_rMasterTableWEBINSERT.LineNow := l_GroupSubjects."Sorting ID";
            l_rMasterTableWEBINSERT.EvaluationType := l_GroupSubjects."Evaluation Type";
            l_rMasterTableWEBINSERT.ClassificationLevelCode := l_GroupSubjects."Assessment Code";
            l_rMasterTableWEBINSERT."School Year" := pNewRec."School Year";
            l_rMasterTableWEBINSERT."Type Education" := l_rMasterTableWEBINSERT."Type Education"::Simple;
            l_rMasterTableWEBINSERT.StudyPlanCode := pNewRec.Code;
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT.Insert;
        end else begin
            l_rMasterTableWEB."Table Type" := l_rMasterTableWEB."Table Type"::"Group Subjects";
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;
            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB.Codew := pNewRec."Option Group";
            l_rMasterTableWEB.SchoolingYear := pNewRec."Schooling Year";
            l_rMasterTableWEB.Description := l_GroupSubjects.Description;
            l_rMasterTableWEB.LineNow := l_GroupSubjects."Sorting ID";
            l_rMasterTableWEB.EvaluationType := l_GroupSubjects."Evaluation Type";
            l_rMasterTableWEB.ClassificationLevelCode := l_GroupSubjects."Assessment Code";
            l_rMasterTableWEB."School Year" := pNewRec."School Year";
            l_rMasterTableWEB.StudyPlanCode := pNewRec.Code;
            l_rMasterTableWEB.Company := CompanyName;
            l_rMasterTableWEB.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteSubjectGroupPLClass(pNewRec: Record "Study Plan Lines"; pOldRec: Record "Study Plan Lines")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_Class: Record Class;
        l_GroupSubjects: Record "Group Subjects";
        l_cStudentsRegistration: Codeunit "Students Registration";
    begin
        if not l_GroupSubjects.Get(pOldRec."Option Group", pOldRec."Schooling Year") then
            exit;
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"Group Subjects");
        l_rMasterTableWEB.SetRange(Codew, pOldRec."Option Group");
        l_rMasterTableWEB.SetRange(SchoolingYear, pNewRec."Schooling Year");
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEB."Type Education"::Simple);
        l_rMasterTableWEB.SetRange(StudyPlanCode, pNewRec.Code);
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                if (l_rMasterTableWEB."Action Type" <> l_rMasterTableWEB."Action Type"::Insert) then
                    l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                if (l_rMasterTableWEB."Action Type 2" <> l_rMasterTableWEB."Action Type 2"::Insert) then
                    l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertSubjectGroupCClass(pNewRec: Record "Course Lines"; pOldRec: Record "Course Lines")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_GroupSubjects: Record "Group Subjects";
        l_cStudentsRegistration: Codeunit "Students Registration";
        l_vEntryNo: Integer;
    begin
        if not l_GroupSubjects.Get(pNewRec."Option Group", '') then
            exit;
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"Group Subjects");
        l_rMasterTableWEB.SetRange(Codew, pNewRec."Option Group");
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year Begin");
        l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEB."Type Education"::Multi);
        l_rMasterTableWEB.SetRange(StudyPlanCode, pNewRec.Code);
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::"Group Subjects";
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.Codew := pNewRec."Option Group";
            l_rMasterTableWEBINSERT.Description := l_GroupSubjects.Description;
            l_rMasterTableWEBINSERT.LineNow := l_GroupSubjects."Sorting ID";
            l_rMasterTableWEBINSERT.EvaluationType := l_GroupSubjects."Evaluation Type";
            l_rMasterTableWEBINSERT.ClassificationLevelCode := l_GroupSubjects."Assessment Code";
            l_rMasterTableWEBINSERT."School Year" := pNewRec."School Year Begin";
            l_rMasterTableWEBINSERT."Type Education" := l_rMasterTableWEBINSERT."Type Education"::Multi;
            l_rMasterTableWEBINSERT.StudyPlanCode := pNewRec.Code;
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT.Insert;
        end else begin
            l_rMasterTableWEB."Table Type" := l_rMasterTableWEB."Table Type"::"Group Subjects";
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;
            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB.Codew := pNewRec."Option Group";
            l_rMasterTableWEB.Description := l_GroupSubjects.Description;
            l_rMasterTableWEB.LineNow := l_GroupSubjects."Sorting ID";
            l_rMasterTableWEB.EvaluationType := l_GroupSubjects."Evaluation Type";
            l_rMasterTableWEB.ClassificationLevelCode := l_GroupSubjects."Assessment Code";
            l_rMasterTableWEB."School Year" := pNewRec."School Year Begin";
            l_rMasterTableWEB."Type Education" := l_rMasterTableWEB."Type Education"::Multi;
            l_rMasterTableWEB.StudyPlanCode := pNewRec.Code;
            l_rMasterTableWEB.Company := CompanyName;
            l_rMasterTableWEB.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteSubjectGroupCClass(pNewRec: Record "Course Lines"; pOldRec: Record "Course Lines")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_Class: Record Class;
        l_GroupSubjects: Record "Group Subjects";
        l_cStudentsRegistration: Codeunit "Students Registration";
    begin
        if not l_GroupSubjects.Get(pOldRec."Option Group", '') then
            exit;
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"Group Subjects");
        l_rMasterTableWEB.SetRange(Codew, pOldRec."Option Group");
        l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEB."Type Education"::Multi);
        l_rMasterTableWEB.SetRange(StudyPlanCode, pNewRec.Code);
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year Begin");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                if (l_rMasterTableWEB."Action Type" <> l_rMasterTableWEB."Action Type"::Insert) then
                    l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                if (l_rMasterTableWEB."Action Type 2" <> l_rMasterTableWEB."Action Type 2"::Insert) then
                    l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertClass(pNewRec: Record Class; pOldRec: Record Class)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_StructureEducationCountry: Record "Structure Education Country";
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseLines: Record "Course Lines";
        rCourseLinesTEMP: Record "Course Lines" temporary;
        l_StudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        l_CompanyInformation: Record "Company Information";
        l_rAssessmentConfiguration: Record "Assessment Configuration";
        cStudentsRegistration: Codeunit "Students Registration";
        l_vEntryNo: Integer;
        fClass: Page Class;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Class);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Class);
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        if not l_rMasterTableWEB.FindSet then begin
            l_StructureEducationCountry.Reset;
            l_StructureEducationCountry.SetRange(Country, pNewRec."Country/Region Code");
            l_StructureEducationCountry.SetRange("Schooling Year", pNewRec."Schooling Year");
            if l_StructureEducationCountry.FindSet then begin

                l_rAssessmentConfiguration.Reset;
                l_rAssessmentConfiguration.SetRange("School Year", pNewRec."School Year");
                l_rAssessmentConfiguration.SetRange("Study Plan Code", pNewRec."Study Plan Code");
                l_rAssessmentConfiguration.SetRange("Country/Region Code", pNewRec."Country/Region Code");
                if l_rAssessmentConfiguration.FindFirst then;

                Clear(l_rMasterTableWEBINSERT);
                l_rMasterTableWEBINSERT.Init;
                l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::Class;
                l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
                l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
                l_rMasterTableWEBINSERT."Posting Date" := Today;
                l_rMasterTableWEBINSERT."Posting Time" := Time;
                l_rMasterTableWEBINSERT.Codew := pNewRec.Class;
                l_rMasterTableWEBINSERT.SchoolingYear := pNewRec."Schooling Year";
                l_rMasterTableWEBINSERT."School Year" := pNewRec."School Year";
                l_rMasterTableWEBINSERT.Description := pNewRec.Description;
                l_rMasterTableWEBINSERT.Company := CompanyName;
                l_rMasterTableWEBINSERT."Responsibility Center" := pNewRec."Responsibility Center";
                l_rMasterTableWEBINSERT."Interface Type WEB" := l_StructureEducationCountry."Interface Type WEB";
                l_rMasterTableWEBINSERT."Type Education" := pNewRec.Type;
                l_rMasterTableWEBINSERT.StudyPlanCode := pNewRec."Study Plan Code";
                l_rMasterTableWEBINSERT."Class Director" := pNewRec."Class Director No.";
                l_rMasterTableWEBINSERT."Annotation Group" := l_rAssessmentConfiguration."Annotation Code";
                l_rMasterTableWEBINSERT.Insert;

                //Insert the subjects for this class.
                if (pNewRec.Type = pNewRec.Type::Simple) and (pNewRec."Study Plan Code" <> '') then begin
                    rStudyPlanLines.Reset;
                    rStudyPlanLines.FilterGroup(2);
                    rStudyPlanLines.SetRange(Code, pNewRec."Study Plan Code");
                    rStudyPlanLines.SetRange("School Year", pNewRec."School Year");
                    rStudyPlanLines.SetRange("Schooling Year", pNewRec."Schooling Year");
                    rStudyPlanLines.FilterGroup(0);
                    if rStudyPlanLines.FindSet then begin
                        repeat
                            rStudyPlanLines.CalcFields("Sub-Subject");
                            InsertSubjectPLClass(rStudyPlanLines, rStudyPlanLines, rStudyPlanLines."Sub-Subject");
                            l_StudyPlanSubSubjectsLines.Reset;
                            l_StudyPlanSubSubjectsLines.SetRange(Type, l_StudyPlanSubSubjectsLines.Type::"Study Plan");
                            l_StudyPlanSubSubjectsLines.SetRange(Code, rStudyPlanLines.Code);
                            l_StudyPlanSubSubjectsLines.SetRange("Schooling Year", pNewRec."Schooling Year");
                            if l_StudyPlanSubSubjectsLines.FindSet then
                                repeat
                                    InsertSubSubjectCClass(l_StudyPlanSubSubjectsLines, l_StudyPlanSubSubjectsLines);
                                until l_StudyPlanSubSubjectsLines.Next = 0;

                        until rStudyPlanLines.Next = 0;
                    end;
                end;
                if (pNewRec.Type = pNewRec.Type::Multi) and (pNewRec."Study Plan Code" <> '') then begin
                    rCourseLinesTEMP.Reset;
                    rCourseLinesTEMP.DeleteAll;
                    //Quadriennal
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, pNewRec."Study Plan Code");
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
                    if rCourseLines.Find('-') then begin
                        repeat
                            rCourseLinesTEMP.Init;
                            rCourseLinesTEMP.TransferFields(rCourseLines);
                            rCourseLinesTEMP."Temp Class" := pNewRec.Class;
                            rCourseLinesTEMP."Temp School Year" := pNewRec."School Year";
                            rCourseLinesTEMP.Insert;
                        until rCourseLines.Next = 0;
                    end;
                    //Anual
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, pNewRec."Study Plan Code");
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
                    rCourseLines.SetRange("Schooling Year Begin", pNewRec."Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            rCourseLinesTEMP.Init;
                            rCourseLinesTEMP.TransferFields(rCourseLines);
                            rCourseLinesTEMP."Temp Class" := pNewRec.Class;
                            rCourseLinesTEMP."Temp School Year" := pNewRec."School Year";
                            rCourseLinesTEMP.Insert;
                        until rCourseLines.Next = 0;
                    end;
                    //Bienal E Triennal
                    l_StructureEducationCountry.Reset;
                    l_StructureEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                    l_StructureEducationCountry.SetRange(Type, l_StructureEducationCountry.Type::Multi);
                    l_StructureEducationCountry.SetRange("Schooling Year", pNewRec."Schooling Year");
                    if l_StructureEducationCountry.Find('-') then begin
                        rCourseLines.Reset;
                        rCourseLines.SetRange(Code, pNewRec."Study Plan Code");
                        rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                        rCourseLines."Characterise Subjects"::Triennial);
                        rCourseLines.SetRange("Schooling Year Begin", pNewRec."Schooling Year");
                        if rCourseLines.Find('-') then begin
                            repeat
                                rCourseLinesTEMP.Init;
                                rCourseLinesTEMP.TransferFields(rCourseLines);
                                rCourseLinesTEMP."Temp Class" := pNewRec.Class;
                                rCourseLinesTEMP."Temp School Year" := pNewRec."School Year";
                                rCourseLinesTEMP.Insert;
                            until rCourseLines.Next = 0;
                        end;
                        //ELSE BEGIN
                        l_StructureEducationCountry.Reset;
                        l_StructureEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                        l_StructureEducationCountry.SetRange(Type, l_StructureEducationCountry.Type::Multi);
                        l_StructureEducationCountry.SetRange("Sorting ID",
                          fClass.GetNoStructureCountry(pNewRec.Class, pNewRec."School Year") - 1);
                        if l_StructureEducationCountry.Find('-') then begin
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, pNewRec."Study Plan Code");
                            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                            rCourseLines.SetRange("Schooling Year Begin", l_StructureEducationCountry."Schooling Year");
                            if rCourseLines.Find('-') then begin
                                repeat
                                    rCourseLinesTEMP.Init;
                                    rCourseLinesTEMP.TransferFields(rCourseLines);
                                    rCourseLinesTEMP."Temp Class" := pNewRec.Class;
                                    rCourseLinesTEMP."Temp School Year" := pNewRec."School Year";
                                    rCourseLinesTEMP.Insert;
                                until rCourseLines.Next = 0;
                            end;
                        end;
                        l_StructureEducationCountry.Reset;
                        l_StructureEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                        l_StructureEducationCountry.SetRange(Type, l_StructureEducationCountry.Type::Multi);
                        l_StructureEducationCountry.SetRange("Sorting ID",
                          fClass.GetNoStructureCountry(pNewRec.Class, pNewRec."School Year") - 2);
                        if l_StructureEducationCountry.Find('-') then begin
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, pNewRec."Study Plan Code");
                            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                            rCourseLines.SetRange("Schooling Year Begin", l_StructureEducationCountry."Schooling Year");
                            if rCourseLines.Find('-') then begin
                                repeat
                                    rCourseLinesTEMP.Init;
                                    rCourseLinesTEMP.TransferFields(rCourseLines);
                                    rCourseLinesTEMP."Temp Class" := pNewRec.Class;
                                    rCourseLinesTEMP."Temp School Year" := pNewRec."School Year";
                                    rCourseLinesTEMP.Insert;
                                until rCourseLines.Next = 0;
                            end;
                        end;
                        l_StructureEducationCountry.Reset;
                        l_StructureEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                        l_StructureEducationCountry.SetRange(Type, l_StructureEducationCountry.Type::Multi);
                        l_StructureEducationCountry.SetRange("Sorting ID",
                          fClass.GetNoStructureCountry(pNewRec.Class, pNewRec."School Year") - 1);
                        if l_StructureEducationCountry.Find('-') then begin
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, pNewRec."Study Plan Code");
                            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                            rCourseLines.SetRange("Schooling Year Begin", l_StructureEducationCountry."Schooling Year");
                            if rCourseLines.Find('-') then begin
                                repeat
                                    rCourseLinesTEMP.Init;
                                    rCourseLinesTEMP.TransferFields(rCourseLines);
                                    rCourseLinesTEMP."Temp Class" := pNewRec.Class;
                                    rCourseLinesTEMP."Temp School Year" := pNewRec."School Year";
                                    rCourseLinesTEMP.Insert;
                                until rCourseLines.Next = 0;
                            end;
                        end;
                        if rCourseLinesTEMP.FindSet then begin
                            repeat
                                rCourseLinesTEMP.CalcFields("Sub-Subject");
                                InsertSubjectCClass(rCourseLinesTEMP, rCourseLinesTEMP, rCourseLinesTEMP."Sub-Subject");

                                if rCourseLinesTEMP."Option Group" <> '' then
                                    InsertSubjectGroupCClass(rCourseLinesTEMP, rCourseLinesTEMP);

                                l_StudyPlanSubSubjectsLines.Reset;
                                l_StudyPlanSubSubjectsLines.SetRange(Type, l_StudyPlanSubSubjectsLines.Type::Course);
                                l_StudyPlanSubSubjectsLines.SetRange(Code, rCourseLinesTEMP.Code);
                                l_StudyPlanSubSubjectsLines.SetRange("Schooling Year", pNewRec."Schooling Year");
                                if l_StudyPlanSubSubjectsLines.FindSet then
                                    repeat
                                        InsertSubSubjectCClass(l_StudyPlanSubSubjectsLines, l_StudyPlanSubSubjectsLines);
                                    until l_StudyPlanSubSubjectsLines.Next = 0;
                            until rCourseLinesTEMP.Next = 0;
                        end;
                    end
                end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyClass(pNewRec: Record Class; pOldRec: Record Class)
    var
        l_StructureEducationCountry: Record "Structure Education Country";
        l_rMasterTableWEB: Record MasterTableWEB;
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseLines: Record "Course Lines";
        rCourseLinesTEMP: Record "Course Lines" temporary;
        l_StudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        l_CompanyInformation: Record "Company Information";
        l_rAssessmentConfiguration: Record "Assessment Configuration";
        cStudentsRegistration: Codeunit "Students Registration";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Class);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Class);
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            l_StructureEducationCountry.Reset;
            l_StructureEducationCountry.SetRange(Country, pNewRec."Country/Region Code");
            l_StructureEducationCountry.SetRange("Schooling Year", pNewRec."Schooling Year");
            if l_StructureEducationCountry.FindSet then begin

                l_rAssessmentConfiguration.Reset;
                l_rAssessmentConfiguration.SetRange("School Year", pNewRec."School Year");
                l_rAssessmentConfiguration.SetRange("Study Plan Code", pNewRec."Study Plan Code");
                l_rAssessmentConfiguration.SetRange("Country/Region Code", pNewRec."Country/Region Code");
                if l_rAssessmentConfiguration.FindFirst then;


                l_rMasterTableWEB."Posting Date" := Today;
                l_rMasterTableWEB."Posting Time" := Time;
                l_rMasterTableWEB.Codew := pNewRec.Class;
                l_rMasterTableWEB.SchoolingYear := pNewRec."Schooling Year";
                l_rMasterTableWEB."School Year" := pNewRec."School Year";
                l_rMasterTableWEB.Description := pNewRec.Description;
                l_rMasterTableWEB.Company := CompanyName;
                l_rMasterTableWEB."Responsibility Center" := pNewRec."Responsibility Center";
                l_rMasterTableWEB."Interface Type WEB" := l_StructureEducationCountry."Interface Type WEB";
                l_rMasterTableWEB."Type Education" := pNewRec.Type;
                l_rMasterTableWEB.StudyPlanCode := pNewRec."Study Plan Code";
                l_rMasterTableWEB."Annotation Group" := l_rAssessmentConfiguration."Annotation Code";

                /*
                //IF the study plan change must delete the old lines of subjects an add the new lines
                //Delete the subjects for this class.
                IF (pOldRec.Type = pOldRec.Type::Simple) AND ((pOldRec."Study Plan Code" <> '')
                OR (pOldRec."Study Plan Code" <> pNewRec."Study Plan Code"))THEN BEGIN
                  rStudyPlanLines.RESET;
                  rStudyPlanLines.FILTERGROUP(2);
                  rStudyPlanLines.SETRANGE(Code,pOldRec."Study Plan Code");
                  rStudyPlanLines.SETRANGE("School Year",pOldRec."School Year");
                  rStudyPlanLines.SETRANGE("Schooling Year",pOldRec."Schooling Year");
                  rStudyPlanLines.FILTERGROUP(0);
                  IF rStudyPlanLines.FINDSET THEN BEGIN
                    REPEAT
                         DeleteSubjectPLClass(rStudyPlanLines,rStudyPlanLines);
                         l_StudyPlanSubSubjectsLines.RESET;
                         l_StudyPlanSubSubjectsLines.SETRANGE(Type,l_StudyPlanSubSubjectsLines.Type::"Study Plan");
                         l_StudyPlanSubSubjectsLines.SETRANGE(Code,rStudyPlanLines.Code);
                         l_StudyPlanSubSubjectsLines.SETRANGE("Schooling Year",pOldRec."Schooling Year");
                         IF l_StudyPlanSubSubjectsLines.FINDSET THEN
                           REPEAT
                             DeleteSubSubjectCClass(l_StudyPlanSubSubjectsLines,l_StudyPlanSubSubjectsLines);
                           UNTIL l_StudyPlanSubSubjectsLines.NEXT = 0;

                    UNTIL rStudyPlanLines.NEXT = 0;
                  END;
                END;
                IF (pOldRec.Type = pOldRec.Type::Multi) AND ((pOldRec."Study Plan Code" <> '')
                OR (pOldRec."Study Plan Code" <> pNewRec."Study Plan Code"))THEN BEGIN
                  rCourseLinesTEMP.RESET;
                  rCourseLinesTEMP.DELETEALL;
                  //Quadriennal
                  rCourseLines.RESET;
                  rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                  rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Quadriennal);
                  IF rCourseLines.FIND('-') THEN BEGIN
                     REPEAT
                       rCourseLinesTEMP.INIT;
                       rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                       rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                       rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                       rCourseLinesTEMP.INSERT;
                     UNTIL  rCourseLines.NEXT = 0;
                  END;
                  //Anual
                  rCourseLines.RESET;
                  rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                  rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Annual);
                  rCourseLines.SETRANGE("Schooling Year Begin",pOldRec."Schooling Year");
                  IF rCourseLines.FIND('-') THEN BEGIN
                     REPEAT
                       rCourseLinesTEMP.INIT;
                       rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                       rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                       rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                       rCourseLinesTEMP.INSERT;
                     UNTIL  rCourseLines.NEXT = 0;
                  END;
                  //Bienal E Triennal
                  l_StructureEducationCountry.RESET;
                  l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                  l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                  l_StructureEducationCountry.SETRANGE("Schooling Year",pOldRec."Schooling Year");
                  IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                        rCourseLines.RESET;
                        rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                        rCourseLines.SETFILTER("Characterise Subjects",'%1|%2',rCourseLines."Characterise Subjects"::Biennial,
                        rCourseLines."Characterise Subjects"::Triennial);
                        rCourseLines.SETRANGE("Schooling Year Begin",pOldRec."Schooling Year");
                        IF rCourseLines.FIND('-') THEN BEGIN
                           REPEAT
                             rCourseLinesTEMP.INIT;
                             rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                             rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                             rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                             rCourseLinesTEMP.INSERT;
                           UNTIL  rCourseLines.NEXT = 0;
                        END;
                         //ELSE BEGIN
                          l_StructureEducationCountry.RESET;
                          l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                          l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                          l_StructureEducationCountry.SETRANGE("Sorting ID",
                            fClass.GetNoStructureCountry(pNewRec.Class,pOldRec."School Year")-1);
                          IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                             rCourseLines.RESET;
                             rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                             rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Biennial);
                             rCourseLines.SETRANGE("Schooling Year Begin",l_StructureEducationCountry."Schooling Year");
                             IF rCourseLines.FIND('-') THEN BEGIN
                                REPEAT
                                  rCourseLinesTEMP.INIT;
                                  rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                                  rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                                  rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                                  rCourseLinesTEMP.INSERT;
                                UNTIL  rCourseLines.NEXT = 0;
                             END;
                          END;
                          l_StructureEducationCountry.RESET;
                          l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                          l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                          l_StructureEducationCountry.SETRANGE("Sorting ID",
                            fClass.GetNoStructureCountry(pNewRec.Class,pOldRec."School Year")-2);
                          IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                             rCourseLines.RESET;
                             rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                             rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Triennial);
                             rCourseLines.SETRANGE("Schooling Year Begin",l_StructureEducationCountry."Schooling Year");
                             IF rCourseLines.FIND('-') THEN BEGIN
                                REPEAT
                                  rCourseLinesTEMP.INIT;
                                  rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                                  rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                                  rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                                  rCourseLinesTEMP.INSERT;
                                UNTIL  rCourseLines.NEXT = 0;
                             END;
                          END;
                          l_StructureEducationCountry.RESET;
                          l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                          l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                          l_StructureEducationCountry.SETRANGE("Sorting ID",
                            fClass.GetNoStructureCountry(pNewRec.Class,pOldRec."School Year")-1);
                          IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                             rCourseLines.RESET;
                             rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                             rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Triennial);
                             rCourseLines.SETRANGE("Schooling Year Begin",l_StructureEducationCountry."Schooling Year");
                             IF rCourseLines.FIND('-') THEN BEGIN
                                REPEAT
                                  rCourseLinesTEMP.INIT;
                                  rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                                  rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                                  rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                                  rCourseLinesTEMP.INSERT;
                                UNTIL  rCourseLines.NEXT = 0;
                             END;
                          END;
                    IF rCourseLinesTEMP.FINDSET THEN BEGIN
                      REPEAT
                         DeleteSubjectCClass(rCourseLinesTEMP,rCourseLinesTEMP);

                         l_StudyPlanSubSubjectsLines.RESET;
                         l_StudyPlanSubSubjectsLines.SETRANGE(Type,l_StudyPlanSubSubjectsLines.Type::Course);
                         l_StudyPlanSubSubjectsLines.SETRANGE(Code,rCourseLinesTEMP.Code);
                         l_StudyPlanSubSubjectsLines.SETRANGE("Schooling Year",pOldRec."Schooling Year");
                         IF l_StudyPlanSubSubjectsLines.FINDSET THEN
                           REPEAT
                             DeleteSubSubjectCClass(l_StudyPlanSubSubjectsLines,l_StudyPlanSubSubjectsLines);
                           UNTIL l_StudyPlanSubSubjectsLines.NEXT = 0;
                      UNTIL rCourseLinesTEMP.NEXT = 0;
                    END;
                  END
                END;

                //Insert the subjects for this class.
                IF (pNewRec.Type = pNewRec.Type::Simple) AND (pNewRec."Study Plan Code" <> '') THEN BEGIN
                  rStudyPlanLines.RESET;
                  rStudyPlanLines.FILTERGROUP(2);
                  rStudyPlanLines.SETRANGE(Code,pNewRec."Study Plan Code");
                  rStudyPlanLines.SETRANGE("School Year",pNewRec."School Year");
                  rStudyPlanLines.SETRANGE("Schooling Year",pNewRec."Schooling Year");
                  rStudyPlanLines.FILTERGROUP(0);
                  IF rStudyPlanLines.FINDSET THEN BEGIN
                    REPEAT
                         rStudyPlanLines.CALCFIELDS("Sub-Subject");
                         InsertSubjectPLClass(rStudyPlanLines,rStudyPlanLines,rStudyPlanLines."Sub-Subject");
                         l_StudyPlanSubSubjectsLines.RESET;
                         l_StudyPlanSubSubjectsLines.SETRANGE(Type,l_StudyPlanSubSubjectsLines.Type::"Study Plan");
                         l_StudyPlanSubSubjectsLines.SETRANGE(Code,rStudyPlanLines.Code);
                         l_StudyPlanSubSubjectsLines.SETRANGE("Schooling Year",pNewRec."Schooling Year");
                         IF l_StudyPlanSubSubjectsLines.FINDSET THEN
                           REPEAT
                             InsertSubSubjectCClass(l_StudyPlanSubSubjectsLines,l_StudyPlanSubSubjectsLines);
                           UNTIL l_StudyPlanSubSubjectsLines.NEXT = 0;

                    UNTIL rStudyPlanLines.NEXT = 0;
                  END;
                END;
                IF (pNewRec.Type = pNewRec.Type::Multi) AND (pNewRec."Study Plan Code" <> '') THEN BEGIN
                  rCourseLinesTEMP.RESET;
                  rCourseLinesTEMP.DELETEALL;
                  //Quadriennal
                  rCourseLines.RESET;
                  rCourseLines.SETRANGE(Code,pNewRec."Study Plan Code");
                  rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Quadriennal);
                  IF rCourseLines.FIND('-') THEN BEGIN
                     REPEAT
                       rCourseLinesTEMP.INIT;
                       rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                       rCourseLinesTEMP."Temp Class" := pNewRec.Class;
                       rCourseLinesTEMP."Temp School Year" := pNewRec."School Year";
                       rCourseLinesTEMP.INSERT;
                     UNTIL  rCourseLines.NEXT = 0;
                  END;
                  //Anual
                  rCourseLines.RESET;
                  rCourseLines.SETRANGE(Code,pNewRec."Study Plan Code");
                  rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Annual);
                  rCourseLines.SETRANGE("Schooling Year Begin",pNewRec."Schooling Year");
                  IF rCourseLines.FIND('-') THEN BEGIN
                     REPEAT
                       rCourseLinesTEMP.INIT;
                       rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                       rCourseLinesTEMP."Temp Class" := pNewRec.Class;
                       rCourseLinesTEMP."Temp School Year" := pNewRec."School Year";
                       rCourseLinesTEMP.INSERT;
                     UNTIL  rCourseLines.NEXT = 0;
                  END;
                  //Bienal E Triennal
                  l_StructureEducationCountry.RESET;
                  l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                  l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                  l_StructureEducationCountry.SETRANGE("Schooling Year",pNewRec."Schooling Year");
                  IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                        rCourseLines.RESET;
                        rCourseLines.SETRANGE(Code,pNewRec."Study Plan Code");
                        rCourseLines.SETFILTER("Characterise Subjects",'%1|%2',rCourseLines."Characterise Subjects"::Biennial,
                        rCourseLines."Characterise Subjects"::Triennial);
                        rCourseLines.SETRANGE("Schooling Year Begin",pNewRec."Schooling Year");
                        IF rCourseLines.FIND('-') THEN BEGIN
                           REPEAT
                             rCourseLinesTEMP.INIT;
                             rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                             rCourseLinesTEMP."Temp Class" := pNewRec.Class;
                             rCourseLinesTEMP."Temp School Year" := pNewRec."School Year";
                             rCourseLinesTEMP.INSERT;
                           UNTIL  rCourseLines.NEXT = 0;
                        END;
                         //ELSE BEGIN
                          l_StructureEducationCountry.RESET;
                          l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                          l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                          l_StructureEducationCountry.SETRANGE("Sorting ID",
                            fClass.GetNoStructureCountry(pNewRec.Class,pNewRec."School Year")-1);
                          IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                             rCourseLines.RESET;
                             rCourseLines.SETRANGE(Code,pNewRec."Study Plan Code");
                             rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Biennial);
                             rCourseLines.SETRANGE("Schooling Year Begin",l_StructureEducationCountry."Schooling Year");
                             IF rCourseLines.FIND('-') THEN BEGIN
                                REPEAT
                                  rCourseLinesTEMP.INIT;
                                  rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                                  rCourseLinesTEMP."Temp Class" := pNewRec.Class;
                                  rCourseLinesTEMP."Temp School Year" := pNewRec."School Year";
                                  rCourseLinesTEMP.INSERT;
                                UNTIL  rCourseLines.NEXT = 0;
                             END;
                          END;
                          l_StructureEducationCountry.RESET;
                          l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                          l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                          l_StructureEducationCountry.SETRANGE("Sorting ID",
                            fClass.GetNoStructureCountry(pNewRec.Class,pNewRec."School Year")-2);
                          IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                             rCourseLines.RESET;
                             rCourseLines.SETRANGE(Code,pNewRec."Study Plan Code");
                             rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Triennial);
                             rCourseLines.SETRANGE("Schooling Year Begin",l_StructureEducationCountry."Schooling Year");
                             IF rCourseLines.FIND('-') THEN BEGIN
                                REPEAT
                                  rCourseLinesTEMP.INIT;
                                  rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                                  rCourseLinesTEMP."Temp Class" := pNewRec.Class;
                                  rCourseLinesTEMP."Temp School Year" := pNewRec."School Year";
                                  rCourseLinesTEMP.INSERT;
                                UNTIL  rCourseLines.NEXT = 0;
                             END;
                          END;
                          l_StructureEducationCountry.RESET;
                          l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                          l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                          l_StructureEducationCountry.SETRANGE("Sorting ID",
                            fClass.GetNoStructureCountry(pNewRec.Class,pNewRec."School Year")-1);
                          IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                             rCourseLines.RESET;
                             rCourseLines.SETRANGE(Code,pNewRec."Study Plan Code");
                             rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Triennial);
                             rCourseLines.SETRANGE("Schooling Year Begin",l_StructureEducationCountry."Schooling Year");
                             IF rCourseLines.FIND('-') THEN BEGIN
                                REPEAT
                                  rCourseLinesTEMP.INIT;
                                  rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                                  rCourseLinesTEMP."Temp Class" := pNewRec.Class;
                                  rCourseLinesTEMP."Temp School Year" := pNewRec."School Year";
                                  rCourseLinesTEMP.INSERT;
                                UNTIL  rCourseLines.NEXT = 0;
                             END;
                          END;
                    IF rCourseLinesTEMP.FINDSET THEN BEGIN
                      REPEAT
                         rCourseLinesTEMP.CALCFIELDS("Sub-Subject");
                         InsertSubjectCClass(rCourseLinesTEMP,rCourseLinesTEMP,rCourseLinesTEMP."Sub-Subject");

                         l_StudyPlanSubSubjectsLines.RESET;
                         l_StudyPlanSubSubjectsLines.SETRANGE(Type,l_StudyPlanSubSubjectsLines.Type::Course);
                         l_StudyPlanSubSubjectsLines.SETRANGE(Code,rCourseLinesTEMP.Code);
                         l_StudyPlanSubSubjectsLines.SETRANGE("Schooling Year",pNewRec."Schooling Year");
                         IF l_StudyPlanSubSubjectsLines.FINDSET THEN
                           REPEAT
                             InsertSubSubjectCClass(l_StudyPlanSubSubjectsLines,l_StudyPlanSubSubjectsLines);
                           UNTIL l_StudyPlanSubSubjectsLines.NEXT = 0;
                      UNTIL rCourseLinesTEMP.NEXT = 0;
                    END;
                  END
                END;
                */
                if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
                  (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                    l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;

                if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
                  (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                    l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

                l_rMasterTableWEB.Modify;
            end;
        end else
            InsertClass(pNewRec, pOldRec);

    end;

    //[Scope('OnPrem')]
    procedure DeleteClass(pNewRec: Record Class; pOldRec: Record Class)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_StructureEducationCountry: Record "Structure Education Country";
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseLines: Record "Course Lines";
        rCourseLinesTEMP: Record "Course Lines" temporary;
        l_StudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        l_CompanyInformation: Record "Company Information";
        cStudentsRegistration: Codeunit "Students Registration";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Class);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Class);
        //l_rMasterTableWEB.SETRANGE("School Year",pNewRec."School Year");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;

                /*
                //Delete the subjects for this class.
                IF (pOldRec.Type = pOldRec.Type::Simple) AND (pOldRec."Study Plan Code" <> '') THEN BEGIN
                  rStudyPlanLines.RESET;
                  rStudyPlanLines.FILTERGROUP(2);
                  rStudyPlanLines.SETRANGE(Code,pOldRec."Study Plan Code");
                  rStudyPlanLines.SETRANGE("School Year",pOldRec."School Year");
                  rStudyPlanLines.SETRANGE("Schooling Year",pOldRec."Schooling Year");
                  rStudyPlanLines.FILTERGROUP(0);
                  IF rStudyPlanLines.FINDSET THEN BEGIN
                    REPEAT
                         DeleteSubjectPLClass(rStudyPlanLines,rStudyPlanLines);
                         l_StudyPlanSubSubjectsLines.RESET;
                         l_StudyPlanSubSubjectsLines.SETRANGE(Type,l_StudyPlanSubSubjectsLines.Type::"Study Plan");
                         l_StudyPlanSubSubjectsLines.SETRANGE(Code,rStudyPlanLines.Code);
                         l_StudyPlanSubSubjectsLines.SETRANGE("Schooling Year",pOldRec."Schooling Year");
                         IF l_StudyPlanSubSubjectsLines.FINDSET THEN
                           REPEAT
                             DeleteSubSubjectCClass(l_StudyPlanSubSubjectsLines,l_StudyPlanSubSubjectsLines);
                           UNTIL l_StudyPlanSubSubjectsLines.NEXT = 0;

                    UNTIL rStudyPlanLines.NEXT = 0;
                  END;
                END;
                IF (pOldRec.Type = pOldRec.Type::Multi) AND (pOldRec."Study Plan Code" <> '') THEN BEGIN
                  rCourseLinesTEMP.RESET;
                  rCourseLinesTEMP.DELETEALL;
                  //Quadriennal
                  rCourseLines.RESET;
                  rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                  rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Quadriennal);
                  IF rCourseLines.FIND('-') THEN BEGIN
                     REPEAT
                       rCourseLinesTEMP.INIT;
                       rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                       rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                       rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                       rCourseLinesTEMP.INSERT;
                     UNTIL  rCourseLines.NEXT = 0;
                  END;
                  //Anual
                  rCourseLines.RESET;
                  rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                  rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Annual);
                  rCourseLines.SETRANGE("Schooling Year Begin",pOldRec."Schooling Year");
                  IF rCourseLines.FIND('-') THEN BEGIN
                     REPEAT
                       rCourseLinesTEMP.INIT;
                       rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                       rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                       rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                       rCourseLinesTEMP.INSERT;
                     UNTIL  rCourseLines.NEXT = 0;
                  END;
                  //Bienal E Triennal
                  l_StructureEducationCountry.RESET;
                  l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                  l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                  l_StructureEducationCountry.SETRANGE("Schooling Year",pOldRec."Schooling Year");
                  IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                        rCourseLines.RESET;
                        rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                        rCourseLines.SETFILTER("Characterise Subjects",'%1|%2',rCourseLines."Characterise Subjects"::Biennial,
                        rCourseLines."Characterise Subjects"::Triennial);
                        rCourseLines.SETRANGE("Schooling Year Begin",pOldRec."Schooling Year");
                        IF rCourseLines.FIND('-') THEN BEGIN
                           REPEAT
                             rCourseLinesTEMP.INIT;
                             rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                             rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                             rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                             rCourseLinesTEMP.INSERT;
                           UNTIL  rCourseLines.NEXT = 0;
                        END;
                         //ELSE BEGIN
                          l_StructureEducationCountry.RESET;
                          l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                          l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                          l_StructureEducationCountry.SETRANGE("Sorting ID",
                            fClass.GetNoStructureCountry(pNewRec.Class,pOldRec."School Year")-1);
                          IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                             rCourseLines.RESET;
                             rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                             rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Biennial);
                             rCourseLines.SETRANGE("Schooling Year Begin",l_StructureEducationCountry."Schooling Year");
                             IF rCourseLines.FIND('-') THEN BEGIN
                                REPEAT
                                  rCourseLinesTEMP.INIT;
                                  rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                                  rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                                  rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                                  rCourseLinesTEMP.INSERT;
                                UNTIL  rCourseLines.NEXT = 0;
                             END;
                          END;
                          l_StructureEducationCountry.RESET;
                          l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                          l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                          l_StructureEducationCountry.SETRANGE("Sorting ID",
                            fClass.GetNoStructureCountry(pNewRec.Class,pOldRec."School Year")-2);
                          IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                             rCourseLines.RESET;
                             rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                             rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Triennial);
                             rCourseLines.SETRANGE("Schooling Year Begin",l_StructureEducationCountry."Schooling Year");
                             IF rCourseLines.FIND('-') THEN BEGIN
                                REPEAT
                                  rCourseLinesTEMP.INIT;
                                  rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                                  rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                                  rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                                  rCourseLinesTEMP.INSERT;
                                UNTIL  rCourseLines.NEXT = 0;
                             END;
                          END;
                          l_StructureEducationCountry.RESET;
                          l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                          l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                          l_StructureEducationCountry.SETRANGE("Sorting ID",
                            fClass.GetNoStructureCountry(pNewRec.Class,pOldRec."School Year")-1);
                          IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                             rCourseLines.RESET;
                             rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                             rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Triennial);
                             rCourseLines.SETRANGE("Schooling Year Begin",l_StructureEducationCountry."Schooling Year");
                             IF rCourseLines.FIND('-') THEN BEGIN
                                REPEAT
                                  rCourseLinesTEMP.INIT;
                                  rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                                  rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                                  rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                                  rCourseLinesTEMP.INSERT;
                                UNTIL  rCourseLines.NEXT = 0;
                             END;
                          END;
                    IF rCourseLinesTEMP.FINDSET THEN BEGIN
                      REPEAT
                         DeleteSubjectCClass(rCourseLinesTEMP,rCourseLinesTEMP);

                         l_StudyPlanSubSubjectsLines.RESET;
                         l_StudyPlanSubSubjectsLines.SETRANGE(Type,l_StudyPlanSubSubjectsLines.Type::Course);
                         l_StudyPlanSubSubjectsLines.SETRANGE(Code,rCourseLinesTEMP.Code);
                         l_StudyPlanSubSubjectsLines.SETRANGE("Schooling Year",pOldRec."Schooling Year");
                         IF l_StudyPlanSubSubjectsLines.FINDSET THEN
                           REPEAT
                             DeleteSubSubjectCClass(l_StudyPlanSubSubjectsLines,l_StudyPlanSubSubjectsLines);
                           UNTIL l_StudyPlanSubSubjectsLines.NEXT = 0;
                      UNTIL rCourseLinesTEMP.NEXT = 0;
                    END;
                  END
                END;
                */
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
                /*
                //Delete the subjects for this class.
                IF (pOldRec.Type = pOldRec.Type::Simple) AND (pOldRec."Study Plan Code" <> '') THEN BEGIN
                  rStudyPlanLines.RESET;
                  rStudyPlanLines.FILTERGROUP(2);
                  rStudyPlanLines.SETRANGE(Code,pOldRec."Study Plan Code");
                  rStudyPlanLines.SETRANGE("School Year",pOldRec."School Year");
                  rStudyPlanLines.SETRANGE("Schooling Year",pOldRec."Schooling Year");
                  rStudyPlanLines.FILTERGROUP(0);
                  IF rStudyPlanLines.FINDSET THEN BEGIN
                    REPEAT
                         DeleteSubjectPLClass(rStudyPlanLines,rStudyPlanLines);
                         l_StudyPlanSubSubjectsLines.RESET;
                         l_StudyPlanSubSubjectsLines.SETRANGE(Type,l_StudyPlanSubSubjectsLines.Type::"Study Plan");
                         l_StudyPlanSubSubjectsLines.SETRANGE(Code,rStudyPlanLines.Code);
                         l_StudyPlanSubSubjectsLines.SETRANGE("Schooling Year",pOldRec."Schooling Year");
                         IF l_StudyPlanSubSubjectsLines.FINDSET THEN
                           REPEAT
                             DeleteSubSubjectCClass(l_StudyPlanSubSubjectsLines,l_StudyPlanSubSubjectsLines);
                           UNTIL l_StudyPlanSubSubjectsLines.NEXT = 0;

                    UNTIL rStudyPlanLines.NEXT = 0;
                  END;
                END;
                IF (pOldRec.Type = pOldRec.Type::Multi) AND (pOldRec."Study Plan Code" <> '') THEN BEGIN
                  rCourseLinesTEMP.RESET;
                  rCourseLinesTEMP.DELETEALL;
                  //Quadriennal
                  rCourseLines.RESET;
                  rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                  rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Quadriennal);
                  IF rCourseLines.FIND('-') THEN BEGIN
                     REPEAT
                       rCourseLinesTEMP.INIT;
                       rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                       rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                       rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                       rCourseLinesTEMP.INSERT;
                     UNTIL  rCourseLines.NEXT = 0;
                  END;
                  //Anual
                  rCourseLines.RESET;
                  rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                  rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Annual);
                  rCourseLines.SETRANGE("Schooling Year Begin",pOldRec."Schooling Year");
                  IF rCourseLines.FIND('-') THEN BEGIN
                     REPEAT
                       rCourseLinesTEMP.INIT;
                       rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                       rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                       rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                       rCourseLinesTEMP.INSERT;
                     UNTIL  rCourseLines.NEXT = 0;
                  END;
                  //Bienal E Triennal
                  l_StructureEducationCountry.RESET;
                  l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                  l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                  l_StructureEducationCountry.SETRANGE("Schooling Year",pOldRec."Schooling Year");
                  IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                        rCourseLines.RESET;
                        rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                        rCourseLines.SETFILTER("Characterise Subjects",'%1|%2',rCourseLines."Characterise Subjects"::Biennial,
                        rCourseLines."Characterise Subjects"::Triennial);
                        rCourseLines.SETRANGE("Schooling Year Begin",pOldRec."Schooling Year");
                        IF rCourseLines.FIND('-') THEN BEGIN
                           REPEAT
                             rCourseLinesTEMP.INIT;
                             rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                             rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                             rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                             rCourseLinesTEMP.INSERT;
                           UNTIL  rCourseLines.NEXT = 0;
                        END;
                         //ELSE BEGIN
                          l_StructureEducationCountry.RESET;
                          l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                          l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                          l_StructureEducationCountry.SETRANGE("Sorting ID",
                            fClass.GetNoStructureCountry(pNewRec.Class,pOldRec."School Year")-1);
                          IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                             rCourseLines.RESET;
                             rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                             rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Biennial);
                             rCourseLines.SETRANGE("Schooling Year Begin",l_StructureEducationCountry."Schooling Year");
                             IF rCourseLines.FIND('-') THEN BEGIN
                                REPEAT
                                  rCourseLinesTEMP.INIT;
                                  rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                                  rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                                  rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                                  rCourseLinesTEMP.INSERT;
                                UNTIL  rCourseLines.NEXT = 0;
                             END;
                          END;
                          l_StructureEducationCountry.RESET;
                          l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                          l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                          l_StructureEducationCountry.SETRANGE("Sorting ID",
                            fClass.GetNoStructureCountry(pNewRec.Class,pOldRec."School Year")-2);
                          IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                             rCourseLines.RESET;
                             rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                             rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Triennial);
                             rCourseLines.SETRANGE("Schooling Year Begin",l_StructureEducationCountry."Schooling Year");
                             IF rCourseLines.FIND('-') THEN BEGIN
                                REPEAT
                                  rCourseLinesTEMP.INIT;
                                  rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                                  rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                                  rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                                  rCourseLinesTEMP.INSERT;
                                UNTIL  rCourseLines.NEXT = 0;
                             END;
                          END;
                          l_StructureEducationCountry.RESET;
                          l_StructureEducationCountry.SETRANGE(Country,cStudentsRegistration.GetCountry);
                          l_StructureEducationCountry.SETRANGE(Type,l_StructureEducationCountry.Type::Multi);
                          l_StructureEducationCountry.SETRANGE("Sorting ID",
                            fClass.GetNoStructureCountry(pNewRec.Class,pOldRec."School Year")-1);
                          IF l_StructureEducationCountry.FIND('-') THEN BEGIN
                             rCourseLines.RESET;
                             rCourseLines.SETRANGE(Code,pOldRec."Study Plan Code");
                             rCourseLines.SETRANGE("Characterise Subjects",rCourseLines."Characterise Subjects"::Triennial);
                             rCourseLines.SETRANGE("Schooling Year Begin",l_StructureEducationCountry."Schooling Year");
                             IF rCourseLines.FIND('-') THEN BEGIN
                                REPEAT
                                  rCourseLinesTEMP.INIT;
                                  rCourseLinesTEMP.TRANSFERFIELDS(rCourseLines);
                                  rCourseLinesTEMP."Temp Class" := pOldRec.Class;
                                  rCourseLinesTEMP."Temp School Year" := pOldRec."School Year";
                                  rCourseLinesTEMP.INSERT;
                                UNTIL  rCourseLines.NEXT = 0;
                             END;
                          END;
                    IF rCourseLinesTEMP.FINDSET THEN BEGIN
                      REPEAT
                         DeleteSubjectCClass(rCourseLinesTEMP,rCourseLinesTEMP);

                         l_StudyPlanSubSubjectsLines.RESET;
                         l_StudyPlanSubSubjectsLines.SETRANGE(Type,l_StudyPlanSubSubjectsLines.Type::Course);
                         l_StudyPlanSubSubjectsLines.SETRANGE(Code,rCourseLinesTEMP.Code);
                         l_StudyPlanSubSubjectsLines.SETRANGE("Schooling Year",pOldRec."Schooling Year");
                         IF l_StudyPlanSubSubjectsLines.FINDSET THEN
                           REPEAT
                             DeleteSubSubjectCClass(l_StudyPlanSubSubjectsLines,l_StudyPlanSubSubjectsLines);
                           UNTIL l_StudyPlanSubSubjectsLines.NEXT = 0;
                      UNTIL rCourseLinesTEMP.NEXT = 0;
                    END;
                  END
                END;
               */
            end;
        end;

    end;

    //[Scope('OnPrem')]
    procedure InsertTeacherClass(pNewRec: Record "Teacher Class"; pOldRec: Record "Teacher Class")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_StructureEducationCountry: Record "Structure Education Country";
        l_vEntryNo: Integer;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::TeacherClass);
        l_rMasterTableWEB.SetRange(Typew, pNewRec."User Type");
        l_rMasterTableWEB.SetRange(Codew, pNewRec.User);
        l_rMasterTableWEB.SetRange(LineNow, pNewRec."Line No.");
        if not l_rMasterTableWEB.FindSet then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT.LineNow := pNewRec."Line No.";
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::TeacherClass;
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.Codew := pNewRec.User;
            l_rMasterTableWEBINSERT."School Year" := pNewRec."School Year";
            l_rMasterTableWEBINSERT.Description := pNewRec."Full Name";
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT."Responsibility Center" := pNewRec."Responsibility Center";
            l_rMasterTableWEBINSERT."Type Education" := pNewRec.Type;
            l_rMasterTableWEBINSERT.Class := pNewRec.Class;
            l_rMasterTableWEBINSERT."Type Subject" := pNewRec."Type Subject";
            l_rMasterTableWEBINSERT."Subject Code" := pNewRec."Subject Code";
            l_rMasterTableWEBINSERT."Subject Group" := pNewRec."Subject Group";
            l_rMasterTableWEBINSERT."Subject Description" := pNewRec."Subject Description";
            l_rMasterTableWEBINSERT."Sub-Subject Code" := pNewRec."Sub-Subject Code";
            l_rMasterTableWEBINSERT."Sub-Subject Description" := pNewRec."Sub-Subject Description";
            l_rMasterTableWEBINSERT."Schooling Year" := pNewRec."Schooling Year";
            l_rMasterTableWEBINSERT.Turn := pNewRec.Turn;
            l_rMasterTableWEBINSERT."Allow Assign Evaluations" := pNewRec."Allow Assign Evaluations";
            l_rMasterTableWEBINSERT."Allow Calc. Final Assess." := pNewRec."Allow Calc. Final Assess.";
            l_rMasterTableWEBINSERT."Allow Stu. Global Observations" := pNewRec."Allow Stu. Global Observations";
            l_rMasterTableWEBINSERT."Allow Assign Incidence" := pNewRec."Allow Assign Incidence";
            l_rMasterTableWEBINSERT."Allow Justify Incidence" := pNewRec."Allow Justify Incidence";
            l_rMasterTableWEBINSERT."Allow Summary" := pNewRec."Allow Summary";
            l_rMasterTableWEBINSERT.Insert;
        end else
            ModifyTeacherClass(pNewRec, pOldRec);
    end;

    //[Scope('OnPrem')]
    procedure ModifyTeacherClass(pNewRec: Record "Teacher Class"; pOldRec: Record "Teacher Class")
    var
        l_StructureEducationCountry: Record "Structure Education Country";
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::TeacherClass);
        l_rMasterTableWEB.SetRange(Typew, pNewRec."User Type");
        l_rMasterTableWEB.SetRange(Codew, pNewRec.User);
        l_rMasterTableWEB.SetRange(LineNow, pNewRec."Line No.");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            l_rMasterTableWEB.LineNow := pNewRec."Line No.";
            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB.Codew := pNewRec.User;
            l_rMasterTableWEB."School Year" := pNewRec."School Year";
            l_rMasterTableWEB.Description := pNewRec."Full Name";
            l_rMasterTableWEB.Company := CompanyName;
            l_rMasterTableWEB."Responsibility Center" := pNewRec."Responsibility Center";
            l_rMasterTableWEB."Type Education" := pNewRec.Type;
            l_rMasterTableWEB.Class := pNewRec.Class;
            l_rMasterTableWEB."Type Subject" := pNewRec."Type Subject";
            l_rMasterTableWEB."Subject Code" := pNewRec."Subject Code";
            l_rMasterTableWEB."Subject Group" := pNewRec."Subject Group";
            l_rMasterTableWEB."Subject Description" := pNewRec."Subject Description";
            l_rMasterTableWEB."Sub-Subject Code" := pNewRec."Sub-Subject Code";
            l_rMasterTableWEB."Sub-Subject Description" := pNewRec."Sub-Subject Description";
            l_rMasterTableWEB."Schooling Year" := pNewRec."Schooling Year";
            l_rMasterTableWEB.Turn := pNewRec.Turn;
            l_rMasterTableWEB."Allow Assign Evaluations" := pNewRec."Allow Assign Evaluations";
            l_rMasterTableWEB."Allow Calc. Final Assess." := pNewRec."Allow Calc. Final Assess.";
            l_rMasterTableWEB."Allow Stu. Global Observations" := pNewRec."Allow Stu. Global Observations";
            l_rMasterTableWEB."Allow Assign Incidence" := pNewRec."Allow Assign Incidence";
            l_rMasterTableWEB."Allow Justify Incidence" := pNewRec."Allow Justify Incidence";
            l_rMasterTableWEB."Allow Summary" := pNewRec."Allow Summary";

            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;

            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB.Modify;
        end else
            InsertTeacherClass(pNewRec, pOldRec);
    end;

    //[Scope('OnPrem')]
    procedure DeleteTeacherClass(pNewRec: Record "Teacher Class"; pOldRec: Record "Teacher Class")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::TeacherClass);
        l_rMasterTableWEB.SetRange(Typew, pNewRec."User Type");
        l_rMasterTableWEB.SetRange(Codew, pNewRec.User);
        l_rMasterTableWEB.SetRange(LineNow, pNewRec."Line No.");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyEntityStudent(pNewRec: Record "Users Family / Students"; pOldRec: Record "Users Family / Students")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_Students: Record Students;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        if (pOldRec."Education Head" and not pNewRec."Education Head") or (pNewRec."No." <> pOldRec."No.") then begin
            DeleteEntityStudent(pOldRec, pOldRec);
        end;

        if not pOldRec."Education Head" and pNewRec."Education Head" then begin
            if pNewRec."Use WEB" then begin
                Clear(l_rMasterTableWEB);
                l_rMasterTableWEB.Init;
                l_rMasterTableWEB."Table Type" := l_rMasterTableWEB."Table Type"::EntityStudent;
                l_Students.Get(pNewRec."Student Code No.");
                l_rMasterTableWEB."Posting Time" := Time;
                l_rMasterTableWEB.Codew := pNewRec."No.";
                l_rMasterTableWEB.Company := CompanyName;
                l_rMasterTableWEB."Responsibility Center" := l_Students."Responsibility Center";
                l_rMasterTableWEB.StudentNo := pNewRec."Student Code No.";

                if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
                  (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                    l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Insert;

                if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
                  (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                    l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Insert;
                l_rMasterTableWEB.Insert;
            end;
        end;

        if pOldRec."Education Head" and pNewRec."Education Head" then begin
            l_rMasterTableWEB.Reset;
            l_rMasterTableWEB.SetRange(Codew, pNewRec."No.");
            l_rMasterTableWEB.SetRange("Responsibility Center", l_Students."Responsibility Center");
            l_rMasterTableWEB.SetRange(StudentNo, pNewRec."Student Code No.");
            if l_rMasterTableWEB.FindSet(true, true) then begin
                l_rMasterTableWEB."Table Type" := l_rMasterTableWEB."Table Type"::EntityStudent;
                l_Students.Get(pNewRec."Student Code No.");
                l_rMasterTableWEB."Posting Time" := Time;
                l_rMasterTableWEB.Codew := pNewRec."No.";
                l_rMasterTableWEB.Company := CompanyName;
                l_rMasterTableWEB."Responsibility Center" := l_Students."Responsibility Center";
                l_rMasterTableWEB.StudentNo := pNewRec."Student Code No.";

                if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
                  (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                    l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;

                if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
                  (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                    l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;
                l_rMasterTableWEB.Modify;
            end else begin
                if pNewRec."Use WEB" then begin
                    Clear(l_rMasterTableWEB);
                    l_rMasterTableWEB.Init;
                    l_rMasterTableWEB."Table Type" := l_rMasterTableWEB."Table Type"::EntityStudent;
                    l_Students.Get(pNewRec."Student Code No.");
                    l_rMasterTableWEB."Posting Time" := Time;
                    l_rMasterTableWEB.Codew := pNewRec."No.";
                    l_rMasterTableWEB.Company := CompanyName;
                    l_rMasterTableWEB."Responsibility Center" := l_Students."Responsibility Center";
                    l_rMasterTableWEB.StudentNo := pNewRec."Student Code No.";

                    if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
                      (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                        l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Insert;

                    if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
                      (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                        l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Insert;
                    l_rMasterTableWEB.Insert;
                end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteEntityStudent(pNewRec: Record "Users Family / Students"; pOldRec: Record "Users Family / Students")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;
        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::EntityStudent);
        l_rMasterTableWEB.SetRange(Codew, pNewRec."No.");
        l_rMasterTableWEB.SetRange(StudentNo, pNewRec."Student Code No.");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertSubjectPLClass(pNewRec: Record "Study Plan Lines"; pOldRec: Record "Study Plan Lines"; pSubSubjects: Boolean)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_GroupSubjects: Record "Group Subjects";
        l_cStudentsRegistration: Codeunit "Students Registration";
        l_vEntryNo: Integer;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        if pNewRec."Subject Code" = '' then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Subjects);
        l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEB."Type Education"::Simple);
        l_rMasterTableWEB.SetRange(StudyPlanCode, pNewRec.Code);
        l_rMasterTableWEB.SetRange("Subject Code", pNewRec."Subject Code");
        l_rMasterTableWEB.SetRange("Sub-Subject Code", '');
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::Subjects;
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT."School Year" := pNewRec."School Year";
            l_rMasterTableWEBINSERT.StudyPlanCode := pNewRec.Code;
            l_rMasterTableWEBINSERT."Type Education" := l_rMasterTableWEBINSERT."Type Education"::Simple;
            l_rMasterTableWEBINSERT."Subject Code" := pNewRec."Subject Code";
            l_rMasterTableWEBINSERT."Sub-Subject Code" := '';
            l_rMasterTableWEBINSERT."Sub-Subject Description" := pNewRec."Subject Description";
            l_rMasterTableWEBINSERT."Incidence Observations" := pNewRec.Observations;
            l_rMasterTableWEBINSERT."Subject Group" := pNewRec."Option Group";
            l_rMasterTableWEBINSERT."Sorting ID" := pNewRec."Sorting ID";
            l_rMasterTableWEBINSERT.Description := pNewRec."Report Descripton";
            l_rMasterTableWEBINSERT.ClassificationLevelCode := pNewRec."Assessment Code";
            l_rMasterTableWEBINSERT.EvaluationType := pNewRec."Evaluation Type";
            l_rMasterTableWEBINSERT.HaveSubSubject := pSubSubjects;
            l_rMasterTableWEBINSERT.Insert;
        end else begin
            l_rMasterTableWEB."Table Type" := l_rMasterTableWEB."Table Type"::Subjects;
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;
            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB.Company := CompanyName;
            l_rMasterTableWEB."School Year" := pNewRec."School Year";
            l_rMasterTableWEB.StudyPlanCode := pNewRec.Code;
            l_rMasterTableWEB."Type Education" := l_rMasterTableWEB."Type Education"::Simple;
            l_rMasterTableWEB."Subject Code" := pNewRec."Subject Code";
            l_rMasterTableWEB."Sub-Subject Code" := '';
            l_rMasterTableWEB."Sub-Subject Description" := pNewRec."Subject Description";
            l_rMasterTableWEB."Incidence Observations" := pNewRec.Observations;
            l_rMasterTableWEB."Subject Group" := pNewRec."Option Group";
            l_rMasterTableWEB."Sorting ID" := pNewRec."Sorting ID";
            l_rMasterTableWEB.Description := pNewRec."Report Descripton";
            l_rMasterTableWEB.ClassificationLevelCode := pNewRec."Assessment Code";
            l_rMasterTableWEB.EvaluationType := pNewRec."Evaluation Type";
            l_rMasterTableWEB.HaveSubSubject := pSubSubjects;
            l_rMasterTableWEB.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteSubjectPLClass(pNewRec: Record "Study Plan Lines"; pOldRec: Record "Study Plan Lines")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_Class: Record Class;
        l_GroupSubjects: Record "Group Subjects";
        l_cStudentsRegistration: Codeunit "Students Registration";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;
        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Subjects);
        l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEB."Type Education"::Simple);
        l_rMasterTableWEB.SetRange(StudyPlanCode, pNewRec.Code);
        l_rMasterTableWEB.SetRange("Subject Code", pNewRec."Subject Code");
        l_rMasterTableWEB.SetRange("Sub-Subject Code", '');
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                if (l_rMasterTableWEB."Action Type" <> l_rMasterTableWEB."Action Type"::Insert) then
                    l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                if (l_rMasterTableWEB."Action Type 2" <> l_rMasterTableWEB."Action Type 2"::Insert) then
                    l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertSubjectCClass(pNewRec: Record "Course Lines"; pOldRec: Record "Course Lines"; pSubSubjects: Boolean)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_GroupSubjects: Record "Group Subjects";
        l_cStudentsRegistration: Codeunit "Students Registration";
        l_vEntryNo: Integer;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        if pNewRec."Subject Code" = '' then
            exit;
        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Subjects);
        l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEB."Type Education"::Multi);
        l_rMasterTableWEB.SetRange(StudyPlanCode, pNewRec.Code);
        l_rMasterTableWEB.SetRange("Subject Code", pNewRec."Subject Code");
        l_rMasterTableWEB.SetRange("Sub-Subject Code", '');
        l_rMasterTableWEB.SetRange(LineNow, pNewRec."Line No.");
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::Subjects;
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT."School Year" := '';
            l_rMasterTableWEBINSERT.StudyPlanCode := pNewRec.Code;
            l_rMasterTableWEBINSERT."Type Education" := l_rMasterTableWEBINSERT."Type Education"::Multi;
            l_rMasterTableWEBINSERT."Subject Code" := pNewRec."Subject Code";
            l_rMasterTableWEBINSERT."Sub-Subject Code" := '';
            l_rMasterTableWEBINSERT."Sub-Subject Description" := pNewRec."Subject Description";
            l_rMasterTableWEBINSERT."Incidence Observations" := pNewRec.Observations;
            l_rMasterTableWEBINSERT."Subject Group" := pNewRec."Option Group";
            l_rMasterTableWEBINSERT."Sorting ID" := pNewRec."Sorting ID";
            l_rMasterTableWEBINSERT.Description := pNewRec."Report Descripton";
            l_rMasterTableWEBINSERT.ClassificationLevelCode := pNewRec."Assessment Code";
            l_rMasterTableWEBINSERT.EvaluationType := pNewRec."Evaluation Type";
            l_rMasterTableWEBINSERT.HaveSubSubject := pSubSubjects;
            l_rMasterTableWEBINSERT.LineNow := pNewRec."Line No.";
            l_rMasterTableWEBINSERT.Insert;
        end else begin
            l_rMasterTableWEB."Table Type" := l_rMasterTableWEB."Table Type"::Subjects;
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;
            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB.Company := CompanyName;
            l_rMasterTableWEB."School Year" := '';
            l_rMasterTableWEB.StudyPlanCode := pNewRec.Code;
            l_rMasterTableWEB."Type Education" := l_rMasterTableWEB."Type Education"::Multi;
            l_rMasterTableWEB."Subject Code" := pNewRec."Subject Code";
            l_rMasterTableWEB."Sub-Subject Code" := '';
            l_rMasterTableWEB."Sub-Subject Description" := pNewRec."Subject Description";
            l_rMasterTableWEB."Incidence Observations" := pNewRec.Observations;
            l_rMasterTableWEB."Subject Group" := pNewRec."Option Group";
            l_rMasterTableWEB."Sorting ID" := pNewRec."Sorting ID";
            l_rMasterTableWEB.Description := pNewRec."Report Descripton";
            l_rMasterTableWEB.ClassificationLevelCode := pNewRec."Assessment Code";
            l_rMasterTableWEB.EvaluationType := pNewRec."Evaluation Type";
            l_rMasterTableWEB.HaveSubSubject := pSubSubjects;
            l_rMasterTableWEB.LineNow := pNewRec."Line No.";
            l_rMasterTableWEB.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteSubjectCClass(pNewRec: Record "Course Lines"; pOldRec: Record "Course Lines")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_Class: Record Class;
        l_GroupSubjects: Record "Group Subjects";
        l_cStudentsRegistration: Codeunit "Students Registration";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;
        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Subjects);
        l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEB."Type Education"::Multi);
        l_rMasterTableWEB.SetRange(StudyPlanCode, pNewRec.Code);
        l_rMasterTableWEB.SetRange("Subject Code", pNewRec."Subject Code");
        l_rMasterTableWEB.SetRange("Sub-Subject Code", '');
        l_rMasterTableWEB.SetRange(LineNow, pNewRec."Line No.");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                if (l_rMasterTableWEB."Action Type" <> l_rMasterTableWEB."Action Type"::Insert) then
                    l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                if (l_rMasterTableWEB."Action Type 2" <> l_rMasterTableWEB."Action Type 2"::Insert) then
                    l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertSubSubjectCClass(pNewRec: Record "Study Plan Sub-Subjects Lines"; pOldRec: Record "Study Plan Sub-Subjects Lines")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_StudyPlanLines: Record "Study Plan Lines";
        l_CourseLines: Record "Course Lines";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;
        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Subjects);
        l_rMasterTableWEB.SetRange("Type Education", pNewRec.Type);
        l_rMasterTableWEB.SetRange(StudyPlanCode, pNewRec.Code);
        l_rMasterTableWEB.SetRange("Subject Code", pNewRec."Subject Code");
        l_rMasterTableWEB.SetRange("Sub-Subject Code", pNewRec."Sub-Subject Code");
        l_rMasterTableWEB.SetRange(SchoolingYear, pNewRec."Schooling Year");
        l_rMasterTableWEB.SetRange(LineNow, pNewRec."Line No.");
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::Subjects;
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.Company := CompanyName;
            if pNewRec.Type = pNewRec.Type::"Study Plan" then
                l_rMasterTableWEBINSERT."School Year" := pNewRec."School Year"
            else
                l_rMasterTableWEBINSERT."School Year" := '';
            l_rMasterTableWEBINSERT.StudyPlanCode := pNewRec.Code;
            l_rMasterTableWEBINSERT."Type Education" := pNewRec.Type;
            l_rMasterTableWEBINSERT.SchoolingYear := pNewRec."Schooling Year";
            l_rMasterTableWEBINSERT.LineNow := pNewRec."Line No.";
            l_rMasterTableWEBINSERT."Subject Code" := pNewRec."Subject Code";
            l_rMasterTableWEBINSERT."Sub-Subject Code" := pNewRec."Sub-Subject Code";
            l_rMasterTableWEBINSERT."Sub-Subject Description" := pNewRec."Sub-Subject Description";
            l_rMasterTableWEBINSERT."Incidence Observations" := pNewRec.Observations;
            l_rMasterTableWEBINSERT."Subject Group" := pNewRec."Option Group";
            l_rMasterTableWEBINSERT."Sorting ID" := pNewRec."Sorting ID";
            l_rMasterTableWEBINSERT.Description := pNewRec."Report Description";
            l_rMasterTableWEBINSERT.ClassificationLevelCode := pNewRec."Assessment Code";
            l_rMasterTableWEBINSERT.EvaluationType := pNewRec."Evaluation Type";
            l_rMasterTableWEBINSERT.Insert;
        end else begin
            l_rMasterTableWEB."Table Type" := l_rMasterTableWEB."Table Type"::Subjects;
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;
            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB.Company := CompanyName;
            if pNewRec.Type = pNewRec.Type::"Study Plan" then
                l_rMasterTableWEB."School Year" := pNewRec."School Year"
            else
                l_rMasterTableWEB."School Year" := '';
            l_rMasterTableWEB.LineNow := pNewRec."Line No.";
            l_rMasterTableWEB.SchoolingYear := pNewRec."Schooling Year";
            l_rMasterTableWEB.StudyPlanCode := pNewRec.Code;
            l_rMasterTableWEB."Type Education" := pNewRec.Type;
            l_rMasterTableWEB."Subject Code" := pNewRec."Subject Code";
            l_rMasterTableWEB."Sub-Subject Code" := pNewRec."Sub-Subject Code";
            l_rMasterTableWEB."Sub-Subject Description" := pNewRec."Sub-Subject Description";
            l_rMasterTableWEB."Incidence Observations" := pNewRec.Observations;
            l_rMasterTableWEB."Subject Group" := pNewRec."Option Group";
            l_rMasterTableWEB."Sorting ID" := pNewRec."Sorting ID";
            l_rMasterTableWEB.Description := pNewRec."Report Description";
            l_rMasterTableWEB.ClassificationLevelCode := pNewRec."Assessment Code";
            l_rMasterTableWEB.EvaluationType := pNewRec."Evaluation Type";
            l_rMasterTableWEB.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteSubSubjectCClass(pNewRec: Record "Study Plan Sub-Subjects Lines"; pOldRec: Record "Study Plan Sub-Subjects Lines")
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_Class: Record Class;
        l_GroupSubjects: Record "Group Subjects";
        l_cStudentsRegistration: Codeunit "Students Registration";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;
        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Subjects);
        l_rMasterTableWEB.SetRange("Type Education", pNewRec.Type);
        l_rMasterTableWEB.SetRange(StudyPlanCode, pNewRec.Code);
        l_rMasterTableWEB.SetRange("Subject Code", pNewRec."Subject Code");
        l_rMasterTableWEB.SetRange("Sub-Subject Code", pNewRec."Sub-Subject Code");
        l_rMasterTableWEB.SetRange(SchoolingYear, pNewRec."Schooling Year");
        l_rMasterTableWEB.SetRange(LineNow, pNewRec."Line No.");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                if (l_rMasterTableWEB."Action Type" <> l_rMasterTableWEB."Action Type"::Insert) then
                    l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                if (l_rMasterTableWEB."Action Type 2" <> l_rMasterTableWEB."Action Type 2"::Insert) then
                    l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertTurn(pNewRec: Record Turn)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_vEntryNo: Integer;
        l_CuStudentsRegistration: Codeunit "Students Registration";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Turn);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        l_rMasterTableWEB.SetRange("School Year", l_CuStudentsRegistration.GetShoolYearActive);
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::Turn;
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.Codew := pNewRec.Code;
            l_rMasterTableWEBINSERT."School Year" := l_CuStudentsRegistration.GetShoolYearActive;
            l_rMasterTableWEBINSERT.Description := pNewRec.Description;
            l_rMasterTableWEBINSERT."Responsibility Center" := pNewRec."Responsibility Center";
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT.Insert;
        end else begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB.Codew := pNewRec.Code;
            l_rMasterTableWEB."School Year" := l_CuStudentsRegistration.GetShoolYearActive;
            l_rMasterTableWEB.Description := pNewRec.Description;
            l_rMasterTableWEBINSERT."Responsibility Center" := pNewRec."Responsibility Center";
            l_rMasterTableWEB.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyTurn(pNewRec: Record Turn)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_CuStudentsRegistration: Codeunit "Students Registration";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Turn);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        l_rMasterTableWEB.SetRange("School Year", l_CuStudentsRegistration.GetShoolYearActive);
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB."School Year" := l_CuStudentsRegistration.GetShoolYearActive;
            l_rMasterTableWEB.Codew := pNewRec.Code;
            l_rMasterTableWEB.Description := pNewRec.Description;
            l_rMasterTableWEB.Modify;
        end else begin
            InsertTurn(pNewRec);
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteTurn(pNewRec: Record Turn)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_CuStudentsRegistration: Codeunit "Students Registration";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Turn);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        l_rMasterTableWEB.SetRange("School Year", l_CuStudentsRegistration.GetShoolYearActive);
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertAnnotations(pNewRec: Record Annotation; pOldRec: Record Annotation)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_rMasterTableWEBINSERT: Record MasterTableWEB;
        l_vEntryNo: Integer;
        l_AnnotationType: Integer;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        //Observation type (For Annotation is 4)
        l_AnnotationType := 4;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Annotations);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        l_rMasterTableWEB.SetRange(Typew, l_AnnotationType);
        l_rMasterTableWEB.SetRange(LineNow, pNewRec."Line No.");
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        if not l_rMasterTableWEB.FindSet(true, true) then begin
            Clear(l_rMasterTableWEBINSERT);
            l_rMasterTableWEBINSERT.Init;
            l_rMasterTableWEBINSERT."Table Type" := l_rMasterTableWEBINSERT."Table Type"::Annotations;
            l_rMasterTableWEBINSERT."Action Type" := l_rMasterTableWEBINSERT."Action Type"::Insert;
            l_rMasterTableWEBINSERT."Action Type 2" := l_rMasterTableWEBINSERT."Action Type 2"::Insert;
            l_rMasterTableWEBINSERT."Posting Date" := Today;
            l_rMasterTableWEBINSERT."Posting Time" := Time;
            l_rMasterTableWEBINSERT.Typew := l_AnnotationType;
            l_rMasterTableWEBINSERT.Codew := pNewRec.Code;
            l_rMasterTableWEBINSERT."School Year" := pNewRec."School Year";
            l_rMasterTableWEBINSERT.LineNow := pNewRec."Line No.";
            l_rMasterTableWEBINSERT.Description := pNewRec.Description;
            l_rMasterTableWEBINSERT.DescriptionMale := pNewRec."Annotation Description";
            l_rMasterTableWEBINSERT.Company := CompanyName;
            l_rMasterTableWEBINSERT.Insert;
        end else begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB."Posting Date" := Today;
            l_rMasterTableWEB."Posting Time" := Time;
            l_rMasterTableWEB.Typew := l_AnnotationType;
            l_rMasterTableWEB.Codew := pNewRec.Code;
            l_rMasterTableWEB."School Year" := pNewRec."School Year";
            l_rMasterTableWEB.LineNow := pNewRec."Line No.";
            l_rMasterTableWEB.Description := pNewRec.Description;
            l_rMasterTableWEB.DescriptionMale := pNewRec."Annotation Description";
            l_rMasterTableWEB.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyAnnotations(pNewRec: Record Annotation; pOldRec: Record Annotation)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_AnnotationType: Integer;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        //Observation type (For Annotation is 4)
        l_AnnotationType := 4;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Annotations);
        l_rMasterTableWEB.SetRange(Typew, l_AnnotationType);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        l_rMasterTableWEB.SetRange(LineNow, pNewRec."Line No.");
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
              (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;
            if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

            l_rMasterTableWEB."School Year" := pNewRec."School Year";
            l_rMasterTableWEB.Typew := l_AnnotationType;
            l_rMasterTableWEB.Codew := pNewRec.Code;
            l_rMasterTableWEB.LineNow := pNewRec."Line No.";
            l_rMasterTableWEB.Description := pNewRec.Description;
            l_rMasterTableWEB.DescriptionMale := pNewRec."Annotation Description";
            l_rMasterTableWEB.Modify;
        end else begin
            InsertAnnotations(pNewRec, pOldRec);
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteAnnotations(pNewRec: Record Annotation; pOldRec: Record Annotation)
    var
        l_rMasterTableWEB: Record MasterTableWEB;
        l_AnnotationType: Integer;
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        //Observation type (For Annotation is 4)
        l_AnnotationType := 4;

        l_rMasterTableWEB.Reset;
        l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Annotations);
        l_rMasterTableWEB.SetRange(Codew, pNewRec.Code);
        l_rMasterTableWEB.SetRange(Typew, l_AnnotationType);
        l_rMasterTableWEB.SetRange(LineNow, pNewRec."Line No.");
        l_rMasterTableWEB.SetRange("School Year", pNewRec."School Year");
        if l_rMasterTableWEB.FindSet(true, true) then begin
            if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Insert) and
              (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Insert) then begin
                l_rMasterTableWEB.Delete;
            end else begin
                l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Delete;
                l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Delete;
                l_rMasterTableWEB.Modify;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyAnnotationsConf(pNewRec: Record "Assessment Configuration"; pOldRec: Record "Assessment Configuration")
    var
        l_StructureEducationCountry: Record "Structure Education Country";
        l_rMasterTableWEB: Record MasterTableWEB;
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseLines: Record "Course Lines";
        rCourseLinesTEMP: Record "Course Lines" temporary;
        l_StudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        l_CompanyInformation: Record "Company Information";
        l_rClass: Record Class;
        cStudentsRegistration: Codeunit "Students Registration";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        l_rClass.Reset;
        l_rClass.SetRange("School Year", pNewRec."School Year");
        l_rClass.SetRange("Study Plan Code", pNewRec."Study Plan Code");
        l_rClass.SetRange("Country/Region Code", pNewRec."Country/Region Code");
        if l_rClass.FindSet then begin
            repeat
                l_rMasterTableWEB.Reset;
                l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Class);
                l_rMasterTableWEB.SetRange(Codew, l_rClass.Class);
                l_rMasterTableWEB.SetRange("School Year", l_rClass."School Year");
                if l_rMasterTableWEB.FindSet(true, true) then begin
                    l_StructureEducationCountry.Reset;
                    l_StructureEducationCountry.SetRange(Country, l_rClass."Country/Region Code");
                    l_StructureEducationCountry.SetRange("Schooling Year", l_rClass."Schooling Year");
                    if l_StructureEducationCountry.FindSet then begin
                        l_rMasterTableWEB."Posting Date" := Today;
                        l_rMasterTableWEB."Posting Time" := Time;
                        l_rMasterTableWEB.Codew := l_rClass.Class;
                        l_rMasterTableWEB.SchoolingYear := l_rClass."Schooling Year";
                        l_rMasterTableWEB."School Year" := l_rClass."School Year";
                        l_rMasterTableWEB.Description := l_rClass.Description;
                        l_rMasterTableWEB.Company := CompanyName;
                        l_rMasterTableWEB."Responsibility Center" := l_rClass."Responsibility Center";
                        l_rMasterTableWEB."Interface Type WEB" := l_StructureEducationCountry."Interface Type WEB";
                        l_rMasterTableWEB."Type Education" := l_rClass.Type;
                        l_rMasterTableWEB.StudyPlanCode := l_rClass."Study Plan Code";
                        l_rMasterTableWEB."Annotation Group" := pNewRec."Annotation Code";

                        if (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::" ") or
                          (l_rMasterTableWEB."Action Type" = l_rMasterTableWEB."Action Type"::Delete) then
                            l_rMasterTableWEB."Action Type" := l_rMasterTableWEB."Action Type"::Update;

                        if (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::" ") or
                          (l_rMasterTableWEB."Action Type 2" = l_rMasterTableWEB."Action Type 2"::Delete) then
                            l_rMasterTableWEB."Action Type 2" := l_rMasterTableWEB."Action Type 2"::Update;

                        l_rMasterTableWEB.Modify;
                    end;
                end;
            until l_rClass.Next = 0;
        end;
    end;
}

