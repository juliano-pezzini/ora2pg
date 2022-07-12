-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_chamado_pck.enviar_parecer_chamado ( nr_seq_chamado_etapa_p pls_chamado_etapa.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

insert	into	pls_chamado_historico(	nr_sequencia,
		nr_seq_chamado,
		nr_seq_tipo_historico,
		ds_historico,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_liberacao)
	(SELECT	nextval('pls_chamado_historico_seq'),
		b.nr_seq_chamado,
		a.nr_seq_tipo_historico,
		a.ds_historico,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp()
	from	pls_chamado_etapa_hist	a,
		pls_chamado_etapa	b,
		pls_tipo_historico_chamado c
	where	b.nr_sequencia	= a.nr_seq_chamado_etapa
	and	c.nr_sequencia	= a.nr_seq_tipo_historico
	and	c.ie_historico_chamado = 'S'
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	b.nr_sequencia	= nr_seq_chamado_etapa_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_chamado_pck.enviar_parecer_chamado ( nr_seq_chamado_etapa_p pls_chamado_etapa.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
