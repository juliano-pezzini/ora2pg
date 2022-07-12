-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_protocolo_agenda ( nr_seq_tratamento_p bigint ) RETURNS varchar AS $body$
DECLARE

    ds_protocolo_w varchar(100) := null;

BEGIN
    if (nr_seq_tratamento_p IS NOT NULL AND nr_seq_tratamento_p::text <> '') then 
        select substr(rxt_obter_nome_protocolo(a.nr_seq_protocolo), 1, 40)
        into STRICT ds_protocolo_w
        from rxt_tratamento a
        where a.nr_sequencia = nr_seq_tratamento_p;
    end if;

    return ds_protocolo_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_protocolo_agenda ( nr_seq_tratamento_p bigint ) FROM PUBLIC;

