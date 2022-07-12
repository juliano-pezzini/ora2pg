-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ctb_uuid_pck.get_uuid (nr_lote_contabil_p lote_contabil.nr_lote_contabil%type default null, nr_seq_info_p movimento_contabil_doc.nr_seq_info%type default null, nr_documento_p movimento_contabil_doc.nr_documento%type default null, nr_seq_doc_compl_p movimento_contabil_doc.nr_seq_doc_compl%type default null, nr_doc_analitico_p movimento_contabil_doc.nr_doc_analitico%type default null, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type default null) RETURNS NOTA_FISCAL.NR_NFE_IMP%TYPE AS $body$
DECLARE


nr_nfe_imp_w    nota_fiscal.nr_nfe_imp%type;
cd_tipo_lote_w  tipo_lote_contabil.cd_tipo_lote_contabil%type;


BEGIN
    begin
    select  cd_tipo_lote_contabil
    into STRICT    cd_tipo_lote_w
    from    lote_contabil
    where   nr_lote_contabil = nr_lote_contabil_p;

    case    cd_tipo_lote_w
    when 5 then /* 5 Contas a Receber  */
        nr_nfe_imp_w := ctb_uuid_pck.get_uuid_contas_receber(nr_documento_p,nr_seq_doc_compl_p);

    when 7 then /* 7 Contas a Pagar  */
        nr_nfe_imp_w:=  ctb_uuid_pck.get_uuid_contas_pagar(nr_documento_p,nr_seq_doc_compl_p);
    else
        nr_nfe_imp_w:= null;
    end case;
    end;
    return nr_nfe_imp_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ctb_uuid_pck.get_uuid (nr_lote_contabil_p lote_contabil.nr_lote_contabil%type default null, nr_seq_info_p movimento_contabil_doc.nr_seq_info%type default null, nr_documento_p movimento_contabil_doc.nr_documento%type default null, nr_seq_doc_compl_p movimento_contabil_doc.nr_seq_doc_compl%type default null, nr_doc_analitico_p movimento_contabil_doc.nr_doc_analitico%type default null, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type default null) FROM PUBLIC;
