-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativar_medicos_import ( ie_origem_import_p text, nm_usuario_p text, nr_seq_conselho_p bigint default 0) AS $body$
DECLARE



C01 CURSOR FOR
	SELECT	*
	from	cadastro_medico
	where	ie_origem_import = 'X'
	and	ie_situacao_reg_base = 'A'
	and	substr(ds_status,1,1) = 'I'
	order by 1;

c01_w				c01%rowtype;
qt_registros_atualizados_w	bigint := 0;
nr_seq_conselho_med_w		bigint;


BEGIN

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	coalesce(max(nr_seq_conselho),0)
	into STRICT	nr_seq_conselho_med_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = c01_w.cd_pessoa_fisica;

	if (coalesce(nr_seq_conselho_p,0) = 0) or (nr_seq_conselho_med_w = coalesce(nr_seq_conselho_p,0)) then
		begin

		update	medico
		set	ie_situacao = 'I',
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	cd_pessoa_fisica = c01_w.cd_pessoa_fisica;

		select ie_situacao
		into STRICT	c01_w.ds_status
		from medico where cd_pessoa_fisica = c01_w.cd_pessoa_fisica;

		qt_registros_atualizados_w := qt_registros_atualizados_w + 1;

		if (qt_registros_atualizados_w = 100) then
			commit;
			qt_registros_atualizados_w := 0;
		end if;


		end;
	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativar_medicos_import ( ie_origem_import_p text, nm_usuario_p text, nr_seq_conselho_p bigint default 0) FROM PUBLIC;

