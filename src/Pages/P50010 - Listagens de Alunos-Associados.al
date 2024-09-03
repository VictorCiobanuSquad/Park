page 50010 "Listagens de Alunos-Associados"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Users Family / Students";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = All;
                }
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = All;
                }
                field(Kinship; Rec.Kinship)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Mobile Phone"; Rec."Mobile Phone")
                {
                    ApplicationArea = All;
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = All;
                }
                field("Education Head"; Rec."Education Head")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field("Paying Entity"; Rec."Paying Entity")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
            }
        }
    }
}