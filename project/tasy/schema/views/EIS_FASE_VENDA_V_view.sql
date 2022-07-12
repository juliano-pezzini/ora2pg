-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_fase_venda_v (nr_sequencia, cd_empresa, dt_atualizacao, nm_usuario, cd_cnpj, ie_situacao, ie_natureza, ie_fase_venda, ie_status_neg, ie_classificacao, ie_tipo, qt_leito, qt_leito_uti, vl_fat_anual, ie_resp_atend, ie_recebe_visita, ie_referencia, dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_forma_conhec, dt_revisao_prevista, nr_seq_ativ, qt_consultores, dt_oficializacao_uso, ie_resp_coordenacao, qt_mes_estimado, ie_hosp_escola, ie_resp_implantacao, qt_vidas, ie_revisado, ie_produto, ie_acompanha_implantacao, nr_visita_pos_venda, pr_possib_fecham, ie_inclusao_manual, nr_seq_lead, ie_forma_aquisicao, dt_revisao_prevista_orig, cd_estabelecimento, dt_cliente, ie_migracao, dt_migrado, ie_porte_cliente, dt_aprov_duplic, ie_etapa_duplic, nr_seq_situacao_fin, ie_restricao, ie_segmentacao, ds_cliente, ds_fase_venda, sg_estado) AS select a.NR_SEQUENCIA,a.CD_EMPRESA,a.DT_ATUALIZACAO,a.NM_USUARIO,a.CD_CNPJ,a.IE_SITUACAO,a.IE_NATUREZA,a.IE_FASE_VENDA,a.IE_STATUS_NEG,a.IE_CLASSIFICACAO,a.IE_TIPO,a.QT_LEITO,a.QT_LEITO_UTI,a.VL_FAT_ANUAL,a.IE_RESP_ATEND,a.IE_RECEBE_VISITA,a.IE_REFERENCIA,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.NR_SEQ_FORMA_CONHEC,a.DT_REVISAO_PREVISTA,a.NR_SEQ_ATIV,a.QT_CONSULTORES,a.DT_OFICIALIZACAO_USO,a.IE_RESP_COORDENACAO,a.QT_MES_ESTIMADO,a.IE_HOSP_ESCOLA,a.IE_RESP_IMPLANTACAO,a.QT_VIDAS,a.IE_REVISADO,a.IE_PRODUTO,a.IE_ACOMPANHA_IMPLANTACAO,a.NR_VISITA_POS_VENDA,a.PR_POSSIB_FECHAM,a.IE_INCLUSAO_MANUAL,a.NR_SEQ_LEAD,a.IE_FORMA_AQUISICAO,a.DT_REVISAO_PREVISTA_ORIG,a.CD_ESTABELECIMENTO,a.DT_CLIENTE,a.IE_MIGRACAO,a.DT_MIGRADO,a.IE_PORTE_CLIENTE,a.DT_APROV_DUPLIC,a.IE_ETAPA_DUPLIC,a.NR_SEQ_SITUACAO_FIN,a.IE_RESTRICAO,a.IE_SEGMENTACAO,
	substr(obter_dados_pf_pj(null,cd_cnpj,'N'),1,100) ds_cliente, 
	substr(obter_valor_dominio(1314,a.ie_fase_venda),1,200) ds_fase_venda, 
	b.sg_estado 
FROM	Com_Cliente a, 
	pessoa_juridica b 
where	a.cd_cnpj = b.cd_cgc;

