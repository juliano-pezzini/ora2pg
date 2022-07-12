-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION smart_obter_status_suspensao ( dt_susp_prescr_p prescr_medica.dt_suspensao%type, dt_susp_material_p prescr_material.dt_suspensao%type, nr_seq_cpoe_p cpoe_material.nr_sequencia%type, ie_tipo_item_p text default 'M') RETURNS timestamp AS $body$
DECLARE


dt_suspensao_cpoe_w         cpoe_material.dt_suspensao%type;
dt_suspensao_cpoe_retorno_w cpoe_material.dt_suspensao%type;


BEGIN

dt_suspensao_cpoe_retorno_w := null;

if ((dt_susp_prescr_p IS NOT NULL AND dt_susp_prescr_p::text <> '') or (dt_susp_material_p IS NOT NULL AND dt_susp_material_p::text <> '')) then
    dt_suspensao_cpoe_retorno_w := coalesce(dt_susp_prescr_p,dt_susp_material_p);
end if;

if ((nr_seq_cpoe_p IS NOT NULL AND nr_seq_cpoe_p::text <> '') and
        coalesce(dt_suspensao_cpoe_retorno_w::text, '') = '') then
    if (ie_tipo_item_p = 'M') then
        select  max(a.dt_suspensao)
        into STRICT    dt_suspensao_cpoe_w
        from    cpoe_material   a
        where   a.nr_sequencia  = nr_seq_cpoe_p
        and     (a.dt_lib_suspensao IS NOT NULL AND a.dt_lib_suspensao::text <> '');
    elsif (ie_tipo_item_p = 'P') then
        select  max(a.dt_suspensao)
        into STRICT    dt_suspensao_cpoe_w
        from    cpoe_procedimento   a
        where   a.nr_sequencia  = nr_seq_cpoe_p
        and     (a.dt_lib_suspensao IS NOT NULL AND a.dt_lib_suspensao::text <> '');
    end if;
    if ((dt_suspensao_cpoe_w IS NOT NULL AND dt_suspensao_cpoe_w::text <> '') and dt_suspensao_cpoe_w <= clock_timestamp()) then
        dt_suspensao_cpoe_retorno_w := dt_suspensao_cpoe_w;
    end if;
end if;

return dt_suspensao_cpoe_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION smart_obter_status_suspensao ( dt_susp_prescr_p prescr_medica.dt_suspensao%type, dt_susp_material_p prescr_material.dt_suspensao%type, nr_seq_cpoe_p cpoe_material.nr_sequencia%type, ie_tipo_item_p text default 'M') FROM PUBLIC;

