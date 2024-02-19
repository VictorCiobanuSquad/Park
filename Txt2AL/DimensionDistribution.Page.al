#pragma implicitwith disable
page 31009898 "Dimension Distribution"
{
    PageType = List;
    SourceTable = "Recenseamento Alunos";

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
                ShowCaption = false;
                field(Turma; Rec.Turma)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Nome Aluno"; Rec."Nome Aluno")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tipo Documento"; Rec."Tipo Documento")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}

#pragma implicitwith restore

