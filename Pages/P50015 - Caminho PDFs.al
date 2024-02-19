page 50015 "Caminho PDFs"
{
    /*
    //IT001 - Parque - 2016.10.20 - Para parametrizar os caminhos dos PDF's criados nos envios por email
    //Este form acede-se a partir da Conf. Educação - Conf. Textos Email
    //O caminho deve ser configurado com \ no fim
    */
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Comment Line";
    SourceTableView = WHERE("Table Name" = CONST("E-mail"), "No." = CONST('E-MAIL ASSUNTO'));
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field("Caminho PDFs"; Rec."Caminho PDFs")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}