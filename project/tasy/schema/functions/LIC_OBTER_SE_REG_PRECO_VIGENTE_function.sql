-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_se_reg_preco_vigente (nr_seq_reg_preco_p bigint) RETURNS varchar AS $body$
DECLARE


qt_existe_w		bigint;
ie_vigente_w		varchar(1) := 'N';


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	reg_compra
where	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(clock_timestamp()) between ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_inicio_vigencia) and ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_fim_vigencia)
and	nr_sequencia = nr_seq_reg_preco_p;

if (qt_existe_w > 0) then
	ie_vigente_w := 'S';
end if;

return	ie_vigente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_se_reg_preco_vigente (nr_seq_reg_preco_p bigint) FROM PUBLIC;
