-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_inicio_gest_hs (nr_atendimento_p bigint) RETURNS timestamp AS $body$
DECLARE




dt_retorno_w timestamp;



BEGIN
    if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
        select a.dt_inicio_gestacao
        into STRICT dt_retorno_w
        from HISTORICO_SAUDE_MULHER a
        where a.nr_sequencia = (SELECT max(x.nr_sequencia) 
                                from HISTORICO_SAUDE_MULHER x 
                                where a.cd_pessoa_fisica = x.cd_pessoa_fisica 
                                and x.cd_pessoa_fisica = obter_pf_atendimento(nr_atendimento_p,'C') 
                                and (x.dt_liberacao IS NOT NULL AND x.dt_liberacao::text <> '') and coalesce(x.dt_inativacao::text, '') = '');
    end if;
    return dt_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_inicio_gest_hs (nr_atendimento_p bigint) FROM PUBLIC;
