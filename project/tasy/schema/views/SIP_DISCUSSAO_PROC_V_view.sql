-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW sip_discussao_proc_v (nr_seq_lote, nr_seq_discussao, nr_seq_discussao_proc, dt_mes_competencia, nr_seq_conta_proc, vl_liberado, qt_procedimento) AS select	a.nr_sequencia nr_seq_lote,
	b.nr_sequencia nr_seq_discussao,
	c.nr_sequencia nr_seq_discussao_proc,
	a.dt_fechamento dt_mes_competencia,
	c.nr_seq_conta_proc,
	c.vl_aceito vl_liberado,
	c.qt_aceita qt_procedimento
FROM	pls_lote_discussao		a,
	pls_contestacao_discussao	b,
	pls_discussao_proc		c
where	-- busca somente os lotes fechados
	a.ie_status = 'F'
	-- só aceita lotes de despesa
and (a.nr_titulo_pagar is not null or a.nr_titulo_pagar_ndr is not null)
and	b.nr_seq_lote		= a.nr_sequencia
	-- somente discussões encerradas
and	b.ie_status		= 'E'
and	c.nr_seq_discussao	= b.nr_sequencia
	-- somente que tenham gerado valores.
and	c.vl_aceito		> 0;
