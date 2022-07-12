-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_cancer_pck.get_if_tcth (cd_pessoa_fisica_p text) RETURNS bigint AS $body$
DECLARE


      ds_retorno_w    integer;


BEGIN        

        select  CASE WHEN count(*)=0 THEN  98  ELSE 1 END 
        into STRICT    ds_retorno_w
        from    san_transfusao st,	
                san_producao_v sp,
                san_derivado sd
        where   st.nr_sequencia = sp.nr_seq_transfusao
        and     sp.sg_sigla = sd.sg_sigla
        and     st.cd_pessoa_fisica = cd_pessoa_fisica_p
        and (sd.ie_tipo_derivado = 'MO' or sd.ie_tipo_derivado = 'CT')
        and     coalesce(st.dt_cancelamento::text, '') = ''
        and     st.dt_transfusao between alto_custo_pck.get_data_inicio_emissao_guia
                                      and alto_custo_pck.get_data_corte;

        return ds_retorno_w;

	  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_cancer_pck.get_if_tcth (cd_pessoa_fisica_p text) FROM PUBLIC;