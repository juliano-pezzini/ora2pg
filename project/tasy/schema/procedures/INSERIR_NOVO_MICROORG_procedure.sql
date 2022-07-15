-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_novo_microorg ( nr_seq_resultado_p bigint, nr_seq_result_item_p bigint, cd_microorganismo_p bigint, qt_microorganismo_p text, ds_obs_microorganismo_p text, ie_micro_sem_antib_p text, nm_usuario_p text, nr_cultura_microorg_p bigint ) AS $body$
BEGIN
insert into exame_lab_result_antib(
									nr_sequencia,
									nr_seq_resultado,
									nr_seq_result_item,
									cd_microorganismo,
									dt_atualizacao,
									nm_usuario,
									qt_microorganismo,
									ds_obs_microorganismo,
									ie_micro_sem_antib,
									nr_cultura_microorg,
									ie_resultado)
							values ( nextval('exame_lab_result_antib_seq'),
									nr_seq_resultado_p,
									nr_seq_result_item_p,
									cd_microorganismo_p,
									clock_timestamp(),
									nm_usuario_p,
									qt_microorganismo_p,
									ds_obs_microorganismo_p,
									ie_micro_sem_antib_p,
									nr_cultura_microorg_p,
									'N');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_novo_microorg ( nr_seq_resultado_p bigint, nr_seq_result_item_p bigint, cd_microorganismo_p bigint, qt_microorganismo_p text, ds_obs_microorganismo_p text, ie_micro_sem_antib_p text, nm_usuario_p text, nr_cultura_microorg_p bigint ) FROM PUBLIC;

