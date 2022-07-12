-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hbo_contab_gvdasa_extcaixa_v (tp_registro, ds_unidade, ds_origem_lote, dt_movimento, cd_conta_contabil, ie_debito_credito, vl_movimento, ds_capa_lote, ds_historico, ds_compl_historico, cd_estabelecimento, nr_lote_contabil) AS select	0					tp_registro,
	20					ds_unidade,
	'TASYEC10' || CASE WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='2' THEN 'NF' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='3' THEN 'CO' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='5' THEN 'CTR' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='6' THEN 'RE' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='7' THEN 'CTP' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='8' THEN 'PF' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='9' THEN 'CT' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='11' THEN 'RC' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='12' THEN 'DIG' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='14' THEN 'RT' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='16' THEN 'PRT' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='17' THEN 'PAT' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='18' THEN 'CB'  ELSE '' END 	ds_origem_lote,
	null					dt_movimento,
	0					cd_conta_contabil,
	''					ie_debito_credito,
	0					vl_movimento,
	''					ds_capa_lote,
	''					ds_historico,
	''					ds_compl_historico,
	a.cd_estabelecimento,
	a.nr_lote_contabil
FROM	ctb_movimento_v a

union all

select	5					tp_registro,
	0					ds_unidade,
	''					ds_origem_lote,
	a.dt_movimento			dt_movimento,
	somente_numero(a.cd_conta_contabil) cd_conta_contabil,
	a.ie_debito_credito			ie_debito_credito,
	a.vl_movimento			vl_movimento,
	to_char(dt_movimento,'yyyymmdd') || 'EC' ||
			CASE WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='2' THEN '_NF' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='3' THEN '_CO' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='5' THEN '_CTR' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='6' THEN '_RE' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='7' THEN '_CTP' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='8' THEN '_PF' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='9' THEN '_CT' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='11' THEN '_RC' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='12' THEN '_DIG' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='14' THEN '_RT' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='16' THEN '_PRT' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='17' THEN '_PAT' WHEN substr(ctb_obter_tipo_lote_contabil(a.nr_lote_contabil,'C'),1,5)='18' THEN '_CB'  ELSE '' END  ds_capa_lote,
	a.ds_historico			ds_historico,
	a.ds_compl_historico		 	ds_compl_historico,
	a.cd_estabelecimento,
	a.nr_lote_contabil
from	ctb_movimento_v a
;

