-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sac_responsavel (nr_seq_tipo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_responsavel_w	varchar(40) := '';


BEGIN

if (nr_seq_tipo_p = 0) then
	ds_responsavel_w := substr(wheb_mensagem_pck.get_texto(300625),1,40);
	/*'Não Informado';*/

else
	begin
	select	ds_responsavel
	into STRICT	ds_responsavel_w
	from	sac_responsavel
	where	nr_sequencia = (	SELECT	nr_seq_resp
					from	sac_tipo_ocorrencia
					where	nr_sequencia = nr_seq_tipo_p);
	end;
end if;

return	ds_responsavel_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sac_responsavel (nr_seq_tipo_p bigint) FROM PUBLIC;
