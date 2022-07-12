-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION default_comp_update ( nr_sequencia_p bigint, nr_seq_dieta_p bigint) RETURNS boolean AS $body$
DECLARE


nut_cur CURSOR(nr_sequencia_p bigint, nr_seq_dieta_p bigint) FOR
SELECT nut.*
FROM nut_composicao nut, dieta_comp_servico dc
WHERE nut.nr_sequencia = dc.nr_seq_composicao_serv
AND dc.nr_sequencia = nr_sequencia_p
AND dc.nr_seq_dieta = nr_seq_dieta_p;



nut_ele nut_composicao%rowtype;
i bigint;


BEGIN
	OPEN nut_cur(nr_sequencia_p,nr_seq_dieta_p);
	LOOP
		FETCH nut_cur INTO nut_ele;
	EXIT WHEN NOT FOUND; /* apply on nut_cur */

	BEGIN
		UPDATE(SELECT dc.*
		FROM dieta_comp_servico dc, nut_composicao nc
		WHERE nc.nr_sequencia = dc.nr_seq_composicao_serv
		AND dc.nr_sequencia <> nr_sequencia_p
		AND dc.nr_seq_dieta = nr_seq_dieta_p
		AND (coalesce(nc.ie_beverage,'N') = nut_ele.ie_beverage OR coalesce(nc.ie_beverage,'N') = 'N')
		AND (coalesce(nc.ie_staple_food,'N') = nut_ele.ie_staple_food OR coalesce(nc.ie_staple_food,'N') = 'N')
		AND dc.ie_comp_padrao = 'S')
		SET ie_comp_padrao = 'N';

		GET DIAGNOSTICS i = ROW_COUNT;
	END;
	END LOOP;
	CLOSE nut_cur;

	IF i >= 1 THEN

	return TRUE;
END IF;

RETURN FALSE;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION default_comp_update ( nr_sequencia_p bigint, nr_seq_dieta_p bigint) FROM PUBLIC;

