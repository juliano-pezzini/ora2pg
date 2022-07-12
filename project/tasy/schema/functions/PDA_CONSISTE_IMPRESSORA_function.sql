-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pda_consiste_impressora (nr_seq_impressora_p bigint) RETURNS varchar AS $body$
DECLARE


ds_erro_w		varchar(255) := '';
ds_endereco_rede_w     	varchar(255);
ds_endereco_ip_w		varchar(255);


BEGIN

select 	max(ds_endereco_rede),
	max(ds_endereco_ip)
into STRICT	ds_endereco_rede_w,
	ds_endereco_ip_w
from	impressora
where	nr_sequencia = nr_seq_impressora_p;

if (coalesce(ds_endereco_rede_w::text, '') = '' or coalesce(ds_endereco_ip_w::text, '') = '') then
	ds_erro_w := wheb_mensagem_pck.get_texto(309618); -- Impressora não cadastrada
end if;

return	ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pda_consiste_impressora (nr_seq_impressora_p bigint) FROM PUBLIC;

