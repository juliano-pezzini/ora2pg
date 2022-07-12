-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_baixa_neg_tit_pag ( nr_titulo_p bigint ) RETURNS bigint AS $body$
DECLARE


ds_retorno_w			regra_tipo_baixa_negociada.cd_tipo_baixa_neg%type;
cd_estabelecimento_w	titulo_pagar.cd_estabelecimento%type;
ie_origem_titulo_w		titulo_pagar.ie_origem_titulo%type;
ie_tipo_titulo_w		titulo_pagar.ie_tipo_titulo%type;
cd_tributo_w			titulo_pagar.cd_tributo%type;
cd_tipo_baixa_neg_w		regra_tipo_baixa_negociada.cd_tipo_baixa_neg%type;

/*
- Não se pode alterar o estabelecimento da regra, ele sempre vai buscar o estabelecimento logado onde a regra foi criada. O título sempre vai ter estabelecimento, pois é obrigatorio.
   Por isso na verificação do estabelecimento na regra somente deve considerar estabelecimento da regra igual ao estabelecimento do título, pois as duas informações sempre vão existir, tanto na regra e no título.

- Function utilizada inicialmente para ser utilizada dentro da rotina GERAR_TITULO_TRIBUTO, Ao ser incluida em mais algum lugar, descrever aqui.
*/
C01 CURSOR FOR
	SELECT	a.cd_tipo_baixa_neg
	from	regra_tipo_baixa_negociada a
	where	a.cd_estabelecimento	= cd_estabelecimento_w
	and		a.ie_origem_titulo		= ie_origem_titulo_w
	and		a.ie_tipo_titulo		= ie_tipo_titulo_w
	and		a.cd_tributo			= cd_tributo_w;


BEGIN

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then
	/*Busca os dados do título para tentar obter a regra através do Cursor C01*/

	select	max(a.cd_estabelecimento),
			max(a.ie_origem_titulo),
			max(a.ie_tipo_titulo),
			max(a.cd_tributo)
	into STRICT	cd_estabelecimento_w,
			ie_origem_titulo_w,
			ie_tipo_titulo_w,
			cd_tributo_w
	from	titulo_pagar a
	where	a.nr_titulo = nr_titulo_p;

	open C01;
	loop
	fetch C01 into
		cd_tipo_baixa_neg_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			ds_retorno_w := cd_tipo_baixa_neg_w;
		end;
	end loop;
	close C01;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_baixa_neg_tit_pag ( nr_titulo_p bigint ) FROM PUBLIC;
