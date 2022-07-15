-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_alerta_paciente ( nr_sequencia_p bigint, ie_opcao_p text, ds_justificativa_p text default null, nm_usuario_p text DEFAULT NULL) AS $body$
BEGIN
if (ie_opcao_p = 'LIB') then
	update 	Alerta_paciente
	set	dt_liberacao = clock_timestamp()
	where    nr_sequencia = nr_sequencia_p;
elsif (ie_opcao_p = 'INA') then
	if (ds_justificativa_p IS NOT NULL AND ds_justificativa_p::text <> '') then
		update 	Alerta_paciente
		set	dt_inativacao = clock_timestamp(),
			nm_usuario_inativacao = nm_usuario_p,
			ie_situacao = 'I',
			ds_justificativa = ds_justificativa_p
		where	nr_sequencia = nr_sequencia_p;
	else
		update 	Alerta_paciente
		set	dt_inativacao = clock_timestamp(),
			nm_usuario_inativacao = nm_usuario_p,
			ie_situacao = 'I'
		where	nr_sequencia = nr_sequencia_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_alerta_paciente ( nr_sequencia_p bigint, ie_opcao_p text, ds_justificativa_p text default null, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;

