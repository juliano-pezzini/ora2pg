-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_uuid_pck.atualizar_uuid_movt_contab_doc (nr_documento_p movimento_contabil_doc.nr_documento%type, nr_seq_doc_compl_p movimento_contabil_doc.nr_seq_doc_compl%type, nr_seq_info_p movimento_contabil_doc.nr_seq_info%type, nr_nfe_imp_p nota_fiscal.nr_nfe_imp%type, nr_lote_contabil_p lote_contabil.nr_lote_contabil%type, nr_seq_nota_fiscal_p nota_fiscal.nr_sequencia%type, nr_sequencia_ref_p nota_fiscal.nr_sequencia_ref%type default null, nr_seq_baixa_tit_p nota_fiscal.nr_seq_baixa_tit%type default null) AS $body$
DECLARE


c_contas_receber CURSOR(
    nr_seq_nota_fiscal_pc     nota_fiscal.nr_sequencia%type,
    nr_sequencia_ref_pc       nota_fiscal.nr_sequencia_ref%type,
    nr_seq_baixa_tit_pc       nota_fiscal.nr_seq_baixa_tit%type
   ) FOR

SELECT  x.nr_sequencia
    from (  SELECT  c.nr_sequencia
        from    movimento_contabil_doc c,
                titulo_receber_liq nf,
                titulo_receber t
        where   nf.nr_titulo = t.nr_titulo
        and     nf.nr_sequencia = c.nr_seq_doc_compl
        and     nf.nr_titulo =  c.nr_documento
        and     c.nr_seq_info = 14
        and     t.nr_seq_nf_saida = nr_sequencia_ref_pc
        and     nf.nr_sequencia  = nr_seq_baixa_tit_pc

union

        select  c.nr_sequencia
        from    movimento_contabil_doc c,
                titulo_receber_liq nf,
                nota_fiscal_item z
        where   z.nr_seq_tit_rec  = nf.nr_sequencia
        and     z.nr_titulo = nf.nr_titulo
        and     c.nr_seq_info = 14
        and     nf.nr_sequencia = c.nr_seq_doc_compl
        and     nf.nr_titulo =  c.nr_documento
        and     z.nr_sequencia = nr_seq_nota_fiscal_pc
        
union

        select  c.nr_sequencia
        from    movimento_contabil_doc c,
                titulo_receber_trib_baixa nf,
                nota_fiscal_item z
        where   z.nr_seq_tit_rec  = nf.nr_seq_tit_liq
        and     z.nr_titulo = nf.nr_titulo
        and     c.nr_seq_info = 55
        and     nf.nr_sequencia = c.nr_seq_doc_compl
        and     nf.nr_titulo =  c.nr_documento
        and     z.nr_sequencia = nr_seq_nota_fiscal_pc
        
union

        select  c.nr_sequencia
        from    movimento_contabil_doc c,
                titulo_receber_trib_baixa nf,
                titulo_receber t
        where   nf.nr_titulo = t.nr_titulo
        and     nf.nr_sequencia = c.nr_seq_doc_compl
        and     nf.nr_titulo =  c.nr_documento
        and     c.nr_seq_info = 55
        and     t.nr_seq_nf_saida = nr_sequencia_ref_pc
        and     nf.nr_seq_tit_liq   = nr_seq_baixa_tit_pc
        )
x;


type t_contas_receber is table of c_contas_receber%rowtype index by integer;
l_contas_receber_w t_contas_receber;

type seq_movto_contabil_doc is table of movimento_contabil_doc.nr_sequencia%type index by integer;
l_seq_movto_contabil_doc_w   seq_movto_contabil_doc;

cd_tipo_lote_contabil_w lote_contabil.cd_tipo_lote_contabil%type;



BEGIN

/*
13  Baixa de titulo a pagar
14  Baixa de titulo a receber
*/
if ( nr_seq_info_p = 13 ) then /* 7 - Contas a Pagar*/
    begin
        update  movimento_contabil_doc
        set     nr_nfe_imp = nr_nfe_imp_p
        where   nr_documento = nr_documento_p
        and     nr_seq_doc_compl = nr_seq_doc_compl_p
        and     nr_seq_info = 13;
    --  commit;
        /*  Triger que dispara TITULO_PAGAR_BAIXA_UPDATE
            Evitar trigger mutante.  Procedure e usada apenas em trigger.
            NAO USAR PRAGMA
        */
    end;

    end if;

if ( nr_seq_info_p = 14 ) then /* 5 - Contas a receber */
    begin
        open c_contas_receber(  nr_seq_nota_fiscal_p,
                    nr_sequencia_ref_p,
                    nr_seq_baixa_tit_p
                    );
        loop fetch c_contas_receber bulk collect into l_contas_receber_w limit 500;
        exit when l_contas_receber_w.count = 0;
            begin
                for i in 1..l_contas_receber_w.count loop
                    begin
                    l_seq_movto_contabil_doc_w(l_seq_movto_contabil_doc_w.count + 1) :=   l_contas_receber_w[i].nr_sequencia;
                    end;
                end loop;
                forall i in 1 .. l_seq_movto_contabil_doc_w.count
                    update  movimento_contabil_doc
                    set     nr_nfe_imp = nr_nfe_imp_p
                    where   nr_sequencia  = l_seq_movto_contabil_doc_w(i);
                 --commit;
                    /*  Trige que dispara esta rotina: nota_fiscal_update.
                        commit comentado, evitar trigger mutante.
                        NAO USAR PRAGMA */
                l_seq_movto_contabil_doc_w.delete;
            end;
        end loop;
        close c_contas_receber;
    end;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_uuid_pck.atualizar_uuid_movt_contab_doc (nr_documento_p movimento_contabil_doc.nr_documento%type, nr_seq_doc_compl_p movimento_contabil_doc.nr_seq_doc_compl%type, nr_seq_info_p movimento_contabil_doc.nr_seq_info%type, nr_nfe_imp_p nota_fiscal.nr_nfe_imp%type, nr_lote_contabil_p lote_contabil.nr_lote_contabil%type, nr_seq_nota_fiscal_p nota_fiscal.nr_sequencia%type, nr_sequencia_ref_p nota_fiscal.nr_sequencia_ref%type default null, nr_seq_baixa_tit_p nota_fiscal.nr_seq_baixa_tit%type default null) FROM PUBLIC;
