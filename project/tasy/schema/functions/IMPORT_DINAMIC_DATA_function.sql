-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION import_dinamic_data (nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

  return_w          varchar(1) := 'N';
  qt_registro_cha_w numeric(20);
  qt_registro_cod_w numeric(20);
  qt_registro_mor_w numeric(20);

BEGIN
  IF (OBTAIN_USER_LOCALE(nm_usuario_p) = 'en_AU') THEN
    qt_registro_cha_w := obter_valor_dinamico('select count(*) from ICD_CHAPTER_AUS', qt_registro_cha_w);
    qt_registro_cod_w := obter_valor_dinamico('select count(*) from ICD_CODES_AUS', qt_registro_cod_w);
    qt_registro_mor_w := obter_valor_dinamico('select count(*) from CID_MORFOLOGIA_AUS', qt_registro_mor_w);

  ELSIF (OBTAIN_USER_LOCALE(nm_usuario_p) = 'de_AT') THEN
      qt_registro_cha_w := obter_valor_dinamico('select count(*) from ICD_CHAPTER_AUT', qt_registro_cha_w);
	  qt_registro_cod_w := obter_valor_dinamico('select count(*) from ICD_CODES_AUT', qt_registro_cod_w);
    END IF;
  /*For any other locales please add the conditions and required logic*/

IF (qt_registro_cha_w > 0 AND qt_registro_cod_w > 0 AND qt_registro_mor_w > 0) OR (qt_registro_cha_w > 0 AND qt_registro_cod_w > 0) OR ( qt_registro_mor_w > 0) THEN
      return_w           := 'S';
ELSE
     return_w := 'N';
END IF;
RETURN return_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION import_dinamic_data (nm_usuario_p text) FROM PUBLIC;

