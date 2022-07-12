-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_rfc ( nr_seq_movimento_p movimento_contabil_doc.nr_seq_ctb_movto%type, nr_lote_contabil_p lote_contabil.nr_lote_contabil%type, cd_estabelecimento_p lote_contabil.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE


nr_rfc_w                  movimento_contabil_doc.nr_rfc%type;
cd_tipo_lote_contabil_w   lote_contabil.cd_tipo_lote_contabil%type;


BEGIN
    select  coalesce(max(cd_tipo_lote_contabil), null)
    into STRICT    cd_tipo_lote_contabil_w
    from    lote_contabil
    where   nr_lote_contabil = nr_lote_contabil_p
    and     cd_estabelecimento = cd_estabelecimento_p;

    if (cd_tipo_lote_contabil_w = 12) then
        select  max(nr_rfc)
        into STRICT    nr_rfc_w
        from    movimento_contabil_doc
        where   nr_seq_ctb_movto = nr_seq_movimento_p;
    end if;

    return nr_rfc_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_rfc ( nr_seq_movimento_p movimento_contabil_doc.nr_seq_ctb_movto%type, nr_lote_contabil_p lote_contabil.nr_lote_contabil%type, cd_estabelecimento_p lote_contabil.cd_estabelecimento%type) FROM PUBLIC;
