report 31009843 "School Movements"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SchoolMovements.rdlc';
    Caption = 'School Movements';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Structure Education Country"; "Structure Education Country")
        {
            DataItemTableView = SORTING("Sorting ID");
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(School_MovementsCaption; School_MovementsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Number_Of_Students_CycleCaption; Number_Of_Students_CycleCaptionLbl)
            {
            }
            column(Number_of_Students_YearCaption; Number_of_Students_YearCaptionLbl)
            {
            }
            column(Number_of_Students_ClassCaption; Number_of_Students_ClassCaptionLbl)
            {
            }
            column(Total_StudentsCaption; Total_StudentsCaptionLbl)
            {
            }
            column(Structure_Education_Country_Country; Country)
            {
            }
            column(Structure_Education_Country_Level; Level)
            {
            }
            column(Structure_Education_Sorting_ID; "Sorting ID")
            {
            }
            column(Structure_Education_Country_Schooling_Year; "Schooling Year")
            {
            }
            dataitem(Class1; Class)
            {
                DataItemLink = "Schooling Year" = FIELD("Schooling Year");
                DataItemTableView = SORTING("School Year", "Schooling Year");
                column(Class1_Class; Class)
                {
                }
                column(Class1_School_Year; "School Year")
                {
                }
                column(Class1_Schooling_Year; "Schooling Year")
                {
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(OldTotalStudents; OldTotalStudents)
                    {
                    }
                    column(OldCycle; OldCycle)
                    {
                    }
                    column(OldSchoolingYear; OldSchoolingYear)
                    {
                    }
                    column(vCountClass; vCountClass)
                    {
                    }
                    column(OldCycleName; OldCycleName)
                    {
                    }
                    column(vClass; vClass)
                    {
                    }
                    column(Integer_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin

                        OldTotalStudents := ' ';
                        if rClass.Next <> 0 then begin
                            if rClass."Schooling Year" = "Structure Education Country"."Schooling Year" then begin
                                OldCycle := ' ';
                                OldSchoolingYear := ' ';
                                SeparatorYear := false;
                            end else begin
                                OldSchoolingYear := Format(vCountSchoolingYear);
                                SeparatorYear := true;
                            end;
                        end else begin
                            SeparatorYear := true;
                            OldSchoolingYear := Format(vCountSchoolingYear);
                            if rStrucEduCountry.Next <> 0 then begin
                                rClass.Reset;
                                rClass.SetCurrentKey("School Year", "Schooling Year");
                                rClass.SetRange("Schooling Year", rStrucEduCountry."Schooling Year");
                                if rClass.FindFirst then begin
                                    if rStrucEduCountry.Level = "Structure Education Country".Level then begin
                                        OldCycle := ' ';
                                        Separator := false;
                                    end else begin
                                        OldCycle := Format(vCountCycle);
                                        Separator := true;
                                    end;
                                end else begin
                                    OldCycle := Format(vCountCycle);
                                    OldTotalStudents := Format(vTotalStudents);
                                    SeparatorCycle := true;
                                end;
                            end else begin
                                OldCycle := Format(vCountCycle);
                                OldTotalStudents := Format(vTotalStudents);
                                SeparatorCycle := true;
                            end;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        rRegistrationClassTEMP.Reset;
                        Integer.SetRange(Number, 1, 1);
                        vCountClass := rRegistrationClassTEMP.Count;
                        vCountCycle += vCountClass;
                        OldSchoolingYear := Format(vCountSchoolingYear);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    rClass.Reset;
                    rClass.Copy(Class1);
                    if vLastClass <> Class1.Class then begin
                        if vLastCycle <> Format("Structure Education Country".Level) then begin
                            if vLastCycle = '' then
                                OldCycleName := Format("Structure Education Country".Level);
                            Clear(vCountCycle);
                            OldCycleName := Format("Structure Education Country".Level);
                            vLastCycle := Format("Structure Education Country".Level);
                        end else
                            OldCycleName := ' ';

                        if vLastSchoolingYear <> "Structure Education Country"."Schooling Year" then begin
                            Clear(vCountSchoolingYear);
                            vLastSchoolingYear := "Structure Education Country"."Schooling Year";
                        end;
                        Clear(vCountClass);
                        vLastClass := Class1.Class;
                    end;

                    vCycle := Format("Structure Education Country".Level);
                    vClass := Class1."Schooling Year" + ' ' + '-' + ' ' + Class1."Class Letter";






                    rRegistrationClass.Reset;
                    rRegistrationClassTEMP.DeleteAll;
                    rRegistrationClass.SetRange(Class, Class1.Class);
                    rRegistrationClass.SetRange("Schooling Year", Class1."Schooling Year");
                    rRegistrationClass.SetRange("School Year", Class1."School Year");
                    rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
                    if rRegistrationClass.FindSet then begin
                        repeat
                            vCountSchoolingYear += 1;
                            vTotalStudents += 1;
                            rRegistrationClassTEMP.Init;
                            rRegistrationClassTEMP.TransferFields(rRegistrationClass);
                            rRegistrationClassTEMP.Insert;
                        until rRegistrationClass.Next = 0;
                    end;
                    OldSchoolingYear := Format(vCountSchoolingYear);
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("School Year", varSchoolYear);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                rStrucEduCountry.Reset;
                rStrucEduCountry.Copy("Structure Education Country");
            end;

            trigger OnPreDataItem()
            var
                lClass: Record Class;
                lStruEduCountry: Record "Structure Education Country";
            begin

                //IT 2016.02.03 - para não aparecerem os anos de escolaridade que não têm turmas
                vFiltroAnosEsc := '';
                lStruEduCountry.Reset;
                if lStruEduCountry.FindSet then begin
                    repeat
                        lClass.Reset;
                        lClass.SetRange(lClass."School Year", varSchoolYear);
                        lClass.SetRange(lClass."Schooling Year", lStruEduCountry."Schooling Year");
                        if not lClass.FindFirst then begin
                            if vFiltroAnosEsc = '' then
                                vFiltroAnosEsc := '<>' + lStruEduCountry."Schooling Year"
                            else
                                vFiltroAnosEsc := vFiltroAnosEsc + '&<>' + lStruEduCountry."Schooling Year";
                        end;
                    until lStruEduCountry.Next = 0;
                end;
                "Structure Education Country".SetFilter("Structure Education Country"."Schooling Year", vFiltroAnosEsc);

                //IT 2016.02.03 - par
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("School Movements")
                {
                    Caption = 'School Movements';
                    field(varSchoolYear; varSchoolYear)
                    {
                        Caption = 'School Year';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            rSchoolYear: Record "School Year";
                        begin
                            if PAGE.RunModal(PAGE::"School Year", rSchoolYear) = ACTION::LookupOK then
                                varSchoolYear := rSchoolYear."School Year";
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

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            rRespCenter.Reset;
            rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
            nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
            varLocation := rRespCenter.City;
        end else begin
            rSchool.Reset;
            if rSchool.Find('-') then
                nomeEscola := rSchool."School Name";
            varLocation := rSchool.Location;
        end;
    end;

    var
        vCountCycle: Integer;
        vCountClass: Integer;
        vCountSchoolingYear: Integer;
        vTotalStudents: Integer;
        vLastClass: Code[20];
        vLastSchoolingYear: Code[20];
        varSchoolYear: Code[20];
        varYear: Integer;
        VarNumber: Integer;
        vClass: Text[250];
        vCycle: Text[250];
        varLocation: Text[250];
        nomeEscola: Text[128];
        OldSchoolingYear: Text[30];
        OldCycle: Text[30];
        OldTotalStudents: Text[30];
        OldCycleName: Text[30];
        vLastCycle: Text[30];
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        CompanyInfo: Record "Company Information";
        SchoolYear: Record "School Year";
        rRegistrationClass: Record "Registration Class";
        rRegistrationClassTEMP: Record "Registration Class" temporary;
        rStrucEduCountry: Record "Structure Education Country";
        rClass: Record Class;
        cUserEducation: Codeunit "User Education";
        First: Boolean;
        printSub: Boolean;
        SeparatorYear: Boolean;
        SeparatorCycle: Boolean;
        Separator: Boolean;
        School_MovementsCaptionLbl: Label 'School Movements';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Number_Of_Students_CycleCaptionLbl: Label 'Number Of Students/Cycle';
        Number_of_Students_YearCaptionLbl: Label 'Number of Students/Year';
        Number_of_Students_ClassCaptionLbl: Label 'Number of Students/Class';
        Total_StudentsCaptionLbl: Label 'Total Students';
        vFiltroAnosEsc: Text;
}

