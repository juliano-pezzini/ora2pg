-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_campos_antimicrobiano (nr_prescricao_p bigint, nr_seq_material_p bigint, qt_dias_liberado_p bigint, qt_dias_solicitado_p bigint, ds_campo_p text ) AS $body$
BEGIN

if (nr_prescricao_p > 0)    and (nr_seq_material_p > 0)  then
	if (ds_campo_p IS NOT NULL AND ds_campo_p::text <> '') then
		if (upper(ds_campo_p) =  'L') then
			update prescr_material
			set	qt_dias_liberado = qt_dias_liberado_p
			where nr_prescricao = nr_prescricao_p
			and	nr_sequencia = nr_seq_material_p
			and	qt_dias_solicitado > 0;
		elsif (upper(ds_campo_p) = 'A') then
			update prescr_material
			set	dt_aprovacao_cih = clock_timestamp()
			where nr_prescricao = nr_prescricao_p
			and	nr_sequencia = nr_seq_material_p
			and	qt_dias_solicitado > 0;
		end if;
		commit;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_campos_antimicrobiano (nr_prescricao_p bigint, nr_seq_material_p bigint, qt_dias_liberado_p bigint, qt_dias_solicitado_p bigint, ds_campo_p text ) FROM PUBLIC;
