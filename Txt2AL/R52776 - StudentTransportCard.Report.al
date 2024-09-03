report 52776 "Student Transport Card"
{
    DefaultLayout = RDLC;
    RDLCLayout = './StudentTransportCard.rdlc';
    Caption = 'Student Transport Card';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Registration; Registration)
        {
            RequestFilterFields = "School Year", "Student Code No.";
            column(rStudent_Picture; rStudent.Picture)
            {
            }
            column(varStudentName; varStudentName)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(Registration__Student_Code_No__; "Student Code No.")
            {
            }
            column(varLunch; Format(varLunch))
            {
            }
            column(varTransportation; Format(varTransportation))
            {
            }
            column("Informació_de_l_AlumneCaption"; Informació_de_l_AlumneCaptionLbl)
            {
            }
            column(MenjadorCaption; MenjadorCaptionLbl)
            {
            }
            column(TransportCaption; TransportCaptionLbl)
            {
            }
            column(NomCaption; NomCaptionLbl)
            {
            }
            column(Registration__Student_Code_No__Caption; Registration__Student_Code_No__CaptionLbl)
            {
            }
            column(Registration_School_Year; "School Year")
            {
            }
            column(Registration_Responsibility_Center; "Responsibility Center")
            {
            }

            trigger OnAfterGetRecord()
            begin
                rStudent.Get("Student Code No.");
                rStudent.CalcFields(Picture);
                varStudentName := rStudent.Name;

                if rStudent."Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;

                varLunch := false;
                varTransportation := false;

                rStudentsNonLectiveHours.Reset;
                rStudentsNonLectiveHours.SetRange("School Year", Registration."School Year");
                rStudentsNonLectiveHours.SetRange("Student Code No.", Registration."Student Code No.");
                rStudentsNonLectiveHours.SetRange("Responsibility Center", Registration."Responsibility Center");
                if rStudentsNonLectiveHours.FindSet then begin
                    repeat
                        if rStudentsNonLectiveHours.Lunch then
                            varLunch := true;
                        if (rStudentsNonLectiveHours."Collect Transport" <> '') or (rStudentsNonLectiveHours."Deliver Transport" <> '') then
                            varTransportation := true;
                    until rStudentsNonLectiveHours.Next = 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
                    if rRespCenter.Find('-') then
                        nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
                end else begin
                    rSchool.Reset;
                    if rSchool.Find('-') then
                        nomeEscola := rSchool."School Name";
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        rStudent: Record Students;
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        rStudentsNonLectiveHours: Record "Students Non Lective Hours";
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[128];
        varStudentName: Text[250];
        varLunch: Boolean;
        varTransportation: Boolean;
        "Informació_de_l_AlumneCaptionLbl": Label 'Student Information';
        MenjadorCaptionLbl: Label 'Lunch';
        TransportCaptionLbl: Label 'Transportation';
        NomCaptionLbl: Label 'Name';
        Registration__Student_Code_No__CaptionLbl: Label 'Student Code No.';
}

