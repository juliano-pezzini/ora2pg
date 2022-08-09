-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativar_atend_perda_ganho (nm_usuario_p text, ds_justificativa_p text, nr_sequencia_p bigint) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	update	atendimento_perda_ganho
	set	ie_situacao = 'I',
		dt_inativacao = clock_timestamp(),
		nm_usuario_inativacao = nm_usuario_p,
		ds_justificativa = ds_justificativa_p
	where	nr_sequencia = nr_sequencia_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativar_atend_perda_ganho (nm_usuario_p text, ds_justificativa_p text, nr_sequencia_p bigint) FROM PUBLIC;
