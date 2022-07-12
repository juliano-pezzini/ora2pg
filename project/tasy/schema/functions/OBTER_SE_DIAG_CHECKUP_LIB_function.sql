-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_diag_checkup_lib ( nr_seq_diag_p bigint, nr_seq_etapa_p bigint) RETURNS varchar AS $body$
DECLARE

ie_retorno_w		varchar(10)	:= 'S';
qt_reg_w		bigint;

BEGIN
select	count(*)
into STRICT	qt_reg_w
from	CHECKUP_TIPO_DIAG_LIB
where	nr_seq_diag	= nr_seq_diag_p;

if (qt_reg_w	> 0) then
	select	count(*)
	into STRICT	qt_reg_w
	from	CHECKUP_TIPO_DIAG_LIB
	where	nr_seq_diag	= nr_seq_diag_p
	and	coalesce(nr_seq_etapa,nr_seq_etapa_p)	= nr_seq_etapa_p;
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
-- REVOKE ALL ON FUNCTION obter_se_diag_checkup_lib ( nr_seq_diag_p bigint, nr_seq_etapa_p bigint) FROM PUBLIC;
