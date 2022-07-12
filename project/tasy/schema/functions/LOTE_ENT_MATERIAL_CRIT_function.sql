-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lote_ent_material_crit (nr_seq_ficha_p bigint, nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
nr_seq_prescr_w		bigint;
nr_prescricao_w		bigint;
nr_seq_resultado_w	bigint;


BEGIN

SELECT 	MAX(nr_prescricao)
INTO STRICT	nr_prescricao_w
FROM	lote_ent_sec_ficha
WHERE	nr_sequencia = nr_seq_ficha_p;

SELECT	MAX(a.nr_sequencia)
INTO STRICT	nr_seq_prescr_w
FROM	prescr_procedimento a,
		lote_ent_sec_ficha b
WHERE	a.nr_prescricao = b.nr_prescricao
AND		a.nr_prescricao = nr_prescricao_w
AND		a.nr_seq_exame = nr_seq_exame_p;

select	max(a.nr_seq_resultado)
into STRICT	nr_seq_resultado_w
from	exame_lab_resultado a
where	a.nr_prescricao = nr_prescricao_w;

IF (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') AND (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') AND (nr_seq_prescr_w IS NOT NULL AND nr_seq_prescr_w::text <> '') THEN

	select	max(a.ds_material_criterio)
	into STRICT	ds_retorno_w
	from	exame_lab_result_item a
	where	a.nr_seq_prescr = nr_seq_prescr_w
	and		a.nr_seq_resultado = nr_seq_resultado_w
	and		a.nr_seq_exame = nr_seq_exame_p
	and		(a.nr_seq_material IS NOT NULL AND a.nr_seq_material::text <> '');


END IF;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lote_ent_material_crit (nr_seq_ficha_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;

