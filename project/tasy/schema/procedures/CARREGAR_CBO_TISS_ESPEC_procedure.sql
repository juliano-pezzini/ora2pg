-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE carregar_cbo_tiss_espec (nm_usuario_p text, cd_medico_p text, cd_especialidade_p bigint) AS $body$
DECLARE


cd_convenio_w		integer;
ie_versao_w		varchar(10);
nr_seq_cbo_saude_w	bigint;

c01 CURSOR FOR
SELECT	a.cd_convenio,
	a.ie_versao,
	a.nr_seq_cbo_saude
from	tiss_cbo_saude a
where	a.cd_especialidade	= cd_especialidade_p
and	coalesce(a.cd_pessoa_fisica::text, '') = ''
and	not exists (select	1
	from	tiss_cbo_saude x
	where	x.cd_pessoa_fisica	= cd_medico_p
	and	x.cd_especialidade	= cd_especialidade_p
	and	x.nr_seq_cbo_saude	= a.nr_seq_cbo_saude
	and	x.ie_versao		= a.ie_versao
	and	coalesce(x.cd_convenio,0)	= coalesce(a.cd_convenio,0));


BEGIN

if (cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') and (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then

	open C01;
	loop
	fetch C01 into
		cd_convenio_w,
		ie_versao_w,
		nr_seq_cbo_saude_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		insert into tiss_cbo_saude(cd_convenio,
			cd_especialidade,
			cd_pessoa_fisica,
			dt_atualizacao,
			dt_atualizacao_nrec,
			ie_versao,
			nm_usuario,
			nm_usuario_nrec,
			nr_seq_cbo_saude,
			nr_sequencia)
		values (cd_convenio_w,
			cd_especialidade_p,
			cd_medico_p,
			clock_timestamp(),
			clock_timestamp(),
			ie_versao_w,
			nm_usuario_p,
			nm_usuario_p,
			nr_seq_cbo_saude_w,
			nextval('tiss_cbo_saude_seq'));
		end;
	end loop;
	close C01;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carregar_cbo_tiss_espec (nm_usuario_p text, cd_medico_p text, cd_especialidade_p bigint) FROM PUBLIC;
