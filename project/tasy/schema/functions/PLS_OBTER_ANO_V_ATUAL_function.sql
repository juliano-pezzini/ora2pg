-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_ano_v_atual ( cd_estabelecimento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno	varchar(10);


BEGIN

select	to_char(dt_mes,'yyyy')
into STRICT	ds_retorno
from 	ano_v
where	to_char(dt_mes,'yyyy') = to_char(to_date(clock_timestamp()),'yyyy');

return	ds_retorno;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_ano_v_atual ( cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
