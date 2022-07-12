-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_procedimento_pbs ( nr_seq_rxt_tumor_p rxt_tumor.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ie_nopbs_w              procedimento.ie_nopbs%type;
nr_seq_tipo_w           rxt_tipo_trat_proced.nr_seq_tipo%type;


BEGIN

    select max(a.nr_seq_tipo)
    into STRICT nr_seq_tipo_w
    from rxt_tumor a,
    rxt_tipo b
    where a.nr_seq_tipo =b.nr_sequencia
    and a.nr_sequencia = nr_seq_rxt_tumor_p;

    select max(    CASE WHEN b.ie_nopbs='S' THEN  b.ie_nopbs  ELSE coalesce(d.ie_nopbs, 'N') END )
    into STRICT nr_seq_tipo_w
    from rxt_tipo_trat_proced a
    left join procedimento b
    on a.cd_procedimento = b.cd_procedimento
    and a.ie_origem_proced = b.ie_origem_proced
    left join proc_interno c
    on a.nr_seq_proc_interno = c.nr_sequencia
    left join procedimento d
    on c.cd_procedimento = d.cd_procedimento
    and c.ie_origem_proced = d.ie_origem_proced
    where a.nr_seq_tipo = nr_seq_tipo_w;

    return ie_nopbs_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_procedimento_pbs ( nr_seq_rxt_tumor_p rxt_tumor.nr_sequencia%type) FROM PUBLIC;
