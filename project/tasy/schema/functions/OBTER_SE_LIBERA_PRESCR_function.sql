-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_libera_prescr ( nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


qt_registro_w	smallint;
qt_registro_ww	smallint;


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	prescr_procedimento
where	(obter_inf_adic_prescr(nr_prescricao,nr_sequencia) IS NOT NULL AND (obter_inf_adic_prescr(nr_prescricao,nr_sequencia))::text <> '')
and		nr_prescricao = nr_prescricao_p
and		coalesce(ie_tipo_proced,'X') <> 'BSHE';

if (qt_registro_w > 0) then
	select	count(*)
	into STRICT	qt_registro_ww
	from	rep_inf_adic_pp
	where	nr_prescricao  	=	nr_prescricao_p;

	if (qt_registro_w > qt_registro_ww) then
		return	'N';
	end if;
end if;

return 'S';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_libera_prescr ( nr_prescricao_p bigint) FROM PUBLIC;

