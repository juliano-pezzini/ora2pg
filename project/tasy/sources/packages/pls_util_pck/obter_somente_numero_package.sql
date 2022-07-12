-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_util_pck.obter_somente_numero (ds_valor_p text) RETURNS bigint AS $body$
DECLARE


nr_valor_w	bigint;

BEGIN

nr_valor_w := (regexp_replace(ds_valor_p, '[^-(0-9)(-)(,)]', ''))::numeric;

return nr_valor_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_util_pck.obter_somente_numero (ds_valor_p text) FROM PUBLIC;
