-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_get_if_adep_modified (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ie_adep_modified_w                varchar(2);


BEGIN

select    coalesce(max('S'), 'N')
into STRICT      ie_adep_modified_w
from    prescr_material a,
    prescr_mat_hor b,
    prescr_mat_alteracao c
where nr_seq_mat_cpoe = nr_sequencia_p
and a.nr_prescricao = b.nr_prescricao
and a.nr_sequencia = b.nr_seq_material
and b.nr_sequencia = c.NR_SEQ_HORARIO
and c.ie_alteracao in (65,66);


return    ie_adep_modified_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_get_if_adep_modified (nr_sequencia_p bigint) FROM PUBLIC;
