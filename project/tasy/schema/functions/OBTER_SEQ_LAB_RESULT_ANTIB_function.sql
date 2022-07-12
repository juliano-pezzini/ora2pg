-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_lab_result_antib ( nr_seq_resultado_p bigint, nr_seq_result_item_p bigint, cd_microorganismo_p bigint, nr_cultura_microorg_p bigint DEFAULT 0) RETURNS bigint AS $body$
DECLARE


nr_seq_lab_res_antib_w		bigint;



BEGIN

SELECT	MAX(nr_sequencia)
INTO STRICT	nr_seq_lab_res_antib_w
FROM	exame_lab_result_antib
WHERE 	nr_seq_resultado 	= nr_seq_resultado_p
AND 	nr_seq_result_item 	= nr_seq_result_item_p
AND 	cd_microorganismo 	= cd_microorganismo_p
AND		coalesce(nr_cultura_microorg,0) = coalesce(nr_cultura_microorg_p,0);

RETURN	nr_seq_lab_res_antib_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_lab_result_antib ( nr_seq_resultado_p bigint, nr_seq_result_item_p bigint, cd_microorganismo_p bigint, nr_cultura_microorg_p bigint DEFAULT 0) FROM PUBLIC;

