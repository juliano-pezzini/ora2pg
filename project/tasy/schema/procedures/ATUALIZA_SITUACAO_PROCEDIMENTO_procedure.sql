-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_situacao_procedimento ( cd_grupo_proc_p bigint, ie_acao_p text) AS $body$
DECLARE


cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;

C01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced
	from	procedimento
	where	ie_situacao <> ie_acao_p
	and	cd_grupo_proc = cd_grupo_proc_p
	order by cd_procedimento,
		ie_origem_proced;


BEGIN

open C01;
loop
fetch C01 into
	cd_procedimento_w,
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	update	procedimento
	set	ie_situacao = ie_acao_p
	where	cd_procedimento = cd_procedimento_w
	and	ie_origem_proced = ie_origem_proced_w;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_situacao_procedimento ( cd_grupo_proc_p bigint, ie_acao_p text) FROM PUBLIC;
