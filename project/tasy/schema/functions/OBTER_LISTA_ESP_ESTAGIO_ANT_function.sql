-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_esp_estagio_ant (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(100);


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select	coalesce(a.ds_estagio, '')
	into STRICT	ds_retorno_w
	from	AG_LISTA_ESPERA_ESTAGIO a
	where	EXISTS ( SELECT	1
					from AG_LISTA_ESP_ESTAGIO_ANT b
					where a.nr_sequencia = b.nr_seq_estagio
					and b.nr_seq_estagio_ant = nr_sequencia_p);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_esp_estagio_ant (nr_sequencia_p bigint) FROM PUBLIC;

