-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_gerar_empresa_pat_grupo () AS $body$
DECLARE


nr_sequencia_w		bigint;
cd_estabelecimento_w	bigint;
cd_empresa_w		bigint;
qt_registro_w		bigint;

c01 CURSOR FOR
SELECT	nr_sequencia,
	cd_estabelecimento
from	pat_grupo_tipo
where	(cd_estabelecimento IS NOT NULL AND cd_estabelecimento::text <> '');


BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	cd_empresa_w	:= obter_empresa_estab(cd_estabelecimento_w);

	update	pat_grupo_tipo
	set	cd_empresa	= cd_empresa_w
	where	nr_sequencia	= nr_sequencia_w;

	end;
end loop;
close C01;

select	count(*)
into STRICT	qt_registro_w
from	pat_grupo_tipo
where	coalesce(cd_empresa::text, '') = '';

if (qt_registro_w = 0) then
	begin
	select	count(*)
	into STRICT	qt_registro_w
	from	user_tab_columns
	where	table_name	= 'PAT_GRUPO_TIPO'
	and	column_name	= 'CD_EMPRESA'
	and	nullable	= 'Y';

	if (qt_registro_w > 0) then
		CALL exec_sql_dinamico('PATGRUPOTIPO','alter table pat_grupo_tipo modify cd_empresa number(4) not null');
	end if;
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_gerar_empresa_pat_grupo () FROM PUBLIC;

