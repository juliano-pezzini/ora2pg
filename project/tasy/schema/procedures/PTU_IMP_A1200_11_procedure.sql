-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_imp_a1200_11 ( ds_conteudo_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ds_arquivo_p ptu_pacote.ds_arquivo%type) AS $body$
DECLARE

				
ds_retorno_w			varchar(4000);
nr_seq_pacote_reg_w		bigint;

--201
cd_unimed_origem_pacote_w	varchar(10);
dt_geracao_pacote_w		timestamp;
ie_tipo_carga_pacote_w		varchar(1);
ie_tipo_informacao_pacote_w	varchar(1);
nr_versao_transacao_pacote_w	varchar(2);

--202
nr_sequencia_w			bigint;
cd_pacote_reg_w			varchar(8);
nm_pacote_reg_w			varchar(60);
cd_unimed_prestador_reg_w		varchar(4) := null;
cd_prestador_reg_w		varchar(8) := null;
nm_prestador_reg_w		varchar(40):= null;
dt_negociacao_reg_w		timestamp;
dt_publicacao_reg_w		timestamp;
ie_tipo_acomodacao_reg_w		varchar(2);
ie_tipo_pacote_reg_w		varchar(2);
cd_especialidade_reg_w		varchar(2);
dt_inicio_vigencia_w		ptu_pacote_reg.dt_inicio_vigencia%type;
dt_fim_vigencia_w			ptu_pacote_reg.dt_fim_vigencia%type;
ie_tipo_internacao_w		ptu_pacote_reg.ie_tipo_internacao%type;
vl_tot_taxas_w			ptu_pacote_reg.vl_tot_taxas%type;
vl_tot_diarias_w 			ptu_pacote_reg.vl_tot_diarias%type;
vl_tot_gases_w			ptu_pacote_reg.vl_tot_gases%type;
vl_tot_mat_w			ptu_pacote_reg.vl_tot_mat%type;
vl_tot_med_w			ptu_pacote_reg.vl_tot_med%type;
vl_tot_proc_w			ptu_pacote_reg.vl_tot_proc%type;
vl_tot_opme_w			ptu_pacote_reg.vl_tot_opme%type;
vl_tot_pacote_w			ptu_pacote_reg.vl_tot_pacote%type;
ie_honorario_w			ptu_pacote_reg.ie_honorario%type;
tipo_rede_min_w			ptu_pacote_reg.tipo_rede_min%type;
versao_pacote_w			ptu_pacote_reg.versao_pacote%type;

--'203'
ds_obs_reg_w			varchar(255);
nr_seq_pacote_w			integer;

--204
ie_tipo_item_serv_w		smallint;
ie_tipo_tabela_serv_w		smallint;
cd_servico_serv_w		integer;
ie_principal_serv_w		smallint;
ie_honorario_serv_w		varchar(1);
ie_tipo_participacao_serv_w	varchar(1);
qt_servico_serv_w		ptu_pacote_servico.qt_servico%type;
vl_servico_serv_w		ptu_pacote_servico.vl_servico%type;
ds_servico_w			ptu_pacote_servico.ds_servico%type;
ds_hash_w			ptu_pacote.ds_hash%type;

-- 205
cd_unimed_prestador_w		ptu_pacote_prest.cd_unimed_prestador%type;
cd_prestador_w			ptu_pacote_prest.cd_prestador%type;
nm_prestador_w			ptu_pacote_prest.nm_prestador%type;
cd_cgc_cpf_w			ptu_pacote_prest.cd_cgc_cpf%type;
cd_cnes_prest_w			ptu_pacote_prest.cd_cnes_prest%type;


BEGIN
ds_retorno_w	:= trim(both substr(ds_conteudo_p,9,3));

-- Tipo de Registro: R201 ? HEADER (OBRIGAT?RIO)
if (ds_retorno_w = '201')	then
	cd_unimed_origem_pacote_w	:= trim(both substr(ds_conteudo_p,12,4));
	ie_tipo_carga_pacote_w		:= trim(both substr(ds_conteudo_p,24,1));
	ie_tipo_informacao_pacote_w	:= trim(both substr(ds_conteudo_p,25,1));
	nr_versao_transacao_pacote_w	:= trim(both substr(ds_conteudo_p,26,2));
	
	Insert into ptu_pacote(nr_sequencia, cd_unimed_origem, dt_geracao,
		ie_tipo_carga, ie_tipo_informacao , nr_versao_transacao,
		cd_estabelecimento, dt_atualizacao, nm_usuario,
		dt_importacao, nm_usuario_arq, ds_arquivo)
	values (nextval('ptu_pacote_seq'), cd_unimed_origem_pacote_w, clock_timestamp(),
		ie_tipo_carga_pacote_w, ie_tipo_informacao_pacote_w,nr_versao_transacao_pacote_w,
		cd_estabelecimento_p, clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p, ds_arquivo_p);

-- Tipo de Registro: R202 ? PACOTE (OBRIGAT?RIO)
elsif (ds_retorno_w = '202') 	then
	cd_pacote_reg_w			:= trim(both substr(ds_conteudo_p,12,8));
	nm_pacote_reg_w			:= trim(both substr(ds_conteudo_p,20,60));	
	ie_tipo_acomodacao_reg_w	:= trim(both substr(ds_conteudo_p,148,2));
	ie_tipo_pacote_reg_w		:= trim(both substr(ds_conteudo_p,150,2));
	cd_especialidade_reg_w		:= trim(both substr(ds_conteudo_p,152,2));
	ie_tipo_internacao_w		:= trim(both substr(ds_conteudo_p,170,1));
	vl_tot_taxas_w			:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,171,14));
	vl_tot_diarias_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,185,14));
	vl_tot_gases_w			:= NULL;  -- OS 2005283
	vl_tot_mat_w			:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,213,14));
	vl_tot_med_w			:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,227,14));
	vl_tot_proc_w			:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,241,14));
	vl_tot_opme_w			:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,255,14));
	ie_honorario_w			:= trim(both substr(ds_conteudo_p,283,1));
	tipo_rede_min_w			:= trim(both substr(ds_conteudo_p,284,1));
	versao_pacote_w			:= trim(both substr(ds_conteudo_p,285,3));
	
	begin
	dt_inicio_vigencia_w	:= to_date(substr(ds_conteudo_p,160,2) || substr(ds_conteudo_p,158,2) || substr(ds_conteudo_p,154,4), 'dd/mm/yyyy');
	exception
	when others then
		dt_inicio_vigencia_w	:= null;
	end;
	
	begin
	dt_fim_vigencia_w	:= to_date(substr(ds_conteudo_p,168,2) || substr(ds_conteudo_p,166,2) || substr(ds_conteudo_p,162,4), 'dd/mm/yyyy');
	exception
	when others then
		dt_fim_vigencia_w	:= null;
	end;
		
	select 	max(nr_sequencia)
	into STRICT 	nr_seq_pacote_w
	from 	ptu_pacote
	where 	nm_usuario = nm_usuario_p;
		
	vl_tot_pacote_w := (vl_tot_taxas_w + vl_tot_diarias_w + vl_tot_mat_w + vl_tot_med_w + vl_tot_proc_w + vl_tot_opme_w);
	
	insert into ptu_pacote_reg(nr_sequencia, cd_pacote, nm_pacote,
		cd_unimed_prestador, cd_prestador, nm_prestador,
		dt_negociacao, dt_publicacao, ie_tipo_acomodacao,
		ie_tipo_pacote, cd_especialidade, ds_observacao,
		dt_atualizacao, nm_usuario, nr_seq_pacote,
		ie_tipo_informacao, dt_inicio_vigencia, dt_fim_vigencia,
		ie_tipo_internacao, vl_tot_taxas, vl_tot_diarias,
		vl_tot_gases, vl_tot_mat, vl_tot_med,
		vl_tot_proc, vl_tot_opme, vl_tot_pacote,
		ie_honorario, tipo_rede_min, versao_pacote)
	values (nextval('ptu_pacote_reg_seq'),cd_pacote_reg_w, nm_pacote_reg_w, 
		cd_unimed_prestador_reg_w, cd_prestador_reg_w, nm_prestador_reg_w,  
		clock_timestamp(), clock_timestamp(), ie_tipo_acomodacao_reg_w, 
		ie_tipo_pacote_reg_w, cd_especialidade_reg_w, ds_obs_reg_w,
		clock_timestamp(), nm_usuario_p,nr_seq_pacote_w,
		1, dt_inicio_vigencia_w, dt_fim_vigencia_w,
		ie_tipo_internacao_w, vl_tot_taxas_w, vl_tot_diarias_w, 
		vl_tot_gases_w, vl_tot_mat_w, vl_tot_med_w,
		vl_tot_proc_w, vl_tot_opme_w, vl_tot_pacote_w,
		ie_honorario_w, tipo_rede_min_w, versao_pacote_w);

-- Tipo de Registro: R203 ? OBSERVA??O (OPCIONAL)
elsif (ds_retorno_w = '203')	then
	cd_pacote_reg_w		:= trim(both substr(ds_conteudo_p,12,8));
	ds_obs_reg_w		:= trim(both substr(ds_conteudo_p,21,255));
	
	select 	max(nr_sequencia)
	into STRICT 	nr_seq_pacote_reg_w
	from 	ptu_pacote_reg
	where	nm_usuario = nm_usuario_p;

	update	ptu_pacote_reg
	set 	cd_pacote	= cd_pacote_reg_w,
		ds_observacao	= ds_obs_reg_w
	where 	nr_sequencia 	= nr_seq_pacote_reg_w;

-- Tipo de Registro: R204 ? SERVI?O - PACOTE (OBRIGAT?RIO)
elsif (ds_retorno_w = '204')	then
	
	select 	max(nr_sequencia)
	into STRICT 	nr_seq_pacote_reg_w
	from 	ptu_pacote_reg
	where 	nm_usuario = nm_usuario_p;
	
	select	coalesce(trim(both CASE WHEN (substr(ds_conteudo_p,12,1))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_p,12,1))::numeric  END ),0),
		coalesce(trim(both CASE WHEN (substr(ds_conteudo_p,13,1))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_p,13,1))::numeric  END ),0),
		coalesce(trim(both CASE WHEN (substr(ds_conteudo_p,14,8))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_p,14,8))::numeric  END ),0),
		trim(both CASE WHEN (substr(ds_conteudo_p,22,1))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_p,22,1))::numeric  END ),
		trim(both substr(ds_conteudo_p,23,1)),
		trim(both substr(ds_conteudo_p,24,1)),
		coalesce(trim(both CASE WHEN (substr(ds_conteudo_p,25,8))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_p,25,8))::numeric  END ),0),
		--jjung OS 524834 - conforme manual do PTU 4.1, o valor de servico n?o ser? gravado com v?rgula, portanto deve se dividr o registro do arquivo por 100 para que sejam adicionada a v?rgula, verificado com Vagner - UL
		pls_format_valor_imp_ptu(substr(ds_conteudo_p,33,14)),
		trim(both substr(ds_conteudo_p,47,80))		
	into STRICT	ie_tipo_item_serv_w,
		ie_tipo_tabela_serv_w,
		cd_servico_serv_w,
		ie_principal_serv_w,
		ie_honorario_serv_w,
		ie_tipo_participacao_serv_w,
		qt_servico_serv_w,
		vl_servico_serv_w,
		ds_servico_w
		
	;
	
	qt_servico_serv_w := dividir_sem_round((qt_servico_serv_w)::numeric, 10000);
	
	insert 	into ptu_pacote_servico(nr_sequencia,ie_tipo_item, ie_tipo_tabela,
		cd_servico, ie_principal, ie_honorario, 
		ie_tipo_participacao,qt_servico, vl_servico,
		dt_atualizacao,nm_usuario,nr_seq_pacote_reg,
		ds_servico, vl_serv_tot)	
	values (nextval('ptu_pacote_servico_seq'),ie_tipo_item_serv_w, ie_tipo_tabela_serv_w, 
		cd_servico_serv_w,ie_principal_serv_w, coalesce(ie_honorario_serv_w,'N'), 
		ie_tipo_participacao_serv_w,qt_servico_serv_w, vl_servico_serv_w,
		clock_timestamp(),nm_usuario_p, nr_seq_pacote_reg_w,
		ds_servico_w, (qt_servico_serv_w * vl_servico_serv_w));
		
-- Tipo de Registro: R205 ? PRESTADOR (OBRIGAT?RIO)
elsif (ds_retorno_w = '205') then

	cd_unimed_prestador_w	:= trim(both substr(ds_conteudo_p,12,4));
	cd_prestador_w		:= trim(both substr(ds_conteudo_p,16,8));
	nm_prestador_w		:= trim(both substr(ds_conteudo_p,24,70));
	cd_cgc_cpf_w		:= trim(both substr(ds_conteudo_p,94,15));
	cd_cnes_prest_w		:= trim(both substr(ds_conteudo_p,109,7));

	select 	max(nr_sequencia)
	into STRICT 	nr_seq_pacote_reg_w
	from 	ptu_pacote_reg
	where 	nm_usuario = nm_usuario_p;
	
	insert into ptu_pacote_prest(nr_sequencia,dt_atualizacao,nm_usuario,
		dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_pacote_reg,
		cd_unimed_prestador,cd_prestador,nm_prestador,
		cd_cgc_cpf,nr_seq_prestador,cd_cnes_prest)
	values (nextval('ptu_pacote_prest_seq'),clock_timestamp(),nm_usuario_p,
		clock_timestamp(),nm_usuario_p,nr_seq_pacote_reg_w,
		cd_unimed_prestador_w,cd_prestador_w,nm_prestador_w,
		cd_cgc_cpf_w,null,cd_cnes_prest_w);

-- Tipo de Registro: R998 ? Hash (OBRIGAT?RIO)
elsif (ds_retorno_w = '998')	then

	ds_hash_w := trim(both substr(ds_conteudo_p,12,32));

	select 	max(nr_sequencia)
	into STRICT 	nr_seq_pacote_w
	from 	ptu_pacote
	where 	nm_usuario = nm_usuario_p;
	
	update	ptu_pacote
	set	ds_hash		= ds_hash_w
	where	nr_sequencia	= nr_seq_pacote_w;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_a1200_11 ( ds_conteudo_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ds_arquivo_p ptu_pacote.ds_arquivo%type) FROM PUBLIC;

