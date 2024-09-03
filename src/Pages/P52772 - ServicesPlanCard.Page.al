#pragma implicitwith disable
page 52771 "Services Plan Card"
{
    Caption = 'Services Plan Card';
    PageType = Card;
    SourceTable = "Services Plan Head";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        SchoolYearOnAfterValidate;
                    end;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        SchoolingYearOnAfterValidate;
                    end;
                }
                field(spc1; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Study Plan/Course Code';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        ResponsibilityCenterOnAfterVal;
                    end;
                }
                field(spc2; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rStudyPlanHeader: Record "Study Plan Header";
                        rCourseHeader: Record "Course Header";
                        rRegistration: Record Registration;
                        cStudentsRegistration: Codeunit "Students Registration";
                        rTEMP: Record "Study Plan Header" temporary;
                        VarInt: Integer;
                    begin
                        rTEMP.DeleteAll;

                        rStudyPlanHeader.Reset;
                        rStudyPlanHeader.SetFilter("School Year", cStudentsRegistration.GetShoolYear);
                        rStudyPlanHeader.SetFilter("Schooling Year", '<>%1', '');
                        if rStudyPlanHeader.Find('-') then begin
                            repeat
                                rTEMP.Init;
                                rTEMP.TransferFields(rStudyPlanHeader);
                                rTEMP.Insert;
                            until rStudyPlanHeader.Next = 0;
                        end;

                        VarInt := 0;
                        rCourseHeader.Reset;
                        if rCourseHeader.Find('-') then begin
                            repeat
                                rRegistration.Reset;
                                rRegistration.SetCurrentKey("School Year", "Schooling Year", Course);
                                rRegistration.SetFilter("School Year", cStudentsRegistration.GetShoolYear);
                                rRegistration.SetRange(Course, rCourseHeader.Code);
                                if rRegistration.Find('-') then begin
                                    repeat

                                        rTEMP.Reset;
                                        rTEMP.SetRange(Code, Format(VarInt));
                                        rTEMP.SetRange("School Year", rRegistration."School Year");
                                        rTEMP.SetRange("Schooling Year", rRegistration."Schooling Year");

                                        if not rTEMP.Find('-') then begin
                                            rTEMP.Init;
                                            VarInt += 1;
                                            rTEMP.TransferFields(rCourseHeader);
                                            rTEMP.Code := Format(VarInt);
                                            rTEMP."School Year" := rRegistration."School Year";
                                            rTEMP."Schooling Year" := rRegistration."Schooling Year";
                                            rTEMP."Temp Code" := rCourseHeader.Code;
                                            rTEMP.Insert;
                                        end;
                                    until rRegistration.Next = 0;
                                end;
                            until rCourseHeader.Next = 0;
                        end;


                        if Rec."Study Plan Code" = '' then begin
                            rTEMP.Reset;
                            if PAGE.RunModal(PAGE::"Study Plan List", rTEMP) = ACTION::LookupOK then begin

                                if rStudyPlanHeader.Get(rTEMP.Code) then begin
                                    Rec."Study Plan Code" := rTEMP.Code;
                                    Rec."Schooling Year" := rTEMP."Schooling Year";
                                    Rec."School Year" := rTEMP."School Year";
                                end else begin
                                    if rCourseHeader.Get(rTEMP."Temp Code") then begin
                                        Rec."Study Plan Code" := rTEMP."Temp Code";
                                        Rec."Schooling Year" := rTEMP."Schooling Year";
                                        Rec."School Year" := rTEMP."School Year";
                                        Rec.Type := Rec.Type::Multi;
                                    end;
                                end;
                            end;
                        end else begin
                            if Confirm(Text002, false, Rec.FieldCaption("Study Plan Code"), Rec.Code) then begin
                                rTEMP.Reset;
                                if PAGE.RunModal(PAGE::"Study Plan List", rTEMP) = ACTION::LookupOK then begin

                                    if rStudyPlanHeader.Get(rTEMP.Code) then begin
                                        Rec."Study Plan Code" := rTEMP.Code;
                                        Rec."Schooling Year" := rTEMP."Schooling Year";
                                        Rec."School Year" := rTEMP."School Year";
                                    end else begin
                                        if rCourseHeader.Get(rTEMP."Temp Code") then begin
                                            Rec."Study Plan Code" := rTEMP."Temp Code";
                                            Rec."Schooling Year" := rTEMP."Schooling Year";
                                            Rec."School Year" := rTEMP."School Year";
                                            Rec.Type := Rec.Type::Multi;
                                        end;
                                    end;
                                end;
                            end else
                                exit;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if Rec."Study Plan Code" = '' then begin
                            Rec."School Year" := '';
                            Rec."Schooling Year" := '';
                        end;
                        StudyPlanCodeC1102059005OnAfte;
                    end;
                }
            }
            part(SubForm; "Services Plan Line")
            {
                ApplicationArea = All;
                SubPageLink = Code = FIELD(Code),
                              "School Year" = FIELD("School Year"),
                              "Schooling Year" = FIELD("Schooling Year");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Service Plan")
            {
                Caption = '&Service Plan';
                Image = Planning;
                separator(Action1110004)
                {
                }
                action("&Insert New Service")
                {
                    ApplicationArea = All;
                    Caption = '&Insert New Service';
                    Image = ServicePriceAdjustment;

                    trigger OnAction()
                    var
                        l_ServicesPlanLine: Record "Services Plan Line";
                        cPostServicesET: Codeunit "Post Services ET";
                    begin
                        CurrPage.SubForm.PAGE.GetRecord(l_ServicesPlanLine);

                        cPostServicesET.InsertServices(l_ServicesPlanLine);
                    end;
                }
                separator(Action1102065000)
                {
                }
                action("Copiar Planos Serviço")
                {
                    ApplicationArea = All;
                    Caption = 'Copiar Planos Serviço';
                    Image = Copy;

                    trigger OnAction()
                    begin
                        RepCopyServicesPlan.GetServicePlanNo(Rec.Code);
                        RepCopyServicesPlan.RunModal;
                        Clear(RepCopyServicesPlan);
                    end;
                }
            }
        }
    }

    var
        RepCopyServicesPlan: Report "Copy Services Plan";
        Text002: Label 'Do you wish to change %1 of service plan %2?';

    local procedure SchoolYearOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure StudyPlanCodeC1102059005OnAfte()
    begin
        CurrPage.Update;
    end;

    local procedure SchoolingYearOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure ResponsibilityCenterOnAfterVal()
    begin
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

