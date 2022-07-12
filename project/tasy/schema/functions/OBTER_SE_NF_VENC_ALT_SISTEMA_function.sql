-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_nf_venc_alt_sistema (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ie_alterado_w	varchar(1) := 'N';
qt_existe_w	bigint;


BEGIN

select	coalesce(count(*),0)
into STRICT	qt_existe_w
from	nota_fiscal_venc
where	ie_venc_alt_sistema = 'S'
and	nr_sequencia = nr_sequencia_p;

if (qt_existe_w > 0) then
	ie_alterado_w := 'S';
end if;

return	ie_alterado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_nf_venc_alt_sistema (nr_sequencia_p bigint) FROM PUBLIC;

