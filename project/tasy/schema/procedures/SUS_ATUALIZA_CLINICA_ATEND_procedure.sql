-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_atualiza_clinica_atend ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_interno_w		sus_laudo_paciente.nr_seq_interno%type;
ie_clinica_w			sus_laudo_paciente.ie_clinica%type := 0;


BEGIN

begin
select 	max(nr_seq_interno)
into STRICT	nr_seq_interno_w
from	sus_laudo_paciente
where	nr_atendimento = nr_atendimento_p
and	ie_tipo_laudo_sus = 0
and	(ie_clinica IS NOT NULL AND ie_clinica::text <> '');
exception
when others then
	nr_seq_interno_w := 0;
end;

if (coalesce(nr_seq_interno_w,0) > 0) then
	begin

	begin
	select	ie_clinica
	into STRICT	ie_clinica_w
	from	sus_laudo_paciente
	where	nr_seq_interno = nr_seq_interno_w;
	exception
	when others then
		ie_clinica_w := 0;
	end;

	if (coalesce(ie_clinica_w,0) > 0) then
		begin

		update 	atendimento_paciente
		set 	ie_clinica 	= ie_clinica_w,
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where 	nr_atendimento	= nr_atendimento_p;

		commit;

		end;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_atualiza_clinica_atend ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

