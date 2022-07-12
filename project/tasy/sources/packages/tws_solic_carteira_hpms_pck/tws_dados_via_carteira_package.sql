-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Verificar o status e qual processo sera executado no portal
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
CREATE OR REPLACE PROCEDURE tws_solic_carteira_hpms_pck.tws_dados_via_carteira ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, ie_aplicacao_p wsuite_configuracao.ie_aplicacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_carteira_p INOUT pls_segurado_carteira.nr_sequencia%type, ds_mensagem_portal_p INOUT pls_regra_segurado_cart.ds_mensagem_portal%type, vl_via_adicional_p INOUT pls_regra_segurado_cart.vl_via_adicional%type, ie_status_p INOUT text) AS $body$
DECLARE




nr_seq_regra_w		bigint;
pr_via_adicional_w	double precision	:= 0;
vl_via_adicional_w	pls_regra_segurado_cart.vl_via_adicional%type	:= 0;
ds_mensagem_portal_w	pls_regra_segurado_cart.ds_mensagem_portal%type;
ds_retorno_w		varchar(5);
					
c01 CURSOR FOR
	SELECT 	a.ie_situacao,
       		(SELECT count(1) from pls_carteira_emissao b where b.nr_seq_seg_carteira = a.nr_sequencia and coalesce(b.dt_entrega_beneficiario::text, '') = '') qt_emissao,
       		(a.nr_via_solicitacao + 1) nr_via_carteira,
       		a.nr_sequencia nr_seq_carteira,
		(select count(1) from pls_solic_carteira_adic b where b.nr_seq_carteira = a.nr_sequencia and b.ie_status = '0') qt_solic_aprovacao,
		b.nr_seq_contrato,
		b.nr_seq_plano
	from   	pls_segurado_carteira a,
		pls_segurado b
	where  	a.nr_seq_segurado = b.nr_sequencia
	and	b.nr_sequencia = nr_seq_segurado_p  LIMIT 1;					
					
BEGIN

for c01_w in c01 loop
	
	pls_obter_regra_via_adic(c01_w.nr_seq_contrato, null, c01_w.nr_seq_plano, c01_w.nr_via_carteira, 'N', nm_usuario_p, cd_estabelecimento_p, clock_timestamp(), nr_seq_regra_w, vl_via_adicional_w, pr_via_adicional_w);
	
	
	if ( c01_w.ie_situacao = 'D' and c01_w.qt_emissao = 0 and c01_w.qt_solic_aprovacao = 0) then
		ds_retorno_w := 'N'; --Novo registro
		
		if ( (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') and nr_seq_regra_w > 0 ) then
			select  ds_mensagem_portal				
			into STRICT	ds_mensagem_portal_w
			from	pls_regra_segurado_cart
			where	nr_sequencia = nr_seq_regra_w;			
		end if;
	elsif ( c01_w.ie_situacao = 'D' and c01_w.qt_emissao > 0 ) then
		ds_retorno_w := 'CR';--Confirmacao de recebimento		
	else
		ds_retorno_w := 'A';--Em analise na Operadora
	end if;
	
	nr_seq_carteira_p	:= c01_w.nr_seq_carteira;
	ds_mensagem_portal_p	:= ds_mensagem_portal_w;
	vl_via_adicional_p	:= vl_via_adicional_w;
	ie_status_p		:= ds_retorno_w;
end loop;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tws_solic_carteira_hpms_pck.tws_dados_via_carteira ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, ie_aplicacao_p wsuite_configuracao.ie_aplicacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_carteira_p INOUT pls_segurado_carteira.nr_sequencia%type, ds_mensagem_portal_p INOUT pls_regra_segurado_cart.ds_mensagem_portal%type, vl_via_adicional_p INOUT pls_regra_segurado_cart.vl_via_adicional%type, ie_status_p INOUT text) FROM PUBLIC;