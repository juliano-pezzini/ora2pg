-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_incluir_frase_obs_exame_js ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_sequencia_p bigint, ds_frase_p text) AS $body$
DECLARE


nr_seq_resultado_w	bigint;


BEGIN

select	max(nr_seq_resultado)
into STRICT	nr_seq_resultado_w
from	exame_lab_resultado
where 	nr_prescricao = nr_prescricao_p;

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') and (ds_frase_p IS NOT NULL AND ds_frase_p::text <> '') then

	if (nr_sequencia_p <> 0) then
		update	exame_lab_result_item
		set 	ds_observacao = ds_observacao||' '||ds_frase_p
		where	nr_seq_prescr = nr_seq_prescr_p
		and	nr_seq_resultado = nr_seq_resultado_w
		and	nr_sequencia = nr_sequencia_p;
	else
		update	exame_lab_result_item
		set 	ds_observacao = ds_observacao||' '||ds_frase_p
		where	nr_seq_prescr = nr_seq_prescr_p
		and	nr_seq_resultado = nr_seq_resultado_w
		and 	(nr_seq_formato IS NOT NULL AND nr_seq_formato::text <> '')
		and 	(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_incluir_frase_obs_exame_js ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_sequencia_p bigint, ds_frase_p text) FROM PUBLIC;

