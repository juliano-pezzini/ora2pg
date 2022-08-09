-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_departamento_desejado (nr_seq_agenda_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_depto_medico_w		integer;
cd_setor_atendimento_w	integer;


BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then

	select	coalesce(max(cd_depto_medico),0),
			coalesce(max(cd_setor_atendimento),0)
	into STRICT	cd_depto_medico_w,
			cd_setor_atendimento_w
	from	agenda_paciente_auxiliar
	where 	nr_seq_agenda = nr_seq_agenda_p;

	if ((cd_depto_medico_w <> 0) or (cd_setor_atendimento_w <> 0)) then
		update 	gestao_vaga
		set 	cd_departamento_desejado = cd_depto_medico_w,
				cd_setor_desejado = cd_setor_atendimento_w
		where	nr_seq_agenda = nr_seq_agenda_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_departamento_desejado (nr_seq_agenda_p bigint, nm_usuario_p text) FROM PUBLIC;
