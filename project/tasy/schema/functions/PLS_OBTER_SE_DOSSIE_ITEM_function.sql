-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_dossie_item (cd_perfil_p bigint, nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(20);
cont_w			bigint;


BEGIN

select	count(*)
into STRICT	cont_w
from	pls_dossie_item_perfil
where	cd_perfil	= cd_perfil_p
and	nr_seq_item	= nr_seq_item_p;

ie_retorno_w	:= 'N';
if (cont_w > 0) then
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_dossie_item (cd_perfil_p bigint, nr_seq_item_p bigint) FROM PUBLIC;
