-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_cancer_pck.get_cd_motivo_cancelamento (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


      ds_retorno_w    bigint;


BEGIN        

        select  coalesce(cd_motivo_ext,98)
        into STRICT    ds_retorno_w
        from    rxt_motivo_canc_tratamento
        where   nr_sequencia = nr_sequencia_p;

        return ds_retorno_w;

	  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_cancer_pck.get_cd_motivo_cancelamento (nr_sequencia_p bigint) FROM PUBLIC;
