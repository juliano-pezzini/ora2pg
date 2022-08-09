-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_stem7_points (NR_STEM7_EDITION_P bigint) AS $body$
BEGIN
    CALL DPC_PKG.UPDATE_STEM7_POINTS(NR_STEM7_EDITION_P);
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_stem7_points (NR_STEM7_EDITION_P bigint) FROM PUBLIC;
