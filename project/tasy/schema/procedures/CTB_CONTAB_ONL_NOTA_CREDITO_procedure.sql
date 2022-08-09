-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_contab_onl_nota_credito ( doc_p INOUT ctb_documento, nm_usuario_p text) AS $body$
DECLARE

/*
===============================================================================
Purpose: Indentacao

Remarks: n/a

Who         When            What
----------  -----------     --------------------------------------------------
chjreinert  13/mai/2021     OS 2444975 - Indentacao

===============================================================================
*/
vl_transacao_w                          double precision;
ds_origem_w                             varchar(255);
cd_pessoa_nota_credito_w                varchar(14);
nm_pessoa_nota_credito_w                varchar(255);
dt_movimento_w                          timestamp;
nr_titulo_origem_hist_guia_w            varchar(20);
ds_atributos_w                          varchar(4000);
ie_regra_w                              varchar(255);
dt_contabil_final_w                     timestamp;
nr_titulo_orig_cr_w                     varchar(255);
cd_empresa_w                            empresa.cd_empresa%type;
nr_lote_contabil_w                      lote_contabil.nr_lote_contabil%type;
nm_agrupador_w                          agrupador_contabil.nm_atributo%type;
dados_contab_w                          ctb_contab_onl_lote_fin_pck.dados_contab_tf;
ctb_param_lote_nota_cred_w              ctb_param_lote_nota_cred%rowtype;
nr_seq_agrupamento_w                    w_movimento_contabil.nr_seq_agrupamento%type;
nr_documento_ww                         movimento_contabil.nr_documento%Type;
ie_origem_documento_w                   movimento_contabil.ie_origem_documento%Type;
nota_credito_w                          nota_credito%rowtype;
ie_nota_credito_classif_w               varchar(1) := 'N';
nr_sequencia_w                          banco_estabelecimento.nr_sequencia%type;

c01 CURSOR FOR
    SELECT  coalesce(b.vl_classificacao, 0) vl_transacao,
            b.cd_centro_custo,
            b.cd_conta_contabil
    from    nota_credito_classif b
    where   b.nr_seq_nota_credito = doc_p.nr_documento;

BEGIN
dados_contab_w          := null;
dados_contab_w.doc      := doc_p;

nr_lote_contabil_w      := ctb_online_pck.get_lote_contabil(29,
                                                            doc_p.cd_estabelecimento,
                                                            doc_p.dt_competencia,
                                                            nm_usuario_p);

cd_empresa_w    := obter_empresa_estab(doc_p.cd_estabelecimento);

begin
select  *
into STRICT    nota_credito_w
from    nota_credito a
where   a.cd_estabelecimento    = doc_p.cd_estabelecimento
and     a.nr_sequencia          = doc_p.nr_documento;
exception when others then
        nota_credito_w  := null;
end;


select  x.*
into STRICT    ctb_param_lote_nota_cred_w
from (
        SELECT  a.*
        from    ctb_param_lote_nota_cred a
        where   a.cd_empresa    = cd_empresa_w
        and     coalesce(a.cd_estab_exclusivo, doc_p.cd_estabelecimento) = doc_p.cd_estabelecimento
        order   by coalesce(a.cd_estab_exclusivo, 0) desc
        ) x LIMIT 1;

nm_agrupador_w  := coalesce(trim(both obter_agrupador_contabil(doc_p.cd_tipo_lote_contabil)),'NR_SEQ_NOTA_CREDITO');

if (coalesce(nr_seq_agrupamento_w,0) = 0)then
        nr_seq_agrupamento_w    :=      nota_credito_w.nr_sequencia;
end if;

if (nm_agrupador_w = 'NR_SEQ_NOTA_CREDITO')then
        nr_seq_agrupamento_w    :=      nota_credito_w.nr_sequencia;
end if;

nr_titulo_orig_cr_w             := substr(obter_titulo_orig_cr(nota_credito_w.nr_sequencia),1,255);

ds_origem_w                             := substr(obter_valor_dominio(3346, nota_credito_w.ie_origem),1,120);
cd_pessoa_nota_credito_w                := substr(coalesce(nota_credito_w.cd_pessoa_fisica, nota_credito_w.cd_cgc),1,14);
nm_pessoa_nota_credito_w                := substr(obter_nome_pf_pj(nota_credito_w.cd_pessoa_fisica, nota_credito_w.cd_cgc),1,255);
dt_movimento_w                          := nota_credito_w.dt_nota_credito;

if (nota_credito_w.dt_cancelamento IS NOT NULL AND nota_credito_w.dt_cancelamento::text <> '') and (trunc(nota_credito_w.dt_cancelamento,'dd') <> trunc(nota_credito_w.dt_nota_credito,'dd')) then
        dt_movimento_w  := nota_credito_w.dt_cancelamento;
end if;

if (coalesce(nota_credito_w.nr_seq_lote_hist_guia,0) <> 0) then
    select  max(somente_numero(obter_titulo_conta_guia(nr_interno_conta,cd_autorizacao,null,null)))
    into STRICT    nr_titulo_origem_hist_guia_w
    from    lote_audit_hist_guia
    where   nr_sequencia    = nota_credito_w.nr_seq_lote_hist_guia;
end if;

if (coalesce(nr_titulo_orig_cr_w,'X') = 'X') then
        nr_titulo_orig_cr_w := nota_credito_w.nr_titulo_receber;
end if;

CALL ctb_online_pck.definir_atrib_compl(doc_p.cd_tipo_lote_contabil);

CALL ctb_online_pck.set_value_compl_hist('NR_SEQUENCIA',                     nota_credito_w.nr_sequencia );
CALL ctb_online_pck.set_value_compl_hist('CD_PESSOA_NOTA_CREDITO',           cd_pessoa_nota_credito_w);
CALL ctb_online_pck.set_value_compl_hist('NM_PESSOA_NOTA_CREDITO',           nm_pessoa_nota_credito_w);
CALL ctb_online_pck.set_value_compl_hist('DS_ORIGEM',                        ds_origem_w);
CALL ctb_online_pck.set_value_compl_hist('NR_TITULO_ORIGEM_HIST_GUIA',       nr_titulo_origem_hist_guia_w);
CALL ctb_online_pck.set_value_compl_hist('NR_TITULO_ORIG_CR',                nr_titulo_orig_cr_w);
CALL ctb_online_pck.set_value_compl_hist('NR_SEQ_CREDITO_N_IDENT',           nota_credito_w.nr_seq_credito_n_ident);

ds_atributos_w  := null;
ds_atributos_w  := 'NR_TITULO_RECEBER=' || nota_credito_w.nr_titulo_receber;

ctb_obter_doc_movto(doc_p.cd_tipo_lote_contabil,
                    doc_p.nm_atributo,
                    'VR',
                    nota_credito_w.dt_nota_credito,
                    null,
                    null,
                    ds_atributos_w,
                    nm_usuario_p,
                    ie_regra_w,
                    nr_documento_ww,
                    ie_origem_documento_w);

nr_documento_ww := dados_contab_w.nr_doc_movto;
vl_transacao_w  := dados_contab_w.doc.vl_movimento;

dados_contab_w.doc                                      := doc_p;
dados_contab_w.cd_estab_movto                           := doc_p.cd_estabelecimento;
dados_contab_w.nr_lote_contabil                         := doc_p.nr_lote_contabil;
dados_contab_w.nr_seq_agrupamento                       := nr_seq_agrupamento_w;
dados_contab_w.dt_transacao                             := doc_p.dt_competencia;
dados_contab_w.nr_seq_trans_fin                         := nota_credito_w.nr_seq_trans_fin_contab;
dados_contab_w.nr_seq_conta_banco                       := nota_credito_w.nr_seq_conta_banco;
dados_contab_w.nm_atributo                              := doc_p.nm_atributo;
dados_contab_w.cd_pessoa_fisica                         := nota_credito_w.cd_pessoa_fisica;
dados_contab_w.cd_cnpj                                  := nota_credito_w.cd_cgc;
dados_contab_w.ie_origem_documento                      := ie_origem_documento_w;
dados_contab_w.nr_doc_movto                             := doc_p.nr_documento;
dados_contab_w.nr_seq_conta_banco                       := nr_sequencia_w;

for c01_w in c01 loop
    begin
    ie_nota_credito_classif_w       := 'S';
    dados_contab_w.doc.vl_movimento         := coalesce(coalesce(c01_w.vl_transacao, nota_credito_w.vl_nota_credito),0);
    dados_contab_w.cd_conta_contabil        := c01_w.cd_conta_contabil;
    dados_contab_w.cd_centro_custo          := c01_w.cd_centro_custo;

    if (nota_credito_w.dt_cancelamento IS NOT NULL AND nota_credito_w.dt_cancelamento::text <> '') then
            vl_transacao_w := coalesce(coalesce(c01_w.vl_transacao, nota_credito_w.vl_nota_credito),0) * -1;
    end if;

    ctb_contab_onl_lote_fin_pck.contabiliza_trans_financ(dados_contab_w,doc_p.nm_usuario);
    end;
end loop;

if (ie_nota_credito_classif_w = 'N') then
        ctb_contab_onl_lote_fin_pck.contabiliza_trans_financ(dados_contab_w,doc_p.nm_usuario);
end if;
doc_p.nr_lote_contabil  := dados_contab_w.doc.nr_lote_contabil;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_contab_onl_nota_credito ( doc_p INOUT ctb_documento, nm_usuario_p text) FROM PUBLIC;
