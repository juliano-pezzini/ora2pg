-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_dados_localizacao ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter os dados da localização
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [ X ] Tasy (Delphi/Java) [  ] Portal [ X ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
	Ie_opcao_p
	D - Descrição
	A - Andar
	B - Bloco
	CD - Código
	S - Código do setor
	DS - Descrição do setor
	DA - Descrição do andar
	LS - Localização e setor
	C - Classificação
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w			varchar(255);
ds_localizacao_w		man_localizacao.ds_localizacao%type;
nr_seq_andar_w			man_localizacao.nr_seq_andar%type;
nr_seq_bloco_w			man_localizacao.nr_seq_bloco%type;
cd_localizacao_w		man_localizacao.cd_localizacao%type;
cd_setor_w			man_localizacao.cd_setor%type;
cd_classificacao_w		man_localizacao.cd_classificacao%type;


BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	if (ie_opcao_p = 'D') then
		select	ds_localizacao
		into STRICT	ds_retorno_w
		from	man_localizacao
		where	nr_sequencia	= nr_sequencia_p;
	elsif (ie_opcao_p = 'A') then
		select	nr_seq_andar
		into STRICT	ds_retorno_w
		from	man_localizacao
		where	nr_sequencia	= nr_sequencia_p;
	elsif (ie_opcao_p = 'B') then
		select	nr_seq_bloco
		into STRICT	ds_retorno_w
		from	man_localizacao
		where	nr_sequencia	= nr_sequencia_p;
	elsif (ie_opcao_p = 'CD') then
		select	cd_localizacao
		into STRICT	ds_retorno_w
		from	man_localizacao
		where	nr_sequencia	= nr_sequencia_p;
	elsif (ie_opcao_p = 'S') then
		select	cd_setor
		into STRICT	ds_retorno_w
		from	man_localizacao
		where	nr_sequencia	= nr_sequencia_p;
	elsif (ie_opcao_p = 'DS') then
		select	cd_setor
		into STRICT	cd_setor_w
		from	man_localizacao
		where	nr_sequencia	= nr_sequencia_p;

		ds_retorno_w	:= substr(obter_nome_setor(cd_setor_w),1,255);
	elsif (ie_opcao_p = 'DA') then
		begin
		select	nr_seq_andar
		into STRICT	nr_seq_andar_w
		from	man_localizacao
		where	nr_sequencia	= nr_sequencia_p;

		select	max(ds_andar)
		into STRICT	ds_retorno_w
		from	andar_setor
		where	nr_sequencia = nr_seq_andar_w;
		end;
	elsif (ie_opcao_p = 'LS') then
		select	ds_localizacao,
			cd_setor
		into STRICT	ds_localizacao_w,
			cd_setor_w
		from	man_localizacao
		where	nr_sequencia	= nr_sequencia_p;

		ds_retorno_w	:= substr(ds_localizacao_w || ' / ' || obter_nome_setor(cd_setor_w),1,255);
	elsif (ie_opcao_p = 'C') then
		select	cd_classificacao
		into STRICT	ds_retorno_w
		from	man_localizacao
		where	nr_sequencia	= nr_sequencia_p;
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_dados_localizacao ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
