-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_execucao_cirurgica_pck.registrar_biometria_checkout ( nr_seq_exec_cirurgica_p pls_execucao_cirurgica.nr_sequencia%type, cd_medico_p pessoa_fisica.cd_pessoa_fisica%type, cd_biometria_p text, cd_token_p text, nr_seq_regra_lib_bio_exec_p pls_regra_lib_bio_exec.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Gerar o registro de biometria do profissional.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_checkin_w	varchar(1);
ie_checkout_w	varchar(1);

C01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_exec_cirurg_bio,
		b.nr_sequencia nr_seq_cirurg_bio_partic
	from	pls_exec_cirurg_biometria a,
		pls_exec_cirurg_bio_partic b,
		pls_exec_cirurgica_proc c
	where	b.nr_seq_exec_cirurg_bio	= a.nr_sequencia
	and	b.nr_seq_exec_cirurg_proc	= c.nr_sequencia
	and	a.nr_seq_exec_cirurgica		= nr_seq_exec_cirurgica_p
	and	c.ie_finalizado			= 'N'
	and	a.ie_situacao			= 'A'
	and	(a.dt_check_in IS NOT NULL AND a.dt_check_in::text <> '')
	and	coalesce(a.dt_check_out::text, '') = ''
	and	a.cd_medico			= cd_medico_p;
	
BEGIN

SELECT * FROM pls_execucao_cirurgica_pck.obter_se_checkin_checkout(nr_seq_exec_cirurgica_p, cd_medico_p, ie_checkin_w, ie_checkout_w) INTO STRICT ie_checkin_w, ie_checkout_w;

if (ie_checkout_w = 'S') then
	for C01_w in C01 loop
		begin
			update	pls_exec_cirurg_biometria
			set	dt_check_out			= clock_timestamp(),
				cd_biometria_check_out		= cd_biometria_p,
				nr_seq_regra_lib_bio_exec	= nr_seq_regra_lib_bio_exec_p,
				dt_atualizacao			= clock_timestamp(),
				nm_usuario			= nm_usuario_p
			where	nr_sequencia			= C01_w.nr_seq_exec_cirurg_bio;
			
			update	pls_exec_cirurg_bio_partic
			set	ie_status			= 'F',
				dt_atualizacao			= clock_timestamp(),
				nm_usuario			= nm_usuario_p
			where	nr_sequencia			= C01_w.nr_seq_cirurg_bio_partic;

			update	pls_execucao_cirurgica
			set	dt_ultima_execucao_proc		= clock_timestamp(),
				dt_atualizacao			= clock_timestamp(),
				nm_usuario			= nm_usuario_p
			where	nr_sequencia			= nr_seq_exec_cirurgica_p;
		end;
	end loop;
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_execucao_cirurgica_pck.registrar_biometria_checkout ( nr_seq_exec_cirurgica_p pls_execucao_cirurgica.nr_sequencia%type, cd_medico_p pessoa_fisica.cd_pessoa_fisica%type, cd_biometria_p text, cd_token_p text, nr_seq_regra_lib_bio_exec_p pls_regra_lib_bio_exec.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
