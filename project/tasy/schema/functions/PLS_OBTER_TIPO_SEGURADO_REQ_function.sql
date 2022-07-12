-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_tipo_segurado_req ( nr_seq_requisicao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(2)	:= '';
nr_seq_segurado_w		bigint;
ie_tipo_segurado		varchar(2);


BEGIN

begin
	select	coalesce(nr_seq_segurado,0)
	into STRICT	nr_seq_segurado_w
	from	pls_requisicao
	where	nr_sequencia	= nr_seq_requisicao_p;
exception
when others then
	nr_seq_segurado_w	:= 0;
end;

if (nr_seq_segurado_w	<> 0) then
	begin
		select	coalesce(ie_tipo_segurado,'X')
		into STRICT	ie_tipo_segurado
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;
	exception
	when others then
		ie_tipo_segurado	:= 'X';
	end;
end if;

if (ie_tipo_segurado	<> 'X') then
	ie_retorno_w	:= ie_tipo_segurado;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_tipo_segurado_req ( nr_seq_requisicao_p bigint) FROM PUBLIC;
