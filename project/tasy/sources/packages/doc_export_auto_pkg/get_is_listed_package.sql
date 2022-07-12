-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION doc_export_auto_pkg.get_is_listed (DS_LIST_P RELATORIO_DINAMICO.DS_SQL%TYPE, DS_ELEM_P RELATORIO_DINAMICO.DS_LABEL%TYPE) RETURNS RELATORIO_AUTO_IMP.IE_EXPORTAR_DOCUMENTO%TYPE AS $body$
DECLARE


    DS_CHECK_W RELATORIO_AUTO_IMP.IE_EXPORTAR_DOCUMENTO%TYPE;


BEGIN

    DS_CHECK_W := 'N';

    IF position(';'||DS_ELEM_P||';' in ';'||DS_LIST_P||';') > 0 THEN

      DS_CHECK_W := 'S';

    END IF;

    RETURN DS_CHECK_W;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION doc_export_auto_pkg.get_is_listed (DS_LIST_P RELATORIO_DINAMICO.DS_SQL%TYPE, DS_ELEM_P RELATORIO_DINAMICO.DS_LABEL%TYPE) FROM PUBLIC;
