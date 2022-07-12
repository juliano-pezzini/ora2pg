-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_ult_resultado ( cd_pessoa_fisica_p bigint, nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE

				
nr_seq_resultado_w		exame_lab_resultado.nr_seq_resultado%type;
ds_resultado_w			varchar(10) := NULL;


BEGIN

SELECT	MAX(b.nr_seq_resultado)
into STRICT	nr_seq_resultado_w
FROM	prescr_medica a,
		prescr_procedimento e,
		exame_lab_resultado b,
		exame_lab_result_item c,
		lab_parametro d
WHERE	a.nr_prescricao = b.nr_prescricao
  AND	b.nr_seq_resultado = c.nr_seq_resultado
  AND	a.cd_estabelecimento = d.cd_estabelecimento
  AND	a.nr_prescricao = e.nr_prescricao
  AND	c.nr_seq_prescr = e.nr_sequencia
  AND	a.cd_pessoa_fisica = to_char(cd_pessoa_fisica_p)
  AND	c.nr_seq_exame = nr_seq_exame_p
  AND	((b.dt_resultado BETWEEN clock_timestamp() - d.qt_dias_res_ant AND clock_timestamp()) OR (coalesce(d.qt_dias_res_ant, 0) = 0))
  AND 	e.ie_status_atend >= 35;

  
IF (nr_seq_resultado_w > 0) THEN

	SELECT	SUBSTR(MAX(coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	
			coalesce(TO_CHAR(c.qt_resultado),TO_CHAR(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado)),1,10)
	INTO STRICT	ds_resultado_w
	FROM	exame_laboratorio d,
			exame_lab_result_item c
	WHERE	d.nr_seq_exame 		= c.nr_seq_exame
	AND		c.nr_seq_resultado 	= nr_seq_resultado_w
	AND		c.nr_seq_exame		= nr_seq_exame_p;
	
END IF;

RETURN ds_resultado_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_ult_resultado ( cd_pessoa_fisica_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;

