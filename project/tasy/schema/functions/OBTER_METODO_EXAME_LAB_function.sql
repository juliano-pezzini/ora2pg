-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_metodo_exame_lab (nr_seq_metodo_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE

nr_sequencia_w             bigint;
ds_metodo_exame_w        varchar(255);
ds_retorno_w       varchar(255);
/* ie_opcao_p
   1 - nr_sequencia
   2 - ds_metodo_exame
*/
BEGIN
ds_retorno_w := '';
if (nr_seq_metodo_p IS NOT NULL AND nr_seq_metodo_p::text <> '') then
	select	nr_sequencia,
		ds_metodo
	into STRICT	nr_sequencia_w,
		ds_metodo_exame_w
	from metodo_exame_lab
	where nr_sequencia = coalesce(nr_seq_metodo_p,nr_sequencia);

	if (ie_opcao_p = 1) then
	   ds_retorno_w := nr_sequencia_w;
	elsif (ie_opcao_p = 2) then
	   ds_retorno_w := ds_metodo_exame_w;
	end if;
end if;

return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_metodo_exame_lab (nr_seq_metodo_p bigint, ie_opcao_p bigint) FROM PUBLIC;

