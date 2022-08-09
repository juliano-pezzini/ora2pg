-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_atualiza_obs_item_result ( nr_seq_resultado_p bigint, nr_seq_prescr_p bigint, ds_observacao_p text) AS $body$
BEGIN

if (nr_seq_resultado_p IS NOT NULL AND nr_seq_resultado_p::text <> '') then

	update	exame_lab_result_item
	set	ds_observacao = ds_observacao_p
	where 	nr_seq_resultado = nr_seq_resultado_p
	and	nr_seq_prescr = nr_seq_prescr_p
	and	(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_atualiza_obs_item_result ( nr_seq_resultado_p bigint, nr_seq_prescr_p bigint, ds_observacao_p text) FROM PUBLIC;
