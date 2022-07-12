-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_resultado_fator_rh (ds_resultado_p text, nr_seq_resultado_p bigint, nr_seq_prescr_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w		varchar(1000);
ie_contem_aspas_w	varchar(1);
ds_resultado_fator_w varchar(255);
ds_aux_w			varchar(255);



BEGIN

select  position('"' in ds_resultado_p)
into STRICT	ie_contem_aspas_w
;

select  CASE WHEN upper(max(ds_resultado))=upper(obter_desc_expressao(296109)) THEN '+'  ELSE '-' END
into STRICT	ds_resultado_fator_w
from    exame_lab_result_item
where	nr_seq_resultado = nr_seq_resultado_p
and		nr_seq_prescr = nr_seq_prescr_p
and		nr_seq_exame = 1481;

if (ie_contem_aspas_w > 0) then
	ds_aux_w := replace(ds_resultado_p,'"','');
	ds_retorno_w := '"'||ds_aux_w||ds_resultado_fator_w||'"';
else
	ds_retorno_w := ds_resultado_p||ds_resultado_fator_w;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_resultado_fator_rh (ds_resultado_p text, nr_seq_resultado_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;
