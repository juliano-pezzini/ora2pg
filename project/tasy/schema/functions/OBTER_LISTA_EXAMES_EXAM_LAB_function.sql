-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_exames_exam_lab (nr_seq_suep_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000) := '';

nr_seq_item_w item_suep.nr_sequencia%type;
nr_seq_exame_w informacao_suep.nr_seq_exame%type;

c01 CURSOR FOR
	SELECT	nr_seq_exame
	from	informacao_suep
	where	nr_seq_item = nr_seq_item_w
	and	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '');


BEGIN

select	nr_sequencia
into STRICT	nr_seq_item_w
from	item_suep
where	nr_seq_suep = nr_seq_suep_p
and		ie_tipo_item = 'EG';

open c01;
	loop
	fetch c01 into
		nr_seq_exame_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
			if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
				ds_retorno_w :=  ds_retorno_w || ',';
			end if;
			ds_retorno_w :=  ds_retorno_w || nr_seq_exame_w;
		end;
		end loop;
	close c01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_exames_exam_lab (nr_seq_suep_p bigint) FROM PUBLIC;
