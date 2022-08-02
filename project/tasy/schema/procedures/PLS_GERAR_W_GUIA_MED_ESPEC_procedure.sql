-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_w_guia_med_espec (nm_usuario_p usuario.nm_usuario%type, nr_seq_guia_medico_p w_pls_guia_medico.nr_sequencia%type, cd_especialidade_p especialidade_medica.cd_especialidade%type ) AS $body$
BEGIN

if (nr_seq_guia_medico_p IS NOT NULL AND nr_seq_guia_medico_p::text <> '') then

	insert into w_pls_guia_med_espec(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_guia_medico,
		cd_especialidade)
	values (nextval('w_pls_guia_med_espec_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_guia_medico_p,
		cd_especialidade_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_w_guia_med_espec (nm_usuario_p usuario.nm_usuario%type, nr_seq_guia_medico_p w_pls_guia_medico.nr_sequencia%type, cd_especialidade_p especialidade_medica.cd_especialidade%type ) FROM PUBLIC;

