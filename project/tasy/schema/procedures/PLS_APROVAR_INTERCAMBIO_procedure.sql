-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_aprovar_intercambio ( nr_seq_intercambio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, ie_permite_tab_dif_p text, ie_consiste_tab_contr_p text, ie_gerar_cartao_p text) AS $body$
DECLARE

 
ds_erro_w			varchar(4000);
ds_erro_pagador_w		varchar(100);
vl_parametro_w    		varchar(255);
nm_segurado_w			varchar(255);
cd_usuario_plano_w		varchar(30);
ie_tipo_contratacao_w		varchar(3);
ie_tipo_erro_w			varchar(2)	:= 'N';
ie_preco_w			varchar(2);
ie_aprovar_contrato_w		varchar(1)	:= 'S';
ie_tabela_contrato_w		varchar(1);
ie_tabela_base_w		varchar(1);
ie_mes_fechado_w		varchar(1);
ie_permite_prod_dif_w		varchar(1);
ie_gerar_documento_w		varchar(1);
ie_acao_contrato_w		varchar(2);
vl_preco_atual_w		double precision;
vl_desconto_atual_w		double precision;
vl_desconto_w			double precision;
qt_registros_w			bigint	:= 0;
nr_seq_segurado_w		bigint;
nr_seq_titular_w		bigint;
nr_seq_plano_w			bigint;
nr_seq_tabela_w			bigint;
nr_seq_plano_tab_w		bigint;
nr_seq_segurado_ant_w		bigint;
nr_seq_plano_seg_w		bigint;
nr_contrato_w			bigint;
nr_seq_seg_desc_w		bigint;
nr_seq_regra_atual_w 		bigint;
nr_seq_regra_desconto_w		bigint;
nr_seq_seg_preco_w		bigint;
qt_documento_w			bigint;
nr_contrato_principal_w		bigint;
dt_inclusao_w			timestamp;
dt_inicio_vigencia_w		timestamp;
dt_contratacao_w		timestamp;
ie_tipo_contrato_w		varchar(2);
ie_tipo_estipulante_w		varchar(2);
nr_seq_rescisao_obito_w		bigint;
ie_tipo_repasse_w		varchar(10);
nr_seq_resc_prog_gerada_w	bigint;

C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_seq_titular, 
		nr_seq_segurado_ant, 
		substr(pls_obter_dados_segurado(nr_sequencia,'N'),1,255), 
		nr_seq_plano, 
		nr_seq_tabela, 
		dt_contratacao, 
		ie_acao_contrato 
	from	pls_segurado 
	where	nr_seq_intercambio	= nr_seq_intercambio_p 
	order by nr_seq_titular desc;

C02 CURSOR FOR 
	SELECT	a.nr_seq_plano, 
		null, 
		b.ie_tipo_contratacao 
	from	pls_plano		b, 
		pls_intercambio_plano 	a 
	where	a.nr_seq_plano		= b.nr_sequencia 
	and	a.nr_seq_intercambio	= nr_seq_intercambio_p;

C03 CURSOR FOR 
	SELECT	a.nr_sequencia 
	from	pls_segurado	a, 
		pls_intercambio	b 
	where	b.nr_sequencia	= nr_seq_intercambio_p 
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
	and	coalesce(a.dt_rescisao::text, '') = '' 
	and	a.nr_seq_intercambio	= b.nr_sequencia;


BEGIN 
 
ds_erro_w	:= coalesce(ds_erro_p,'');
 
select	nr_seq_motivo_rescisao_obito 
into STRICT	nr_seq_rescisao_obito_w 
from	pls_parametros 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
select 	dt_inclusao, 
	ie_tipo_contrato, 
	CASE WHEN cd_pessoa_fisica='' THEN 'PJ'  ELSE 'PF' END  
into STRICT	dt_inclusao_w, 
	ie_tipo_contrato_w, 
	ie_tipo_estipulante_w 
from 	pls_intercambio 
where	nr_sequencia = nr_seq_intercambio_p;
 
if (coalesce(dt_inclusao_w::text, '') = '') then 
	ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(280537);
	if (coalesce(ie_tipo_erro_w,'N') <> 'S') then 
		ie_tipo_erro_w	:= 'N';
	end if;
end if;
 
select	pls_obter_se_mes_fechado(dt_inclusao_w,'T', cd_estabelecimento_p) 
into STRICT	ie_mes_fechado_w
;
 
 
if (ie_mes_fechado_w = 'S') then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(177824);
end if;
 
select	count(*) 
into STRICT	qt_registros_w 
from	pls_intercambio 
where	nr_sequencia	= nr_seq_intercambio_p 
and	coalesce(cd_pessoa_fisica::text, '') = '' 
and	coalesce(cd_cgc::text, '') = '';
 
if (qt_registros_w > 0) then 
	ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(280538);
	if (coalesce(ie_tipo_erro_w,'N') <> 'S') then 
		ie_tipo_erro_w	:= 'N';
	end if;
end if;
 
select	count(*) 
into STRICT	qt_registros_w 
from	pls_segurado 
where	nr_seq_intercambio	= nr_seq_intercambio_p;
 
if (qt_registros_w = 0) then 
	ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(280539);
	if (coalesce(ie_tipo_erro_w,'N') <> 'S') then 
		ie_tipo_erro_w	:= 'N';
	end if;
end if;
 
select	count(*) 
into STRICT	qt_registros_w 
from	pls_segurado 
where	nr_seq_intercambio	= nr_seq_intercambio_p 
and	coalesce(nr_seq_pagador::text, '') = '';
if (qt_registros_w > 0) then 
	ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(280540);
	if (coalesce(ie_tipo_erro_w,'N') <> 'S') then 
		ie_tipo_erro_w	:= 'N';
	end if;
end if;
 
select	count(*) 
into STRICT	qt_registros_w 
from	pls_intercambio_plano 
where	nr_seq_intercambio	= nr_seq_intercambio_p;
 
if (qt_registros_w = 0) then 
	ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(280541);
	if (coalesce(ie_tipo_erro_w,'N') <> 'S') then 
		ie_tipo_erro_w	:= 'N';
	end if;
end if;	
 
select	count(*) 
into STRICT	qt_registros_w 
from	pls_segurado 
where	nr_seq_intercambio	= nr_seq_intercambio_p 
and	coalesce(nr_seq_plano::text, '') = '';
if (qt_registros_w > 0) then 
	ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(280542);
	if (coalesce(ie_tipo_erro_w,'N') <> 'S') then 
		ie_tipo_erro_w	:= 'N';
	end if;
end if;
 
select	max(ie_tipo_repasse) 
into STRICT	ie_tipo_repasse_w 
from	pls_segurado 
where	nr_seq_intercambio	= nr_seq_intercambio_p;
 
if (coalesce(ds_erro_w::text, '') = '') then 
 
	if (ie_gerar_cartao_p = 'S') then 
		CALL ptu_cd_empresa_intercambio(nr_seq_intercambio_p,cd_estabelecimento_p,nm_usuario_p);
		CALL pls_gerar_grupos_contr_interc(nr_seq_intercambio_p,ie_tipo_repasse_w,cd_estabelecimento_p,nm_usuario_p);
		CALL pls_gerar_lanc_aut_contr_inter(nr_seq_intercambio_p,cd_estabelecimento_p,nm_usuario_p);
	end if;
	 
	open C01;
	loop 
	fetCh C01 into	 
		nr_seq_segurado_w, 
		nr_seq_titular_w, 
		nr_seq_segurado_ant_w, 
		nm_segurado_w, 
		nr_seq_plano_seg_w, 
		nr_seq_tabela_w, 
		dt_contratacao_w, 
		ie_acao_contrato_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		select	count(*) 
		into STRICT	qt_registros_w 
		from	pls_intercambio_plano a 
		where	a.nr_seq_intercambio	= nr_seq_intercambio_p 
		and	a.nr_seq_plano		= nr_seq_plano_seg_w;
		 
		if (qt_registros_w = 0) then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(177835,'NR_SEQ_SEGURADO='||nr_seq_segurado_w||'NM_SEGURADO='||nm_segurado_w);
		end if;
		 
		CALL pls_gerar_vl_seg_intercambio(null, nr_seq_segurado_w, 'C', 
				cd_estabelecimento_p, nm_usuario_p, ie_permite_tab_dif_p, ie_consiste_tab_contr_p, 
				ie_gerar_cartao_p, 'N');
		end;
	end loop;
	close C01;
	/*aaschlote 06/01/2012 - Essa procedure não pode ser chamada aqui, pois é referente a liberação do SCA dos contratos de plano de saúde 
		pls_liberar_vinculo_sca(nr_seq_intercambio_p, null, null, 'L', 'N', nm_usuario_p, cd_estabelecimento_p);*/
 
end if;
 
ds_erro_p	:= substr(ds_erro_w,1,255);
 
if (coalesce(ds_erro_p::text, '') = '') then 
	update	pls_intercambio 
	set	dt_aprovacao	= clock_timestamp(), 
		nm_usuario	= nm_usuario_p, 
		dt_atualizacao	= clock_timestamp() 
	where	nr_sequencia	= nr_seq_intercambio_p;
	 
	/*aaschlote OS 265605 09/12/2010 - Se o tipo de contrato de intercâmbio for Seguro óbito, então a data de rescisão será daqui há 5 anos*/
 
	if (ie_tipo_contrato_w	= 'S') and (ie_tipo_estipulante_w = 'PF') then 
		/*update	pls_intercambio 
		set	dt_exclusao	= dt_inclusao + 1827 
		where	nr_sequencia	= nr_seq_intercambio_p;*/
 
		/*aaschlote OS 281611 - O sistema irá gerar uma rescisão programa invés de rescindir o intercâmbio*/
 
		nr_seq_resc_prog_gerada_w := pls_gerar_rescisao_programada(nr_seq_intercambio_p, null, null, nr_seq_rescisao_obito_w, 5, dt_inclusao_w, ie_tipo_estipulante_w, 'N', wheb_mensagem_pck.get_texto(280546), nm_usuario_p, null, null, 0, null, 'S', nr_seq_resc_prog_gerada_w, null);
	end if;
	/*aaschlote OS - 319475 30/05/2011*/
 
	CALL pls_gerar_contrato_grupo(nr_seq_intercambio_p,'I',nm_usuario_p,cd_estabelecimento_p);
end if;
 
CALL pls_atualizar_mes_reaj_pck.aprovar_contrato_intercambio(nr_seq_intercambio_p, nm_usuario_p, cd_estabelecimento_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_aprovar_intercambio ( nr_seq_intercambio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, ie_permite_tab_dif_p text, ie_consiste_tab_contr_p text, ie_gerar_cartao_p text) FROM PUBLIC;

