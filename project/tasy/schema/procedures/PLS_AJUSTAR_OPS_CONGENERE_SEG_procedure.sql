-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_ops_congenere_seg ( cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w	bigint;
ie_commit_w		varchar(10);
qt_registros_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_segurado
	where	ie_tipo_segurado not in ('A','B','R')
	and	(cd_operadora_empresa IS NOT NULL AND cd_operadora_empresa::text <> '')
	and	coalesce(nr_seq_ops_congenere::text, '') = '';


BEGIN

qt_registros_w	:= 0;

ie_commit_w	:= 'N';

open C01;
loop
fetch C01 into
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	qt_registros_w	:= qt_registros_w + 1;

	if (qt_registros_w = 1000) then
		qt_registros_w	:= 0;
		ie_commit_w	:= 'S';
	end if;

	CALL pls_gerar_ops_congenere_benef(nr_seq_segurado_w,null,cd_estabelecimento_p,nm_usuario_p,ie_commit_w);

	ie_commit_w	:= 'N';

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_ops_congenere_seg ( cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
