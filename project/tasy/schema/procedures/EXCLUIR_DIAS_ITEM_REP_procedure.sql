-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_dias_item_rep ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_tipo_item_p text) AS $body$
BEGIN

if (ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	if (ie_tipo_item_p = 'SOL') then

		delete from rep_dias_solucao
		where	nr_prescricao = nr_prescricao_p
		and		nr_seq_solucao = nr_sequencia_p;

	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_dias_item_rep ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_tipo_item_p text) FROM PUBLIC;
