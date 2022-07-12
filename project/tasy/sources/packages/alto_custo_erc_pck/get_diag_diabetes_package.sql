-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_erc_pck.get_diag_diabetes ( cd_pessoa_fisica_p text ) RETURNS varchar AS $body$
DECLARE

        ds_retorno_w varchar(255);

    
BEGIN
    
        select  coalesce(max(1),2)
        into STRICT    ds_retorno_w
        from    diagnostico_doenca a,
                atendimento_paciente b
        where   a.nr_atendimento = b.nr_atendimento
        and     b.cd_pessoa_fisica = cd_pessoa_fisica_p
        and     a.cd_doenca in (SELECT  cd_doenca_cid 
                                from    cid_doenca 
                                where   ie_doenca_cronica_mx = 'DIABT')
		and		a.dt_diagnostico <= alto_custo_pck.get_data_corte;

      return ds_retorno_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_erc_pck.get_diag_diabetes ( cd_pessoa_fisica_p text ) FROM PUBLIC;