-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nfse_obter_regra (ie_opcao_p text, cd_estabelecimento_p text default null) RETURNS varchar AS $body$
DECLARE


/*	ie_opcao_p			
	TR - Codigo de tipo de RPS 
	RET - Codigo de identificacao do regime especial de tributacao 
	OSN - Optante simples nacional
	IC - Incentivador cultural
	TP - Tributação prestador
	VL - Buscar valor de envio para a NFSe
	DTP - Descrição Tributação Prestador.
	TD - Tipo documento
*/
			
ie_tipo_rps_w		integer;
ie_regime_especial_trib_w	integer;
ie_optante_simples_nac_w	varchar(255);			
ie_incentivador_cultural_w	varchar(255);			
nr_tributacao_prestador_w	bigint;	
cd_tributacao_prestador_w	varchar(15);			
vl_retorno_w		varchar(255);
ie_altera_valor_nfse_w	varchar(10);
ds_tributacao_prestador_w	varchar(255);
cd_tipo_documento_w	varchar(255);
nr_seq_tipo_documento_w	bigint;
qt_regra_w		bigint;

BEGIN

select	count(*)
into STRICT	qt_regra_w
from	nfse_regra
where	cd_estabelecimento = coalesce(cd_estabelecimento_p, cd_estabelecimento);

if (qt_regra_w > 1) then

	select	max(ie_tipo_rps),
		max(ie_regime_especial_trib),
		max(ie_optante_simples_nac),
		max(ie_incentivador_cultural),
		max(coalesce(nr_seq_trib_prestador, 0)),
		max(ie_altera_valor_nfse),
		max(nr_seq_tipo_documento)
	into STRICT	ie_tipo_rps_w,
		ie_regime_especial_trib_w,
		ie_optante_simples_nac_w,
		ie_incentivador_cultural_w,
		nr_tributacao_prestador_w,
		ie_altera_valor_nfse_w,
		nr_seq_tipo_documento_w
	from	nfse_regra
	where	cd_estabelecimento = coalesce(cd_estabelecimento_p, cd_estabelecimento);
	
else

	select	ie_tipo_rps,
		ie_regime_especial_trib,
		ie_optante_simples_nac,
		ie_incentivador_cultural,
		coalesce(nr_seq_trib_prestador, 0),
		ie_altera_valor_nfse,
		nr_seq_tipo_documento
	into STRICT	ie_tipo_rps_w,
		ie_regime_especial_trib_w,
		ie_optante_simples_nac_w,
		ie_incentivador_cultural_w,
		nr_tributacao_prestador_w,
		ie_altera_valor_nfse_w,
		nr_seq_tipo_documento_w
	from	nfse_regra
	where	cd_estabelecimento = coalesce(cd_estabelecimento_p, cd_estabelecimento);

end if;

if (upper(ie_opcao_p) = 'TR') then
	vl_retorno_w	:= ie_tipo_rps_w;
elsif (upper(ie_opcao_p) = 'RET') then	
	vl_retorno_w	:= ie_regime_especial_trib_w;
elsif (upper(ie_opcao_p) = 'OSN') then	
	vl_retorno_w	:= ie_optante_simples_nac_w;
elsif (upper(ie_opcao_p) = 'IC') then	
	vl_retorno_w	:= ie_incentivador_cultural_w;
elsif (upper(ie_opcao_p) = 'VL') then
	vl_retorno_w	:= ie_altera_valor_nfse_w;
elsif (upper(ie_opcao_p) = 'TP') then	
	begin	
	select	max(cd_situacao)
	into STRICT	cd_tributacao_prestador_w
	from	situacao_trib_prest_serv
	where	nr_sequencia = nr_tributacao_prestador_w;
	
	vl_retorno_w	:= cd_tributacao_prestador_w;	
	end;
elsif (upper(ie_opcao_p) = 'DTP') then
	begin
	select	substr(ds_situacao,1,255)
	into STRICT	ds_tributacao_prestador_w
	from	situacao_trib_prest_serv
	where	nr_sequencia = nr_tributacao_prestador_w
	and		cd_situacao = (	SELECT	max(cd_situacao)
							from	situacao_trib_prest_serv
							where	nr_sequencia = cd_tributacao_prestador_w);
	vl_retorno_w	:= ds_tributacao_prestador_w;
	end;
elsif (upper(ie_opcao_p) = 'TD') then
	begin	
	select	cd_tipo_documento
	into STRICT	cd_tipo_documento_w
	from	nfse_tipo_doc_fiscal
	where	nr_sequencia = nr_seq_tipo_documento_w;	
	
	vl_retorno_w	:= cd_tipo_documento_w;
	end;	
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nfse_obter_regra (ie_opcao_p text, cd_estabelecimento_p text default null) FROM PUBLIC;

