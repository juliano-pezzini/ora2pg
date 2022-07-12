-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_volume_parcial_interface (nr_seq_mat_cpoe_p bigint default 0, nr_seq_agent_p bigint default 0) RETURNS bigint AS $body$
DECLARE


qt_volume_w	                 bomba_infusao_interface.qt_volume%type;
qt_volume_inicial_w	         bomba_infusao_interface.qt_volume_inicial%type;
qt_bolus_w	                 bomba_infusao_interface.qt_bolus%type;
qt_ult_volume_w	             bomba_infusao_interface.qt_ult_volume%type;
soma_total_volume_w	         bomba_infusao_interface.qt_volume%type := 0;

c01 CURSOR FOR
SELECT
    coalesce(bii.qt_volume, 0) qt_volume,
    coalesce(bii.qt_volume_inicial, 0) qt_volume_inicial,
    coalesce(bii.qt_bolus, 0) qt_bolus,
    coalesce(bii.qt_ult_volume, 0) qt_ult_volume
from 
    bomba_infusao bi, bomba_infusao_interface bii
where 
    bi.nr_seq_bomba_interface = bii.nr_sequencia
and (nr_seq_mat_cpoe = nr_seq_mat_cpoe_p OR bi.nr_seq_agente = nr_seq_agent_p)
and ie_ativo = 'S';


BEGIN

open C01;
loop
fetch C01 into
	qt_volume_w,
    qt_volume_inicial_w,
    qt_bolus_w,
    qt_ult_volume_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
        soma_total_volume_w := soma_total_volume_w +
        (qt_volume_w - qt_volume_inicial_w + qt_bolus_w + qt_ult_volume_w);
        if (soma_total_volume_w < 0) then
        soma_total_volume_w := 0;
        end if;
	end;
end loop;
close C01;

RETURN	soma_total_volume_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_volume_parcial_interface (nr_seq_mat_cpoe_p bigint default 0, nr_seq_agent_p bigint default 0) FROM PUBLIC;
