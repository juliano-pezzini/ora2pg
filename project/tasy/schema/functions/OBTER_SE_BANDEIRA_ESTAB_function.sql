-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_bandeira_estab ( nr_seq_bandeira_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1)	:= 'S';
qt_registro_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	bandeira_cartao_estab
where	nr_seq_bandeira	= nr_seq_bandeira_p;

if (qt_registro_w = 0) then
	ie_retorno_w	:= 'S';
else
	select	count(*)
	into STRICT	qt_registro_w
	from	bandeira_cartao_estab
	where	nr_seq_bandeira		= nr_seq_bandeira_p
	and	cd_estabelecimento	= cd_estabelecimento_p;

	if (qt_registro_w > 0) then
		ie_retorno_w	:= 'S';
	else
		ie_retorno_w	:= 'N';
	end if;
end if;

return coalesce(ie_retorno_w,'S');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_bandeira_estab ( nr_seq_bandeira_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

