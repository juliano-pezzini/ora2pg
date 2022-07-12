-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prescr_anterior_seq ( nr_prescricao_p bigint, cd_pessoa_fisica_p text, nr_seq_exame_p bigint, nr_anterior_p bigint) RETURNS varchar AS $body$
DECLARE

nr_ant_w	bigint;
nr_prescricao_w	bigint;
ds_retorno_w	varchar(10);


c01 CURSOR FOR
SELECT  row_number() OVER () AS nr_ant,
	nr_prescricao
FROM (
	SELECT	DISTINCT
			b.nr_prescricao
	FROM	exame_laboratorio c,
			exame_lab_resultado b,
			prescr_medica d,
			exame_lab_result_item a
	WHERE b.nr_seq_resultado = a.nr_seq_resultado
	  AND b.nr_prescricao = d.nr_prescricao
	  AND a.nr_seq_exame = c.nr_seq_exame
	  AND (obter_equipamento_exame(a.nr_seq_exame,NULL,'CETUS') IS NOT NULL AND (obter_equipamento_exame(a.nr_seq_exame,NULL,'CETUS'))::text <> '')
	  AND (obter_data_aprov_lab(d.nr_prescricao,a.nr_seq_prescr) IS NOT NULL AND (obter_data_aprov_lab(d.nr_prescricao,a.nr_seq_prescr))::text <> '')
	  and a.nr_seq_exame = nr_seq_exame_p
	  and d.nr_prescricao < nr_prescricao_p
	  and d.cd_pessoa_fisica = cd_pessoa_fisica_p
	  ORDER BY nr_prescricao DESC) a;


BEGIN


open c01;
loop
fetch c01 into
	nr_ant_w,
	nr_prescricao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (nr_ant_w = nr_anterior_p) then
		ds_retorno_w :=  nr_prescricao_w;
	end if;

end loop;
close c01;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prescr_anterior_seq ( nr_prescricao_p bigint, cd_pessoa_fisica_p text, nr_seq_exame_p bigint, nr_anterior_p bigint) FROM PUBLIC;
