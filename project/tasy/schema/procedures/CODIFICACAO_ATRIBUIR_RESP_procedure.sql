-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE codificacao_atribuir_resp ( nm_usuario_p text, nr_seq_grupo_p bigint, nr_seq_codificacao_p bigint, nm_resp_p text) AS $body$
BEGIN

if (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '') then

	update	codificacao_atendimento
	set		cd_grupo_atual 		= nr_seq_grupo_p,
			nm_responsavel 		= nm_resp_p,
			dt_atualizacao		 = clock_timestamp(),
			nm_usuario		 	= nm_usuario_p
	where	nr_sequencia 		= nr_seq_codificacao_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE codificacao_atribuir_resp ( nm_usuario_p text, nr_seq_grupo_p bigint, nr_seq_codificacao_p bigint, nm_resp_p text) FROM PUBLIC;

