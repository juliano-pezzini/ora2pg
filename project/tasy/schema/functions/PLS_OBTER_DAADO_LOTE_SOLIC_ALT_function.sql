-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_daado_lote_solic_alt ( nr_seq_lote_solic_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/*ie_opcao_p 
D - Data solicitação 
M - Motivo de negação 
U - Usuário solicitação 
I - Origem do processo 
O - Observação 
Q - Quantidade de solicitações pendentes 
S - Status 
L - Status (retorna o ie) 
T - Tipo de complemento 
DS - Descrição do setor do usuário 
*/
 
 
ds_retorno_w		varchar(255);
qt_registros_w		bigint;
ds_chave_composta_w	varchar(255);
ie_tipo_complemento_w	varchar(255);


BEGIN 
 
if (ie_opcao_p	= 'D') then 
	select	to_char(DT_ATUALIZACAO_NREC,'dd/mm/yyyy hh24:mi:ss') 
	into STRICT	ds_retorno_w 
	from	TASY_SOLIC_ALTERACAO 
	where	nr_sequencia	= nr_seq_lote_solic_p;
elsif (ie_opcao_p	= 'M') then 
	select	substr(b.DS_MOTIVO,1,255) 
	into STRICT	ds_retorno_w 
	from	TASY_MOTIVO_NEG_SOLIC_ALT	b, 
		TASY_SOLIC_ALTERACAO		a 
	where	a.NR_SEQ_MOTIVO_NEG		= b.nr_sequencia 
	and	a.nr_sequencia			= nr_seq_lote_solic_p;
elsif (ie_opcao_p	= 'U') then 
	select	substr(obter_usuario_alteracao(nm_usuario_nrec), 1,255) 
	into STRICT	ds_retorno_w 
	from	tasy_solic_alteracao 
	where	nr_sequencia	= nr_seq_lote_solic_p;
elsif (ie_opcao_p = 'DS') then 
	select	substr(Obter_dados_usuario_opcao(nm_usuario_nrec,'DS'), 1,255) 
	into STRICT	ds_retorno_w 
	from	tasy_solic_alteracao 
	where	nr_sequencia	= nr_seq_lote_solic_p;
elsif (ie_opcao_p	= 'I') then 
	select	CASE WHEN IE_PROCESSO='M' THEN 'Manual' WHEN IE_PROCESSO='W' THEN 'Portal Web' WHEN IE_PROCESSO='A' THEN 'Arquivo' END  
	into STRICT	ds_retorno_w 
	from	TASY_SOLIC_ALTERACAO 
	where	nr_sequencia	= nr_seq_lote_solic_p;
elsif (ie_opcao_p	= 'O') then 
	SELECT	substr(ds_observacao, 1, 255) 
	into STRICT	ds_retorno_w 
	from	TASY_SOLIC_ALTERACAO 
	where	nr_sequencia	= nr_seq_lote_solic_p;
elsif (ie_opcao_p	= 'Q') then 
	select	count(1) 
	into STRICT	qt_registros_w 
	from	TASY_SOLIC_ALT_CAMPO 
	where	NR_SEQ_SOLICITACAO	= nr_seq_lote_solic_p 
	and	ie_status		= 'P';
	 
	ds_retorno_w	:= to_char(qt_registros_w);
elsif (ie_opcao_p	= 'S') then 
	select	CASE WHEN ie_status='A' THEN 'Aguardando ação' WHEN ie_status='L' THEN 'Liberada' WHEN ie_status='N' THEN 'Negada' END  
	into STRICT	ds_retorno_w 
	from	TASY_SOLIC_ALTERACAO 
	where	nr_sequencia	= nr_seq_lote_solic_p;
elsif (ie_opcao_p	= 'L') then 
	select	ie_status 
	into STRICT	ds_retorno_w 
	from	TASY_SOLIC_ALTERACAO 
	where	nr_sequencia	= nr_seq_lote_solic_p;
elsif (ie_opcao_p	= 'T') then 
	select	max(ds_chave_composta) 
	into STRICT 	ds_chave_composta_w 
	from	tasy_solic_alt_campo 
	where	nr_seq_solicitacao = nr_seq_lote_solic_p;
	 
	if (ds_chave_composta_w IS NOT NULL AND ds_chave_composta_w::text <> '') then 
		select	substr(ds_chave_composta_w,position('IE_TIPO_COMPLEMENTO=' in ds_chave_composta_w) + 20, length(ds_chave_composta_w)) 
		into STRICT	ie_tipo_complemento_w 
		;
		 
		if (ie_tipo_complemento_w = '1') then 
			ds_retorno_w	:=	'Residencial';
		elsif (ie_tipo_complemento_w = '2') then 
			ds_retorno_w	:=	'Comercial';
		elsif (ie_tipo_complemento_w = '3') then 
			ds_retorno_w	:=	'do Responsável';
		elsif (ie_tipo_complemento_w = '30') then 
			ds_retorno_w	:=	'Exclusivo cooperado';
		elsif (ie_tipo_complemento_w = '4') then 
			ds_retorno_w	:=	'do Pai';
		elsif (ie_tipo_complemento_w = '5') then 
			ds_retorno_w	:=	'da Mãe';
		elsif (ie_tipo_complemento_w = '6') then 
			ds_retorno_w	:=	'do Cônjuge';
		elsif (ie_tipo_complemento_w = '7') then 
			ds_retorno_w	:=	'Comercial 2';
		elsif (ie_tipo_complemento_w = '8') then 
			ds_retorno_w	:=	'Hospedagem';
		elsif (ie_tipo_complemento_w = '9') then 
			ds_retorno_w	:=	'Adicional';
		end if;	
	end if;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_daado_lote_solic_alt ( nr_seq_lote_solic_p bigint, ie_opcao_p text) FROM PUBLIC;

