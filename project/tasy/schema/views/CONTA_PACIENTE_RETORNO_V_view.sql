-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW conta_paciente_retorno_v (nr_seq_protocolo, nr_atendimento, nr_interno_conta, cd_convenio_parametro, dt_mesano_referencia, dt_mesano_contabil, cd_autorizacao, vl_guia, vl_convenio, dt_convenio, ie_situacao_guia, nr_seq_retorno, vl_pago, vl_glosado, vl_adicional, vl_amenor, ie_glosa, cd_motivo_glosa, ds_motivo_glosa, ds_convenio, ie_status_retorno) AS select	a.nr_seq_protocolo,
	a.nr_atendimento,
	a.nr_interno_conta,
	a.cd_convenio_parametro,
	a.dt_mesano_referencia,
	a.dt_mesano_contabil,
	b.cd_autorizacao,
	b.vl_guia,
	b.vl_convenio,
	b.dt_convenio,
	b.ie_situacao_guia,
	c.nr_seq_retorno,
	c.vl_pago,
	c.vl_glosado,
	c.vl_adicional,
	c.vl_amenor,
	c.ie_glosa,
	c.cd_motivo_glosa,
	obter_valor_dominio(1033,c.cd_motivo_glosa) ds_motivo_glosa,
	e.ds_convenio,
	d.ie_status_retorno
FROM	convenio e,
	convenio_retorno d,
	convenio_retorno_item c,
	conta_paciente_guia b,
	conta_paciente a
where	a.nr_interno_conta = b.nr_interno_conta
  and	b.nr_interno_conta = c.nr_interno_conta
  and b.cd_autorizacao = c.cd_autorizacao
  and c.nr_seq_retorno = d.nr_sequencia
  and d.cd_convenio = e.cd_convenio;
