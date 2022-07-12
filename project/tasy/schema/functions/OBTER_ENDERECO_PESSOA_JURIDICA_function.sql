-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_endereco_pessoa_juridica (cd_cgc_p pessoa_juridica.cd_cgc%TYPE) RETURNS varchar AS $body$
DECLARE


ds_endereco_w	varchar(4000);


BEGIN
    IF (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') THEN
        SELECT  CASE WHEN coalesce(rtrim(ltrim(ds_endereco)), '')='' THEN  ds_endereco  ELSE ds_endereco||', ' END ||
                CASE WHEN coalesce(rtrim(ltrim(nr_endereco)), '')='' THEN  nr_endereco  ELSE nr_endereco||', ' END ||
                CASE WHEN coalesce(rtrim(ltrim(cd_cep)), '')='' THEN  cd_cep  ELSE cd_cep||', ' END ||
                CASE WHEN coalesce(rtrim(ltrim(ds_municipio)), '')='' THEN  ds_municipio  ELSE ds_municipio END  ds_endereco
        INTO STRICT    ds_endereco_w
        FROM	pessoa_juridica
        WHERE	cd_cgc	= cd_cgc_p;
    END IF;

    RETURN ds_endereco_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_endereco_pessoa_juridica (cd_cgc_p pessoa_juridica.cd_cgc%TYPE) FROM PUBLIC;
