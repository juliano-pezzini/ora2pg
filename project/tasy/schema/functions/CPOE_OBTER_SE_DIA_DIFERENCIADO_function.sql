-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_se_dia_diferenciado ( nr_seq_cpoe_p cpoe_procedimento.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE


qt_proc_dia_dif_w		bigint;


BEGIN
-- retorna se utiliza intervalo diferenciado por dias
select	min(1)
into STRICT	qt_proc_dia_dif_w
from	cpoe_dias_procedimento d
where	d.nr_seq_proc_cpoe = nr_seq_cpoe_p;

if (qt_proc_dia_dif_w IS NOT NULL AND qt_proc_dia_dif_w::text <> '') then
    return qt_proc_dia_dif_w;
end if;

return null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_se_dia_diferenciado ( nr_seq_cpoe_p cpoe_procedimento.nr_sequencia%type) FROM PUBLIC;
