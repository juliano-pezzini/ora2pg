-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_se_existe_diaria ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1)	:= 'N';
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
ie_classificacao_w		varchar(1);
qt_dispesas_w			bigint	:= 0;

C01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced
	from	pls_guia_plano_proc
	where	nr_seq_guia		= nr_seq_guia_p;

C02 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced
	from	pls_requisicao_proc
	where	nr_seq_requisicao	= nr_seq_requisicao_p;


BEGIN

open C01;
loop
fetch C01 into
	cd_procedimento_w,
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	coalesce(ie_classificacao,'X')
	into STRICT	ie_classificacao_w
	from	procedimento
	where	cd_procedimento		= cd_procedimento_w
	and	ie_origem_proced	= ie_origem_proced_w;

	if (ie_classificacao_w	= '3') then
		qt_dispesas_w	:= qt_dispesas_w + 1;
	end if;

	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	cd_procedimento_w,
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	select	coalesce(ie_classificacao,'X')
	into STRICT	ie_classificacao_w
	from	procedimento
	where	cd_procedimento		= cd_procedimento_w
	and	ie_origem_proced	= ie_origem_proced_w;

	if (ie_classificacao_w	= '3') then
		qt_dispesas_w	:= qt_dispesas_w + 1;
	end if;

	end;
end loop;
close C02;

if (qt_dispesas_w	> 0) then
	ds_retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_se_existe_diaria ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint) FROM PUBLIC;

