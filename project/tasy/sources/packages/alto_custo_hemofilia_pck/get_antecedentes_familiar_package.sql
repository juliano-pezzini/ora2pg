-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_hemofilia_pck.get_antecedentes_familiar () RETURNS varchar AS $body$
DECLARE

    ds_retorno_w varchar(255);

BEGIN
    select  coalesce(max('0'), '1')
    into STRICT    ds_retorno_w
    from    table(alto_custo_pck.get_atendimentos_paciente(current_setting('alto_custo_hemofilia_pck.option_all_w')::varchar(1))) t,
            paciente_antec_clinico p
    where   p.nr_atendimento = t.nr_atendimento
    and     (p.nr_seq_parentesco IS NOT NULL AND p.nr_seq_parentesco::text <> '')
    and     alto_custo_pck.is_alto_custo(p.cd_doenca, current_setting('alto_custo_hemofilia_pck.ie_tipo_doenca_w')::regra_alto_custo.ie_tipo_doenca%type) = 'S'
    and     coalesce(p.dt_inativacao::text, '') = ''
    and     (p.dt_liberacao IS NOT NULL AND p.dt_liberacao::text <> '');

    return ds_retorno_w;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_hemofilia_pck.get_antecedentes_familiar () FROM PUBLIC;
