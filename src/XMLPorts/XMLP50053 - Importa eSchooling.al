xmlport 50053 "Importa eSchooling"
{
    /*
    IT001 - Parque - 2018.02.22 - Novos campos Endereço Mae, NIF Mae, Endereço Pai, NIF Pai
    */
    Direction = Import;

    schema
    {
        textelement(NodeName1)
        {
            tableelement(eSchooling; eSchooling)
            {
                fieldelement(a; eSchooling."No.") { }
                fieldelement(b; eSchooling.Name) { }
                fieldelement(c; eSchooling."VAT Registration No.") { }
                fieldelement(d; eSchooling."Birth Date") { }
                fieldelement(e; eSchooling.Sex) { }
                fieldelement(f; eSchooling.Address) { }
                fieldelement(g; eSchooling."Post Code") { }
                fieldelement(h; eSchooling.Location) { }
                fieldelement(i; eSchooling.ParentescoEncEdu) { }
                fieldelement(j; eSchooling.NomeMae) { }
                fieldelement(k; eSchooling.TelefoneEmpMae) { }
                fieldelement(l; eSchooling.TelemovelMae) { }
                fieldelement(m; eSchooling."E-mailMae") { }
                fieldelement(n; eSchooling.NomePai) { }
                fieldelement(o; eSchooling.TelefoneEmpPai) { }
                fieldelement(p; eSchooling.TelemovelPai) { }
                fieldelement(q; eSchooling."E-mailPai") { }
                fieldelement(r; eSchooling."NIB-IBAN") { }
                fieldelement(s; eSchooling.NContribuinteEncEdu) { }
                fieldelement(t; eSchooling."E-mail") { }
                fieldelement(u; eSchooling.EnderecoMae) { }
                fieldelement(v; eSchooling.CodPostalMae) { }
                fieldelement(w; eSchooling.LocalidadeMae) { }
                fieldelement(x; eSchooling.NIFMae) { }
                fieldelement(y; eSchooling.EnderecoPai) { }
                fieldelement(z; eSchooling.CodPostalPai) { }
                fieldelement(aa; eSchooling.LocalidadePai) { }
                fieldelement(ab; eSchooling.NIFPai) { }

                trigger OnPreXmlItem()
                begin
                    reSchooling.RESET;
                    reSchooling.DELETEALL;
                end;
            }
        }
    }

    var
        reSchooling: Record eSchooling;
}