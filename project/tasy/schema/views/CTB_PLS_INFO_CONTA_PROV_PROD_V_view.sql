-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ctb_pls_info_conta_prov_prod_v (nr_seq_protocolo, nr_seq_conta, ie_ato_cooperado, ie_regulamentacao, ie_tipo_contratacao, ie_segmentacao, ie_tipo_contrato, nr_seq_grupo_ans, ds_tipo_despesa, ie_tipo_segurado, ie_tipo_compartilhamento, ie_tipo_repasse, nr_seq_tipo_prestador, ie_tipo_relacao, nr_contrato, nr_lote_contabil_prov, cd_conta_prov_cred, cd_conta_prov_deb, nr_seq_resumo, nr_seq_mat, nr_seq_proc, nr_doc_analitico, nr_seq_doc_compl, nr_documento) AS select d.nr_sequencia nr_seq_protocolo,
       c.nr_sequencia nr_seq_conta,
       coalesce(a.ie_ato_cooperado,b.ie_ato_cooperado) ie_ato_cooperado,
       e.ie_regulamentacao,
       e.ie_tipo_contratacao,
       e.ie_segmentacao,
       case when
               coalesce(g.nr_seq_contrato, 0) <> 0 then (select    CASE WHEN cd_pf_estipulante IS NULL THEN  'PJ'  ELSE 'PF' END
               FROM      pls_contrato
               where     nr_sequencia    = g.nr_seq_contrato  LIMIT 1)
	else case when   coalesce(g.nr_seq_intercambio, 0) <> 0 then (select    CASE WHEN cd_pessoa_fisica IS NULL THEN  'PJ'  ELSE 'PF' END 
               from      pls_intercambio
               where     nr_sequencia    = g.nr_seq_intercambio  LIMIT 1)
        else   null
               end
       end ie_tipo_contrato,
       coalesce(a.nr_seq_grupo_ans,b.nr_seq_grupo_ans) nr_seq_grupo_ans,
       substr(obter_valor_dominio(3796 ,coalesce(a.ie_tipo_despesa,b.ie_tipo_despesa)), 1, 255) ds_tipo_despesa,
       coalesce(c.ie_tipo_segurado,g.ie_tipo_segurado) ie_tipo_segurado,
       pls_obter_comp_repasse(b.dt_procedimento, d.dt_mes_competencia, g.nr_sequencia, d.nr_seq_congenere, 'C') ie_tipo_compartilhamento,
       pls_obter_comp_repasse(b.dt_procedimento, d.dt_mes_competencia, g.nr_sequencia, d.nr_seq_congenere, 'R') ie_tipo_repasse,      
	(select	max(nr_seq_tipo_prestador)
	from	pls_prestador
	where	nr_sequencia	= CASE WHEN h.ie_prestador_codificacao='E' THEN c.nr_seq_prestador_exec WHEN h.ie_prestador_codificacao='S' THEN c.nr_seq_prestador WHEN h.ie_prestador_codificacao='A' THEN d.nr_seq_prestador WHEN h.ie_prestador_codificacao='P' THEN a.nr_seq_prestador_pgto END ) nr_seq_tipo_prestador,
       (select	max(ie_tipo_relacao)
       from	pls_prestador
       where	nr_sequencia	= CASE WHEN h.ie_prestador_codificacao='E' THEN c.nr_seq_prestador_exec WHEN h.ie_prestador_codificacao='S' THEN c.nr_seq_prestador WHEN h.ie_prestador_codificacao='A' THEN d.nr_seq_prestador WHEN h.ie_prestador_codificacao='P' THEN a.nr_seq_prestador_pgto END ) ie_tipo_relacao,
       i.nr_contrato,
       a.nr_lote_contabil_prov,
       a.cd_conta_prov_cred,
       a.cd_conta_prov_deb,
       a.nr_sequencia nr_seq_resumo,
       null nr_seq_mat,
       b.nr_sequencia nr_seq_proc,
       a.nr_sequencia nr_doc_analitico,
       c.nr_sequencia nr_seq_doc_compl,
       d.nr_sequencia nr_documento
FROM pls_esquema_contabil h, pls_protocolo_conta d, pls_conta_proc b, pls_conta_medica_resumo a, pls_conta c
LEFT OUTER JOIN pls_plano e ON (c.nr_seq_plano = e.nr_sequencia)
, pls_segurado g
LEFT OUTER JOIN pls_contrato i ON (g.nr_seq_contrato = i.nr_sequencia)
WHERE c.nr_sequencia = a.nr_seq_conta and c.nr_sequencia = b.nr_seq_conta and b.nr_sequencia = a.nr_seq_conta_proc and d.nr_sequencia = c.nr_seq_protocolo  and g.nr_sequencia = c.nr_seq_segurado and h.nr_sequencia = a.nr_seq_esquema_prov  
union all

select d.nr_sequencia nr_seq_protocolo,
       c.nr_sequencia nr_seq_conta,
       coalesce(a.ie_ato_cooperado,b.ie_ato_cooperado) ie_ato_cooperado,
       e.ie_regulamentacao,
       e.ie_tipo_contratacao,
       e.ie_segmentacao,
       case when
               coalesce(g.nr_seq_contrato, 0) <> 0 then (select    CASE WHEN cd_pf_estipulante IS NULL THEN  'PJ'  ELSE 'PF' END 
               from      pls_contrato
               where     nr_sequencia    = g.nr_seq_contrato  LIMIT 1)
	else case when   coalesce(g.nr_seq_intercambio, 0) <> 0 then (select    CASE WHEN cd_pessoa_fisica IS NULL THEN  'PJ'  ELSE 'PF' END 
               from      pls_intercambio
               where     nr_sequencia    = g.nr_seq_intercambio  LIMIT 1)
        else   null
               end
       end ie_tipo_contrato,
       coalesce(a.nr_seq_grupo_ans,b.nr_seq_grupo_ans) nr_seq_grupo_ans,
       substr(obter_valor_dominio(1854 ,coalesce(a.ie_tipo_despesa,b.ie_tipo_despesa)), 1, 255) ds_tipo_despesa,
       coalesce(c.ie_tipo_segurado,g.ie_tipo_segurado) ie_tipo_segurado,
       pls_obter_comp_repasse(b.dt_atendimento, d.dt_mes_competencia, g.nr_sequencia, d.nr_seq_congenere, 'C') ie_tipo_compartilhamento,
       pls_obter_comp_repasse(b.dt_atendimento, d.dt_mes_competencia, g.nr_sequencia, d.nr_seq_congenere, 'R') ie_tipo_repasse, 
      (select	max(nr_seq_tipo_prestador)
       from	pls_prestador
       where	nr_sequencia	= CASE WHEN h.ie_prestador_codificacao='E' THEN c.nr_seq_prestador_exec WHEN h.ie_prestador_codificacao='S' THEN c.nr_seq_prestador WHEN h.ie_prestador_codificacao='A' THEN d.nr_seq_prestador WHEN h.ie_prestador_codificacao='P' THEN a.nr_seq_prestador_pgto END ) nr_seq_tipo_prestador,
       (select	max(ie_tipo_relacao)
       from	pls_prestador
       where	nr_sequencia	= CASE WHEN h.ie_prestador_codificacao='E' THEN c.nr_seq_prestador_exec WHEN h.ie_prestador_codificacao='S' THEN c.nr_seq_prestador WHEN h.ie_prestador_codificacao='A' THEN d.nr_seq_prestador WHEN h.ie_prestador_codificacao='P' THEN a.nr_seq_prestador_pgto END ) ie_tipo_relacao,
       i.nr_contrato,
       a.nr_lote_contabil_prov,
       a.cd_conta_prov_cred,
       a.cd_conta_prov_deb,
       a.nr_sequencia nr_seq_resumo,
       b.nr_sequencia nr_seq_mat,
       null nr_seq_proc,
       a.nr_sequencia nr_doc_analitico,
       c.nr_sequencia nr_seq_doc_compl,
       d.nr_sequencia nr_documento
FROM pls_esquema_contabil h, pls_protocolo_conta d, pls_conta_mat b, pls_conta_medica_resumo a, pls_conta c
LEFT OUTER JOIN pls_plano e ON (c.nr_seq_plano = e.nr_sequencia)
, pls_segurado g
LEFT OUTER JOIN pls_contrato i ON (g.nr_seq_contrato = i.nr_sequencia)
WHERE c.nr_sequencia = b.nr_seq_conta and b.nr_sequencia = a.nr_seq_conta_mat  and d.nr_sequencia = c.nr_seq_protocolo and g.nr_sequencia = c.nr_seq_segurado and h.nr_sequencia = a.nr_seq_esquema_prov  
union all

select d.nr_sequencia nr_seq_protocolo,
       c.nr_sequencia nr_seq_conta,
       b.ie_ato_cooperado,
       e.ie_regulamentacao,
       e.ie_tipo_contratacao,
       e.ie_segmentacao,
       case when
               coalesce(g.nr_seq_contrato, 0) <> 0 then (select    CASE WHEN cd_pf_estipulante IS NULL THEN  'PJ'  ELSE 'PF' END 
               from      pls_contrato
               where     nr_sequencia    = g.nr_seq_contrato  LIMIT 1)
	else case when   coalesce(g.nr_seq_intercambio, 0) <> 0 then (select    CASE WHEN cd_pessoa_fisica IS NULL THEN  'PJ'  ELSE 'PF' END 
               from      pls_intercambio
               where     nr_sequencia    = g.nr_seq_intercambio  LIMIT 1)
        else   null
               end
       end ie_tipo_contrato,
       b.nr_seq_grupo_ans,
       substr(obter_valor_dominio(1854, b.ie_tipo_despesa), 1, 255) ds_tipo_despesa,
       coalesce(c.ie_tipo_segurado,g.ie_tipo_segurado) ie_tipo_segurado,
       pls_obter_comp_repasse(b.dt_atendimento, d.dt_mes_competencia, g.nr_sequencia, d.nr_seq_congenere, 'C') ie_tipo_compartilhamento,
       pls_obter_comp_repasse(b.dt_atendimento, d.dt_mes_competencia, g.nr_sequencia, d.nr_seq_congenere, 'R') ie_tipo_repasse,      
      (select	max(nr_seq_tipo_prestador)
       from	pls_prestador
       where	nr_sequencia	= CASE WHEN h.ie_prestador_codificacao='E' THEN c.nr_seq_prestador_exec WHEN h.ie_prestador_codificacao='S' THEN c.nr_seq_prestador WHEN h.ie_prestador_codificacao='A' THEN d.nr_seq_prestador  ELSE c.nr_seq_prestador_exec END ) nr_seq_tipo_prestador,
       (select	max(ie_tipo_relacao)
       from	pls_prestador
       where	nr_sequencia	= CASE WHEN h.ie_prestador_codificacao='E' THEN c.nr_seq_prestador_exec WHEN h.ie_prestador_codificacao='S' THEN c.nr_seq_prestador WHEN h.ie_prestador_codificacao='A' THEN d.nr_seq_prestador  ELSE c.nr_seq_prestador_exec END ) ie_tipo_relacao,
       i.nr_contrato,
       b.nr_lote_contabil_prov,
       b.cd_conta_provisao_cred,
       b.cd_conta_provisao_deb,
       null nr_seq_resumo,
       b.nr_sequencia nr_seq_mat,
       null nr_seq_proc,
       b.nr_sequencia nr_doc_analitico,
       c.nr_sequencia nr_seq_doc_compl,
       d.nr_sequencia nr_documento
FROM pls_esquema_contabil h, pls_protocolo_conta d, pls_conta_mat b, pls_conta c
LEFT OUTER JOIN pls_plano e ON (c.nr_seq_plano = e.nr_sequencia)
, pls_segurado g
LEFT OUTER JOIN pls_contrato i ON (g.nr_seq_contrato = i.nr_sequencia)
WHERE c.nr_sequencia = b.nr_seq_conta  and d.nr_sequencia = c.nr_seq_protocolo and g.nr_sequencia = c.nr_seq_segurado and h.nr_sequencia = b.nr_seq_esquema_prov  
union all

select d.nr_sequencia nr_seq_protocolo,
       c.nr_sequencia nr_seq_conta,
       b.ie_ato_cooperado,
       e.ie_regulamentacao,
       e.ie_tipo_contratacao,
       e.ie_segmentacao,
       case when
               coalesce(g.nr_seq_contrato, 0) <> 0 then (select    CASE WHEN cd_pf_estipulante IS NULL THEN  'PJ'  ELSE 'PF' END 
               from      pls_contrato
               where     nr_sequencia    = g.nr_seq_contrato  LIMIT 1)
	else case when   coalesce(g.nr_seq_intercambio, 0) <> 0 then (select    CASE WHEN cd_pessoa_fisica IS NULL THEN  'PJ'  ELSE 'PF' END 
               from      pls_intercambio
               where     nr_sequencia    = g.nr_seq_intercambio  LIMIT 1)
        else   null
               end
       end ie_tipo_contrato,
       b.nr_seq_grupo_ans,
       substr(obter_valor_dominio(3796, b.ie_tipo_despesa), 1, 255) ds_tipo_despesa,
       coalesce(c.ie_tipo_segurado,g.ie_tipo_segurado) ie_tipo_segurado,
       pls_obter_comp_repasse(b.dt_procedimento, d.dt_mes_competencia, g.nr_sequencia, d.nr_seq_congenere, 'C') ie_tipo_compartilhamento,
       pls_obter_comp_repasse(b.dt_procedimento, d.dt_mes_competencia, g.nr_sequencia, d.nr_seq_congenere, 'R') ie_tipo_repasse,      
      (select	max(nr_seq_tipo_prestador)
       from	pls_prestador
       where	nr_sequencia	= CASE WHEN h.ie_prestador_codificacao='E' THEN c.nr_seq_prestador_exec WHEN h.ie_prestador_codificacao='S' THEN c.nr_seq_prestador WHEN h.ie_prestador_codificacao='A' THEN d.nr_seq_prestador  ELSE c.nr_seq_prestador_exec END ) nr_seq_tipo_prestador,
       (select	max(ie_tipo_relacao)
       from	pls_prestador
       where	nr_sequencia	= CASE WHEN h.ie_prestador_codificacao='E' THEN c.nr_seq_prestador_exec WHEN h.ie_prestador_codificacao='S' THEN c.nr_seq_prestador WHEN h.ie_prestador_codificacao='A' THEN d.nr_seq_prestador  ELSE c.nr_seq_prestador_exec END ) ie_tipo_relacao,
       i.nr_contrato,
       b.nr_lote_contabil_prov,
       b.cd_conta_provisao_cred,
       b.cd_conta_provisao_deb,
       null nr_seq_resumo,
       null nr_seq_mat,
       b.nr_sequencia nr_seq_proc,
       b.nr_sequencia nr_doc_analitico,
       c.nr_sequencia nr_seq_doc_compl,
       d.nr_sequencia nr_documento
FROM pls_esquema_contabil h, pls_protocolo_conta d, pls_conta_proc b, pls_conta c
LEFT OUTER JOIN pls_plano e ON (c.nr_seq_plano = e.nr_sequencia)
, pls_segurado g
LEFT OUTER JOIN pls_contrato i ON (g.nr_seq_contrato = i.nr_sequencia)
WHERE c.nr_sequencia = b.nr_seq_conta  and d.nr_sequencia = c.nr_seq_protocolo and g.nr_sequencia = c.nr_seq_segurado and h.nr_sequencia = b.nr_seq_esquema_prov;

