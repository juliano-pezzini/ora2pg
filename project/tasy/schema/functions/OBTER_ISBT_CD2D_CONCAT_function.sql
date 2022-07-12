-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_isbt_cd2d_concat ( ds_codigo_p text) RETURNS varchar AS $body$
DECLARE


ds_codigo_w		varchar(2000);
ds_structure_w		varchar(255);
ie_contador_w		bigint	:= 0;
ie_pos_igual_w		smallint;
ie_pos_eCom_w		smallint;
ie_pos_menor_w		smallint;
ds_referencia_w		varchar(255);
tam_lista_w		bigint;
ds_001_w		varchar(255);
ds_002_w		varchar(255);
ds_003_w		varchar(255);
ds_004_w		varchar(255);
ds_005_w		varchar(255);
ds_006_w		varchar(255);
ds_007_w		varchar(255);
ds_008_w		varchar(255);
ds_009_w		varchar(255);
ds_019_w		varchar(255);
ds_retorno_w		varchar(255);


BEGIN
IF (ds_codigo_p IS NOT NULL AND ds_codigo_p::text <> '') THEN

	ds_codigo_w	:= ds_codigo_p;
	WHILE	(ds_codigo_w IS NOT NULL AND ds_codigo_w::text <> '') AND
		ie_contador_w < 200 LOOP
		BEGIN
		tam_lista_w		:= LENGTH(ds_codigo_w);
		ie_pos_igual_w		:= position(CHR(61) in ' '||SUBSTR(ds_codigo_w,2,tam_lista_w));
		ie_pos_eCom_w		:= position(CHR(38) in ' '||SUBSTR(ds_codigo_w,2,tam_lista_w));

		IF	(ie_pos_igual_w > ie_pos_eCom_w AND ie_pos_eCom_w <> 0) OR (ie_pos_igual_w = 0) THEN
			ie_pos_menor_w	:= ie_pos_eCom_w;
		ELSE
			ie_pos_menor_w	:= ie_pos_igual_w;
		END IF;

		IF (ie_pos_menor_w <> 0) THEN

			ds_structure_w	:= SUBSTR(ds_codigo_w,1,(ie_pos_menor_w)-1);
			ds_codigo_w	:= SUBSTR(ds_codigo_w,(ie_pos_menor_w),tam_lista_w);
		ELSE
			ds_structure_w	:= ds_codigo_w;
			ds_codigo_w	:= '';
		END IF;


		SELECT	MAX(SUBSTR(Obter_Ref_ISBT_codigo(ds_structure_w),1,3))
		INTO STRICT	ds_referencia_w
		;

		IF (ds_referencia_w = '001') THEN
			ds_001_w := ds_structure_w;
		END IF;
		IF (ds_referencia_w = '002') THEN
			ds_002_w := ds_structure_w;
		END IF;
		IF (ds_referencia_w = '003') THEN
			ds_003_w := ds_structure_w;
		END IF;
		IF (ds_referencia_w = '004') THEN
			ds_004_w := ds_structure_w;
		END IF;
		IF (ds_referencia_w = '005') THEN
			ds_005_w := ds_structure_w;
		END IF;
		IF (ds_referencia_w = '006') THEN
			ds_006_w := ds_structure_w;
		END IF;
		IF (ds_referencia_w = '007') THEN
			ds_007_w := ds_structure_w;
		END IF;
		IF (ds_referencia_w = '008') THEN
			ds_008_w := ds_structure_w;
		END IF;
		IF (ds_referencia_w = '009') THEN
			ds_009_w := ds_structure_w;
		END IF;


		ie_contador_w	:= ie_contador_w + 1;

		END;
	END LOOP;
END IF;

ds_retorno_w	:= ds_001_w||'|'||ds_002_w||'|'||ds_003_w||'|'||ds_004_w||'|'||ds_005_w||'|'||ds_006_w||'|'||ds_007_w||'|'||ds_008_w||'|'||ds_009_w||'|';

RETURN	 ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_isbt_cd2d_concat ( ds_codigo_p text) FROM PUBLIC;
