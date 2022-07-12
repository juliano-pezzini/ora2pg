-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rp_obter_status_lista (nr_seq_lista_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w varchar(255);

BEGIN

if (nr_seq_lista_p IS NOT NULL AND nr_seq_lista_p::text <> '') then
	if (ie_opcao_p = 'D') then

		select	CASE WHEN ie_status='A' THEN wheb_mensagem_pck.get_texto(803027) WHEN ie_status='T' THEN wheb_mensagem_pck.get_texto(803030) WHEN ie_status='C' THEN wheb_mensagem_pck.get_texto(309479) WHEN ie_status='B' THEN wheb_mensagem_pck.get_texto(795187)  ELSE '' END
		into STRICT	ds_retorno_w
		from	RP_LISTA_ESPERA_MODELO
		where	nr_sequencia = nr_seq_lista_p;

	elsif (ie_opcao_p = 'C') then

		select	max(ie_status)
		into STRICT	ds_retorno_w
		from	RP_LISTA_ESPERA_MODELO
		where	nr_sequencia = nr_seq_lista_p;

	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rp_obter_status_lista (nr_seq_lista_p bigint, ie_opcao_p text) FROM PUBLIC;
