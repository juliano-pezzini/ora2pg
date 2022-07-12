-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW umrs_ipe_pa_v (tp_registro, nr_seq_protocolo, nm_sistema, cd_cgc_hospital, qt_total_conta, qt_total_lancamento, cd_interno, nm_hospital, ds_espaco, ie_zeros, tp_nota, nr_folha, qt_lancamento, qt_matricula, cd_usuario_convenio, cd_prestador, tp_prestador, dt_referencia, nr_interno_conta, vl_total_conta, nr_linha, dt_item, cd_item_convenio, qt_item, vl_matmed, vl_total_matmed, nm_paciente) AS Select
	1				tp_registro,
	a.nr_seq_protocolo		nr_seq_protocolo,
	'SMH'				nm_sistema,
	a.cd_cgc_hospital		cd_cgc_hospital,
	max(c.nr_folha)		qt_total_conta,
	count(*)			qt_total_lancamento,
	somente_numero(coalesce(b.cd_interno,0))
					cd_interno,
	substr(a.nm_hospital,1,45)	nm_hospital,
	' '				ds_espaco,
	0				ie_zeros,
	0				tp_nota,
	0				nr_folha,
	0				qt_lancamento,
	0				qt_matricula,
	' '				cd_usuario_convenio,
	'0'				cd_prestador,
	3				tp_prestador,
	LOCALTIMESTAMP			dt_referencia,
	0				nr_interno_conta,
	0				vl_total_conta,
	0				nr_linha,
	LOCALTIMESTAMP			dt_item,
	0				cd_item_convenio,
	0				qt_item,
	0				vl_matmed,
	0				vl_total_matmed,
	' '				nm_paciente
FROM	w_interf_conta_item_ipe c,
	w_interf_conta_trailler b,
	w_interf_conta_header a
where	a.nr_seq_protocolo		= c.nr_seq_protocolo
and	a.nr_seq_protocolo		= b.nr_seq_protocolo
group by
	a.nr_seq_protocolo,
	a.cd_cgc_hospital,
	somente_numero(coalesce(b.cd_interno,0)),
	substr(a.nm_hospital,1,45)

union all

select
	2				tp_registro,
	c.nr_seq_protocolo		nr_seq_protocolo,
	'SMH'				nm_sistema,
	' '				cd_cgc_hospital,
	0				qt_total_conta,
	0				qt_total_lancamento,
	0				cd_interno,
	' '				nm_hospital,
	' '				ds_espaco,
	0 				ie_zeros,
	55				tp_nota,
	0				nr_folha,
	count(*)			qt_lancamento,
	01				qt_matricula,
	' '				cd_usuario_convenio,
	b.cd_interno		cd_prestador,
	3				tp_prestador,
	min(c.dt_item)		dt_referencia,
	c.nr_seq_conta_convenio	nr_interno_conta,
	sum(CASE WHEN c.ie_responsavel_credito='P' THEN c.vl_honorario  ELSE c.vl_total_item END )	vl_total_conta,
	0				nr_linha,
	LOCALTIMESTAMP			dt_item,
	0				cd_item_convenio,
	0				qt_item,
	0				vl_matmed,
	sum(CASE WHEN c.cd_item_convenio=98007530 THEN c.vl_total_item WHEN c.cd_item_convenio=98007963 THEN c.vl_total_item  ELSE 0 END )
					vl_total_matmed,
	' '				nm_paciente
from	protocolo_convenio d,
	w_interf_conta_trailler b,
	w_interf_conta_item_ipe c
where	c.nr_seq_protocolo		= d.nr_seq_protocolo
and	c.nr_seq_protocolo		= b.nr_seq_protocolo
group by
	c.nr_seq_protocolo,
	b.cd_interno,
	c.nr_seq_conta_convenio

union all

select
	3				tp_registro,
	c.nr_seq_protocolo		nr_seq_protocolo,
	'SMH'				nm_sistema,
	' '				cd_cgc_hospital,
	0				qt_total_conta,
	0 				qt_total_lancamento,
	0				cd_interno,
	' '				nm_hospital,
	' '				ds_espaco,
	0 				ie_zeros,
	55				tp_nota,
	0				nr_folha,
	0				qt_lancamento,
	0				qt_matricula,
	substr(b.cd_usuario_convenio,1,13)
					cd_usuario_convenio,
	CASE WHEN c.ie_responsavel_credito='cdii' THEN '87701249000374'  ELSE CASE WHEN c.ie_responsavel_credito='CDI' THEN '87701249000374'  ELSE to_char(c.cd_prestador) END  END  cd_prestador,
	3				tp_prestador,
	LOCALTIMESTAMP			dt_referencia,
	c.nr_seq_conta_convenio	nr_interno_conta,
	0				vl_total_conta,
	c.nr_linha			nr_linha,
	c.dt_item			dt_item,
	c.cd_item_convenio		cd_item_convenio,
	c.qt_item			qt_item,
	CASE WHEN c.cd_item_convenio=98007530 THEN c.vl_total_item WHEN c.cd_item_convenio=98007963 THEN c.vl_total_item  ELSE 0 END
					vl_matmed,
	0				vl_total_matmed,
	substr(b.nm_paciente,1,45)	nm_paciente
from	w_interf_conta_item_ipe c,
	w_interf_conta_cab b
where	b.nr_interno_conta		= c.nr_interno_conta;

