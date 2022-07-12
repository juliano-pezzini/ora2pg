-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_hash_assinatura ( nr_seq_assinatura_p bigint) RETURNS varchar AS $body$
DECLARE

ds_texto_w varchar(255);

BEGIN
ds_texto_w := '';
if (nr_seq_assinatura_p IS NOT NULL AND nr_seq_assinatura_p::text <> '') then
    select  coalesce(max(ds_hash_assinatura),'')
    into STRICT    ds_texto_w
    from    tasy_assinatura_digital
    where   nr_sequencia = nr_seq_assinatura_p
    and (ds_hash_assinatura IS NOT NULL AND ds_hash_assinatura::text <> '');
end if;

return ds_texto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_hash_assinatura ( nr_seq_assinatura_p bigint) FROM PUBLIC;
