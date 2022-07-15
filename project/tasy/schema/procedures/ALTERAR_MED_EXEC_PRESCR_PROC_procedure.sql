-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_med_exec_prescr_proc ( nr_prescricao_p bigint , cd_medico_p text , nm_usuario_p text ) AS $body$
DECLARE


nr_prescricao_w		bigint;
nr_sequencia_w		integer;
cd_cbo_w		varchar(6)	:= '';
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_prescricao,
		ie_origem_proced,
		cd_procedimento
	from	prescr_procedimento
	where	nr_prescricao = nr_prescricao_p;


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	open c01;
	loop
	fetch c01 into
		nr_sequencia_w,
		nr_prescricao_w,
		ie_origem_proced_w,
		cd_procedimento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		update	prescr_procedimento
		set	cd_medico_exec	= cd_medico_p,
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_prescricao	= nr_prescricao_w
		and	nr_sequencia	= nr_sequencia_w;

		if (ie_origem_proced_w = 7) then
			begin
			select	max(a.cd_cbo)
			into STRICT	cd_cbo_w
			from    sus_cbo                 b,
				sus_cbo_pessoa_fisica   a
			where   sus_obter_secbo_compativel(cd_medico_p, cd_procedimento_w, ie_origem_proced_w, clock_timestamp(), a.cd_cbo, 0) = 'S'
			and     cd_pessoa_fisica        = cd_medico_p
			and     a.cd_cbo        	= b.cd_cbo;
			end;
		end if;

		update	procedimento_paciente
		set	cd_medico_executor	= cd_medico_p,
			cd_cbo			= cd_cbo_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			cd_pessoa_fisica	= ''
		where	nr_prescricao		= nr_prescricao_w
		and	nr_sequencia_prescricao	= nr_sequencia_w;

		end;
	end loop;
	close c01;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_med_exec_prescr_proc ( nr_prescricao_p bigint , cd_medico_p text , nm_usuario_p text ) FROM PUBLIC;

