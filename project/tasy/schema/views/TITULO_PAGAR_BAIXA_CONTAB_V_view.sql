-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW titulo_pagar_baixa_contab_v (nr_seq_baixa, nr_lote_contabil, nr_titulo, vl_transacao, nr_seq_conta_banco, nr_seq_trans_fin, ds_atributo, nr_bordero, nr_seq_escrit, cd_centro_custo, cd_conta_contabil, dt_baixa, nr_seq_movto_trans_fin, cd_tipo_baixa, cd_moeda, cd_tributo, nr_seq_baixa_origem, nr_seq_trib_baixa) AS select 	a.nr_sequencia nr_seq_baixa,
	a.nr_lote_contabil,
	a.nr_titulo,
	a.vl_baixa vl_transacao,
	a.nr_seq_conta_banco,
	nr_seq_trans_fin,
	'VL_BAIXA' ds_atributo,
	nr_bordero,
	nr_seq_escrit,
	cd_centro_custo,
	cd_conta_contabil,
	dt_baixa,
	nr_seq_movto_trans_fin,
	a.cd_tipo_baixa,
	a.cd_moeda,
	null cd_tributo,
	a.nr_seq_baixa_origem,
    null nr_seq_trib_baixa
FROM    titulo_pagar_baixa a
where 	a.vl_baixa <> 0

union all

select 	a.nr_sequencia nr_seq_baixa,
	a.nr_lote_contabil,
	a.nr_titulo,
	a.vl_descontos,
	a.nr_seq_conta_banco,
	nr_seq_trans_fin,
	'VL_DESCONTOS',
	nr_bordero,
	nr_seq_escrit,
	cd_centro_custo,
	cd_conta_contabil,
	dt_baixa,
	nr_seq_movto_trans_fin,
	a.cd_tipo_baixa,
	a.cd_moeda,
	null cd_tributo,
	a.nr_seq_baixa_origem,
    null nr_seq_trib_baixa
from 	titulo_pagar_baixa a
where 	a.vl_descontos <> 0

union all

select	a.nr_sequencia nr_seq_baixa,
	a.nr_lote_contabil,
	a.nr_titulo,
	a.vl_outras_deducoes,
	a.nr_seq_conta_banco,
	nr_seq_trans_fin,
	'VL_OUTRAS_DEDUCOES',
	nr_bordero,
	nr_seq_escrit,
	cd_centro_custo,
	cd_conta_contabil,
	dt_baixa,
	nr_seq_movto_trans_fin,
	a.cd_tipo_baixa,
	a.cd_moeda,
	null cd_tributo,
	a.nr_seq_baixa_origem,
    null nr_seq_trib_baixa
from 	titulo_pagar_baixa a
where 	a.vl_outras_deducoes <> 0

union all

select	a.nr_sequencia nr_seq_baixa,
	a.nr_lote_contabil,
	a.nr_titulo,
	a.vl_juros,
	a.nr_seq_conta_banco,
	nr_seq_trans_fin,
	'VL_JUROS',
	nr_bordero,
	nr_seq_escrit,
	cd_centro_custo,
	cd_conta_contabil,
	dt_baixa,
	nr_seq_movto_trans_fin,
	a.cd_tipo_baixa,
	a.cd_moeda,
	null cd_tributo,
	a.nr_seq_baixa_origem,
    null nr_seq_trib_baixa
from 	titulo_pagar_baixa a
where 	a.vl_juros <> 0

union all

select	a.nr_sequencia nr_seq_baixa,
	a.nr_lote_contabil,
	a.nr_titulo,
	a.vl_multa,
	a.nr_seq_conta_banco,
	nr_seq_trans_fin,
	'VL_MULTA',
	nr_bordero,
	nr_seq_escrit,
	cd_centro_custo,
	cd_conta_contabil,
	dt_baixa,
	nr_seq_movto_trans_fin,
	a.cd_tipo_baixa,
	a.cd_moeda,
	null cd_tributo,
	a.nr_seq_baixa_origem,
    null nr_seq_trib_baixa
from 	titulo_pagar_baixa a
where 	a.vl_multa <> 0

union all

select	a.nr_sequencia nr_seq_baixa,
	a.nr_lote_contabil,
	a.nr_titulo,
	a.vl_outros_acrescimos,
	a.nr_seq_conta_banco,
	nr_seq_trans_fin,
	'VL_OUTROS_ACRESCIMOS',
	nr_bordero,
	nr_seq_escrit,
	cd_centro_custo,
	cd_conta_contabil,
	dt_baixa,
	nr_seq_movto_trans_fin,
	a.cd_tipo_baixa,
	a.cd_moeda,
	null cd_tributo,
	a.nr_seq_baixa_origem,
    null nr_seq_trib_baixa
from 	titulo_pagar_baixa a
where 	a.vl_outros_acrescimos <> 0

union all

select	a.nr_sequencia nr_seq_baixa,
	a.nr_lote_contabil,
	a.nr_titulo,
	a.vl_pago,
	a.nr_seq_conta_banco,
	nr_seq_trans_fin,
	'VL_PAGO',
	nr_bordero,
	nr_seq_escrit,
	cd_centro_custo,
	cd_conta_contabil,
	dt_baixa,
	nr_seq_movto_trans_fin,
	a.cd_tipo_baixa,
	a.cd_moeda,
	null cd_tributo,
	a.nr_seq_baixa_origem,
    null nr_seq_trib_baixa
from 	titulo_pagar_baixa a
where 	a.vl_pago <> 0

union all

select	a.nr_sequencia nr_seq_baixa,
	a.nr_lote_contabil,
	a.nr_titulo,
	a.vl_inss,
	a.nr_seq_conta_banco,
	nr_seq_trans_fin,
	'VL_INSS',
	nr_bordero,
	nr_seq_escrit,
	cd_centro_custo,
	cd_conta_contabil,
	dt_baixa,
	nr_seq_movto_trans_fin,
	a.cd_tipo_baixa,
	a.cd_moeda,
	null cd_tributo,
	a.nr_seq_baixa_origem,
    null nr_seq_trib_baixa
from 	titulo_pagar_baixa a
where 	coalesce(a.vl_inss,0) <> 0

union all

select	a.nr_sequencia nr_seq_baixa,
	a.nr_lote_contabil,
	a.nr_titulo,
	a.vl_imposto_munic,
	a.nr_seq_conta_banco,
	nr_seq_trans_fin,
	'VL_IMPOSTO_MUNIC',
	nr_bordero,
	nr_seq_escrit,
	cd_centro_custo,
	cd_conta_contabil,
	dt_baixa,
	nr_seq_movto_trans_fin,
	a.cd_tipo_baixa,
	a.cd_moeda,
	null cd_tributo,
	a.nr_seq_baixa_origem,
    null nr_seq_trib_baixa
from 	titulo_pagar_baixa a
where 	coalesce(a.vl_imposto_munic,0) <> 0

union all

select	a.nr_sequencia nr_seq_baixa,
	a.nr_lote_contabil,
	a.nr_titulo,
	coalesce(b.vl_baixa, a.vl_imposto) vl_transacao,
	a.nr_seq_conta_banco,
	coalesce(b.nr_seq_trans_financ, a.nr_seq_trans_fin) nr_seq_trans_fin,
	'VL_IMPOSTO_BAIXA',
	a.nr_bordero,
	a.nr_seq_escrit,
	a.cd_centro_custo,
	a.cd_conta_contabil,
	a.dt_baixa,
	a.nr_seq_movto_trans_fin,
	a.cd_tipo_baixa,
	a.cd_moeda,
	Fin_Obter_Codigo_Trib_Titpag(b.nr_seq_tit_trib) cd_tributo,
	a.nr_seq_baixa_origem,
    b.nr_sequencia nr_seq_trib_baixa
FROM titulo_pagar_baixa a
LEFT OUTER JOIN titulo_pagar_trib_baixa b ON (a.nr_sequencia = b.nr_seq_tit_baixa AND a.nr_titulo = b.nr_titulo)
WHERE coalesce(coalesce(b.vl_baixa, a.vl_imposto),0) <> 0
union all

select	a.nr_sequencia nr_seq_baixa,
	a.nr_lote_contabil,
	a.nr_titulo,
	a.vl_outras_despesas vl_transacao,
	a.nr_seq_conta_banco,
	nr_seq_trans_fin,
	'VL_OUTRAS_DESPESAS',
	nr_bordero,
	nr_seq_escrit,
	cd_centro_custo,
	cd_conta_contabil,
	dt_baixa,
	nr_seq_movto_trans_fin,
	a.cd_tipo_baixa,
	a.cd_moeda,
	null cd_tributo,
	a.nr_seq_baixa_origem,
    null nr_seq_trib_baixa
from 	titulo_pagar_baixa a
where 	coalesce(a.vl_outras_despesas,0) <> 0

union all

select	a.nr_sequencia nr_seq_baixa,
	a.nr_lote_contabil,
	a.nr_titulo,
	a.vl_cambial_ativo,
	a.nr_seq_conta_banco,
	nr_seq_trans_fin,
	'VL_CAMBIAL_ATIVO',
	nr_bordero,
	nr_seq_escrit,
	cd_centro_custo,
	cd_conta_contabil,
	dt_baixa,
	nr_seq_movto_trans_fin,
	a.cd_tipo_baixa,
	a.cd_moeda,
	null cd_tributo,
	a.nr_seq_baixa_origem,
    null nr_seq_trib_baixa
from 	titulo_pagar_baixa a
where 	a.vl_cambial_ativo <> 0

union all

select	a.nr_sequencia nr_seq_baixa,
	a.nr_lote_contabil,
	a.nr_titulo,
	a.vl_cambial_passivo,
	a.nr_seq_conta_banco,
	nr_seq_trans_fin,
	'VL_CAMBIAL_PASSIVO',
	nr_bordero,
	nr_seq_escrit,
	cd_centro_custo,
	cd_conta_contabil,
	dt_baixa,
	nr_seq_movto_trans_fin,
	a.cd_tipo_baixa,
	a.cd_moeda,
	null cd_tributo,
	a.nr_seq_baixa_origem,
    null nr_seq_trib_baixa
from 	titulo_pagar_baixa a
where 	a.vl_cambial_passivo <> 0;
