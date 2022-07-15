-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_atualizar_obs_agenda (ds_observacao_p text, ie_tipo_p text, nr_seq_agenda_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
BEGIN

if (ie_tipo_p = 'E') then
	update	agenda_paciente
	set	ds_observacao 	= substr(ds_observacao_p,1,4000),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia 	= nr_seq_agenda_p;
else
	update	agenda_consulta
	set	ds_observacao 	= substr(ds_observacao_p,1,4000),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia 	= nr_seq_agenda_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_atualizar_obs_agenda (ds_observacao_p text, ie_tipo_p text, nr_seq_agenda_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

