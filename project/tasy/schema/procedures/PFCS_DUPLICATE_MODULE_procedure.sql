-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_duplicate_module ( nr_seq_module_p bigint ) AS $body$
BEGIN
    CALL pfcs_pck_dynamic_exports.duplicate_module(nr_seq_module_p);
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_duplicate_module ( nr_seq_module_p bigint ) FROM PUBLIC;

