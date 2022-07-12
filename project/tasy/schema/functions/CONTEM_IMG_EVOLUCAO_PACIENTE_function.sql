-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION contem_img_evolucao_paciente ( CD_EVOLUCAO_P text ) RETURNS varchar AS $body$
DECLARE

vl_retorno_w		varchar(4000);

BEGIN
            select case when consulta.nr_imagem > 0 then 'S'
            else  'N' end contem_imagem
            INTO STRICT vl_retorno_w
            from ( SELECT distinct count(ds_arquivo) nr_imagem
            from    evolucao_paciente_imagem epi
            where epi.cd_evolucao = CD_EVOLUCAO_P) consulta;

    
return	coalesce(vl_retorno_w,' ');
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION contem_img_evolucao_paciente ( CD_EVOLUCAO_P text ) FROM PUBLIC;

