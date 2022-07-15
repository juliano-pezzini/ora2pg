-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_atual_estab_conta_pj () AS $body$
DECLARE


qt_registro_w		bigint;
cd_estabelecimento_w	bigint;


BEGIN

select	count(*),
	min(cd_estabelecimento)
into STRICT	qt_registro_w,
	cd_estabelecimento_w
from	estabelecimento;

if (qt_registro_w > 1) then
	begin
	select	count(*)
	into STRICT	qt_registro_w
	from	pessoa_jur_conta_cont
	where	coalesce(cd_estabelecimento,cd_estabelecimento_w) <> cd_estabelecimento_w;

	if (qt_registro_w = 0) then
		update	pessoa_jur_conta_cont
		set	cd_estabelecimento	 = NULL
		where	cd_estabelecimento	= cd_estabelecimento_w;
	end if;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_atual_estab_conta_pj () FROM PUBLIC;

