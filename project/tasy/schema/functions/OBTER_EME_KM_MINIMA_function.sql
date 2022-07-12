-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_eme_km_minima (nr_seq_veiculo_p bigint, nr_seq_custo_km_p bigint DEFAULT 0) RETURNS bigint AS $body$
DECLARE


qt_km_minima_w		bigint;


BEGIN

SELECT coalesce(MAX(qt_km_minima),0)
INTO STRICT	qt_km_minima_w
FROM eme_custo_km_veiculo
WHERE nr_seq_veiculo = nr_seq_veiculo_p
AND dt_vigencia  = (
		SELECT MAX(dt_vigencia)
		FROM eme_custo_km_veiculo
		WHERE nr_seq_veiculo =  nr_seq_veiculo_p
		AND dt_vigencia <= clock_timestamp()
		AND (( coalesce(nr_seq_custo_km_p,0) = 0) OR (nr_sequencia = coalesce(nr_seq_custo_km_p,0))))
AND (( coalesce(nr_seq_custo_km_p,0) = 0) OR (nr_sequencia = coalesce(nr_seq_custo_km_p,0)));

RETURN qt_km_minima_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_eme_km_minima (nr_seq_veiculo_p bigint, nr_seq_custo_km_p bigint DEFAULT 0) FROM PUBLIC;
