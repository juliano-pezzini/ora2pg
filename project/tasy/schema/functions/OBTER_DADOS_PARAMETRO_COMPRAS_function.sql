-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_parametro_compras ( cd_estabelecimento_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE


/* 0 - OBRIGA JUSTIFICAR DIVERGENCIA OC NF 
     1 - MOEDA		
     2 - CONDICAO PAGAMENTO PADRAO
     3 - INTERFACE ENVIO TXT
     4 - INTERFACE RETORNO TXT
     5 - TIPO INTERFACE
     6 - FORMA ENVIO DOS ITENS DA COTACAO
     7 - IE_SOLIC_PENDENTE      
     8 - IE_COTACAO_PENDENTE    
     9 - IE_ORDEM_PENDENTE
     10 - IE_PRECO_DUPLICADO_COTACAO
     11 - PR_TAXA_INFLACAO
     12 - IE_RESPOSTA_INT_COMPRA
     13 - PROGRAMACAO ENTREGA
     14 - NATUREZA OPERACAO RPS
     15 - CD_RESPONSAVEL_COMPRAS
     16 - CD_COMPRADOR_PADRAO
     17 - QT_DIA_BAIXA_ORDEM
     18 - DS_LOGIN_INTEGR_COMPRAS_SC
     19 - DS_SENHA_INTEGR_COMPRAS_SC
     20 - CD_PESSOA_SOLIC_PADRAO (SOLICITANTE)
     21 - IE_FORMA_PAGTO_INT_COMPRA
     22 - IE_DATA_HORA_INT_COMPRA
     23 - IE_OBS_INT_COMPRA
     24 - IE_CONV_QTDE_INT_COMPRA
     25 - IE_APROVACAO_NIVEL
     26 - CPF Diretor Responsavel
     27 - IE_DATA_BASE_EIS_COMPRA_W
     28 - IE_TETO_APROVACAO
     29 - IE_GERAR_OC_INTEGRACAO	
     30 - NR_TELEFONE
     31 - NR_DDD_TELEFONE
     32 - IE_OCULTAR_MESMO_CARGO
	 33 - IE_PUBLICA_COTACAO
*/
ds_retorno_w			varchar(255);
ie_diverg_oc_nf_w			varchar(1);
cd_moeda_w			smallint;
cd_cond_pagto_padrao_w		bigint;
cd_interface_envio_w		integer;
cd_interface_retorno_w		integer;
ie_tipo_interface_w		varchar(25);
ie_forma_envio_cot_w		varchar(15);
ie_solic_pendente_w		varchar(1);
ie_cotacao_pendente_w		varchar(1);
ie_ordem_pendente_w		varchar(1);
ie_preco_duplicado_cotacao_w	varchar(1);
pr_taxa_inflacao_w		double precision;
ie_resposta_int_compra_w		varchar(1);
ie_entrega_int_compra_w		varchar(1);
ie_nat_oper_rps_w			smallint;
cd_responsavel_compras_w		varchar(10);
cd_comprador_padrao_w		varchar(10);
qt_dia_baixa_ordem_w		integer;
ds_login_integr_compras_sc_w	varchar(255);
ds_senha_integr_compras_sc_w	varchar(255);
cd_pessoa_solic_padrao_w		varchar(10);
ie_forma_pagto_int_compra_w	varchar(1);
ie_data_hora_int_compra_w		varchar(1);
ie_obs_int_compra_w		varchar(1);
ie_conv_qtde_int_compra_w		varchar(1);
ie_aprovacao_nivel_w		varchar(1);
cd_cpf_responsavel_w		varchar(20);
ie_data_base_eis_compra_w		varchar(15);
IE_TETO_APROVACAO_w		varchar(15);
ie_gerar_oc_integracao_w		varchar(1);
nr_telefone_w				varchar(15);
nr_ddd_telefone_w			varchar(3);
ie_ocultar_mesmo_cargo_w		varchar(1);
ie_publica_cotacao_w			parametro_compras.ie_publica_cotacao%type;


BEGIN

select	coalesce(max(ie_diverg_oc_nf),'N'),
	max(cd_moeda_padrao),
	max(cd_condicao_pagamento_padrao),
	max(cd_interface_envio),
	max(cd_interface_retorno),
	max(ie_tipo_interface_compras),
	coalesce(max(ie_forma_envio_cot),'IC'),
	coalesce(max(ie_solic_pendente),'S'),
	coalesce(max(ie_cotacao_pendente),'S'),
	coalesce(max(ie_ordem_pendente),'S'),
	coalesce(max(ie_preco_duplicado_cotacao),'N'),
	coalesce(max(pr_taxa_inflacao),0),
	coalesce(max(ie_resposta_int_compra), 'S'),
	coalesce(max(ie_entrega_int_compra),'S'),
	coalesce(max(ie_nat_oper_rps),0),
	coalesce(max(cd_responsavel_compras),''),
	coalesce(max(cd_comprador_padrao),''),
	coalesce(max(qt_dia_baixa_ordem), 180),
	coalesce(max(ds_login_integr_compras_sc),''),
	coalesce(max(ds_senha_integr_compras_sc),''),
	coalesce(max(cd_pessoa_solic_padrao),''),
	coalesce(max(ie_forma_pagto_int_compra),'S'),
	coalesce(max(ie_data_hora_int_compra),'S'),
	coalesce(max(ie_obs_int_compra),'S'),
	coalesce(max(ie_conv_qtde_int_compra),'N'),
	coalesce(max(ie_aprovacao_nivel),'N'),
	substr(coalesce(max(OBTER_CPF_PESSOA_FISICA(cd_diretor_responsavel)),'0'),1,20),
	coalesce(max(ie_data_base_eis_compra),'E'),
	coalesce(max(IE_TETO_APROVACAO),'N'),
	coalesce(max(ie_gerar_oc_integracao),'S'),
	coalesce(max(nr_telefone),'') nr_telefone,
	coalesce(max(nr_ddd_telefone),'') nr_ddd_telefone,
	coalesce(max(ie_ocultar_mesmo_cargo),'N'),
	max(ie_publica_cotacao)
into STRICT	ie_diverg_oc_nf_w,
	cd_moeda_w,
	cd_cond_pagto_padrao_w,
	cd_interface_envio_w,
	cd_interface_retorno_w,
	ie_tipo_interface_w,
	ie_forma_envio_cot_w,
	ie_solic_pendente_w,
	ie_cotacao_pendente_w,
	ie_ordem_pendente_w,
	ie_preco_duplicado_cotacao_w,
	pr_taxa_inflacao_w,
	ie_resposta_int_compra_w,
	ie_entrega_int_compra_w,
	ie_nat_oper_rps_w,
	cd_responsavel_compras_w,
	cd_comprador_padrao_w,
	qt_dia_baixa_ordem_w,
	ds_login_integr_compras_sc_w,
	ds_senha_integr_compras_sc_w,
	cd_pessoa_solic_padrao_w,
	ie_forma_pagto_int_compra_w,
	ie_data_hora_int_compra_w,
	ie_obs_int_compra_w,
	ie_conv_qtde_int_compra_w,
	ie_aprovacao_nivel_w,
	cd_cpf_responsavel_w,
	ie_data_base_eis_compra_w,
	IE_TETO_APROVACAO_w,
	ie_gerar_oc_integracao_w,
	nr_telefone_w,
	nr_ddd_telefone_w,
	ie_ocultar_mesmo_cargo_w,
	ie_publica_cotacao_w
from	parametro_compras
where	cd_estabelecimento = cd_Estabelecimento_p;

if (ie_opcao_p = 0) then
	ds_retorno_w := ie_diverg_oc_nf_w;
elsif (ie_opcao_p = 1) then
	ds_retorno_w := cd_moeda_w;
elsif (ie_opcao_p = 2) then
	ds_retorno_w := cd_cond_pagto_padrao_w;
elsif (ie_opcao_p = 3) then
	ds_retorno_w := cd_interface_envio_w;
elsif (ie_opcao_p = 4) then
	ds_retorno_w := cd_interface_retorno_w;
elsif (ie_opcao_p = 5) then
	ds_retorno_w :=  ie_tipo_interface_w;
elsif (ie_opcao_p = 6) then
	ds_retorno_w :=  ie_forma_envio_cot_w;
elsif (ie_opcao_p = 7) then
	ds_retorno_w :=  ie_solic_pendente_w;
elsif (ie_opcao_p = 8) then
	ds_retorno_w :=  ie_cotacao_pendente_w;
elsif (ie_opcao_p = 9) then
	ds_retorno_w :=  ie_ordem_pendente_w;
elsif (ie_opcao_p = 10) then
	ds_retorno_w :=  ie_preco_duplicado_cotacao_w;
elsif (ie_opcao_p = 11) then
	ds_retorno_w :=  pr_taxa_inflacao_w;
elsif (ie_opcao_p = 12) then
	ds_retorno_w :=  ie_resposta_int_compra_w;
elsif (ie_opcao_p = 13) then
	ds_retorno_w :=  ie_entrega_int_compra_w;
elsif (ie_opcao_p = 14) then
	ds_retorno_w :=  ie_nat_oper_rps_w;
elsif (ie_opcao_p = 15) then
	ds_retorno_w :=  cd_responsavel_compras_w;
elsif (ie_opcao_p = 16) then
	ds_retorno_w :=  cd_comprador_padrao_w;
elsif (ie_opcao_p = 17) then
	ds_retorno_w :=  qt_dia_baixa_ordem_w;
elsif (ie_opcao_p = 18) then
	ds_retorno_w :=  ds_login_integr_compras_sc_w;
elsif (ie_opcao_p = 19) then
	ds_retorno_w :=  ds_senha_integr_compras_sc_w;
elsif (ie_opcao_p = 20) then
	ds_retorno_w :=  cd_pessoa_solic_padrao_w;
elsif (ie_opcao_p = 21) then
	ds_retorno_w :=  ie_forma_pagto_int_compra_w;
elsif (ie_opcao_p = 22) then
	ds_retorno_w :=  ie_data_hora_int_compra_w;
elsif (ie_opcao_p = 23) then
	ds_retorno_w := ie_obs_int_compra_w;
elsif (ie_opcao_p = 24) then
	ds_retorno_w := ie_conv_qtde_int_compra_w;
elsif (ie_opcao_p = 25) then
	ds_retorno_w := ie_aprovacao_nivel_w;
elsif (ie_opcao_p = 26) then
	ds_retorno_w := cd_cpf_responsavel_w;
elsif (ie_opcao_p = 27) then
	ds_retorno_w := ie_data_base_eis_compra_w;
elsif (ie_opcao_p = 28) then
	ds_retorno_w := IE_TETO_APROVACAO_w;
elsif (ie_opcao_p = 29) then
	ds_retorno_w := ie_gerar_oc_integracao_w;
elsif (ie_opcao_p = 30) then
	ds_retorno_w := nr_telefone_w;
elsif (ie_opcao_p = 31) then
	ds_retorno_w := nr_ddd_telefone_w;
elsif (ie_opcao_p = 32) then
	ds_retorno_w := ie_ocultar_mesmo_cargo_w;
elsif (ie_opcao_p = 33) then
	ds_retorno_w := ie_publica_cotacao_w;	
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_parametro_compras ( cd_estabelecimento_p bigint, ie_opcao_p bigint) FROM PUBLIC;
