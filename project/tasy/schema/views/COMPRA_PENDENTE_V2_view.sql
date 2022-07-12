-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW compra_pendente_v2 (ie_tipo_documento, nr_documento, cd_material, qt_compra, cd_estabelecimento, ds_documento) AS select 	/*+ INDEX(b ORDCOMP_ESTABEL_FK_I) */	'O' ie_tipo_documento, 
	b.nr_ordem_compra nr_documento,	 
	a.cd_material,	 
	sum(coalesce(c.qt_prevista_entrega,-0)) - sum(coalesce(c.qt_real_entrega,0)) qt_compra,	 
	b.cd_estabelecimento, 
	'Ordem de compra' ds_documento 
FROM 	parametro_compras p, 
	ordem_compra b, 
	ordem_compra_item a, 
	ordem_compra_item_entrega c 
where 	p.cd_estabelecimento	= b.cd_estabelecimento 
and 	a.nr_ordem_compra	= b.nr_ordem_compra 
and 	a.nr_ordem_compra	= c.nr_ordem_compra 
and	a.nr_item_oci		= c.nr_item_oci 
and	b.dt_baixa 		is null 
and	c.dt_cancelamento 	is null 
and	b.nr_seq_motivo_cancel 	is null 
and (coalesce(c.qt_prevista_entrega,0) - coalesce(c.qt_real_entrega,0)) > 0 
and CASE WHEN p.ie_data_base_compra_pend='DT_ATUALIZACAO' THEN  a.dt_atualizacao WHEN p.ie_data_base_compra_pend='DT_ORDEM_COMPRA' THEN  b.dt_ordem_compra WHEN p.ie_data_base_compra_pend='DT_ENTREGA' THEN  b.dt_entrega END  > LOCALTIMESTAMP - coalesce(p.qt_dia_compra_pend, 180)and	coalesce(ie_ordem_pendente,'S') = 'S' 
group by	b.nr_ordem_compra, 
	a.cd_material,	 
	b.cd_estabelecimento 

union
 
select	/*+ INDEX(b SOLCOMP_ESTABEL_FK_I) INDEX (a SOCOITE_SOLCOMP_FK_I) */ 
	'S' ie_tipo_documento, 
	b.nr_solic_compra, 
	a.cd_material, 
	coalesce(sum(c.qt_entrega_solicitada),0),	 
	b.cd_estabelecimento, 
	'Solicitação de compra' ds_documento 
from 	parametro_compras p, 
	solic_compra b, 
	Solic_compra_item a, 
	solic_compra_item_entrega c 
where 	p.cd_estabelecimento	= b.cd_estabelecimento 
and	a.nr_cot_compra		is null 
and	a.nr_solic_compra	= b.nr_solic_compra 
and	a.nr_solic_compra	= c.nr_solic_compra 
and	a.nr_item_solic_compra	= c.nr_item_solic_compra 
and	a.dt_baixa		is null 
and	b.dt_baixa		is null 
and	a.dt_atualizacao > LOCALTIMESTAMP - coalesce(p.qt_dia_compra_pend, 180) 
and	coalesce(ie_solic_pendente,'S') = 'S' 
group by b.nr_solic_compra, 
	a.cd_material, 
	b.cd_estabelecimento 

union
 
select /*+ INDEX(a solcomp_materia_fk_i) */	 
	'C' ie_tipo_documento, 
	d.nr_cot_compra, 
	a.cd_material, 
	coalesce(sum(a.qt_material),0),	 
	b.cd_estabelecimento, 
	'Cotação de compra' ds_documento 
from 	parametro_compras p, 
	Solic_Compra b, 
	Solic_compra_item a, 
	cot_compra_item d, 
	cot_compra e, 
	solic_compra_item_entrega c 
where	p.cd_estabelecimento	= b.cd_estabelecimento 
and	a.nr_cot_compra		= d.nr_cot_compra 
and	a.nr_item_cot_compra	= d.nr_item_cot_compra 
and	a.nr_solic_compra	= b.nr_solic_compra 
and	e.nr_cot_compra		= d.nr_cot_compra 
and	a.dt_baixa		is null 
and	b.dt_baixa		is null 
and	a.nr_solic_compra	= c.nr_solic_compra 
and	a.nr_item_solic_compra	= c.nr_item_solic_compra 
and	e.nr_seq_motivo_cancel	is null 
and	coalesce(d.ie_situacao,'A') = 'A' 
and	a.dt_atualizacao > LOCALTIMESTAMP - coalesce(p.qt_dia_compra_pend, 180) 
and	coalesce(ie_cotacao_pendente,'S') = 'S' 
and	not exists ( 
   	select	1 
   	from	ordem_compra_item x 
	where	a.nr_solic_compra	= x.nr_solic_compra 
	and	a.nr_item_solic_compra	= x.nr_item_solic_compra) 
group by d.nr_cot_compra, 
	a.cd_material, 
	b.cd_estabelecimento;
