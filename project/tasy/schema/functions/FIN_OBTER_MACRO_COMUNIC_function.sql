-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fin_obter_macro_comunic ( nr_sequencia_p bigint, cd_funcao_p bigint, cd_evento_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2000);
ds_enter_w		varchar(10) := chr(13) || chr(10);
cd_funcao_w		integer;
cd_evento_w		varchar(3);


BEGIN

if (coalesce(nr_sequencia_p,0) = 0) then

	cd_funcao_w	:= cd_funcao_p;
	cd_evento_w	:= cd_evento_p;

else

	select	max(a.cd_funcao),
		max(b.cd_evento)
	into STRICT	cd_funcao_w,
		cd_evento_w
	from	fin_regra_envio_comunic a,
		fin_regra_comunic_evento b
	where	b.nr_seq_regra	= a.nr_sequencia
	and	b.nr_sequencia	= nr_sequencia_p;

end if;

if (cd_funcao_w = 815) and (cd_evento_w = '5') then
	ds_retorno_w := '@DT_RECEBIMENTO = Data de recebimento da cobranca escritural' || ds_enter_w ||
			'@NR_SEQUENCIA = Numero de sequencia da cobranca escritural' || ds_enter_w ||
			'@DS_BANCO = Nome do banco da cobranca escritural' || ds_enter_w || 
			'@DT_CREDITO_BANCARIO = Data da movimentacao na conta bancaria';
end if;

if (cd_funcao_w = 813) and (cd_evento_w = '6') then
    ds_retorno_w := '@DS_EMPRESA = Nome da empresa que o usuario esta logado' || ds_enter_w ||
            '@DS_CLIENTE = Nome do Cliente' || ds_enter_w ||
            '@DS_ESTABELECIMENTO = Nome do estabelecimento que o usuario esta logado' || ds_enter_w ||
            '@DT_COBRANCA = Data da cobranca PIX' || ds_enter_w ||
            '@VALOR_COBRANCA = Valor da cobranca PIX' || ds_enter_w ||
            '@PIX_COPIA_COLA = Pix Copia e Cola' || ds_enter_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fin_obter_macro_comunic ( nr_sequencia_p bigint, cd_funcao_p bigint, cd_evento_p text) FROM PUBLIC;

