-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medico_exec_cpoe ( cd_protocolo_p protocolo_medic_proc.cd_protocolo%type default null, nr_seq_proc_p protocolo_medic_proc.nr_sequencia%type default null, nr_seq_item_proc_p protocolo_medic_proc.nr_seq_proc%type default null, nr_seq_proc_rotina_p procedimento_rotina.nr_sequencia%type default null, nr_seq_rotina_p exame_lab_rotina.nr_seq_exame_interno%type default null, nr_proc_interno_p proc_interno.nr_sequencia%type default null) RETURNS bigint AS $body$
DECLARE

    nr_retorno_w bigint;

BEGIN
    nr_retorno_w := 0;

    -- protocolo
    if (cd_protocolo_p IS NOT NULL AND cd_protocolo_p::text <> '' AND nr_seq_proc_p IS NOT NULL AND nr_seq_proc_p::text <> '') then
        select coalesce(cd_medico_exec,0)
        into STRICT nr_retorno_w
        from protocolo_medic_proc
        where cd_protocolo = cd_protocolo_p
        and nr_seq_proc = nr_seq_item_proc_p
        and nr_sequencia = nr_seq_proc_p;
    end if;

    -- exames laboratoriais
    if (nr_retorno_w = 0 and (nr_seq_proc_rotina_p IS NOT NULL AND nr_seq_proc_rotina_p::text <> '')) then
        select coalesce(cd_medico_exec,0)
        into STRICT nr_retorno_w
        from procedimento_rotina
        where nr_sequencia = nr_seq_proc_rotina_p;
    end if;

    -- exames nao laboratoriais
    if (nr_retorno_w  = 0 and (nr_seq_rotina_p IS NOT NULL AND nr_seq_rotina_p::text <> '')) then
        select coalesce(cd_medico_exec,0)
        into STRICT nr_retorno_w
        from exame_lab_rotina
        where nr_sequencia = nr_seq_rotina_p;
    end if;

    -- proc. interno
    if (nr_retorno_w  = 0 and (nr_proc_interno_p IS NOT NULL AND nr_proc_interno_p::text <> '')) then
        select coalesce(cd_medico_exec, obter_medico_exec_proc(cd_procedimento,ie_origem_proced,wheb_usuario_pck.get_cd_estabelecimento))
        into STRICT nr_retorno_w
        from proc_interno
        where nr_sequencia = nr_proc_interno_p;
    end if;

    return nr_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medico_exec_cpoe ( cd_protocolo_p protocolo_medic_proc.cd_protocolo%type default null, nr_seq_proc_p protocolo_medic_proc.nr_sequencia%type default null, nr_seq_item_proc_p protocolo_medic_proc.nr_seq_proc%type default null, nr_seq_proc_rotina_p procedimento_rotina.nr_sequencia%type default null, nr_seq_rotina_p exame_lab_rotina.nr_seq_exame_interno%type default null, nr_proc_interno_p proc_interno.nr_sequencia%type default null) FROM PUBLIC;

