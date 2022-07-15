-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agecons_insere_se_med_ciente ( ds_observacao_p text, ie_ciente_p text, cd_agenda_p bigint, dt_agenda_p timestamp, nm_usuario_p text) AS $body$
DECLARE



nr_sequencia_w		bigint;


BEGIN

select	nextval('agenda_medico_ciente_seq')
into STRICT	nr_sequencia_w
;

	begin

	insert into	agenda_medico_ciente(
						cd_agenda,
						dt_agenda,
						dt_atualizacao,
						dt_contato,
						ie_ciente,
						nm_usuario,
						nr_sequencia,
						ds_observacao,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						ie_situacao
						)
					values (
						cd_agenda_p,
						dt_agenda_p,
						clock_timestamp(),
						clock_timestamp(),
						ie_ciente_p,
						nm_usuario_p,
						nr_sequencia_w,
						ds_observacao_p,
						clock_timestamp(),
						nm_usuario_p,
						'A'
						);
	end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agecons_insere_se_med_ciente ( ds_observacao_p text, ie_ciente_p text, cd_agenda_p bigint, dt_agenda_p timestamp, nm_usuario_p text) FROM PUBLIC;

