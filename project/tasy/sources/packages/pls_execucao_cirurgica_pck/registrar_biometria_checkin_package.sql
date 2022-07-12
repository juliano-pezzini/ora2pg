-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_execucao_cirurgica_pck.registrar_biometria_checkin ( nr_seq_exec_cirurgica_p pls_execucao_cirurgica.nr_sequencia%type, cd_medico_p pessoa_fisica.cd_pessoa_fisica%type, cd_biometria_p text, cd_token_p text, nr_seq_regra_lib_bio_exec_p pls_regra_lib_bio_exec.nr_sequencia%type, nr_seq_cbo_saude_p pls_exec_cirurg_biometria.nr_seq_cbo_saude%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_exec_cirurg_biometria_p INOUT pls_exec_cirurg_biometria.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Gerar o registro de biometria do profissional.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_checkin_w			varchar(1);
ie_checkout_w			varchar(1);
qt_guia_checkin_w		integer;
nr_seq_exec_cirurgica_guia_w	pls_exec_cirurgica_guia.nr_sequencia%type;


BEGIN

SELECT * FROM pls_execucao_cirurgica_pck.obter_se_checkin_checkout(nr_seq_exec_cirurgica_p, cd_medico_p, ie_checkin_w, ie_checkout_w) INTO STRICT ie_checkin_w, ie_checkout_w;

if (ie_checkin_w = 'S') then
	insert into 	pls_exec_cirurg_biometria(	nr_sequencia, cd_estabelecimento, dt_atualizacao_nrec,
							dt_atualizacao, nm_usuario_nrec, nm_usuario,
							cd_medico, dt_check_in, nr_seq_exec_cirurgica,
							cd_biometria_check_in, ie_situacao, nr_seq_regra_lib_bio_exec, nr_seq_cbo_saude)
					values (	nextval('pls_exec_cirurg_biometria_seq'), cd_estabelecimento_p, clock_timestamp(),
							clock_timestamp(), nm_usuario_p, nm_usuario_p,
							cd_medico_p, clock_timestamp(), nr_seq_exec_cirurgica_p,
							cd_biometria_p, 'A', nr_seq_regra_lib_bio_exec_p, nr_seq_cbo_saude_p) returning nr_sequencia into nr_seq_exec_cirurg_biometria_p;
							
	select	count(1)
	into STRICT	qt_guia_checkin_w
	from	pls_exec_cirurgica_guia
	where	nr_seq_exec_cirurgica	= nr_seq_exec_cirurgica_p
	and	ie_status		<> 'F'
	and	(dt_inicio_check_in IS NOT NULL AND dt_inicio_check_in::text <> '');
							
	if (qt_guia_checkin_w = 0) then	
		select	min(nr_sequencia)
		into STRICT	nr_seq_exec_cirurgica_guia_w
		from	pls_exec_cirurgica_guia
		where	nr_seq_exec_cirurgica	= nr_seq_exec_cirurgica_p
		and	ie_status		<> 'F';
							
		update	pls_exec_cirurgica_guia
		set	dt_inicio_check_in	= clock_timestamp(),
			ie_status		= 'E',
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_sequencia		= nr_seq_exec_cirurgica_guia_w;
		
		update	pls_exec_cirurgica_guia
		set	ie_status		= 'E',
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_seq_exec_cirurgica	= nr_seq_exec_cirurgica_p
		and	ie_status		= 'A';
			
		update	pls_execucao_cirurgica
		set	ie_status			= 'E',
			dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p,
			dt_primeira_execucao_proc	= clock_timestamp()
		where	nr_sequencia			= nr_seq_exec_cirurgica_p
		and	ie_status			= 'A';

		--Registrado o inicio de checkin na guia cirurgica #@NR_SEQ_GUIA#@ em #@DT_CHECKIN#@.
		CALL pls_execucao_cirurgica_pck.gerar_log_exec_cirurgica(nr_seq_exec_cirurgica_p, wheb_mensagem_pck.get_texto(1148126,'NR_SEQ_GUIA=' || nr_seq_exec_cirurgica_guia_w || ';' || 'DT_CHECKIN=' || clock_timestamp()), cd_estabelecimento_p, nm_usuario_p);
	end if;
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_execucao_cirurgica_pck.registrar_biometria_checkin ( nr_seq_exec_cirurgica_p pls_execucao_cirurgica.nr_sequencia%type, cd_medico_p pessoa_fisica.cd_pessoa_fisica%type, cd_biometria_p text, cd_token_p text, nr_seq_regra_lib_bio_exec_p pls_regra_lib_bio_exec.nr_sequencia%type, nr_seq_cbo_saude_p pls_exec_cirurg_biometria.nr_seq_cbo_saude%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_exec_cirurg_biometria_p INOUT pls_exec_cirurg_biometria.nr_sequencia%type) FROM PUBLIC;
