-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_estornar_status_dia (dt_registro_p timestamp, nr_seq_inscrito_p bigint, ie_status_agenda_p text, nm_usuario_p text) AS $body$
BEGIN

update	tre_paciente_dia
set	ie_status_paciente = 'N',
	ds_motivo_status = CASE WHEN ie_status_paciente='I' THEN null  ELSE ds_motivo_status END
where	trunc(dt_registro) = trunc(dt_registro_p)
and	   	nr_seq_inscrito = nr_seq_inscrito_p;

if (ie_status_agenda_p in ('I','F')) then
	begin
	CALL tre_aplica_regra_falta(dt_registro_p, nr_seq_inscrito_p, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento);
	end;
end if;

if (ie_status_agenda_p in ('AD','E')) then
	begin
	update	tre_paciente_dia
	set	nr_atendimento  = NULL
	where	trunc(dt_registro) = dt_registro_p
	and	nr_seq_inscrito = nr_seq_inscrito_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_estornar_status_dia (dt_registro_p timestamp, nr_seq_inscrito_p bigint, ie_status_agenda_p text, nm_usuario_p text) FROM PUBLIC;

