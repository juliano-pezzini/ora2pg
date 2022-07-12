-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_se_item_liberado ( nr_Seq_Ageint_item_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);
qt_liberada_w	integer;


BEGIN

select	count(*)
into STRICT	qt_liberada_w
from	ageint_lib_usuario
where	nr_seq_ageint_item	= nr_seq_Ageint_item_p
and	nm_usuario		= nm_usuario_p;

if (qt_liberada_w	> 0) then
	ds_retorno_w	:= 'S';
else
	ds_retorno_w	:= 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_se_item_liberado ( nr_Seq_Ageint_item_p bigint, nm_usuario_p text) FROM PUBLIC;
