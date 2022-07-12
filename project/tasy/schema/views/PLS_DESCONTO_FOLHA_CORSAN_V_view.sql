-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_desconto_folha_corsan_v (nr_seq_cobranca, tp_registro, cd_empresa, nr_cpf, cd_matricula, dt_arquivo, vl_cobranca) AS select	a.nr_seq_cobranca,
	1 tp_registro,
	coalesce(f.ie_empresa,'0001') cd_empresa,
	e.nr_cpf,
	9101 cd_matricula,
	to_char(g.dt_remessa_retorno,'yyyymm') dt_arquivo,
	lpad(replace(replace(campo_mascara_virgula(a.vl_cobranca),'.',''),',',''),16,'0') vl_cobranca
FROM	titulo_receber_cobr a,
	titulo_receber b,
	pls_mensalidade c,
	pls_contrato_pagador_fin d,
	pessoa_fisica e,
	pls_desc_empresa f,
	cobranca_escritural g
where	b.nr_titulo	= a.nr_titulo
and	c.nr_sequencia	= b.nr_seq_mensalidade
and	d.nr_sequencia	= c.nr_seq_pagador_fin
and	e.cd_pessoa_fisica = b.cd_pessoa_fisica
and	f.nr_sequencia	= d.nr_seq_empresa
and	g.nr_sequencia	= a.nr_seq_cobranca;

