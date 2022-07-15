-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE deactivate_stem7 (NR_SEQ_EDITION_P bigint, NM_USUARIO_P text) AS $body$
BEGIN
    CALL DPC_PKG.DEACTIVATE_STEM7(NR_SEQ_EDITION_P, NM_USUARIO_P);
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE deactivate_stem7 (NR_SEQ_EDITION_P bigint, NM_USUARIO_P text) FROM PUBLIC;

