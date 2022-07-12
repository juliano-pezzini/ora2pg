-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION gpt_utils_pck.get_rev_prescr_plan (nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, ie_revisao_pendente_p text) RETURNS SETOF T_REV_PRESCR_PLAN AS $body$
DECLARE


    c01 CURSOR FOR
        SELECT	*
        from	prescr_medica
        where	nr_atendimento = nr_atendimento_p
        and		cd_pessoa_fisica = cd_pessoa_fisica_p
        and		(dt_liberacao_medico IS NOT NULL AND dt_liberacao_medico::text <> '')
        and (ie_revisao_pendente_p = 'N' or coalesce(dt_revisao::text, '') = '')
        and		coalesce(dt_inicio_analise_farm::text, '') = ''
        and		coalesce(nm_usuario_analise_farm::text, '') = ''
        and		dt_prescricao	> (clock_timestamp() - interval '3 days')
        
union

        SELECT	*
        from	prescr_medica
        where	cd_pessoa_fisica = cd_pessoa_fisica_p
        and		coalesce(nr_atendimento::text, '') = ''
        and		(dt_liberacao_medico IS NOT NULL AND dt_liberacao_medico::text <> '') 
        and (ie_revisao_pendente_p = 'N' or coalesce(dt_revisao::text, '') = '')
        and		coalesce(dt_inicio_analise_farm::text, '') = ''
        and		coalesce(nm_usuario_analise_farm::text, '') = ''
        and		dt_prescricao	> (clock_timestamp() - interval '3 days');

BEGIN
    for r_c01_w in c01 loop
        RETURN NEXT r_c01_w;
    end loop;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION gpt_utils_pck.get_rev_prescr_plan (nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, ie_revisao_pendente_p text) FROM PUBLIC;