page 31009915 "Grouped Information Archive"
{
    Caption = 'Student Invoiced Ledger Entry';
    Editable = false;
    PageType = Card;
    SourceTable = Registration;

    layout
    {
        area(content)
        {
            part("Mov. Faturados Aluno"; "SubForm Student Ledger Entry")
            {
                Caption = 'Mov. Faturados Aluno';
                Editable = false;
                SubPageLink = "Student No." = FIELD("Student Code No."),
                              "School Year" = FIELD("School Year");
                SubPageView = WHERE("Registed Invoice No." = FILTER(<> ''));
            }
        }
    }

    actions
    {
    }
}

