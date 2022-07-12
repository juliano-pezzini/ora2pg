-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_carta_compromisso (nr_conta_p bigint) RETURNS varchar AS $body$
DECLARE

				
  ds_cartas_w	varchar(255);

  c_cartas CURSOR FOR
    SELECT nr_sequencia
    from carta_compromisso
    where nr_interno_conta = nr_conta_p
    order by nr_sequencia;
BEGIN
	
	for c_carta_w in c_cartas loop
	begin
		select (CASE WHEN (ds_cartas_w IS NOT NULL AND ds_cartas_w::text <> '') THEN ds_cartas_w ||','|| c_carta_w.nr_sequencia ELSE c_carta_w.nr_sequencia END)
		into STRICT ds_cartas_w
		;
	end;
	end loop;
	
	return ds_cartas_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_carta_compromisso (nr_conta_p bigint) FROM PUBLIC;
