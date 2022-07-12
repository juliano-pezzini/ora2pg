-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_se_result_dig (nr_prescricao_p bigint, nr_seq_prescr_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w			varchar(1);


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') then

	select  CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from 	exame_lab_resultado a,
			exame_lab_result_item b
	where 	a.nr_seq_resultado = b.nr_Seq_resultado
	and ((b.dt_digitacao IS NOT NULL AND b.dt_digitacao::text <> '')
	or		b.ie_status = 1)
	and		a.nr_prescricao = 	nr_prescricao_p
	and		b.nr_seq_prescr = 	nr_seq_prescr_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_se_result_dig (nr_prescricao_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;

