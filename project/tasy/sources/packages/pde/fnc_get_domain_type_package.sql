-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pde.fnc_get_domain_type (NM_TABLE_P text, NM_ATTRIBUTE_P text) RETURNS bigint AS $body$
DECLARE

    IE_DOMINIO_W PDE_ATTRIBUTE.IE_DOMINIO%TYPE := 0;
    CD_DOMINIO_W TABELA_ATRIBUTO.CD_DOMINIO%TYPE;
    DS_VALORES_W TABELA_ATRIBUTO.DS_VALORES%TYPE;

    /*
      - IE_DOMINIO_W:
        0 - Sem dominio
        1 - Dominio Tasy
        2 - Valores
    */
  
BEGIN
    SELECT MAX(TA.CD_DOMINIO), MAX(TA.DS_VALORES)
      INTO STRICT CD_DOMINIO_W, DS_VALORES_W
      FROM OBJETO_SCHEMATIC OS
     INNER JOIN TABELA_SISTEMA TS ON OS.NM_TABELA = TS.NM_TABELA
     INNER JOIN TABELA_ATRIBUTO TA ON TS.NM_TABELA = TA.NM_TABELA
     INNER JOIN ONTOLOGIA_TABELA_ATRIBUTO OA ON OA.NM_TABELA = TA.NM_TABELA
     WHERE TA.NM_TABELA = NM_TABLE_P
       AND TA.NM_ATRIBUTO = NM_ATTRIBUTE_P;

    IF (CD_DOMINIO_W IS NOT NULL AND CD_DOMINIO_W::text <> '') THEN
      IE_DOMINIO_W := 1;
    ELSIF ((trim(both DS_VALORES_W) IS NOT NULL AND (trim(both DS_VALORES_W))::text <> '')) THEN
      IE_DOMINIO_W := 2;
    END IF;

    RETURN IE_DOMINIO_W;
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        CALL PDE.GRAVA_LOG_ERRO('FNC.GET.DOMAIN.TYPE.ERROR',
                           'NM_TABLE_P: ' || NM_TABLE_P ||
                           ', NM_ATTRIBUTE_P: ' || NM_ATTRIBUTE_P,
                           SQLSTATE,
                           SQLERRM);
        RETURN IE_DOMINIO_W;
      END;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pde.fnc_get_domain_type (NM_TABLE_P text, NM_ATTRIBUTE_P text) FROM PUBLIC;
