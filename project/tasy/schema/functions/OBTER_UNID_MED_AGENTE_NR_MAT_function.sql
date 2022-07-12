-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_unid_med_agente_nr_mat ( NR_SEQ_MAT_P bigint ) RETURNS varchar AS $body$
DECLARE
 ds_retorno_w varchar(100);

BEGIN
    select	obter_desc_unid_med(aa.cd_unid_med_apres)
    into STRICT	ds_retorno_w
    from    agente_anestesico aa, agente_anest_material aam
    where aam.nr_sequencia = nr_seq_mat_p
        and aam.nr_seq_agente = aa.nr_sequencia;
    return	ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_unid_med_agente_nr_mat ( NR_SEQ_MAT_P bigint ) FROM PUBLIC;
