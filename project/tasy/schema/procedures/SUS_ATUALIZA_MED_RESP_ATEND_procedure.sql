-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_atualiza_med_resp_atend ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, ie_opcao_medico_p text, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE


nr_seq_interno_w		sus_laudo_paciente.nr_seq_interno%type;
cd_medico_requisitante_w	sus_laudo_paciente.cd_medico_requisitante%type;
cd_medico_responsavel_w		sus_laudo_paciente.cd_medico_responsavel%type;


BEGIN

if (ie_opcao_medico_p = 'Req') then
	begin

	begin
	select 	max(nr_seq_interno)
	into STRICT	nr_seq_interno_w
	from	sus_laudo_paciente
	where	nr_atendimento = nr_atendimento_p
	and	ie_tipo_laudo_sus = 0;
	exception
	when others then
		nr_seq_interno_w := 0;
	end;

	if (coalesce(nr_seq_interno_w,0) > 0) then
		begin

		begin
		select	cd_medico_requisitante
		into STRICT	cd_medico_requisitante_w
		from	sus_laudo_paciente
		where	nr_seq_interno = nr_seq_interno_w;
		exception
		when others then
			cd_medico_requisitante_w := 'X';
		end;

		if (coalesce(cd_medico_requisitante_w,'X') <> 'X') then
			begin

			update 	atendimento_paciente
			set 	cd_medico_resp 	= cd_medico_requisitante_w,
				dt_atualizacao 	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where 	nr_atendimento	= nr_atendimento_p;

			commit;

			end;
		end if;
		end;
	end if;
	end;
elsif (ie_opcao_medico_p = 'Res') then
	begin

	begin
	select 	max(nr_seq_interno)
	into STRICT	nr_seq_interno_w
	from	sus_laudo_paciente
	where	nr_atendimento = nr_atendimento_p
	and	ie_tipo_laudo_sus = 0;
	exception
	when others then
		nr_seq_interno_w := 0;
	end;

	if (coalesce(nr_seq_interno_w,0) > 0) then
		begin

		begin
		select	CD_MEDICO_RESPONSAVEL
		into STRICT	cd_medico_responsavel_w
		from	sus_laudo_paciente
		where	nr_seq_interno_w = nr_seq_interno_w;
		exception
		when others then
			cd_medico_responsavel_w := 'X';
		end;

		if (coalesce(cd_medico_responsavel_w,'X') <> 'X') then
			begin

			update 	atendimento_paciente
			set 	cd_medico_resp 	= cd_medico_responsavel_w,
				dt_atualizacao 	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where 	nr_atendimento	= nr_atendimento_p;

			commit;

			end;
		end if;
		end;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_atualiza_med_resp_atend ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, ie_opcao_medico_p text, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;
