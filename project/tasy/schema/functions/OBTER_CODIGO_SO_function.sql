-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_codigo_so (nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
	Function utilizada na função Notificações - SINEPS
*/
cd_so_w			varchar(12);
cd_termo_preconizado_w	varchar(10);


BEGIN

select	cd_so,
	cd_termo_preconizado
into STRICT	cd_so_w,
	cd_termo_preconizado_w
from	sineps_termo_preconizado
where	nr_sequencia = nr_sequencia_p;

if (ie_opcao_p = 'SO') then
	return	cd_so_w;
elsif (ie_opcao_p = 'TP') then
	return	cd_termo_preconizado_w;
end	if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_codigo_so (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
