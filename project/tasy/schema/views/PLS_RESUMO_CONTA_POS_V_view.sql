-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_resumo_conta_pos_v (ie_ordem, ie_ordem_titulo, nr_sequencia, nr_seq_conta, nr_seq_item, nr_seq_analise, ie_tipo_item, ds_item_despesa, cd_item, ds_tipo_despesa, vl_calculado, vl_total, nr_seq_conta_proc, nr_seq_conta_mat, nr_seq_partic_proc) AS select	CASE WHEN ds_tipo_despesa='P1' THEN '1' WHEN ds_tipo_despesa='P2' THEN '3' WHEN ds_tipo_despesa='P3' THEN '2' WHEN ds_tipo_despesa='P4' THEN '4' WHEN ds_tipo_despesa='M1' THEN '6' WHEN ds_tipo_despesa='M2' THEN '5' WHEN ds_tipo_despesa='M3' THEN '7' END  ie_ordem,
	0 ie_ordem_titulo,
	nr_sequencia,
	nr_seq_conta,
	nr_seq_item,
	nr_seq_analise,
	ie_tipo_item,
	substr(CASE WHEN coalesce(coalesce(pls_obter_cod_mat_analise(cd_item, ds_tipo_despesa),cd_item),0)=0 THEN InitCap(pls_obter_desc_item_desp(ds_tipo_despesa, 'S'))||' não reconhecido.'  ELSE ds_item END ,1,255) ds_item_despesa,
	cd_item,
	ds_tipo_despesa,
	vl_calculado,
	vl_total,
	nr_seq_conta_proc,
	nr_seq_conta_mat,
	nr_seq_partic_proc
FROM	w_pls_resumo_conta
where	ie_tipo_item = 'P'

union all

select	CASE WHEN ds_tipo_despesa='P1' THEN '1' WHEN ds_tipo_despesa='P2' THEN '3' WHEN ds_tipo_despesa='P3' THEN '2' WHEN ds_tipo_despesa='P4' THEN '4' WHEN ds_tipo_despesa='M1' THEN '6' WHEN ds_tipo_despesa='M2' THEN '5' WHEN ds_tipo_despesa='M3' THEN '7' END  ie_ordem,
	0 ie_ordem_titulo,
	nr_sequencia,
	nr_seq_conta,
	nr_seq_item,
	nr_seq_analise,
	ie_tipo_item,
	substr(CASE WHEN coalesce(coalesce(pls_obter_cod_mat_analise(cd_item, ds_tipo_despesa),cd_item),0)=0 THEN InitCap(pls_obter_desc_item_desp(ds_tipo_despesa, 'S'))||' não reconhecido.'  ELSE ds_item END ,1,255) ds_item_despesa,
	coalesce((substr(pls_obter_cod_mat_analise(cd_item, ds_tipo_despesa),1,20))::numeric ,cd_item) cd_item,
	ds_tipo_despesa,
	vl_calculado,
	vl_total,
	nr_seq_conta_proc,
	nr_seq_conta_mat,
	nr_seq_partic_proc
from	w_pls_resumo_conta y
where	ie_tipo_item = 'M'

union all

select	CASE WHEN ds_tipo_despesa='P1' THEN '1' WHEN ds_tipo_despesa='P2' THEN '3' WHEN ds_tipo_despesa='P3' THEN '2' WHEN ds_tipo_despesa='P4' THEN '4' WHEN ds_tipo_despesa='M1' THEN '6' WHEN ds_tipo_despesa='M2' THEN '5' WHEN ds_tipo_despesa='M3' THEN '7' END  ie_ordem,
	0 ie_ordem_titulo,
	nr_sequencia,
	nr_seq_conta,
	nr_seq_item,
	nr_seq_analise,
	ie_tipo_item,
	substr(pls_obter_desc_item_desp(ds_tipo_despesa, 'P'),1,255) ds_item_despesa,
	cd_item,
	ds_tipo_despesa,
	vl_calculado,
	vl_total,
	nr_seq_conta_proc,
	nr_seq_conta_mat,
	nr_seq_partic_proc
from	w_pls_resumo_conta y
where	ie_tipo_item = 'R';
