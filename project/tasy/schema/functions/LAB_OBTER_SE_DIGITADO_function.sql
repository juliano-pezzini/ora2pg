-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_se_digitado ( nr_seq_resultado_p bigint, nr_seq_prescr_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1);	

/*
ie_opcao
1 - Verifica se o exame teve algo digitado
2 - Verifica se todos os analitos do exame foram digitados (parametro [55] da Exames Pendentes)
3 - Opcao 'ND' do parametro [55] da funcao Exames Pendentes. A opcao consiste resultados descritivos que foram apagados apos entrar em digitacao, impedindo a aprovacao. 
***conferir ie_consiste_res_desc na exame_laboratorio
*/
BEGIN

IF (ie_opcao_p = 1) 	THEN

	SELECT 	CASE WHEN COUNT(*)=0 THEN 'N'  ELSE 'S' END
	INTO STRICT	ds_retorno_w
	FROM	exame_laboratorio b,
		exame_lab_result_item a
	WHERE	a.nr_seq_exame		= b.nr_seq_exame
	AND	a.nr_seq_resultado	= nr_seq_resultado_p
	AND	a.nr_seq_prescr		= nr_seq_prescr_p
	AND	a.ie_status		= '1';


ELSIF (ie_opcao_p = 2)	THEN

	SELECT 	CASE WHEN COUNT(*)=0 THEN 'S'  ELSE 'N' END 
	INTO STRICT	ds_retorno_w
	FROM	exame_laboratorio b,
			exame_lab_result_item a
	WHERE	a.nr_seq_exame		= b.nr_seq_exame
	AND	a.nr_seq_resultado	= nr_seq_resultado_p
	AND	a.nr_seq_prescr		= nr_seq_prescr_p
	AND	((a.ie_status <> '1') OR (coalesce(a.ie_status::text, '') = ''))
	AND	(b.nr_seq_superior IS NOT NULL AND b.nr_seq_superior::text <> '')
	AND NOT EXISTS (	SELECT 1
					FROM   exame_lab_format_item y
					WHERE  y.nr_seq_formato = a.nr_seq_formato);
					
ELSIF (ie_opcao_p = 3)	THEN

	SELECT 	CASE WHEN COUNT(*)=0 THEN 'S'  ELSE 'N' END
	INTO STRICT	ds_retorno_w
	FROM	exame_laboratorio b,
		exame_lab_result_item a
	WHERE	a.nr_seq_exame		= b.nr_seq_exame
	AND	a.nr_seq_resultado	= nr_seq_resultado_p
	AND	a.nr_seq_prescr		= nr_seq_prescr_p
	AND	a.ie_status 		= '1'
	AND	coalesce(a.qt_resultado, 0) 	= 0
	AND	coalesce(trim(both a.ds_resultado)::text, '') = ''
	AND	b.ie_formato_resultado NOT IN ('V', 'P', 'PV', 'CV', 'CA')
	AND	b.ie_consiste_res_desc = 'S';
	
	IF (ds_retorno_w = 'S' AND pkg_i18n.get_user_locale <> 'es_AR') THEN
		SELECT 	CASE WHEN COUNT(*)=0 THEN 'S'  ELSE 'N' END
		INTO STRICT	ds_retorno_w
		FROM	exame_laboratorio b,
			exame_lab_result_item a
		WHERE	a.nr_seq_exame		= b.nr_seq_exame
		AND	a.nr_seq_resultado	= nr_seq_resultado_p
		AND	a.nr_seq_prescr		= nr_seq_prescr_p
		AND	((a.ie_status <> '1') OR (coalesce(a.ie_status::text, '') = ''));
	END IF;
	
END IF;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_se_digitado ( nr_seq_resultado_p bigint, nr_seq_prescr_p bigint, ie_opcao_p bigint) FROM PUBLIC;

