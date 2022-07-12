-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_inf_acumulada ( cd_pessoa_fisica_p text, qt_peso_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1) := 'N';
qt_idade_w		bigint;

C01 CURSOR FOR
	SELECT	coalesce(ie_abrir_tela,'N')
	from	rep_infusao_acumulada
	where	coalesce(qt_peso_p,1) between coalesce(qt_peso_min,0) and coalesce(qt_peso_max,999999)
	and		coalesce(qt_idade_w,1) between coalesce(obter_idade_conversao(coalesce(qt_idade_min,0),coalesce(qt_idade_min_mes,0),coalesce(qt_idade_min_dia,0),coalesce(qt_idade_max,0),coalesce(qt_idade_max_mes,0),coalesce(qt_idade_max_dia,0),'MIN'),0) and coalesce(obter_idade_conversao(coalesce(qt_idade_min,0),coalesce(qt_idade_min_mes,0),coalesce(qt_idade_min_dia,0),coalesce(qt_idade_max,0),coalesce(qt_idade_max_mes,0),coalesce(qt_idade_max_dia,0),'MAX'),9999999)
	order by nr_sequencia;


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	select	max(obter_idade(dt_nascimento,coalesce(dt_obito,clock_timestamp()),'DIA'))
	into STRICT	qt_idade_w
	from	pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p;

	open C01;
	loop
	fetch C01 into
		ie_retorno_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ie_retorno_w := ie_retorno_w;
		end;
	end loop;
	close C01;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_inf_acumulada ( cd_pessoa_fisica_p text, qt_peso_p bigint) FROM PUBLIC;

