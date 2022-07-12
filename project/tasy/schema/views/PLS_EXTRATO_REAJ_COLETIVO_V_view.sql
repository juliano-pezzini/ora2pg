-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_extrato_reaj_coletivo_v (nr_seq_contrato, nr_seq_reaj_doc, dt_mes_reajuste, dt_liberacao_extrato, ds_titulo, ds_documentacao, ds_arquivo, nr_seq_relatorio, tx_reajuste, ie_status, ie_status_novo_portal) AS select	a.nr_seq_contrato, --Extrato vinculado a programacao de reajuste
	c.nr_sequencia nr_seq_reaj_doc,
	to_char(b.dt_mes_reajuste) dt_mes_reajuste,
	to_char(a.dt_liberacao_extrato, 'dd/MM/yyyy') dt_liberacao_extrato,
	CASE WHEN pls_obter_status_prog_reajuste(a.nr_sequencia)='L' THEN 'O reajuste aplicado em ' || to_char(b.dt_mes_reajuste,'mm/yyyy') || ' foi de '||a.tx_reajuste_programado||'%'  ELSE to_char(b.dt_mes_reajuste,'mm/yyyy') ||' - '|| obter_desc_expressao(323935) END  ds_titulo,
	c.ds_documentacao,
	c.ds_arquivo ds_arquivo,
	c.nr_seq_relatorio,
	to_char(a.tx_reajuste_programado) tx_reajuste,
	(select	max(x.ie_status)
	FROM	pls_reajuste x
	where	x.nr_sequencia = a.nr_seq_reajuste) ie_status,
	(select	coalesce(max(x.ie_status),'1')
	from	pls_reajuste x
	where	x.nr_sequencia = a.nr_seq_reajuste) ie_status_novo_portal
from	pls_prog_reaj_coletivo a,
	pls_prog_reaj_colet_lote b,
	pls_prog_reaj_documentacao c
where	a.nr_seq_lote	= b.nr_sequencia
and	a.nr_sequencia	= c.nr_seq_prog_reaj
and	coalesce(coalesce(a.ie_exibir_portal,b.ie_exibir_portal),'N') = 'S'

union all

select	a.nr_seq_contrato, --Extrato vinculado ao grupo de relacionamento
	e.nr_sequencia nr_seq_reaj_doc,
	to_char(b.dt_mes_reajuste) dt_mes_reajuste,
	to_char(a.dt_liberacao_extrato, 'dd/MM/yyyy') dt_liberacao_extrato,
	CASE WHEN pls_obter_status_prog_reajuste(a.nr_sequencia)='L' THEN 'O reajuste aplicado em ' || to_char(b.dt_mes_reajuste,'mm/yyyy') || ' foi de '||a.tx_reajuste_programado||'%'  ELSE to_char(b.dt_mes_reajuste,'mm/yyyy') ||' - '|| obter_desc_expressao(323935) END  ds_titulo,
	e.ds_documentacao,
	e.ds_arquivo ds_arquivo,
	e.nr_seq_relatorio,
	to_char(a.tx_reajuste_programado) tx_reajuste,
	(select	max(x.ie_status)
	from	pls_reajuste x
	where	x.nr_sequencia = a.nr_seq_reajuste) ie_status,
	(select	coalesce(max(x.ie_status),'1')
	from	pls_reajuste x
	where	x.nr_sequencia = a.nr_seq_reajuste) ie_status_novo_portal
from	pls_prog_reaj_coletivo a,
	pls_prog_reaj_colet_lote b,
	pls_contrato_grupo c,
	pls_grupo_contrato d,
	pls_prog_reaj_documentacao e
where	a.nr_seq_lote	= b.nr_sequencia
and	c.nr_seq_contrato = a.nr_seq_contrato
and	d.nr_sequencia	= c.nr_seq_grupo
and	d.nr_sequencia	= e.nr_seq_grupo_contrato
and	trunc(e.dt_reajuste,'mm') = trunc(a.dt_reajuste,'mm')
and	coalesce(coalesce(a.ie_exibir_portal,b.ie_exibir_portal),'N') = 'S'
and	not exists (	select	1
			from	pls_prog_reaj_documentacao x
			where	x.nr_seq_prog_reaj = a.nr_sequencia)

union all

select	a.nr_seq_contrato, --Extrato vinculado ao lote de programacao de reajuste
	c.nr_sequencia nr_seq_reaj_doc,
	to_char(b.dt_mes_reajuste) dt_mes_reajuste,
	to_char(a.dt_liberacao_extrato, 'dd/MM/yyyy') dt_liberacao_extrato,
	CASE WHEN pls_obter_status_prog_reajuste(a.nr_sequencia)='L' THEN 'O reajuste aplicado em ' || to_char(b.dt_mes_reajuste,'mm/yyyy') || ' foi de '||a.tx_reajuste_programado||'%'  ELSE to_char(b.dt_mes_reajuste,'mm/yyyy') ||' - '|| obter_desc_expressao(323935) END  ds_titulo,
	c.ds_documentacao,
	c.ds_arquivo ds_arquivo,
	c.nr_seq_relatorio,
	to_char(a.tx_reajuste_programado) tx_reajuste,
	(select	max(x.ie_status)
	from	pls_reajuste x
	where	x.nr_sequencia = a.nr_seq_reajuste) ie_status,
	(select	coalesce(max(x.ie_status),'1')
	from	pls_reajuste x
	where	x.nr_sequencia = a.nr_seq_reajuste) ie_status_novo_portal
from	pls_prog_reaj_coletivo a,
	pls_prog_reaj_colet_lote b,
	pls_prog_reaj_documentacao c
where	a.nr_seq_lote	= b.nr_sequencia
and	c.nr_seq_lote = b.nr_sequencia
and	coalesce(coalesce(a.ie_exibir_portal,b.ie_exibir_portal),'N') = 'S'
and	not exists (	select	1
			from	pls_prog_reaj_documentacao x
			where	x.nr_seq_prog_reaj = a.nr_sequencia)
and	not exists (	select	1
			from	pls_prog_reaj_documentacao x,
				pls_grupo_contrato y,
				pls_contrato_grupo z
			where	y.nr_sequencia	= x.nr_seq_grupo_contrato
			and	y.nr_sequencia	= z.nr_seq_grupo
			and	z.nr_seq_contrato = a.nr_seq_contrato
			and	trunc(x.dt_reajuste,'mm') = trunc(a.dt_reajuste,'mm'))

union all

select	c.nr_seq_contrato,
	a.nr_sequencia nr_seq_reaj_doc,
	to_char(b.dt_inicio_vigencia) dt_mes_reajuste,
	to_char(a.dt_liberacao_extrato, 'dd/MM/yyyy') dt_liberacao_extrato,
	pls_obter_mensagem_reaj_pool(c.nr_seq_contrato, b.dt_inicio_vigencia, b.dt_fim_vigencia, 'M') ds_titulo,
	a.ds_documentacao,
	a.ds_arquivo ds_arquivo,
	a.nr_seq_relatorio,
	pls_obter_mensagem_reaj_pool(c.nr_seq_contrato, b.dt_inicio_vigencia, b.dt_fim_vigencia, 'T') tx_reajuste,
	pls_obter_mensagem_reaj_pool(c.nr_seq_contrato, b.dt_inicio_vigencia, b.dt_fim_vigencia, 'S') ie_status,
	coalesce(pls_obter_mensagem_reaj_pool(c.nr_seq_contrato, b.dt_inicio_vigencia, b.dt_fim_vigencia, 'S'),'1') ie_status_novo_portal
from	pls_prog_reaj_documentacao a,
	pls_grupo_contrato b,
	pls_contrato_grupo c
where	b.nr_sequencia = a.nr_seq_grupo_contrato
and	b.nr_sequencia = c.nr_seq_grupo
and	coalesce(b.ie_exibir_portal, 'N') = 'S'
and	not exists (	select	1
			from	pls_prog_reaj_documentacao x
			where	x.nr_seq_contrato = c.nr_seq_contrato
			and	b.nr_sequencia = x.nr_seq_grupo_contrato)
and	a.nr_seq_contrato is null
and	b.ie_tipo_relacionamento = 4
and	b.ie_tipo_agrupamento_exclusivo = 1
and	pls_obter_dt_reaj_contrato(c.nr_seq_contrato, b.dt_inicio_vigencia, b.dt_fim_vigencia) between b.dt_inicio_vigencia and b.dt_fim_vigencia

union all

select	c.nr_seq_contrato,
	a.nr_sequencia nr_seq_reaj_doc,
	to_char(b.dt_inicio_vigencia) dt_mes_reajuste,
	to_char(a.dt_liberacao_extrato, 'dd/MM/yyyy') dt_liberacao_extrato,
	pls_obter_mensagem_reaj_pool(c.nr_seq_contrato, b.dt_inicio_vigencia, b.dt_fim_vigencia, 'M') ds_titulo,
	a.ds_documentacao,
	a.ds_arquivo ds_arquivo,
	a.nr_seq_relatorio,
	pls_obter_mensagem_reaj_pool(c.nr_seq_contrato, b.dt_inicio_vigencia, b.dt_fim_vigencia, 'T') tx_reajuste,
	pls_obter_mensagem_reaj_pool(c.nr_seq_contrato, b.dt_inicio_vigencia, b.dt_fim_vigencia, 'S') ie_status,
	coalesce(pls_obter_mensagem_reaj_pool(c.nr_seq_contrato, b.dt_inicio_vigencia, b.dt_fim_vigencia, 'S'),'1') ie_status_novo_portal
from	pls_prog_reaj_documentacao a,
	pls_grupo_contrato b,
	pls_contrato_grupo c
where	b.nr_sequencia = a.nr_seq_grupo_contrato
and	b.nr_sequencia = c.nr_seq_grupo
and	a.nr_seq_contrato = c.nr_seq_contrato
and	coalesce(b.ie_exibir_portal, 'N') = 'S'
and	b.ie_tipo_relacionamento = 4
and	b.ie_tipo_agrupamento_exclusivo = 1
and	pls_obter_dt_reaj_contrato(c.nr_seq_contrato, b.dt_inicio_vigencia, b.dt_fim_vigencia) between b.dt_inicio_vigencia and b.dt_fim_vigencia;
