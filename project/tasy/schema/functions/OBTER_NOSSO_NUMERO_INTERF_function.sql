-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nosso_numero_interf ( cd_banco_p bigint, nr_titulo_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w		numeric(20);
nr_nosso_numero_w	numeric(20);


BEGIN
if (cd_banco_p IS NOT NULL AND cd_banco_p::text <> '') and (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then

	begin

	select 	elimina_caracteres_especiais(obter_nosso_numero_banco(cd_banco_p, nr_titulo_p))
	into STRICT	nr_nosso_numero_w
	;

	exception
	when others then
		/*Erro no cadastros da regra nosso número em: 'Cadastros financeiros / Banco / Contas a receber / Regra nosso número'*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(264901);
	end;

	nr_retorno_w := nr_nosso_numero_w;
end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nosso_numero_interf ( cd_banco_p bigint, nr_titulo_p bigint) FROM PUBLIC;

