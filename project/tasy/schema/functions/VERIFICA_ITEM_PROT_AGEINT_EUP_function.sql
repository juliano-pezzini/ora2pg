-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_item_prot_ageint_eup (nr_seq_ageint_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(10);
qt_todos_itens_w	varchar(10);
qt_itens_w	varchar(10);


BEGIN

if (nr_seq_ageint_p IS NOT NULL AND nr_seq_ageint_p::text <> '') then

	select		count(*)
	into STRICT		qt_todos_itens_w
	from		ageint_exame_lab
	where		nr_seq_ageint = nr_seq_ageint_p
	and		(dt_prevista IS NOT NULL AND dt_prevista::text <> '');

	select		count(*)
	into STRICT		qt_itens_w
	from		ageint_exame_lab
	where		nr_seq_ageint = nr_seq_ageint_p
	and		(dt_prevista IS NOT NULL AND dt_prevista::text <> '')
	and		(nr_prescricao IS NOT NULL AND nr_prescricao::text <> '');

	if (qt_itens_w = qt_todos_itens_w) then
	   ds_retorno_w := 'U';
	elsif (qt_itens_w > 0) and (qt_itens_w < qt_todos_itens_w) then
	   ds_retorno_w := 'UP';
	elsif (qt_itens_w = 0) then
	   ds_retorno_w := 'NU';
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_item_prot_ageint_eup (nr_seq_ageint_p bigint) FROM PUBLIC;
