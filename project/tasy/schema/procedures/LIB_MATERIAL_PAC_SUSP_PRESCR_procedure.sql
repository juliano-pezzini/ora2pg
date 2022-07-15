-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lib_material_pac_susp_prescr ( cd_pessoa_fisica_p text, nr_prescricao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_material_w	bigint;

c01 CURSOR FOR
SELECT	nr_sequencia,
	nr_seq_material
from	lib_material_paciente
where 	cd_pessoa_fisica   = cd_pessoa_fisica_p
and 	nr_prescricao       = nr_prescricao_p
and	(qt_dose_diaria IS NOT NULL AND qt_dose_diaria::text <> '');


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	begin

	open C01;
	loop
	fetch C01 into
		nr_sequencia_w,
		nr_seq_material_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		update	lib_material_paciente
		set	dt_suspenso		= clock_timestamp(),
			dt_atualizacao		= clock_timestamp(),
			nm_usuario      	= nm_usuario_p,
			nm_usuario_susp 	= nm_usuario_p
		where 	nr_sequencia		= nr_sequencia_w;

		update	prescr_material
		set	nr_seq_lib_mat_pac	 = NULL
		where	nr_prescricao		= nr_prescricao_p
		and	nr_sequencia		= nr_seq_material_w;

		end;
	end loop;
	close C01;

	end;
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lib_material_pac_susp_prescr ( cd_pessoa_fisica_p text, nr_prescricao_p text, nm_usuario_p text) FROM PUBLIC;

