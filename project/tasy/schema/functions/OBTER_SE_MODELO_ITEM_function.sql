-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_modelo_item ( nr_seq_item_pront_p bigint, nr_seq_modelo_p bigint) RETURNS varchar AS $body$
DECLARE


qt_reg_w	bigint;
ie_retorno_w	varchar(10)	:= 'S';

BEGIN


select	count(*)
into STRICT	qt_reg_w
from	PE_SAE_MODELO_ITEM;

if (qt_reg_w	> 0) then
	select	count(*)
	into STRICT	qt_reg_w
	from	PE_SAE_MODELO_ITEM
	where	nr_seq_modelo	= nr_seq_modelo_p
	and	nr_seq_item_pront= nr_seq_item_pront_p;
	if (qt_reg_w	= 0) then
		ie_retorno_w	:= 'N';
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_modelo_item ( nr_seq_item_pront_p bigint, nr_seq_modelo_p bigint) FROM PUBLIC;

