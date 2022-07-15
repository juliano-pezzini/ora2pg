-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_inconsistencia_agenda ( nr_seq_agenda_p bigint, ie_permite_p text, ie_tipo_p text, ds_inconsistencia_p text, nm_objeto_p text, nm_usuario_p text) AS $body$
DECLARE


ds_origem_w	varchar(255);


BEGIN

begin

insert	into	agenda_pac_inconsistencia(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_agenda,
						ie_permite,
						ie_tipo_inconsistencia,
						ds_inconsistencia,
						nm_objeto)
values (nextval('agenda_pac_inconsistencia_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_agenda_p,
		ie_permite_p,
		ie_tipo_p,
		ds_inconsistencia_p,
		nm_objeto_p);

commit;

exception
when others then
	ds_origem_w	:= '';
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_inconsistencia_agenda ( nr_seq_agenda_p bigint, ie_permite_p text, ie_tipo_p text, ds_inconsistencia_p text, nm_objeto_p text, nm_usuario_p text) FROM PUBLIC;

