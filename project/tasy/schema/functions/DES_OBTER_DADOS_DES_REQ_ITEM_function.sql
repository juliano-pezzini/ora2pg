-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION des_obter_dados_des_req_item ( nr_seq_req_item_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255)	:= null;

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter dados do requisito
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

if (nr_seq_req_item_p IS NOT NULL AND nr_seq_req_item_p::text <> '') then
	/* Número */

	if (ie_opcao_p = 'NR') then
		select	a.nr_requisito
		into STRICT	ds_retorno_w
		from	des_requisito_item a
		where	a.nr_sequencia	= nr_seq_req_item_p;
	/* Título */

	elsif (ie_opcao_p = 'TI') then
		select	substr(a.ds_titulo,1,255)
		into STRICT	ds_retorno_w
		from	des_requisito_item a
		where	a.nr_sequencia	= nr_seq_req_item_p;
	/* Tipo do Requisito */

	elsif (ie_opcao_p = 'TR') then
		select	substr(a.ie_tipo_requisito,1,255)
		into STRICT	ds_retorno_w
		from	des_requisito_item a
		where	a.nr_sequencia	= nr_seq_req_item_p;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION des_obter_dados_des_req_item ( nr_seq_req_item_p bigint, ie_opcao_p text) FROM PUBLIC;
