-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW interf_envio_amil_v (tp_registro, cd_registro, cd_prestador, dt_referencia, qt_consulta, vl_consulta, qt_exames, vl_exames, qt_lpi, vl_lpi, cd_beneficiario, dt_item, cd_item, nr_crm, vl_item, dt_sessao, qt_sessao, vl_total_item, dt_geracao_arquivo, qt_total_reg, nr_seq_protocolo) AS select
	1					tp_registro,
	0					cd_registro,
	somente_numero(a.cd_interno)		cd_prestador,
	b.dt_mesano_referencia			dt_referencia,
   	sum(CASE WHEN c.cd_area_proc=1 THEN c.qt_item WHEN c.cd_area_proc=11 THEN c.qt_item  ELSE 0 END ) qt_consulta,
	sum(CASE WHEN c.cd_area_proc=1 THEN c.vl_total_item WHEN c.cd_area_proc=11 THEN c.vl_total_item  ELSE 0 END ) vl_consulta,
   	sum(CASE WHEN c.cd_area_proc=2 THEN c.qt_item WHEN c.cd_area_proc=3 THEN c.qt_item WHEN c.cd_area_proc=14 THEN c.qt_item WHEN c.cd_area_proc=12 THEN c.qt_item  ELSE 0 END ) qt_exames,
	sum(CASE WHEN c.cd_area_proc=2 THEN c.vl_total_item WHEN c.cd_area_proc=3 THEN c.vl_total_item WHEN c.cd_area_proc=14 THEN c.vl_total_item WHEN c.cd_area_proc=12 THEN c.vl_total_item  ELSE 0 END ) vl_exames,
   	sum(CASE WHEN c.ie_total_interf IS NULL THEN 0  ELSE (CASE WHEN c.cd_area_proc=4 THEN c.qt_item WHEN c.cd_area_proc=13 THEN c.qt_item  ELSE 0 END ) END ) qt_lpi,
   	sum(CASE WHEN c.ie_total_interf IS NULL THEN 0  ELSE (CASE WHEN c.cd_area_proc=4 THEN c.vl_total_item WHEN c.cd_area_proc=13 THEN c.vl_total_item  ELSE 0 END ) END ) vl_lpi,
	0					cd_beneficiario,
	LOCALTIMESTAMP					dt_item,
	0					cd_item,
	0					nr_crm,
	0					vl_item,
	LOCALTIMESTAMP				dt_sessao,
	0					qt_sessao,
	0					vl_total_item,
	LOCALTIMESTAMP					dt_geracao_arquivo,
	0					qt_total_reg,
	a.nr_seq_protocolo		nr_seq_protocolo
FROM	protocolo_convenio b,
	w_interf_conta_header a,
	w_interf_conta_item c
where	c.nr_seq_protocolo	= b.nr_seq_protocolo
and	c.nr_seq_protocolo	= a.nr_seq_protocolo
group	by
	somente_numero(a.cd_interno),
	b.dt_mesano_referencia,
	a.nr_seq_protocolo

union all

 /* Detalhe */

select
	2					tp_registro,
	2					cd_registro,
	somente_numero(a.cd_interno)	cd_prestador,
	LOCALTIMESTAMP				dt_referencia,
	0					qt_consulta,
	0					vl_consulta,
	0					qt_exames,
	0					vl_exames,
	0					qt_lpi,
	0					vl_lpi,
	coalesce(somente_numero(b.cd_usuario_convenio),0) cd_beneficiario,
	trunc(c.dt_item)			dt_item,
	somente_numero(c.cd_item_convenio)	cd_item,
	coalesce(somente_numero(c.nr_crm_executor),0)
						nr_crm,
	(sum(c.vl_total_item) / sum(CASE WHEN c.qt_item=0 THEN 1  ELSE c.qt_item END )) vl_item,
	trunc(CASE WHEN c.cd_item=25040014 THEN c.dt_item WHEN c.cd_item=25070037 THEN c.dt_item WHEN c.cd_item=25040030 THEN c.dt_item WHEN c.cd_item=23006021 THEN c.dt_item  ELSE LOCALTIMESTAMP END ) dt_sessao,
	sum(CASE WHEN c.cd_item=25040014 THEN c.qt_item WHEN c.cd_item=25070037 THEN c.qt_item WHEN c.cd_item=25040030 THEN c.qt_item WHEN c.cd_item=23006021 THEN c.qt_item  ELSE 0 END ) qt_sessao,
	sum(c.vl_total_item)		vl_total_item,
	LOCALTIMESTAMP				dt_geracao_arquivo,
	0					qt_total_reg,
	a.nr_seq_protocolo		nr_seq_protocolo
from	w_interf_conta_header a,
	w_interf_conta_cab b,
	w_interf_conta_item c
where	c.nr_seq_protocolo	= a.nr_seq_protocolo
and	c.nr_interno_conta	= b.nr_interno_conta
group	by
	somente_numero(a.cd_interno),
	coalesce(somente_numero(b.cd_usuario_convenio),0),
	trunc(c.dt_item),
	somente_numero(c.cd_item_convenio),
	coalesce(somente_numero(c.nr_crm_executor),0),
	trunc(CASE WHEN c.cd_item=25040014 THEN c.dt_item WHEN c.cd_item=25070037 THEN c.dt_item WHEN c.cd_item=25040030 THEN c.dt_item WHEN c.cd_item=23006021 THEN c.dt_item  ELSE LOCALTIMESTAMP END ),
	a.nr_seq_protocolo
 
union all

 /* Trailler */

select
	3					tp_registro,
	4					cd_registro,
	0					cd_prestador,
	LOCALTIMESTAMP					dt_referencia,
	0					qt_consulta,
	0					vl_consulta,
	0					qt_exames,
	0					vl_exames,
	0					qt_lpi,
	0					vl_lpi,
	0					cd_beneficiario,
	LOCALTIMESTAMP					dt_item,
	0					cd_item,
	0					nr_crm,
	0					vl_item,
	LOCALTIMESTAMP				dt_sessao,
	0					qt_sessao,
	0					vl_total_item,
	a.dt_remessa				dt_geracao_arquivo,
	0					qt_total_reg,
	a.nr_seq_protocolo
from	w_interf_conta_header a;
