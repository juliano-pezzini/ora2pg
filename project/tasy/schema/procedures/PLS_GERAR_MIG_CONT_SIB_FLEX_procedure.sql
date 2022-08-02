-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_mig_cont_sib_flex ( nr_seq_lote_sib_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_referencia_w			timestamp;
ie_tipo_reg_w			smallint;
nr_seq_segurado_w		pls_interf_sib.nr_seq_segurado%type;
cd_pessoa_fisica_w		pls_interf_sib.cd_pessoa_fisica%type;
nm_segurado_w			pls_interf_sib.nm_beficiario%type;
dt_nascimento_w			timestamp;
ie_sexo_w			pls_interf_sib.ie_sexo%type;
nr_pis_pasep_w			pls_interf_sib.nr_pis_pasep%type;
nm_mae_segurado_w		pls_interf_sib.nm_mae_benef%type;
cd_cns_w			pls_interf_sib.cd_cns%type;
nr_identidade_w			pls_interf_sib.nr_identidade%type;
ds_orgao_emissor_ci_w		pessoa_fisica.ds_orgao_emissor_ci%type;
cd_nacionalidade_w		pls_interf_sib.cd_nacionalidade%type;
nr_seq_titular_w		pls_segurado.nr_seq_titular%type;
ie_regulamentacao_w		pls_plano.ie_regulamentacao%type;
cd_plano_ans_w			pls_interf_sib.cd_plano_ans%type;
cd_plano_ans_pre_w		pls_interf_sib.cd_plano_ans_pre%type;
dt_liberacao_w			timestamp;
ds_logradouro_w			pls_interf_sib.logradouro%type;
ds_numero_w			pls_interf_sib.ds_numero%type;
ds_complemento_w		pls_interf_sib.ds_complemento%type;
ds_bairro_w			pls_interf_sib.ds_bairro%type;
ds_municipio_w			pls_interf_sib.ds_municipio%type;
uf_w				pls_interf_sib.uf%type;
cep_w				pls_interf_sib.cep%type;
dt_mesano_referencia_w		timestamp;
dt_reinclusao_w			timestamp;
nr_seq_portabilidade_w		pls_segurado.nr_seq_portabilidade%type;
cd_pais_sib_w			pls_interf_sib.cd_pais%type;
cd_usuario_ant_w		pls_interf_sib.cd_usuario_ant%type;
cd_usuario_plano_w		pls_interf_sib.cd_usuario_plano%type;
cd_usuario_plano_tit_w		pls_interf_sib.cd_usuario_plano_sup%type;
cd_cgc_estipulante_w		pls_interf_sib.cd_cgc_estipulante%type;
nr_cpf_w			pls_interf_sib.nr_cpf%type;
cd_vinculo_benef_w		pls_interf_sib.cd_vinculo_benef%type;
ie_carencia_temp_w		pls_interf_sib.ie_carencia_temp%type;
ie_resid_brasil_w		pls_interf_sib.ie_resid_brasil%type;
cd_motivo_w			smallint;
nr_prot_ans_origem_w		varchar(20);
nr_seq_reg_arquivo_w		pls_interf_sib.nr_sequencia%type;
nr_cco_w			pls_interf_sib.nr_cco%type;
cd_cco_w			pls_segurado.cd_cco%type;
ie_digito_cco_w			pls_interf_sib.ie_digito_cco%type;
cd_declaracao_nasc_vivo_w	pessoa_fisica.cd_declaracao_nasc_vivo%type;
dt_movimentacao_w		timestamp;
cd_municipio_ibge_resid_w	pls_interf_sib.cd_municipio_ibge_resid%type;
nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
ie_tipo_logradouro_w		varchar(1);
ie_scpa_contrato_w		pls_parametros.ie_scpa_contrato%type;
nr_seq_seq_alt_produto_w	pls_segurado_alt_plano.nr_sequencia%type;
cd_scpa_contrato_w		pls_contrato.cd_scpa%type;
nr_matricula_cei_w		varchar(30);
ie_logradouro_sib_w		pls_parametros.ie_logradouro_sib%type;
ie_itens_excluid_cobertura_w	pls_interf_sib.ie_itens_excluid_cobertura%type;
dt_alteracao_prod_w		pls_segurado_alt_plano.dt_alteracao%type;
ie_gera_dt_alt_w		pls_parametros.ie_gerar_dt_alteracao_sib%type;
nr_seq_segurado_ant_w		pls_segurado.nr_seq_segurado_ant%type;
cd_cgc_estipulante_ant_w	pls_contrato.cd_cgc_estipulante%type;
ie_migracao_w			varchar(1);
nr_seq_plano_w			pls_plano.nr_sequencia%type;
nr_seq_plano_ant_w		pls_plano.nr_sequencia%type;
ie_retif_novo_benef_mig_w	pls_parametros.ie_retificacao_novo_benef_mig%type;
ds_alteracoes_w			pls_interf_sib.ds_alteracoes%type;
cd_usuario_plano_ant_w		pls_interf_sib.cd_usuario_plano%type;

cd_plano_ans_ant_w		pls_interf_sib.cd_plano_ans%type;
cd_plano_ans_ant_pre_w		pls_interf_sib.cd_plano_ans_pre%type;
is_alteracao_cod_ans_w		boolean;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_segurado a,
		pls_contrato b
	where	b.nr_sequencia		= a.nr_seq_contrato
	and	b.cd_estabelecimento	= cd_estabelecimento_p
	and	b.ie_tipo_beneficiario <> 'ENB'
	and	trunc(a.dt_contratacao,'month') = trunc(dt_movimentacao_w,'month')
	and	((trunc(a.dt_contratacao,'month') <> trunc(a.dt_rescisao,'month') and (a.dt_rescisao IS NOT NULL AND a.dt_rescisao::text <> '')) or coalesce(a.dt_rescisao::text, '') = '') /*aaschlote 03/02/2011  os - 288304*/
	and 	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	coalesce(a.dt_cancelamento::text, '') = ''
	and (a.ie_tipo_segurado in ('B','R') and (a.ie_tipo_segurado IS NOT NULL AND a.ie_tipo_segurado::text <> ''))
	and	(a.cd_cco IS NOT NULL AND a.cd_cco::text <> '')
	and	(a.nr_seq_segurado_ant IS NOT NULL AND a.nr_seq_segurado_ant::text <> '')
	order  by
		a.nr_seq_titular;

C02 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_segurado a,
		pls_contrato b
	where	b.nr_sequencia		= a.nr_seq_contrato
	and	b.cd_estabelecimento	= cd_estabelecimento_p
	and	b.ie_tipo_beneficiario <> 'ENB'
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	coalesce(a.dt_cancelamento::text, '') = ''
	and (a.ie_tipo_segurado('B','R') and (a.ie_tipo_segurado IS NOT NULL AND a.ie_tipo_segurado::text <> ''))
	and	trunc(a.dt_contratacao,'month') <> trunc(dt_movimentacao_w,'month')
	and	exists (	SELECT	1
				from	pls_segurado_alt_plano	x
				where	x.nr_seq_segurado		= a.nr_sequencia
				and	trunc(x.dt_alteracao,'Month')	= trunc(dt_movimentacao_w,'month')
				and	x.ie_situacao 			= 'A'
				and	x.ie_regulamentacao_ant		in ('R','P')
				and	x.ie_regulamentacao_atual	<> 'R')
	order  by
		a.nr_seq_titular;


BEGIN

select	dt_mesano_referencia,
	dt_mes_competencia
into STRICT	dt_referencia_w,
	dt_movimentacao_w
from	pls_lote_sib
where	nr_sequencia	= nr_seq_lote_sib_p;

select	max(nr_sequencia)
into STRICT	nr_seq_reg_arquivo_w
from	pls_interf_sib
where	nr_seq_lote_sib	= nr_seq_lote_sib_p;

if (coalesce(nr_seq_reg_arquivo_w,0) = 0) then
	nr_seq_reg_arquivo_w	:= 0;
end if;

if (nr_seq_reg_arquivo_w = 0) then
	nr_seq_reg_arquivo_w	:= 1;
end if;

select	max(ie_scpa_contrato),
	max(ie_logradouro_sib),
	coalesce(max(ie_gerar_dt_alteracao_sib), 'N'),
	coalesce(max(ie_retificacao_novo_benef_mig),'N')
into STRICT	ie_scpa_contrato_w,
	ie_logradouro_sib_w,
	ie_gera_dt_alt_w,
	ie_retif_novo_benef_mig_w
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;

if (coalesce(ie_scpa_contrato_w::text, '') = '') then
	ie_scpa_contrato_w	:= 'N';
end if;

/*Cursor dos beneficiarios migrados*/

open C01;
loop
fetch C01 into
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	cd_motivo_w			:= 00;
	nr_prot_ans_origem_w		:= '000000000';
	cd_plano_ans_w			:= '';
	cd_plano_ans_pre_w		:= '';
	nr_matricula_cei_w		:= '';
	ie_migracao_w 			:= 'S';
	ds_alteracoes_w 		:= '';
	
	select	distinct
		5 ie_tipo_reg,
		a.cd_pessoa_fisica,
		substr(coalesce(l.nm_pessoa_fisica,b.nm_pessoa_fisica),1,69) nm_beficiario,
		b.dt_nascimento,
		CASE WHEN b.ie_sexo='M' THEN 1  ELSE CASE WHEN b.ie_sexo='F' THEN 3  ELSE 0 END  END ,
		coalesce(b.nr_pis_pasep,'00000000000'),
		coalesce(substr(b.nr_cartao_nac_sus,1,15),lpad(' ',15,' ')) cd_cns,
		b.nr_identidade,
		b.ds_orgao_emissor_ci,
		b.cd_nacionalidade,
		a.nr_seq_titular,
		c.ie_regulamentacao,
		CASE WHEN ie_regulamentacao='P' THEN coalesce(c.nr_protocolo_ans,'000000000')  ELSE '000000000' END ,
		CASE WHEN ie_regulamentacao='P' THEN ' '  ELSE CASE WHEN ie_scpa_contrato_w='S' THEN coalesce(e.cd_scpa,c.cd_scpa)  ELSE c.cd_scpa END  END ,
		a.dt_contratacao,
		a.dt_contratacao	dt_mesano_referencia,
		a.dt_reativacao,
		coalesce(a.nr_seq_portabilidade,0),
		a.nr_cco,
		a.cd_cco,
		a.ie_digito_cco,
		b.cd_declaracao_nasc_vivo,
		e.nr_sequencia,
		a.nr_seq_segurado_ant,
		c.nr_sequencia nr_seq_plano
	into STRICT	ie_tipo_reg_w,
		cd_pessoa_fisica_w,
		nm_segurado_w,
		dt_nascimento_w,
		ie_sexo_w,
		nr_pis_pasep_w,
		cd_cns_w,
		nr_identidade_w,
		ds_orgao_emissor_ci_w,
		cd_nacionalidade_w,
		nr_seq_titular_w,
		ie_regulamentacao_w,
		cd_plano_ans_w,
		cd_plano_ans_pre_w,
		dt_liberacao_w,
		dt_mesano_referencia_w,
		dt_reinclusao_w,
		nr_seq_portabilidade_w,		
		nr_cco_w,
		cd_cco_w,		
		ie_digito_cco_w,
		cd_declaracao_nasc_vivo_w,
		nr_seq_contrato_w,
		nr_seq_segurado_ant_w,
		nr_seq_plano_w
	FROM pls_contrato e, pls_plano c, pls_segurado a, pessoa_fisica b
LEFT OUTER JOIN pls_pessoa_fisica l ON (b.cd_pessoa_fisica = l.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica	= b.cd_pessoa_fisica  and e.nr_sequencia		= a.nr_seq_contrato and c.nr_sequencia		= a.nr_seq_plano and a.nr_sequencia		= nr_seq_segurado_w;
	
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		SELECT * FROM pls_obter_enderecos_benef_sib(	cd_pessoa_fisica_w, nr_seq_contrato_w, 'S', ie_logradouro_sib_w, ie_tipo_logradouro_w, ds_logradouro_w, ds_numero_w, ds_complemento_w, ds_bairro_w, ds_municipio_w, cd_municipio_ibge_resid_w, uf_w, cep_w) INTO STRICT ie_tipo_logradouro_w, ds_logradouro_w, ds_numero_w, ds_complemento_w, ds_bairro_w, ds_municipio_w, cd_municipio_ibge_resid_w, uf_w, cep_w;
	end if;
	
	if (length(nr_pis_pasep_w) < 11) then
		nr_pis_pasep_w	:= '00000000000';
	end if;
	
	SELECT * FROM pls_obter_dados_interf_sib(	nr_seq_segurado_w, cd_pais_sib_w, cd_usuario_ant_w, cd_usuario_plano_w, cd_usuario_plano_tit_w, cd_cgc_estipulante_w, nr_cpf_w, cd_vinculo_benef_w, ie_carencia_temp_w, ie_resid_brasil_w) INTO STRICT cd_pais_sib_w, cd_usuario_ant_w, cd_usuario_plano_w, cd_usuario_plano_tit_w, cd_cgc_estipulante_w, nr_cpf_w, cd_vinculo_benef_w, ie_carencia_temp_w, ie_resid_brasil_w;
	
	if (cd_cgc_estipulante_w IS NOT NULL AND cd_cgc_estipulante_w::text <> '') then
		if (nr_seq_segurado_ant_w IS NOT NULL AND nr_seq_segurado_ant_w::text <> '') then	
			select	coalesce(e.cd_cgc_estipulante,'X')
			into STRICT	cd_cgc_estipulante_ant_w
			from	pls_segurado	a,
				pls_contrato	e
			where	e.nr_sequencia	= a.nr_seq_contrato
			and	a.nr_sequencia	= nr_seq_segurado_ant_w;
			
			if (substr(cd_cgc_estipulante_ant_w,1,8) = substr(cd_cgc_estipulante_w,1,8)) then
				select	nr_seq_plano
				into STRICT	nr_seq_plano_ant_w
				from	pls_segurado
				where	nr_sequencia = nr_seq_segurado_ant_w;
				
				if (nr_seq_plano_w = nr_seq_plano_ant_w) then			
					ie_migracao_w := 'N';
				end if;
			end if;
		end if;
		
		select	max(nr_matricula_cei)
		into STRICT	nr_matricula_cei_w
		from	pessoa_juridica
		where	cd_cgc	= cd_cgc_estipulante_w;
		
		if ((trim(both nr_matricula_cei_w) IS NOT NULL AND (trim(both nr_matricula_cei_w))::text <> '')) then
			cd_cgc_estipulante_w	:= '';
		end if;
	end if;
	
	select	max(a.nm_pessoa_fisica)
	into STRICT	nm_mae_segurado_w
	from	pessoa_fisica a,
		compl_pessoa_fisica b
	where	b.cd_pessoa_fisica_ref	= a.cd_pessoa_fisica
	and	b.ie_tipo_complemento	= 5
	and	b.cd_pessoa_fisica	= cd_pessoa_fisica_w;
	
	if (coalesce(nm_mae_segurado_w::text, '') = '') then
		select	max(a.nm_contato)
		into STRICT	nm_mae_segurado_w
		from	compl_pessoa_fisica a
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_w
		and	a.ie_tipo_complemento	= 5;
	end if;
	
	nm_mae_segurado_w	:= substr(nm_mae_segurado_w,1,59);
	
	if (ie_migracao_w = 'S') then	
		if (coalesce(nr_seq_portabilidade_w,0) > 0) then /* se for de portabilidade o motivo e o 41 */
			cd_motivo_w	:= 41;
			
			begin
			select	to_char(somente_numero(max(nr_prot_ans_origem)))
			into STRICT	nr_prot_ans_origem_w
			from	pls_segurado a,
				pls_portab_pessoa b
			where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
			and	a.nr_sequencia	= nr_seq_segurado_w;
			exception
			when others then
				nr_prot_ans_origem_w	:= '';
			end;
		else
			begin
			select	max(cd_ans)
			into STRICT	cd_motivo_w
			from	pls_motivo_inclusao_seg a,
				pls_segurado b
			where	b.nr_seq_motivo_inclusao	= a.nr_sequencia
			and	b.nr_sequencia			= nr_seq_segurado_w;
			exception
			when others then
				cd_motivo_w	:= 15;
			end;
			
			if (coalesce(cd_motivo_w::text, '') = '') then
				cd_motivo_w	:= 15;
			end if;
		end if;
		
		nr_seq_reg_arquivo_w	:= nr_seq_reg_arquivo_w + 1;
		
		dt_mesano_referencia_w	:= trunc(dt_mesano_referencia_w,'month');
		
		if (coalesce(nr_prot_ans_origem_w::text, '') = '') then
			nr_prot_ans_origem_w	:= '000000000';
		end if;
		
		if (uf_w = 'IN') then
			uf_w	:= 'EX';
		end if;
		
		cep_w	:= replace(cep_w,'-','');
		cep_w	:= replace(cep_w,'.','');
		
		if (dt_nascimento_w < to_date('01/01/2010')) then
			cd_declaracao_nasc_vivo_w	:= '';
		end if;	
		
		if (ie_regulamentacao_w = 'R') then
			ie_itens_excluid_cobertura_w	:= 1;
		else
			ie_itens_excluid_cobertura_w	:= 2; /* No projeto XML converte para 0 */
		end if;
		
		if (ie_gera_dt_alt_w = 'S') then
			select	max(a.dt_alteracao)
			into STRICT	dt_alteracao_prod_w
			from	pls_segurado_alt_plano a,
				pls_segurado b
			where	a.nr_seq_segurado = b.nr_sequencia
			and	b.nr_sequencia = nr_seq_segurado_w
			and	a.ie_situacao = 'A'
			and	trunc(a.dt_alteracao) <= trunc(dt_movimentacao_w)
			and (	SELECT	count(1)
					from	pls_plano x,
						pls_plano y
					where	x.nr_sequencia = a.nr_seq_plano_atual
					and	y.nr_sequencia = a.nr_seq_plano_ant
					and	x.nr_protocolo_ans <> y.nr_protocolo_ans) > 0;
			
			
			if (dt_alteracao_prod_w IS NOT NULL AND dt_alteracao_prod_w::text <> '') then
				dt_liberacao_w := dt_alteracao_prod_w;
			end if;	
		end if;	
		--fim alteracao dellandrea
		
		insert into pls_interf_sib(	nr_sequencia,dt_mesano_referencia,ie_tipo_reg,cd_usuario_plano,nm_beficiario,
				dt_nascimento,ie_sexo,nr_cpf,nr_pis_pasep,nm_mae_benef,
				cd_cns,nr_identidade,ds_orgao_emissor_ci,cd_usuario_plano_sup,cd_plano_ans,
				cd_plano_ans_pre,dt_adesao_plano,cd_vinculo_benef,dt_reinclusao,cd_motivo,
				ie_carencia_temp,ie_itens_excluid_cobertura,cd_cgc_estipulante,logradouro,ds_numero,
				ds_complemento,ds_bairro,ds_municipio,uf,cep,
				cd_pessoa_fisica,nr_seq_lote_sib,cd_cei,nr_seq_segurado,cd_usuario_ant,
				cd_pais,nr_seq_titular,nr_prot_ans_origem,ie_resid_brasil,nr_seq_plano_portab,
				nr_seq_portabilidade,nr_cco,ie_digito_cco,cd_nacionalidade,cd_declaracao_nasc_vivo,
				ie_tipo_logradouro,cd_municipio_ibge_resid)
		values (	nr_seq_reg_arquivo_w,dt_mesano_referencia_w,ie_tipo_reg_w,cd_usuario_plano_w,nm_segurado_w,
				dt_nascimento_w,ie_sexo_w,nr_cpf_w,nr_pis_pasep_w,nm_mae_segurado_w,
				cd_cns_w,nr_identidade_w,ds_orgao_emissor_ci_w,cd_usuario_plano_tit_w,cd_plano_ans_w,
				cd_plano_ans_pre_w,dt_liberacao_w,cd_vinculo_benef_w,dt_reinclusao_w,cd_motivo_w,
				ie_carencia_temp_w,ie_itens_excluid_cobertura_w,cd_cgc_estipulante_w,ds_logradouro_w,ds_numero_w,
				ds_complemento_w,ds_bairro_w,ds_municipio_w,uf_w,cep_w,
				cd_pessoa_fisica_w,nr_seq_lote_sib_p,nr_matricula_cei_w,nr_seq_segurado_w,cd_usuario_ant_w,
				cd_pais_sib_w,nr_seq_titular_w,nr_prot_ans_origem_w,ie_resid_brasil_w,nr_prot_ans_origem_w,
				nr_seq_portabilidade_w,coalesce(substr(cd_cco_w,1,10),nr_cco_w),coalesce(substr(cd_cco_w,11,2),ie_digito_cco_w),cd_nacionalidade_w,cd_declaracao_nasc_vivo_w,
				ie_tipo_logradouro_w,cd_municipio_ibge_resid_w);
	end if;
	
	nr_seq_reg_arquivo_w	:= nr_seq_reg_arquivo_w + 1;
	
	if (nr_seq_segurado_ant_w IS NOT NULL AND nr_seq_segurado_ant_w::text <> '') and (ie_retif_novo_benef_mig_w = 'N') then
		select	b.cd_cgc_estipulante
		into STRICT	cd_cgc_estipulante_ant_w
		from	pls_segurado	a,
			pls_contrato	b
		where	b.nr_sequencia	= a.nr_seq_contrato
		and	a.nr_sequencia	= nr_seq_segurado_ant_w;
		
		begin
		select 	coalesce(a.cd_cartao_ident_ans_sist_ant,b.cd_usuario_plano)
		into STRICT	cd_usuario_plano_ant_w
		from	pls_segurado_carteira	b,
			pls_segurado		a
		where	b.nr_seq_segurado	= a.nr_sequencia
		and	a.nr_sequencia		= nr_seq_segurado_ant_w;
		exception
		when others then
			cd_usuario_plano_ant_w	:= '';
		end;
	end if;
	
	if (coalesce(cd_cgc_estipulante_ant_w,'X') <> coalesce(cd_cgc_estipulante_w,'X')) then
		ds_alteracoes_w	:= ds_alteracoes_w || ' CNPJ anterior: ' || cd_cgc_estipulante_ant_w || ' - CNPJ atual:  ' || cd_cgc_estipulante_w || chr(10);
	else
		cd_cgc_estipulante_w := null;
	end if;
	
	if (coalesce(cd_usuario_plano_ant_w,'X') <> coalesce(cd_usuario_plano_w,'X')) then
		ds_alteracoes_w	:= ds_alteracoes_w || ' Carteira anterior: ' || cd_usuario_plano_ant_w || ' - Carteira atual:  ' || cd_usuario_plano_w || chr(10);
	else
		cd_usuario_plano_w := null;
	end if;
	
	if (cd_cgc_estipulante_w IS NOT NULL AND cd_cgc_estipulante_w::text <> '') or (cd_usuario_plano_w IS NOT NULL AND cd_usuario_plano_w::text <> '') then
	
		insert into pls_interf_sib(	nr_sequencia, dt_mesano_referencia, ie_tipo_reg, nr_seq_lote_sib,
				nr_seq_segurado, cd_pessoa_fisica, nr_seq_titular, ds_complemento, 
				nr_cco, ie_digito_cco, cd_motivo, nr_seq_portabilidade, 
				cd_cgc_estipulante, cd_usuario_plano, ds_alteracoes )		
		values (	nr_seq_reg_arquivo_w, dt_mesano_referencia_w, 2, nr_seq_lote_sib_p, 
				nr_seq_segurado_w, cd_pessoa_fisica_w, nr_seq_titular_w, ds_complemento_w, 
				coalesce(substr(cd_cco_w,1,10),nr_cco_w), coalesce(substr(cd_cco_w,11,2),ie_digito_cco_w), cd_motivo_w, nr_seq_portabilidade_w, 
				cd_cgc_estipulante_w, cd_usuario_plano_w, ds_alteracoes_w );
	end if;
	end;
end loop;
close C01;

/*Cursor dos beneficiarios que tiveram alteracao de um produto antigo ou novo para um novo ou adaptado*/

open C02;
loop
fetch C02 into
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	
	cd_motivo_w			:= 00;
	nr_prot_ans_origem_w		:= '000000000';
	cd_plano_ans_w			:= '';
	cd_plano_ans_pre_w		:= '';
	nr_matricula_cei_w		:= '';
	cd_plano_ans_ant_w		:= '';
	cd_plano_ans_ant_pre_w		:= '';
	is_alteracao_cod_ans_w		:= true;
	
	select	distinct
		5 ie_tipo_reg,
		a.cd_pessoa_fisica,
		substr(b.nm_pessoa_fisica,1,59) nm_beficiario,
		b.dt_nascimento,
		CASE WHEN b.ie_sexo='M' THEN 1  ELSE CASE WHEN b.ie_sexo='F' THEN 3  ELSE 0 END  END ,
		coalesce(b.nr_pis_pasep,'00000000000'),
		coalesce(substr(b.nr_cartao_nac_sus,1,15),'000000000000000') cd_cns,
		b.nr_identidade,
		b.ds_orgao_emissor_ci,
		b.cd_nacionalidade,
        	a.nr_seq_titular,
		c.ie_regulamentacao,
		a.dt_contratacao,
		a.dt_contratacao	dt_mesano_referencia,
		a.dt_reativacao,
		coalesce(a.nr_seq_portabilidade,0),
		a.nr_cco,
		a.cd_cco,
		a.ie_digito_cco,
		b.cd_declaracao_nasc_vivo,
		e.nr_sequencia,
		CASE WHEN c.ie_regulamentacao='P' THEN ' '  ELSE CASE WHEN ie_scpa_contrato_w='S' THEN coalesce(e.cd_scpa,c.cd_scpa)  ELSE c.cd_scpa END  END
	into STRICT	ie_tipo_reg_w,
		cd_pessoa_fisica_w,
		nm_segurado_w,
		dt_nascimento_w,
		ie_sexo_w,
		nr_pis_pasep_w,
		cd_cns_w,
		nr_identidade_w,
		ds_orgao_emissor_ci_w,
		cd_nacionalidade_w,
		nr_seq_titular_w,
		ie_regulamentacao_w,
		dt_liberacao_w,
		dt_mesano_referencia_w,
		dt_reinclusao_w,
		nr_seq_portabilidade_w,
		nr_cco_w,
		cd_cco_w,
		ie_digito_cco_w,
		cd_declaracao_nasc_vivo_w,
		nr_seq_contrato_w,
		cd_scpa_contrato_w
	from	pls_segurado a,
		pls_plano c,
		pessoa_fisica b,
		pls_contrato e
	where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	e.nr_sequencia		= a.nr_seq_contrato
	and	c.nr_sequencia		= a.nr_seq_plano
	and	a.nr_sequencia		= nr_seq_segurado_w;
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_seq_alt_produto_w
	from	pls_segurado_alt_plano
	where	nr_seq_segurado			= nr_seq_segurado_w
	and	trunc(dt_alteracao,'Month')	= trunc(dt_movimentacao_w,'month')
	and	ie_regulamentacao_ant		in ('R','P')
	and	ie_situacao 			= 'A'
	and	ie_regulamentacao_atual		<> 'R';
	
	if (nr_seq_seq_alt_produto_w IS NOT NULL AND nr_seq_seq_alt_produto_w::text <> '') then
		select	CASE WHEN a.ie_regulamentacao='P' THEN coalesce(a.nr_protocolo_ans,'000000000')  ELSE '000000000' END ,
			a.ie_regulamentacao,
			b.dt_alteracao
		into STRICT	cd_plano_ans_w,
			ie_regulamentacao_w,
			dt_liberacao_w
		from	pls_segurado_alt_plano	b,
			pls_plano		a
		where	b.nr_seq_plano_atual	= a.nr_sequencia
		and	b.nr_sequencia		= nr_seq_seq_alt_produto_w;
		
		cd_plano_ans_pre_w := cd_scpa_contrato_w;
		
		select	CASE WHEN a.ie_regulamentacao='P' THEN coalesce(a.nr_protocolo_ans,'000000000')  ELSE '000000000' END ,
			a.cd_scpa
		into STRICT	cd_plano_ans_ant_w,
			cd_plano_ans_ant_pre_w
		from	pls_segurado_alt_plano	b,
			pls_plano		a
		where	b.nr_seq_plano_ant	= a.nr_sequencia
		and	b.nr_sequencia		= nr_seq_seq_alt_produto_w;
		
		if (ie_scpa_contrato_w = 'S') then
			cd_plano_ans_ant_pre_w	:= coalesce(cd_scpa_contrato_w,cd_plano_ans_ant_pre_w);
		end if;
	end if;
	
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		SELECT * FROM pls_obter_enderecos_benef_sib(	cd_pessoa_fisica_w, nr_seq_contrato_w, 'S', ie_logradouro_sib_w, ie_tipo_logradouro_w, ds_logradouro_w, ds_numero_w, ds_complemento_w, ds_bairro_w, ds_municipio_w, cd_municipio_ibge_resid_w, uf_w, cep_w) INTO STRICT ie_tipo_logradouro_w, ds_logradouro_w, ds_numero_w, ds_complemento_w, ds_bairro_w, ds_municipio_w, cd_municipio_ibge_resid_w, uf_w, cep_w;
	end if;
	
	if (length(nr_pis_pasep_w) < 11) then
		nr_pis_pasep_w	:= '00000000000';
	end if;
	
	SELECT * FROM pls_obter_dados_interf_sib(	nr_seq_segurado_w, cd_pais_sib_w, cd_usuario_ant_w, cd_usuario_plano_w, cd_usuario_plano_tit_w, cd_cgc_estipulante_w, nr_cpf_w, cd_vinculo_benef_w, ie_carencia_temp_w, ie_resid_brasil_w) INTO STRICT cd_pais_sib_w, cd_usuario_ant_w, cd_usuario_plano_w, cd_usuario_plano_tit_w, cd_cgc_estipulante_w, nr_cpf_w, cd_vinculo_benef_w, ie_carencia_temp_w, ie_resid_brasil_w;
	
	if (coalesce(nr_seq_portabilidade_w,0) > 0) then /* se for de portabilidade o motivo e o 41 */
		cd_motivo_w	:= 41;
		
		begin
		select	to_char(somente_numero(max(nr_prot_ans_origem)))
		into STRICT	nr_prot_ans_origem_w
		from	pls_segurado a,
			pls_portab_pessoa b
		where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
		and	a.nr_sequencia	= nr_seq_segurado_w;
		exception
		when others then
			nr_prot_ans_origem_w	:= '';
		end;
	else
		begin
		select	max(cd_ans)
		into STRICT	cd_motivo_w
		from	pls_motivo_inclusao_seg a,
			pls_segurado b
		where	b.nr_seq_motivo_inclusao	= a.nr_sequencia
		and	b.nr_sequencia			= nr_seq_segurado_w;
		exception
		when others then
			cd_motivo_w	:= 15;
		end;
		
		if (coalesce(cd_motivo_w::text, '') = '') then
			cd_motivo_w	:= 15;
		end if;
	end if;
	
	select	max(a.nm_pessoa_fisica)
	into STRICT	nm_mae_segurado_w
	from	pessoa_fisica a,
		compl_pessoa_fisica b
	where	b.cd_pessoa_fisica_ref	= a.cd_pessoa_fisica
	and	b.ie_tipo_complemento	= 5
	and	b.cd_pessoa_fisica	= cd_pessoa_fisica_w;
	
	if (coalesce(nm_mae_segurado_w::text, '') = '') then
		select	max(a.nm_contato)
		into STRICT	nm_mae_segurado_w
		from	compl_pessoa_fisica a
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_w
		and	a.ie_tipo_complemento	= 5;
	end if;
	
	nm_mae_segurado_w	:= substr(nm_mae_segurado_w,1,59);
	
	nr_seq_reg_arquivo_w	:= nr_seq_reg_arquivo_w + 1;
	
	dt_mesano_referencia_w	:= trunc(dt_mesano_referencia_w,'month');
	
	if (coalesce(nr_prot_ans_origem_w::text, '') = '') then
		nr_prot_ans_origem_w	:= '000000000';
	end if;
	
	if (uf_w = 'IN') then
		uf_w	:= 'EX';
	end if;
	
	cep_w	:= replace(cep_w,'-','');
	cep_w	:= replace(cep_w,'.','');
	
	if (coalesce(ds_numero_w::text, '') = '') then
		ds_numero_w	:= 0;
	end if;
	
	if (dt_nascimento_w < to_date('01/01/2010')) then
		cd_declaracao_nasc_vivo_w	:= '';
	end if;
	
	if (cd_cgc_estipulante_w IS NOT NULL AND cd_cgc_estipulante_w::text <> '') then
		select	max(nr_matricula_cei)
		into STRICT	nr_matricula_cei_w
		from	pessoa_juridica
		where	cd_cgc	= cd_cgc_estipulante_w;
		
		if ((trim(both nr_matricula_cei_w) IS NOT NULL AND (trim(both nr_matricula_cei_w))::text <> '')) then
			cd_cgc_estipulante_w	:= '';
		end if;
	end if;
	
	if (ie_regulamentacao_w = 'R') then
		ie_itens_excluid_cobertura_w	:= 1;
	else
		ie_itens_excluid_cobertura_w	:= 2; /* No projeto XML converte para 0 */
	end if;
	
	if (ie_gera_dt_alt_w = 'S') then
		select	max(a.dt_alteracao)
		into STRICT	dt_alteracao_prod_w
		from	pls_segurado_alt_plano a,
			pls_segurado b
		where	a.nr_seq_segurado = b.nr_sequencia
		and	b.nr_sequencia = nr_seq_segurado_w
		and	a.ie_situacao = 'A'
		and	trunc(a.dt_alteracao) <= trunc(dt_movimentacao_w)
		and (	SELECT	count(1)
				from	pls_plano x,
					pls_plano y
				where	x.nr_sequencia = a.nr_seq_plano_atual
				and	y.nr_sequencia = a.nr_seq_plano_ant
				and	x.nr_protocolo_ans <> y.nr_protocolo_ans) > 0;
		
		
		if (dt_alteracao_prod_w IS NOT NULL AND dt_alteracao_prod_w::text <> '') then
			dt_liberacao_w := dt_alteracao_prod_w;
		end if;	
	end if;	
	
	--Caso o produto for regulamentado
	if (ie_regulamentacao_w = 'P') then
		--Verifica se o protocolo ANS e igual ao alterado
		if (cd_plano_ans_ant_w = cd_plano_ans_w) then
			is_alteracao_cod_ans_w	:= false;
		end if;
	--Caso o produto for adpatado
	elsif (ie_regulamentacao_w = 'A') and (coalesce(cd_plano_ans_pre_w::text, '') = '') then
		--Verifica se o protocolo ANS e igual ao alterado
		if (cd_plano_ans_ant_w = cd_plano_ans_w) then
			is_alteracao_cod_ans_w	:= false;
		end if;
	end if;
	
	--Apenas faz a alteracao caso o codigo do produto na ANS e diferente do alterado
	if (is_alteracao_cod_ans_w) then
		insert into pls_interf_sib(	nr_sequencia,dt_mesano_referencia,ie_tipo_reg,cd_usuario_plano,nm_beficiario,
				dt_nascimento,ie_sexo,nr_cpf,nr_pis_pasep,nm_mae_benef,
				cd_cns,nr_identidade,ds_orgao_emissor_ci,cd_usuario_plano_sup,cd_plano_ans,
				cd_plano_ans_pre,dt_adesao_plano,cd_vinculo_benef,dt_reinclusao,cd_motivo,
				ie_carencia_temp,ie_itens_excluid_cobertura,cd_cgc_estipulante,logradouro,ds_numero,
				ds_complemento,ds_bairro,ds_municipio,uf,cep,
				cd_pessoa_fisica,nr_seq_lote_sib,cd_cei,nr_seq_segurado,cd_usuario_ant,
				cd_pais,nr_seq_titular,nr_prot_ans_origem,ie_resid_brasil,nr_seq_plano_portab,
				nr_seq_portabilidade,nr_cco,ie_digito_cco,cd_nacionalidade,cd_declaracao_nasc_vivo,
				ie_tipo_logradouro,cd_municipio_ibge_resid)
		values (	nr_seq_reg_arquivo_w,dt_mesano_referencia_w,ie_tipo_reg_w,cd_usuario_plano_w,nm_segurado_w,
				dt_nascimento_w,ie_sexo_w,nr_cpf_w,nr_pis_pasep_w,nm_mae_segurado_w,
				cd_cns_w,nr_identidade_w,ds_orgao_emissor_ci_w,cd_usuario_plano_tit_w,cd_plano_ans_w,
				cd_plano_ans_pre_w,dt_liberacao_w,cd_vinculo_benef_w,dt_reinclusao_w,cd_motivo_w,
				ie_carencia_temp_w,ie_itens_excluid_cobertura_w,cd_cgc_estipulante_w,ds_logradouro_w,ds_numero_w,
				ds_complemento_w,ds_bairro_w,ds_municipio_w,uf_w,cep_w,
				cd_pessoa_fisica_w,nr_seq_lote_sib_p,nr_matricula_cei_w,nr_seq_segurado_w,cd_usuario_ant_w,
				cd_pais_sib_w,nr_seq_titular_w,nr_prot_ans_origem_w,ie_resid_brasil_w,nr_prot_ans_origem_w,
				nr_seq_portabilidade_w,coalesce(substr(cd_cco_w,1,10),nr_cco_w),coalesce(substr(cd_cco_w,11,2),ie_digito_cco_w),cd_nacionalidade_w,cd_declaracao_nasc_vivo_w,
				ie_tipo_logradouro_w,cd_municipio_ibge_resid_w);
	end if;
	
	end;
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_mig_cont_sib_flex ( nr_seq_lote_sib_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

