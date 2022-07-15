-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cih_excluir_resultado_culturas (nr_ficha_ocorrencia_p bigint, nr_seq_cultura_p bigint, cd_medicamento_p bigint, ie_resultado_cultura_p text) AS $body$
BEGIN

if	((nr_ficha_ocorrencia_p IS NOT NULL AND nr_ficha_ocorrencia_p::text <> '') and (nr_seq_cultura_p IS NOT NULL AND nr_seq_cultura_p::text <> '') and (cd_medicamento_p IS NOT NULL AND cd_medicamento_p::text <> '') and (ie_resultado_cultura_p IS NOT NULL AND ie_resultado_cultura_p::text <> '')) then
	delete	FROM cih_Cultura_medic
	where	nr_ficha_ocorrencia 	= nr_ficha_ocorrencia_p
	and	nr_seq_cultura 		= nr_seq_cultura_p
	and	cd_medicamento		= cd_medicamento_p
	and	ie_resultado_cultura	= ie_resultado_cultura_p;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cih_excluir_resultado_culturas (nr_ficha_ocorrencia_p bigint, nr_seq_cultura_p bigint, cd_medicamento_p bigint, ie_resultado_cultura_p text) FROM PUBLIC;

