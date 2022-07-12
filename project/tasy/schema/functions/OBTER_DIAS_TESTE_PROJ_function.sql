-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dias_teste_proj ( IE_TAMANHO_P text) RETURNS bigint AS $body$
DECLARE

  PR_RETORNO_W	bigint  := 0;

BEGIN
  IF (coalesce(IE_TAMANHO_P::text, '') = '') THEN
    PR_RETORNO_W := 0;
  ELSIF (IE_TAMANHO_P = 'XS') THEN
    PR_RETORNO_W := 1;
  ELSIF (IE_TAMANHO_P = 'S') THEN
    PR_RETORNO_W := 2;
  ELSIF (IE_TAMANHO_P = 'M') THEN
    PR_RETORNO_W := 3;
  ELSIF (IE_TAMANHO_P = 'L') THEN
    PR_RETORNO_W := 5;
  ELSIF (IE_TAMANHO_P = 'XL') THEN
    PR_RETORNO_W := 10;
  END IF;

  RETURN	PR_RETORNO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dias_teste_proj ( IE_TAMANHO_P text) FROM PUBLIC;

