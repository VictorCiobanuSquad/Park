report 31009764 "Copy Services Plan"
{
    Caption = 'Copy Services Plan';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Opções")
                {
                    Caption = 'Opções';
                    field(varCopyPlanService; varCopyPlanService)
                    {
                        Caption = 'Copy Plan Service';
                        TableRelation = "Services Plan Head";
                    }
                    field(varNewPlanService; varNewPlanService)
                    {
                        Caption = 'New Plan Service';
                        Editable = false;
                    }
                    field(varNewSchoolYear; varNewSchoolYear)
                    {
                        Caption = 'New School Year';
                        TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Planning | Active));
                    }
                    field(varNewSchoolingYear; varNewSchoolingYear)
                    {
                        Caption = 'New Schooling Year';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            l_rServicesPlanHead: Record "Services Plan Head";
                        begin
                            l_rServicesPlanHead.Reset;
                            l_rServicesPlanHead.SetRange(Code, varNewPlanService);
                            if l_rServicesPlanHead.Find('-') then begin
                                rStructureEducationCountry.Reset;
                                rStructureEducationCountry.SetRange(Country, l_rServicesPlanHead."Country/Region Code");
                                if PAGE.RunModal(0, rStructureEducationCountry) = ACTION::LookupOK then begin
                                    varNewSchoolingYear := rStructureEducationCountry."Schooling Year";
                                    varNewStudyPlan := '';
                                end;
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            varNewStudyPlan := '';
                        end;
                    }
                    field(varNewStudyPlan; varNewStudyPlan)
                    {
                        Caption = 'New Study Plan';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            rStudyPlanHeader: Record "Study Plan Header";
                            rCourseHeader: Record "Course Header";
                            rRegistration: Record Registration;
                            cStudentsRegistration: Codeunit "Students Registration";
                            rTEMP: Record "Study Plan Header" temporary;
                            VarInt: Integer;
                            l_rServicesPlanHead: Record "Services Plan Head";
                        begin
                            l_rServicesPlanHead.Reset;
                            l_rServicesPlanHead.SetRange(Code, varNewPlanService);
                            if l_rServicesPlanHead.Find('-') then begin
                                rStructureEducationCountry.Reset;
                                rStructureEducationCountry.SetRange(Country, l_rServicesPlanHead."Country/Region Code");
                                rStructureEducationCountry.SetRange("Schooling Year", varNewSchoolingYear);
                                if rStructureEducationCountry.Find('-') then begin
                                    if rStructureEducationCountry.Type = rStructureEducationCountry.Type::Simple then begin
                                        rStudyPlanHeader.Reset;
                                        rStudyPlanHeader.SetFilter("School Year", cStudentsRegistration.GetShoolYear);
                                        rStudyPlanHeader.SetFilter("Schooling Year", '<>%1', '');
                                        if rStudyPlanHeader.Find('-') then begin
                                            if PAGE.RunModal(PAGE::"Study Plan List", rStudyPlanHeader) = ACTION::LookupOK then begin
                                                varNewStudyPlan := rStudyPlanHeader.Code;
                                            end;
                                        end;
                                    end;
                                    if rStructureEducationCountry.Type = rStructureEducationCountry.Type::Multi then begin
                                        rCourseHeader.Reset;
                                        rCourseHeader.SetFilter("School Year Begin", cStudentsRegistration.GetShoolYear);
                                        if rCourseHeader.Find('-') then begin
                                            if PAGE.RunModal(PAGE::"Course List", rCourseHeader) = ACTION::LookupOK then begin
                                                varNewStudyPlan := rCourseHeader.Code;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                            /*
                            rStudyPlanHeader.RESET;
                            rStudyPlanHeader.SETFILTER("School Year",cStudentsRegistration.GetShoolYear);
                            rStudyPlanHeader.SETFILTER("Schooling Year",'<>%1','');
                            IF rStudyPlanHeader.FIND('-') THEN BEGIN
                               REPEAT
                            
                                    rTEMP.INIT;
                                    rTEMP.TRANSFERFIELDS(rStudyPlanHeader);
                                    rTEMP."Code Text" := rStudyPlanHeader.Code;
                                    rTEMP.INSERT;
                               UNTIL rStudyPlanHeader.NEXT = 0;
                            END;
                            
                            VarInt := 0;
                            rCourseHeader.RESET;
                            IF rCourseHeader.FIND('-') THEN BEGIN
                               REPEAT
                            
                                 rRegistration.RESET;
                                 rRegistration.SETCURRENTKEY("School Year","Schooling Year",Course);
                                 rRegistration.SETFILTER("School Year",cStudentsRegistration.GetShoolYear);
                                 rRegistration.SETRANGE(Course,rCourseHeader.Code);
                                 IF rRegistration.FIND('-') THEN BEGIN
                                    REPEAT
                            
                                        rTEMP.RESET;
                                        rTEMP.SETRANGE(Code,FORMAT(VarInt));
                                        rTEMP.SETRANGE("School Year",rRegistration."School Year");
                                        rTEMP.SETRANGE("Schooling Year",rRegistration."Schooling Year");
                            
                                        IF NOT rTEMP.FIND('-') THEN BEGIN
                                            rTEMP.INIT;
                                            VarInt += 1;
                                            rTEMP.TRANSFERFIELDS(rCourseHeader);
                                            rTEMP.Code := FORMAT(VarInt);
                                            rTEMP."Code Text" :=rCourseHeader.Code;
                                            rTEMP."School Year" := rRegistration."School Year";
                                            rTEMP."Schooling Year" := rRegistration."Schooling Year";
                                            rTEMP."Temp Code" := rCourseHeader.Code;
                                            rTEMP.INSERT;
                                        END;
                                    UNTIL rRegistration.NEXT = 0;
                                 END;
                               UNTIL rCourseHeader.NEXT = 0;
                            END;
                            
                            rTEMP.RESET;
                            rTEMP.SETRANGE("School Year",varNewSchoolYear);
                            IF varNewSchoolingYear <> '' THEN
                               rTEMP.SETRANGE("Schooling Year",varNewSchoolingYear);
                            IF Page.RUNMODAL(Page::"Study Plan List Temp",rTEMP) = ACTION::LookupOK THEN BEGIN
                            
                                  IF rStudyPlanHeader.GET(rTEMP.Code) THEN BEGIN
                                     varNewStudyPlan := rTEMP.Code;
                                  END ELSE BEGIN
                                     IF rCourseHeader.GET(rTEMP."Temp Code") THEN BEGIN
                                        varNewStudyPlan := rTEMP."Temp Code";
                                     END;
                                  END;
                            END;
                            */

                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin

        if varNewPlanService = '' then
            Error(Text0001);

        if varCopyPlanService = '' then
            Error(Text0002);

        if varNewSchoolYear = '' then
            Error(Text0005);

        //IF varNewStudyPlan = '' THEN
        //   ERROR(Text0007);

        if (varNewPlanService = varCopyPlanService) then
            Error(Text0006);

        InsertServicePlan;
    end;

    var
        rServicesPlanHead: Record "Services Plan Head";
        rServicesPlanLine: Record "Services Plan Line";
        varCopyPlanService: Code[20];
        varNewPlanService: Code[20];
        varNewSchoolYear: Code[9];
        varNewSchoolingYear: Code[10];
        varNewStudyPlan: Code[20];
        Text0001: Label 'The Field New Plan Study must be completed.';
        Text0002: Label 'The Field Plan study must be completed.';
        Text0003: Label 'Copies conducted successfully.';
        Text0004: Label 'Already exists for the New Plan Study';
        Text0005: Label 'Mandatory New Schoolling Year.';
        Text0006: Label 'The new plan of service may not be equal to the level of service copy.';
        Text0007: Label 'The field new plan or course of study must be completed';
        rStructureEducationCountry: Record "Structure Education Country";

    //[Scope('OnPrem')]
    procedure InsertServicePlan()
    var
        l_rServicesPlanHead: Record "Services Plan Head";
        l_rServicesPlanLine: Record "Services Plan Line";
    begin
        rServicesPlanHead.Reset;
        rServicesPlanHead.SetRange(Code, varCopyPlanService);
        if rServicesPlanHead.Find('-') then begin
            l_rServicesPlanHead.Reset;
            l_rServicesPlanHead.SetRange(Code, varNewPlanService);
            if l_rServicesPlanHead.Find('-') then begin
                l_rServicesPlanHead."School Year" := varNewSchoolYear;

                if varNewStudyPlan <> '' then
                    l_rServicesPlanHead."Study Plan Code" := varNewStudyPlan;

                if varNewSchoolingYear <> '' then
                    l_rServicesPlanHead."Schooling Year" := varNewSchoolingYear;
                l_rServicesPlanHead.Modify;
            end;

            rServicesPlanLine.Reset;
            rServicesPlanLine.SetRange(Code, varCopyPlanService);
            rServicesPlanLine.SetRange("School Year", rServicesPlanHead."School Year");
            if rServicesPlanLine.Find('-') then
                repeat
                    l_rServicesPlanLine.Init;
                    l_rServicesPlanLine.Code := varNewPlanService;
                    l_rServicesPlanLine."School Year" := varNewSchoolYear;
                    if varNewSchoolingYear <> '' then
                        l_rServicesPlanLine."Schooling Year" := varNewSchoolingYear;
                    l_rServicesPlanLine."Service Code" := rServicesPlanLine."Service Code";
                    l_rServicesPlanLine.Description := rServicesPlanLine.Description;
                    l_rServicesPlanLine."Description 2" := rServicesPlanLine."Description 2";
                    l_rServicesPlanLine."Service Type" := rServicesPlanLine."Service Type";
                    l_rServicesPlanLine."Country/Region Code" := rServicesPlanLine."Country/Region Code";
                    l_rServicesPlanLine.January := rServicesPlanLine.January;
                    l_rServicesPlanLine.February := rServicesPlanLine.February;
                    l_rServicesPlanLine.March := rServicesPlanLine.March;
                    l_rServicesPlanLine.April := rServicesPlanLine.April;
                    l_rServicesPlanLine.May := rServicesPlanLine.May;
                    l_rServicesPlanLine.June := rServicesPlanLine.June;
                    l_rServicesPlanLine.July := rServicesPlanLine.July;
                    l_rServicesPlanLine.August := rServicesPlanLine.August;
                    l_rServicesPlanLine.Setember := rServicesPlanLine.Setember;
                    l_rServicesPlanLine.October := rServicesPlanLine.October;
                    l_rServicesPlanLine.November := rServicesPlanLine.November;
                    l_rServicesPlanLine.Dezember := rServicesPlanLine.Dezember;

                    l_rServicesPlanLine.Insert;
                until rServicesPlanLine.Next = 0;

            Message(Text0003);
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetServicePlanNo(pServicePlanCode: Code[20])
    begin
        varNewPlanService := pServicePlanCode;
    end;
}

