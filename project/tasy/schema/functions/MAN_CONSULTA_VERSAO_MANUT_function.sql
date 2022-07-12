-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_consulta_versao_manut (cd_versao_destino_p text, cd_cnpj_p text) RETURNS varchar AS $body$
DECLARE


cd_versao_w		varchar(15);
ds_versao_w		varchar(200):= 'NOK';
ie_primeira_w		varchar(1):= 'S';
cd_versao_destino_w	varchar(500);
cd_cgc_w		varchar(500);
qt_registro_w		bigint;

C01 CURSOR FOR
	SELECT	cd_versao
	from	aplicacao_tasy_versao
	where	cd_aplicacao_tasy = 'Tasy'
	and	coalesce(IE_VERSAO_OFICIAL, 'N') = 'S'
	and	trunc(dt_versao) between clock_timestamp() - interval '90 days' and clock_timestamp()
    	and     somente_numero(cd_versao) <> 3061794
	and	somente_numero(cd_versao) <> 4001794
	order by dt_versao desc;


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	tasy_autorizacao_atualiza a
where	somente_numero_char(a.cd_cnpj_cliente)  = somente_numero_char(cd_cnpj_p)
and	somente_numero_char(a.cd_versao) = somente_numero_char(cd_versao_destino_p)
and	trunc(clock_timestamp()) between trunc(a.dt_ini_intervalo) and trunc(a.dt_fim_intervalo);

if (qt_registro_w > 0) then
	ds_versao_w:= 'ok';
end if;

open C01;
loop
fetch C01 into
	cd_versao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin		

	if (ds_versao_w <> 'ok') then

		if (ie_primeira_w = 'S') then
			ie_primeira_w:= 'N';
			ds_versao_w:= cd_versao_w;				
		else
			ds_versao_w:= ds_versao_w || ', '||cd_versao_w;
		end if;		

		if (cd_versao_destino_p = cd_versao_w) then
			ds_versao_w := 'ok';
		end if;

	end if;

	end;
end loop;
close C01;

return	ds_versao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_consulta_versao_manut (cd_versao_destino_p text, cd_cnpj_p text) FROM PUBLIC;

