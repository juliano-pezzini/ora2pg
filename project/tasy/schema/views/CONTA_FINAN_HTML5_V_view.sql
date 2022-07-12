-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW conta_finan_html5_v (ds_tipo, cd_conta_financ, ds_conta_financ, dt_referencia, nr_seq_cheque) AS select obter_desc_expressao(786722,null) ds_tipo,
obter_conta_financ_cheque_cr(a.nr_seq_cheque, 0) cd_conta_financ,
b.ds_conta_financ ds_conta_financ,
coalesce(a.dt_prev_desbloqueio, coalesce(a.dt_vencimento_atual, a.dt_vencimento)) dt_referencia,
a.nr_seq_cheque
FROM   conta_financeira b,
cheque_cr a
where  obter_se_cheque_cr_avista(a.nr_seq_cheque) = 'S'
and    coalesce(a.dt_prev_desbloqueio, coalesce(a.dt_vencimento_atual, a.dt_vencimento)) is not null
and    obter_conta_financ_cheque_cr(a.nr_seq_cheque, 0)   = b.cd_conta_financ

union all

select obter_desc_expressao(786724,null) ds_tipo,
obter_conta_financ_cheque_cr(a.nr_seq_cheque, 2) cd_conta_financ,
b.ds_conta_financ ds_conta_financ,
coalesce(a.dt_prev_desbloqueio, a.dt_deposito) dt_referencia,
a.nr_seq_cheque
from   conta_financeira b,
cheque_cr a
where  obter_se_cheque_cr_avista(a.nr_seq_cheque) = 'N'
and    coalesce(a.dt_prev_desbloqueio, a.dt_deposito) is not null
and    obter_conta_financ_cheque_cr(a.nr_seq_cheque, 2) = b.cd_conta_financ
and    a.dt_deposito is not null

union all

select obter_desc_expressao(287647,null) ds_tipo,
obter_conta_financ_cheque_cr(a.nr_seq_cheque, 3) cd_conta_financ,
b.ds_conta_financ ds_conta_financ,
a.dt_devolucao_banco dt_referencia,
a.nr_seq_cheque
from   conta_financeira b,
cheque_cr a
where  a.dt_devolucao_banco is not null
and    obter_conta_financ_cheque_cr(a.nr_seq_cheque, 3) = b.cd_conta_financ

union all

select obter_desc_expressao(297276,null) ds_tipo,
obter_conta_financ_cheque_cr(a.nr_seq_cheque, 4) cd_conta_financ,
b.ds_conta_financ ds_conta_financ,
coalesce(a.dt_prev_seg_desbloqueio, a.dt_reapresentacao) dt_referencia,
a.nr_seq_cheque
from   conta_financeira b,
cheque_cr a
where  coalesce(a.dt_prev_seg_desbloqueio, a.dt_reapresentacao) is not null
and    obter_conta_financ_cheque_cr(a.nr_seq_cheque, 4) = b.cd_conta_financ

union all

select obter_desc_expressao(319667,null) ds_tipo,
obter_conta_financ_cheque_cr(a.nr_seq_cheque, 5) cd_conta_financ,
b.ds_conta_financ ds_conta_financ,
a.dt_seg_devolucao dt_referencia,
a.nr_seq_cheque
from   conta_financeira b,
cheque_cr a
where  a.dt_seg_devolucao is not null
and    obter_conta_financ_cheque_cr(a.nr_seq_cheque, 5) = b.cd_conta_financ

union all

select obter_desc_expressao(343592,null) ds_tipo,
obter_conta_financ_cheque_cr(a.nr_seq_cheque, 9) cd_conta_financ,
b.ds_conta_financ ds_conta_financ,
coalesce(a.dt_prev_terc_desbloqueio, a.dt_seg_reapresentacao) dt_referencia,
a.nr_seq_cheque
from   conta_financeira b,
cheque_cr a
where  coalesce(a.dt_prev_terc_desbloqueio, a.dt_seg_reapresentacao) is not null
and    obter_conta_financ_cheque_cr(a.nr_seq_cheque, 9) = b.cd_conta_financ

union all

select obter_desc_expressao(319670,null) ds_tipo,
obter_conta_financ_cheque_cr(a.nr_seq_cheque, 10) cd_conta_financ,
b.ds_conta_financ ds_conta_financ,
a.dt_terc_devolucao dt_referencia,
a.nr_seq_cheque
from   conta_financeira b,
cheque_cr a
where  a.dt_terc_devolucao is not null
and    obter_conta_financ_cheque_cr(a.nr_seq_cheque, 10) = b.cd_conta_financ

union all

select obter_desc_expressao(330788,null) ds_tipo,
obter_conta_financ_cheque_cr(a.nr_seq_cheque, 6) cd_conta_financ,
b.ds_conta_financ ds_conta_financ,
a.dt_devolucao dt_referencia,
a.nr_seq_cheque
from   conta_financeira b,
cheque_cr a
where  a.dt_devolucao is not null
and    obter_conta_financ_cheque_cr(a.nr_seq_cheque, 6) = b.cd_conta_financ;
