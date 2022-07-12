-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_anzics_value_default (NR_SEQ_ANZICS_ITEM_P ANZICS_ITEM.NR_SEQUENCIA%TYPE) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	anzics_item.ds_default_value%TYPE;


BEGIN
if (NR_SEQ_ANZICS_ITEM_P IS NOT NULL AND NR_SEQ_ANZICS_ITEM_P::text <> '') then

    select	
        MAX(SUBSTR(a.ds_default_value, 0, coalesce(a.qt_max_charecter, 4000)))
    into STRICT ds_retorno_w
    from ANZICS_ITEM a
    where	
        a.NR_SEQUENCIA = NR_SEQ_ANZICS_ITEM_P;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_anzics_value_default (NR_SEQ_ANZICS_ITEM_P ANZICS_ITEM.NR_SEQUENCIA%TYPE) FROM PUBLIC;
