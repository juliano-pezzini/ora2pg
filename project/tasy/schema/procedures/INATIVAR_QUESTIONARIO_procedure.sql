-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativar_questionario (motivo_inativacao_p bigint, nm_usuario_p text, nr_sequencia_p bigint) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	update	mat_aval_quest
	set	ie_situacao = 'I',
		nr_seq_motivo_inat = motivo_inativacao_p,
		dt_inativacao = clock_timestamp(),
		nm_usuario_inat = nm_usuario_p
	where	nr_sequencia = nr_sequencia_p;
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativar_questionario (motivo_inativacao_p bigint, nm_usuario_p text, nr_sequencia_p bigint) FROM PUBLIC;
