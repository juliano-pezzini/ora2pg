-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_local_atend_usuario ( nm_usuario_web_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w			bigint;
nr_seq_local_atend_w		bigint;


BEGIN



begin
	select	nr_seq_local_atend
	into STRICT	nr_seq_local_atend_w
	from	pls_usuario_web
	where	upper(nm_usuario_web) = upper(nm_usuario_web_p)
	and	cd_estabelecimento = cd_estabelecimento_p;
exception
when others then
	nr_seq_local_atend_w := 0;
end;

if (coalesce(nr_seq_local_atend_w,0) > 0) then
	nr_retorno_w	:= nr_seq_local_atend_w;
else
	nr_retorno_w	:= 0;
end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_local_atend_usuario ( nm_usuario_web_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
