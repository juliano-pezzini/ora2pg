-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION allow_check_grid (NR_SEQ_APAP_INFO_P W_APAP_PAC_INFORMACAO.NR_SEQUENCIA%TYPE) RETURNS varchar AS $body$
DECLARE

    ALLOW_W  DOCUMENTO_SUBSECAO.IE_PLOT_STYLE%TYPE;

BEGIN
    SELECT
        coalesce(MAX(SUB.IE_PLOT_STYLE),'N') allow_check
    INTO STRICT ALLOW_W
    FROM DOCUMENTO_SUBSECAO SUB
    INNER JOIN W_APAP_PAC_INFORMACAO AINF ON
        AINF.NR_SEQ_DOC_SUBSECAO = SUB.NR_SEQUENCIA
    WHERE
        coalesce(SUB.NR_SEQ_SUPERIOR::text, '') = '' AND
        AINF.NR_SEQUENCIA = NR_SEQ_APAP_INFO_P;

    RETURN ALLOW_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION allow_check_grid (NR_SEQ_APAP_INFO_P W_APAP_PAC_INFORMACAO.NR_SEQUENCIA%TYPE) FROM PUBLIC;
