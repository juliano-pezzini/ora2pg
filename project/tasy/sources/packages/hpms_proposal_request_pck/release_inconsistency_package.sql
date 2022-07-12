-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hpms_proposal_request_pck.release_inconsistency ( nr_seq_inconsistencia_p pls_proposta_on_inconsist.nr_sequencia%type, ds_observacao_p pls_proposta_on_inconsist.ds_observacao_liberacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

qt_nao_liberacao_w smallint;
nr_seq_prop_online_w  pls_proposta_online.nr_sequencia%type;


BEGIN

	update	pls_proposta_on_inconsist
	set	nm_usuario_liberacao = nm_usuario_p,
		dt_liberacao = clock_timestamp(),
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		ds_observacao_liberacao = ds_observacao_p
	where	nr_sequencia = nr_seq_inconsistencia_p;

	select	nr_seq_proposta
	into STRICT	nr_seq_prop_online_w
	from	pls_proposta_on_inconsist
	where	nr_sequencia = nr_seq_inconsistencia_p;

	insert into pls_proposta_hist_online(nr_sequencia, nr_seq_prop_online, dt_atualizacao,
						dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec, 
						dt_criacao, ie_tipo_historico, dt_liberacao, ds_historico)
	values (nextval('pls_proposta_hist_online_seq'), nr_seq_prop_online_w, clock_timestamp(),
					clock_timestamp(), nm_usuario_p, nm_usuario_p, clock_timestamp(), 'LI', clock_timestamp(), ds_observacao_p);

	select	count(1)
	into STRICT	qt_nao_liberacao_w
	from	pls_proposta_on_inconsist
	where	coalesce(dt_liberacao::text, '') = ''
	and	nr_seq_proposta = nr_seq_prop_online_w;

	if (qt_nao_liberacao_w = 0) then
		update	pls_proposta_online
		set	ie_status = 'A',
			dt_validacao = clock_timestamp(),
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p 
		where	nr_sequencia = nr_seq_prop_online_w;
	end if;

	commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hpms_proposal_request_pck.release_inconsistency ( nr_seq_inconsistencia_p pls_proposta_on_inconsist.nr_sequencia%type, ds_observacao_p pls_proposta_on_inconsist.ds_observacao_liberacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
