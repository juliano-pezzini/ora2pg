-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW proj_rat_v (nr_sequencia, nr_seq_cliente, dt_atualizacao, nm_usuario, cd_executor, dt_inicio, dt_final, dt_liberacao, nm_usuario_lib, dt_aprovacao, nm_usuario_aprov, qt_total_hora, vl_hora_cobrar, qt_hora_cobrar, vl_cobrar_cliente, vl_hora_pagar, qt_hora_pagar, vl_pagar, nr_titulo_rec, nr_titulo_pagar, nr_seq_nf, nr_ordem_compra, dt_prev_nf, ie_status_cobrar, ie_paga_rat, dt_atualizacao_nrec, nm_usuario_nrec, dt_receb_rat, nm_usuario_receb, nr_seq_canal, qt_dia_exec, qt_dia_reg, ie_funcao_exec, nr_seq_proj, vl_imposto, vl_adicional_clt, vl_custo_inst, vl_fixo_consultor, dt_rec_fin, dt_aprov_fin, nr_seq_fech_mes, ie_status_rat, ie_regime_contr, nr_seq_cronograma, ie_faturado, ds_cliente, ds_fantasia, nm_consultor, dt_ordem_compra, dt_nf_cobrar, dt_nf_pagar, nr_nf_oc, ds_cobrado, ds_funcao_exec, ds_nivel, vl_hora, ds_origem_projeto, ds_regime_contr, cd_centro_custo, ds_centro_custo) AS select	a.NR_SEQUENCIA,a.NR_SEQ_CLIENTE,a.DT_ATUALIZACAO,a.NM_USUARIO,a.CD_EXECUTOR,a.DT_INICIO,a.DT_FINAL,a.DT_LIBERACAO,a.NM_USUARIO_LIB,a.DT_APROVACAO,a.NM_USUARIO_APROV,a.QT_TOTAL_HORA,a.VL_HORA_COBRAR,a.QT_HORA_COBRAR,a.VL_COBRAR_CLIENTE,a.VL_HORA_PAGAR,a.QT_HORA_PAGAR,a.VL_PAGAR,a.NR_TITULO_REC,a.NR_TITULO_PAGAR,a.NR_SEQ_NF,a.NR_ORDEM_COMPRA,a.DT_PREV_NF,a.IE_STATUS_COBRAR,a.IE_PAGA_RAT,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.DT_RECEB_RAT,a.NM_USUARIO_RECEB,a.NR_SEQ_CANAL,a.QT_DIA_EXEC,a.QT_DIA_REG,a.IE_FUNCAO_EXEC,a.NR_SEQ_PROJ,a.VL_IMPOSTO,a.VL_ADICIONAL_CLT,a.VL_CUSTO_INST,a.VL_FIXO_CONSULTOR,a.DT_REC_FIN,a.DT_APROV_FIN,a.NR_SEQ_FECH_MES,a.IE_STATUS_RAT,a.IE_REGIME_CONTR,a.NR_SEQ_CRONOGRAMA,a.IE_FATURADO,
	substr(obter_desc_cliente(a.nr_seq_cliente,'N'),1,100) ds_cliente,
	substr(obter_desc_cliente(a.nr_seq_cliente,'F'),1,100) ds_fantasia,
	substr(obter_nome_pf(a.cd_executor),1,100) nm_consultor,
	(select max(dt_ordem_compra) FROM ordem_compra b where b.nr_ordem_compra = a.nr_ordem_compra) dt_ordem_compra,
	(select max(dt_emissao) from nota_fiscal b where b.nr_sequencia = a.nr_seq_nf) dt_nf_cobrar,
	(select max(b.dt_emissao) from nota_fiscal b, nota_fiscal_item c where b.nr_sequencia = c.nr_sequencia and c.nr_ordem_compra = a.nr_ordem_compra) dt_nf_pagar,
	(select max(b.nr_nota_fiscal) from nota_fiscal b, nota_fiscal_item c where b.nr_sequencia = c.nr_sequencia and c.nr_ordem_compra = a.nr_ordem_compra) nr_nf_oc,
	(select obter_valor_dominio_idioma(6, coalesce(max(pc.ie_cobrado), 'N'), wheb_usuario_pck.get_nr_seq_idioma) from proj_cronograma pc where pc.nr_sequencia = a.nr_seq_cronograma) ds_cobrado,
	obter_valor_dominio(2396, ie_funcao_exec) ds_funcao_exec,
    (SELECT MAX(Obter_Nivel_Consultor(p.CD_EMPRESA, a.cd_executor, 'NF', a.dt_inicio)) FROM proj_consultor_nivel p WHERE a.cd_executor = p.CD_CONSULTOR) ds_nivel,
    (SELECT MAX(Obter_Nivel_Consultor(p.CD_EMPRESA, a.cd_executor, 'VV', a.dt_inicio)) FROM proj_consultor_nivel p WHERE a.cd_executor = p.CD_CONSULTOR) vl_hora,
    Obter_Descricao_Padrao('PROJ_ORIGEM_PROJETO','DS_ORIGEM_PROJETO', pp.nr_seq_origem_proj) ds_origem_projeto,
    SUBSTR(obter_valor_dominio(2395,a.ie_regime_contr),1,150) ds_regime_contr,
    pp.cd_centro_custo,
    substr(obter_desc_centro_custo(pp.cd_centro_custo),1,255) ds_centro_custo
from	proj_rat a
left outer join proj_projeto pp on a.nr_seq_proj = pp.nr_sequencia;
