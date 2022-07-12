-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_todos_tipos_dietas ( NR_SEQ_SUPERIOR_P bigint, ie_dieta_nutricao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(400) := '';
ds_dieta_w		varchar(200) := '';

C01 CURSOR FOR
	SELECT	OBTER_NOME_DIETA(cd_dieta)
	FROM	mapa_dieta
	WHERE	nr_seq_superior = nr_seq_superior_p
	AND	((ie_tipo_dieta = 'N' and ie_dieta_nutricao_p = 'S')
	or (ie_dieta_nutricao_p = 'N'));


BEGIN

OPEN C01;
LOOP
FETCH C01 INTO
	ds_dieta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN
		ds_retorno_w := ds_retorno_w|| ds_dieta_w||',';
	END;
END LOOP;
CLOSE C01;

IF (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') THEN
	ds_retorno_w := SUBSTR(ds_retorno_w,1,LENGTH(ds_retorno_w)-1);
	ds_retorno_w := ds_retorno_w||' - ';
END IF;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_todos_tipos_dietas ( NR_SEQ_SUPERIOR_P bigint, ie_dieta_nutricao_p text) FROM PUBLIC;

