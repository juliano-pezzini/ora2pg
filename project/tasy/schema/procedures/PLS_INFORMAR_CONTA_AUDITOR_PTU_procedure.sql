-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_informar_conta_auditor_ptu ( nr_seq_grupo_membro_med_p pls_conta_auditor.nr_seq_grupo_membro_med%type, nr_seq_grupo_membro_enf_p pls_conta_auditor.nr_seq_grupo_membro_enf%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p text, ie_toda_analise_p text) AS $body$
DECLARE


nr_seq_conta_aud_w		pls_conta_auditor.nr_sequencia%type;

C01 CURSOR(nr_seq_analise_pc	pls_analise_conta.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_conta,
		(SELECT	max(nr_sequencia)
		 from	pls_conta_auditor
		 where	nr_seq_conta = a.nr_sequencia
		 and	nr_seq_analise = a.nr_seq_analise) nr_seq_conta_aud
	from	pls_conta a
	where	a.nr_seq_analise = nr_seq_analise_pc;

BEGIN
if (ie_toda_analise_p = 'S') then

	for r_C01_w in C01(nr_seq_analise_p) loop

		if (r_C01_w.nr_seq_conta_aud IS NOT NULL AND r_C01_w.nr_seq_conta_aud::text <> '') then
			update	pls_conta_auditor
			set	nr_seq_grupo_membro_med	= nr_seq_grupo_membro_med_p,
				nr_seq_grupo_membro_enf	= nr_seq_grupo_membro_enf_p,
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	nr_sequencia		= r_C01_w.nr_seq_conta_aud;
		else
			insert into pls_conta_auditor(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_conta,
				nr_seq_grupo_membro_med,
				nr_seq_grupo_membro_enf,
				nr_seq_analise)
			values (	nextval('pls_conta_auditor_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				r_C01_w.nr_seq_conta,
				nr_seq_grupo_membro_med_p,
				nr_seq_grupo_membro_enf_p,
				nr_seq_analise_p);
		end if;

		commit;
	end loop;
else
	select	max(nr_sequencia)
	into STRICT	nr_seq_conta_aud_w
	from	pls_conta_auditor
	where	nr_seq_conta	= nr_seq_conta_p
	and	nr_seq_analise	= nr_seq_analise_p;

	if (nr_seq_conta_aud_w IS NOT NULL AND nr_seq_conta_aud_w::text <> '') then
		update	pls_conta_auditor
		set	nr_seq_grupo_membro_med	= nr_seq_grupo_membro_med_p,
			nr_seq_grupo_membro_enf	= nr_seq_grupo_membro_enf_p,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_sequencia		= nr_seq_conta_aud_w;
	else
		insert into pls_conta_auditor(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_conta,
			nr_seq_grupo_membro_med,
			nr_seq_grupo_membro_enf,
			nr_seq_analise)
		values (	nextval('pls_conta_auditor_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_conta_p,
			nr_seq_grupo_membro_med_p,
			nr_seq_grupo_membro_enf_p,
			nr_seq_analise_p);
	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_informar_conta_auditor_ptu ( nr_seq_grupo_membro_med_p pls_conta_auditor.nr_seq_grupo_membro_med%type, nr_seq_grupo_membro_enf_p pls_conta_auditor.nr_seq_grupo_membro_enf%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p text, ie_toda_analise_p text) FROM PUBLIC;
