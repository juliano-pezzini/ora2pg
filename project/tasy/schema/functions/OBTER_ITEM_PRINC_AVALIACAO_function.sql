-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_item_princ_avaliacao ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_seq_Superior_w			bigint	:= 1;


BEGIN

nr_sequencia_w			:= nr_sequencia_p;
while (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') LOOP
	begin
	select nr_seq_superior
	into STRICT nr_seq_superior_w
	from Med_Item_Avaliar
	where nr_sequencia	= nr_sequencia_w;
	if (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') then
		nr_sequencia_w	:= nr_seq_superior_w;
	end if;
	end;
END LOOP;

RETURN nr_sequencia_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_item_princ_avaliacao ( nr_sequencia_p bigint) FROM PUBLIC;

