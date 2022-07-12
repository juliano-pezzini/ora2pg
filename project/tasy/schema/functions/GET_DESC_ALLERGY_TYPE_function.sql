-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_desc_allergy_type (IE_TIPO_INTERACAO_P text) RETURNS varchar AS $body$
DECLARE

  ds_result_w   varchar(255)  := '';
  ds_expression_w bigint;

BEGIN
    SELECT CASE WHEN IE_TIPO_INTERACAO_P='A' THEN 33768 WHEN IE_TIPO_INTERACAO_P='C' THEN 33831 WHEN IE_TIPO_INTERACAO_P='J' THEN 1136944 END
    INTO STRICT ds_expression_w
;

    SELECT OBTER_TEXTO_TASY(ds_expression_w,wheb_usuario_pck.get_nr_seq_idioma)
    INTO STRICT ds_result_w
;
    RETURN ds_result_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_desc_allergy_type (IE_TIPO_INTERACAO_P text) FROM PUBLIC;

