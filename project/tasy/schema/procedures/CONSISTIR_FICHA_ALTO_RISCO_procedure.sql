-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_ficha_alto_risco (nr_seq_ficha_p bigint) AS $body$
DECLARE


ie_existe_material_risco_w varchar(1);


BEGIN

if (nr_seq_ficha_p IS NOT NULL AND nr_seq_ficha_p::text <> '') and (nr_seq_ficha_p > 0)	then

	select	obter_se_material_risco_PRM(nr_seq_ficha_p)
	into STRICT	ie_existe_material_risco_w
	;

	if (ie_existe_material_risco_w = 'S')	then

		update	PRM_FICHA_OCORRENCIA
		set	IE_ALTO_RISCO = 'S'
		where	NR_SEQUENCIA = nr_seq_ficha_p;

	else

		update	PRM_FICHA_OCORRENCIA
		set	IE_ALTO_RISCO = 'N'
		where	NR_SEQUENCIA = nr_seq_ficha_p;

	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_ficha_alto_risco (nr_seq_ficha_p bigint) FROM PUBLIC;

