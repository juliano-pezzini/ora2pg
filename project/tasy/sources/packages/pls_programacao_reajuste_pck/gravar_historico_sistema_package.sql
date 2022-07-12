-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_programacao_reajuste_pck.gravar_historico_sistema ( nr_seq_programacao_p pls_prog_reaj_coletivo.nr_sequencia%type, ds_historico_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

nr_seq_tipo_historico_w	pls_tipo_hist_reajuste.nr_sequencia%type;

BEGIN
if (ds_historico_p IS NOT NULL AND ds_historico_p::text <> '') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_tipo_historico_w
	from	pls_tipo_hist_reajuste
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	ie_padrao_sistema	= 'S';
	
	insert	into	pls_prog_reaj_historico(	nr_sequencia, nr_seq_programacao, nr_seq_tipo_historico, dt_liberacao,
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			ds_historico)
		values (	nextval('pls_prog_reaj_historico_seq'), nr_seq_programacao_p, nr_seq_tipo_historico_w, clock_timestamp(),
			clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
			ds_historico_p);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_programacao_reajuste_pck.gravar_historico_sistema ( nr_seq_programacao_p pls_prog_reaj_coletivo.nr_sequencia%type, ds_historico_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;