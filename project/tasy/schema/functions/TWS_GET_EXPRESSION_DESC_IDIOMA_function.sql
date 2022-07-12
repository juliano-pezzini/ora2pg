-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tws_get_expression_desc_idioma ( cd_dominio_p bigint, vl_dominio_p text, cd_exp_informacao_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


  ds_retorno_w        varchar(255) := '';

  ds_locale_w         varchar(255);

  ds_lang_tag_seq_w   bigint;

  cd_exp_informacao_w varchar(255);

  ds_exp_informacao_w varchar(255) := '';


BEGIN

  IF (cd_dominio_p IS NOT NULL AND cd_dominio_p::text <> '' AND vl_dominio_p IS NOT NULL AND vl_dominio_p::text <> '') THEN

    SELECT CD_EXP_VALOR_DOMINIO,
	DS_VALOR_DOMINIO_CLIENTE

    INTO STRICT cd_exp_informacao_w,
	ds_exp_informacao_w

    FROM valor_dominio_v

    WHERE CD_DOMINIO = cd_dominio_p

    AND VL_DOMINIO   = vl_dominio_p;

  END IF;

  if (ds_exp_informacao_w IS NOT NULL AND ds_exp_informacao_w::text <> '') then
	ds_retorno_w := ds_exp_informacao_w;
  else

SELECT ds_locale_tws

INTO STRICT ds_locale_w

FROM establishment_locale

WHERE cd_estabelecimento = cd_estabelecimento_p;

SELECT coalesce(nr_sequencia,5)

INTO STRICT ds_lang_tag_seq_w

FROM tasy_idioma

WHERE ds_language_tag = ds_locale_w;


SELECT Obter_desc_expressao_idioma(coalesce(cd_exp_informacao_w,cd_exp_informacao_p),NULL,ds_lang_tag_seq_w)

INTO STRICT ds_retorno_w

;
end if;

RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tws_get_expression_desc_idioma ( cd_dominio_p bigint, vl_dominio_p text, cd_exp_informacao_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
