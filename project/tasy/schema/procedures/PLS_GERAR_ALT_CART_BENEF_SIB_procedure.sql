-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_alt_cart_benef_sib ( nr_seq_lote_sib_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nr_seq_segurado_w		bigint;
cd_pessoa_fisica_w		varchar(10);
nm_segurado_w			varchar(255);
dt_nascimento_w			timestamp;
ie_sexo_w			smallint;
nr_pis_pasep_w			varchar(11);
nm_mae_segurado_w		varchar(255);
cd_cns_w			varchar(15);
nr_identidade_w			varchar(15);
ds_orgao_emissor_ci_w		pessoa_fisica.ds_orgao_emissor_ci%type;
cd_nacionalidade_w		varchar(8);
nr_seq_titular_w		bigint;
ie_regulamentacao_w		varchar(2);
cd_plano_ans_w			varchar(20);
cd_plano_ans_pre_w		varchar(20);
dt_liberacao_w			timestamp;
ds_logradouro_w			varchar(50);
ds_numero_w			varchar(5);
ds_complemento_w		varchar(15);
ds_bairro_w			varchar(50);
ds_municipio_w			varchar(50);
uf_w				varchar(10);
cep_w				varchar(15);
dt_mesano_referencia_w		timestamp;
dt_reinclusao_w			timestamp;
nr_seq_portabilidade_w		bigint;
cd_pais_sib_w			varchar(30);
cd_usuario_ant_w		varchar(30);
cd_usuario_plano_w		varchar(30);
cd_usuario_plano_tit_w		varchar(30);
cd_cgc_estipulante_w		varchar(14);
nr_cpf_w			varchar(11);
cd_vinculo_benef_w		varchar(2);
ie_carencia_temp_w		smallint;
ie_resid_brasil_w		smallint;
cd_motivo_w			smallint;
nr_prot_ans_origem_w		varchar(20);
nr_seq_reg_arquivo_w		integer;
nr_cco_w			bigint;
ie_digito_cco_w			smallint;
nr_seq_retorno_sib_w		bigint;
ie_enviar_sib_w			varchar(5);
ie_tipo_reg_reenvio_w		integer;
nr_seq_motivo_reenvio_w		bigint;
ie_opcao_w			smallint;
ie_carteira_ant_w		varchar(2);
nr_seq_segurado_sib_w		bigint;
cd_declaracao_nasc_vivo_w	pessoa_fisica.cd_declaracao_nasc_vivo%type;
dt_movimentacao_w		timestamp;
cd_municipio_ibge_resid_w	varchar(7);
qt_endereco_residencial_w	bigint;
qt_endereco_comercial_w		bigint;
nr_seq_motivo_cancelamento_w	bigint;
cd_motivo_cancelamento_w	bigint;
dt_cancelamento_w		timestamp;
ie_tipo_logradouro_w		varchar(1);
ds_erro_w			varchar(255);
ie_scpa_contrato_w		varchar(255);
dt_mes_competencia_w		timestamp;
nr_seq_cart_ant_w		bigint;
nr_seq_contrato_w		bigint;
nr_matricula_cei_w		varchar(30);
ie_logradouro_sib_w		pls_parametros.ie_logradouro_sib%type;
ie_itens_excluid_cobertura_w	pls_interf_sib.ie_itens_excluid_cobertura%type;

C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		b.nr_sequencia 
	from	pls_segurado		a, 
		pls_segurado_cart_ant	b 
	where	b.nr_seq_segurado	= a.nr_sequencia 
	and	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
	and	b.ie_sistema_anterior	= 'S' 
	and	coalesce(b.nr_seq_lote_sib::text, '') = '' 
	and	trunc(b.dt_alteracao,'Month')	= dt_mes_competencia_w;


BEGIN 
 
select	trunc(dt_mes_competencia,'Month') 
into STRICT	dt_mes_competencia_w 
from	pls_lote_sib 
where	nr_sequencia	= nr_seq_lote_sib_p;
 
nr_seq_reg_arquivo_w := 1;
 
select	max(ie_scpa_contrato), 
	MAX(ie_logradouro_sib) 
into STRICT	ie_scpa_contrato_w, 
	ie_logradouro_sib_w 
from	pls_parametros 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
if (coalesce(ie_scpa_contrato_w::text, '') = '') then 
	ie_scpa_contrato_w	:= 'N';
end if;
 
if (coalesce(ie_logradouro_sib_w::text, '') = '') then 
	ie_logradouro_sib_w	:= '1';
end if;
 
open C01;
loop 
fetch C01 into 
	nr_seq_segurado_w, 
	nr_seq_cart_ant_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	cd_motivo_w			:= 00;
	nr_prot_ans_origem_w		:= '000000000';
	cd_plano_ans_w			:= '';
	cd_plano_ans_pre_w		:= '';
	ie_tipo_logradouro_w		:= '';
	cd_municipio_ibge_resid_w	:= '';
	nr_matricula_cei_w		:= '';
	 
	select	a.cd_pessoa_fisica, 
		substr(coalesce(l.nm_pessoa_fisica,b.nm_pessoa_fisica),1,69) nm_beficiario, 
		b.dt_nascimento, 
		CASE WHEN b.ie_sexo='M' THEN 1  ELSE CASE WHEN b.ie_sexo='F' THEN 3  ELSE 0 END  END , 
		coalesce(b.nr_pis_pasep,'00000000000'), 
		coalesce(substr(b.nr_cartao_nac_sus,1,15),'000000000000000') cd_cns, 
		b.nr_identidade, 
		b.ds_orgao_emissor_ci, 
		b.cd_nacionalidade, 
		a.nr_seq_titular, 
		c.ie_regulamentacao, 
		CASE WHEN ie_regulamentacao='P' THEN coalesce(c.nr_protocolo_ans,'000000000')  ELSE '000000000' END , 
		CASE WHEN ie_regulamentacao='P' THEN  ' '  ELSE CASE WHEN ie_scpa_contrato_w='S' THEN coalesce(e.cd_scpa,c.cd_scpa)  ELSE c.cd_scpa END  END , 
		a.dt_contratacao, 
		a.dt_contratacao	dt_mesano_referencia, 
		a.dt_reativacao, 
		coalesce(a.nr_seq_portabilidade,0), 
		a.nr_cco, 
		a.ie_digito_cco, 
		b.cd_declaracao_nasc_vivo, 
		a.nr_seq_motivo_cancelamento, 
		a.dt_rescisao, 
		e.nr_sequencia 
	into STRICT	cd_pessoa_fisica_w, 
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
		ie_digito_cco_w, 
		cd_declaracao_nasc_vivo_w, 
		nr_seq_motivo_cancelamento_w, 
		dt_cancelamento_w, 
		nr_seq_contrato_w 
	FROM pls_contrato e, pls_plano c, pls_segurado a, pessoa_fisica b
LEFT OUTER JOIN pls_pessoa_fisica l ON (b.cd_pessoa_fisica = l.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica	= b.cd_pessoa_fisica  and e.nr_sequencia		= a.nr_seq_contrato and c.nr_sequencia		= a.nr_seq_plano and a.nr_sequencia		= nr_seq_segurado_w;
	 
	if (coalesce(dt_reinclusao_w::text, '') = '') then 
		if (nr_seq_motivo_cancelamento_w IS NOT NULL AND nr_seq_motivo_cancelamento_w::text <> '') and (dt_cancelamento_w IS NOT NULL AND dt_cancelamento_w::text <> '') and (trunc(dt_cancelamento_w,'dd') > trunc(dt_mes_competencia_w,'dd')) then 
			select	cd_motivo_cancelamento 
			into STRICT	cd_motivo_cancelamento_w 
			from	pls_motivo_cancelamento 
			where	nr_sequencia	= nr_seq_motivo_cancelamento_w;
		else 
			dt_cancelamento_w		:= null;
			cd_motivo_cancelamento_w	:= null;
		end if;
	else 
		begin 
		select	max(nr_seq_motivo_cancelamento), 
			max(dt_ocorrencia_sib) 
		into STRICT	nr_seq_motivo_cancelamento_w, 
			dt_cancelamento_w 
		from	pls_segurado_historico 
		where	nr_seq_segurado	= nr_seq_segurado_w 
		and	ie_tipo_historico	= '1';
		exception 
		when others then 
			nr_seq_motivo_cancelamento_w	:= null;
			dt_cancelamento_w		:= null;
		end;
		 
		if (nr_seq_motivo_cancelamento_w IS NOT NULL AND nr_seq_motivo_cancelamento_w::text <> '') and (dt_cancelamento_w IS NOT NULL AND dt_cancelamento_w::text <> '') then 
			begin 
			select	max(cd_motivo_cancelamento) 
			into STRICT	cd_motivo_cancelamento_w 
			from	pls_motivo_cancelamento 
			where	nr_sequencia	= nr_seq_motivo_cancelamento_w;
			exception 
			when others then 
				cd_motivo_cancelamento_w	:= null;
			end;
		else 
			dt_cancelamento_w		:= null;
			dt_reinclusao_w			:= null;
			cd_motivo_cancelamento_w	:= null;
		end if;
	end if;
	 
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
		/*aaschlote 26/09/2012 OS - 463181*/
 
		SELECT * FROM pls_obter_enderecos_benef_sib(	cd_pessoa_fisica_w, nr_seq_contrato_w, 'S', ie_logradouro_sib_w, ie_tipo_logradouro_w, ds_logradouro_w, ds_numero_w, ds_complemento_w, ds_bairro_w, ds_municipio_w, cd_municipio_ibge_resid_w, uf_w, cep_w) INTO STRICT ie_tipo_logradouro_w, ds_logradouro_w, ds_numero_w, ds_complemento_w, ds_bairro_w, ds_municipio_w, cd_municipio_ibge_resid_w, uf_w, cep_w;
	end if;
	 
	if (length(nr_pis_pasep_w) < 11) then 
		nr_pis_pasep_w	:= '00000000000';
	end if;
	 
	SELECT * FROM pls_obter_dados_interf_sib(	nr_seq_segurado_w, cd_pais_sib_w, cd_usuario_ant_w, cd_usuario_plano_w, cd_usuario_plano_tit_w, cd_cgc_estipulante_w, nr_cpf_w, cd_vinculo_benef_w, ie_carencia_temp_w, ie_resid_brasil_w) INTO STRICT cd_pais_sib_w, cd_usuario_ant_w, cd_usuario_plano_w, cd_usuario_plano_tit_w, cd_cgc_estipulante_w, nr_cpf_w, cd_vinculo_benef_w, ie_carencia_temp_w, ie_resid_brasil_w;
	 
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
	 
	cd_motivo_w	:= 51;
	 
	/*aaschlote 24/12/2012 OS - 522445*/
 
	if (cd_cgc_estipulante_w IS NOT NULL AND cd_cgc_estipulante_w::text <> '') THEN 
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
	 
	insert into pls_interf_sib(	nr_sequencia,dt_mesano_referencia,ie_tipo_reg,cd_usuario_plano,nm_beficiario, 
			dt_nascimento,ie_sexo,nr_cpf,nr_pis_pasep,nm_mae_benef, 
			cd_cns,nr_identidade,ds_orgao_emissor_ci,cd_usuario_plano_sup,cd_plano_ans, 
			cd_plano_ans_pre,dt_adesao_plano,cd_vinculo_benef,dt_reinclusao,cd_motivo, 
			ie_carencia_temp,ie_itens_excluid_cobertura,cd_cgc_estipulante,logradouro,ds_numero, 
			ds_complemento,ds_bairro,ds_municipio,uf,cep,cd_pessoa_fisica, 
			nr_seq_lote_sib,cd_cei,nr_seq_segurado,cd_usuario_ant,cd_pais, 
			nr_seq_titular,nr_prot_ans_origem,ie_resid_brasil,nr_seq_plano_portab,nr_seq_portabilidade, 
			nr_cco,ie_digito_cco,cd_nacionalidade,cd_declaracao_nasc_vivo,ie_tipo_logradouro, 
			cd_municipio_ibge_resid,cd_motivo_cancelamento,dt_cancelamento) 
	values (	nr_seq_reg_arquivo_w,dt_mesano_referencia_w,2,cd_usuario_plano_w,nm_segurado_w, 
			dt_nascimento_w,ie_sexo_w,nr_cpf_w,nr_pis_pasep_w,nm_mae_segurado_w, 
			cd_cns_w,nr_identidade_w,ds_orgao_emissor_ci_w,cd_usuario_plano_tit_w,cd_plano_ans_w, 
			cd_plano_ans_pre_w,dt_liberacao_w,cd_vinculo_benef_w,dt_reinclusao_w,cd_motivo_w, 
			ie_carencia_temp_w,ie_itens_excluid_cobertura_w,cd_cgc_estipulante_w,ds_logradouro_w,ds_numero_w, 
			ds_complemento_w,ds_bairro_w,ds_municipio_w,uf_w,cep_w,cd_pessoa_fisica_w, 
			nr_seq_lote_sib_p,nr_matricula_cei_w,nr_seq_segurado_w,cd_usuario_ant_w,cd_pais_sib_w, 
			nr_seq_titular_w,nr_prot_ans_origem_w,ie_resid_brasil_w,nr_prot_ans_origem_w,nr_seq_portabilidade_w, 
			nr_cco_w,ie_digito_cco_w,cd_nacionalidade_w,cd_declaracao_nasc_vivo_w,ie_tipo_logradouro_w, 
			cd_municipio_ibge_resid_w,cd_motivo_cancelamento_w,dt_cancelamento_w);
	 
	update	pls_segurado_cart_ant 
	set	nr_seq_lote_sib	= nr_seq_lote_sib_p 
	where	nr_sequencia	= nr_seq_cart_ant_w;
	 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_alt_cart_benef_sib ( nr_seq_lote_sib_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
