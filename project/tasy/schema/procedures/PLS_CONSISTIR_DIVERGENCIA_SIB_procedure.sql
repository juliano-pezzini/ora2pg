-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_divergencia_sib ( nr_seq_lote_retorno_sib_p bigint, nr_seq_retorno_sib_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_retorno_sib_w		bigint;
nr_cpf_sib_w			varchar(11);
nm_mae_sib_w			varchar(70);
ie_sexo_sib_w			smallint;
dt_nascimento_sib_w		timestamp;
nr_protocolo_plano_sib_w	varchar(10);
cd_cep_sib_w			varchar(8);
nr_endereco_sib_w		varchar(5);
ds_logradouro_sib_w		varchar(50);
dt_exclusao_sib_w		timestamp;
dt_inclusao_sib_w		timestamp;
nm_beneficiario_sib_w		varchar(70);
ie_tipo_registro_sib_w		smallint;
nr_seq_segurado_gerado_w	bigint;
nr_seq_segurado_vinculado_w	bigint;
nr_seq_segurado_encontrado_w	bigint;
nr_seq_segurado_w		bigint;
nm_pessoa_fisica_w		varchar(255);
nr_cpf_w			varchar(11);
nm_mae_w			varchar(70);
ie_sexo_w			smallint;
cd_pessoa_fisica_w		varchar(10);
dt_nascimento_w			timestamp;
nr_protocolo_plano_w		varchar(30);
cd_cep_w			varchar(15);
nr_endereco_w			varchar(5);
ds_logradouro_w			varchar(50);
dt_exclusao_w			timestamp;
dt_inclusao_w			timestamp;
ie_tipo_registro_w		smallint;
qt_registros_w			bigint;
qt_carencia_w			bigint;
i_w				bigint;
nr_seq_contrato_w		bigint;
dt_mesano_referencia_w		timestamp;
ds_bairro_sib_w			varchar(255);
cd_municipio_ibge_w		varchar(255);
nr_seq_alt_produto_w		pls_segurado_alt_plano.nr_sequencia%type;
---------------------------------------------------------------------------------------------------------------------------
ie_logradouro_sib_w		pls_parametros.ie_logradouro_sib%type;
cd_municipio_ibge_resid_w	varchar(7);
ds_complemento_w		varchar(15);
ds_bairro_w			varchar(50);
ds_municipio_w			varchar(50);
sg_uf_w				varchar(10);
ie_tipo_logradouro_w		varchar(10);
nr_cns_sib_w			pls_retorno_sib.nr_cns%type;
nr_cartao_nac_sus_w		pessoa_fisica.nr_cartao_nac_sus%type;
nr_seq_motivo_canc_sib_w	pls_retorno_sib.nr_seq_motivo_cancelamento%type;
nr_seq_motivo_cancelamento_w	pls_segurado.nr_seq_motivo_cancelamento%type;
ie_cobertura_parcial_sib_w	pls_retorno_sib.ie_cobertura_parcial%type;
ie_cobertura_parcial_w		pls_retorno_sib.ie_cobertura_parcial%type;
cd_motivo_cancelamento_w	pls_motivo_cancelamento.cd_motivo_cancelamento%type;

C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		a.dt_mesano_referencia
	from	pls_retorno_sib		b,
		pls_lote_retorno_sib	a
	where	b.nr_seq_lote_sib	= a.nr_sequencia
	and	b.nr_seq_lote_sib	= nr_seq_lote_retorno_sib_p
	and	(nr_seq_lote_retorno_sib_p IS NOT NULL AND nr_seq_lote_retorno_sib_p::text <> '')
	
union

	SELECT	b.nr_sequencia,
		a.dt_mesano_referencia
	from	pls_retorno_sib		b,
		pls_lote_retorno_sib	a
	where	b.nr_seq_lote_sib	= a.nr_sequencia
	and	b.nr_sequencia		= nr_seq_retorno_sib_p
	and	(nr_seq_retorno_sib_p IS NOT NULL AND nr_seq_retorno_sib_p::text <> '');


BEGIN

select	max(ie_logradouro_sib)
into STRICT	ie_logradouro_sib_w
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;

if (coalesce(ie_logradouro_sib_w::text, '') = '') then
	ie_logradouro_sib_w	:= '1';
end if;

i_w	:= 0;

open C01;
loop
fetch C01 into
	nr_seq_retorno_sib_w,
	dt_mesano_referencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	i_w	:= i_w + 1;
	delete	FROM pls_retorno_sib_diverg
	where	nr_seq_retorno_sib	= nr_seq_retorno_sib_w;
	
	select	nr_cpf,
		nm_mae,
		ie_sexo,
		dt_nascimento,
		nr_seq_segurado,
		nr_seq_segurado_vinculado,
		nr_seq_segurado_encontrado,
		nr_plano_ans,
		cd_cep,
		nr_endereco,
		trim(both upper(elimina_acentos(ds_logradouro))),
		trunc(dt_exclusao,'dd'),
		trunc(dt_inclusao,'dd'),
		upper(nm_beneficiario),
		ie_tipo_registro,
		trim(both upper(elimina_acentos(ds_bairro))),
		cd_municipio_ibge,
		nr_cns,
		nr_seq_motivo_cancelamento,
		coalesce(ie_cobertura_parcial,0)
	into STRICT	nr_cpf_sib_w,
		nm_mae_sib_w,
		ie_sexo_sib_w,
		dt_nascimento_sib_w,
		nr_seq_segurado_gerado_w,
		nr_seq_segurado_vinculado_w,
		nr_seq_segurado_encontrado_w,
		nr_protocolo_plano_sib_w,
		cd_cep_sib_w,
		nr_endereco_sib_w,
		ds_logradouro_sib_w,
		dt_exclusao_sib_w,
		dt_inclusao_sib_w,
		nm_beneficiario_sib_w,
		ie_tipo_registro_sib_w,
		ds_bairro_sib_w,
		cd_municipio_ibge_w,
		nr_cns_sib_w,
		nr_seq_motivo_canc_sib_w,
		ie_cobertura_parcial_sib_w
	from	pls_retorno_sib
	where	nr_sequencia	= nr_seq_retorno_sib_w;
	
	nr_seq_segurado_w	:= null;
	
	/*Deve respeitar a ordem de verificacao atrves de Benef. Gerado, Benef. Encontrado, Benef. Vinculado.*/

	if (nr_seq_segurado_gerado_w IS NOT NULL AND nr_seq_segurado_gerado_w::text <> '') then
		nr_seq_segurado_w	:= nr_seq_segurado_gerado_w;
	elsif (coalesce(nr_seq_segurado_gerado_w::text, '') = '') then
		if (nr_seq_segurado_encontrado_w IS NOT NULL AND nr_seq_segurado_encontrado_w::text <> '') then
			nr_seq_segurado_w	:= nr_seq_segurado_encontrado_w;
		elsif (coalesce(nr_seq_segurado_encontrado_w::text, '') = '') then
			if (nr_seq_segurado_vinculado_w IS NOT NULL AND nr_seq_segurado_vinculado_w::text <> '') then
			nr_seq_segurado_w	:= nr_seq_segurado_vinculado_w;
			end if;
		end if;
	end if;
	
	if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
		select 	distinct
			substr(b.nm_pessoa_fisica,1,255),
			trunc(b.dt_nascimento,'dd'),
			CASE WHEN b.ie_sexo='M' THEN 1 WHEN b.ie_sexo='F' THEN 3  ELSE 0 END ,
			coalesce(b.nr_cpf,'00000000000'),
			substr(coalesce(obter_compl_pf(b.cd_pessoa_fisica,5,'NPR'),obter_compl_pf(b.cd_pessoa_fisica,5,'N')),1,59) nm_mae_benef,
			b.cd_pessoa_fisica,
			d.nr_protocolo_ans,
			trunc(a.dt_contratacao,'dd'),
			trunc(a.dt_rescisao,'dd'),
			c.nr_sequencia,
			b.nr_cartao_nac_sus,
			a.nr_seq_motivo_cancelamento
		into STRICT	nm_pessoa_fisica_w,
			dt_nascimento_w,
			ie_sexo_w,
			nr_cpf_w,
			nm_mae_w,
			cd_pessoa_fisica_w,
			nr_protocolo_plano_w,
			dt_inclusao_w,
			dt_exclusao_w,
			nr_seq_contrato_w,
			nr_cartao_nac_sus_w,
			nr_seq_motivo_cancelamento_w
		FROM pessoa_fisica b, pls_segurado a
LEFT OUTER JOIN pls_contrato c ON (a.nr_seq_contrato = c.nr_sequencia)
LEFT OUTER JOIN pls_plano d ON (a.nr_seq_plano = d.nr_sequencia)
WHERE a.cd_pessoa_fisica		= b.cd_pessoa_fisica   and a.nr_sequencia			= nr_seq_segurado_w;
		
		select 	max(cd_motivo_cancelamento)
		into STRICT 	cd_motivo_cancelamento_w
		from 	pls_motivo_cancelamento
		where   nr_sequencia = nr_seq_motivo_cancelamento_w;
		
		select	max(nr_sequencia)
		into STRICT	nr_seq_alt_produto_w
		from	pls_segurado_alt_plano
		where	nr_seq_segurado			= nr_seq_segurado_w
		and	ie_regulamentacao_ant		in ('R','P')
		and	ie_situacao			= 'A'
		and	ie_regulamentacao_atual		<> 'R';
		
		if (nr_seq_alt_produto_w IS NOT NULL AND nr_seq_alt_produto_w::text <> '') then
			select	dt_alteracao
			into STRICT	dt_inclusao_w
			from	pls_segurado_alt_plano
			where	nr_sequencia	= nr_seq_alt_produto_w;
		end if;
		
		
		select 	count(1)
		into STRICT 	qt_carencia_w
		from	pls_carencia		a
		where	a.nr_seq_segurado	= nr_seq_segurado_w
		and	a.ie_cpt		= 'S'  LIMIT 1;
		
		if (coalesce(qt_carencia_w,0) > 0) then
			ie_cobertura_parcial_w	:= 1;
		else
			ie_cobertura_parcial_w	:= 0;
		end if;
		
		/*aaschlote 09/12/2013 OS - 611774*/

		SELECT * FROM pls_obter_enderecos_benef_sib(	cd_pessoa_fisica_w, nr_seq_contrato_w, 'N', ie_logradouro_sib_w, ie_tipo_logradouro_w, ds_logradouro_w, nr_endereco_w, ds_complemento_w, ds_bairro_w, ds_municipio_w, cd_municipio_ibge_resid_w, sg_uf_w, cd_cep_w) INTO STRICT ie_tipo_logradouro_w, ds_logradouro_w, nr_endereco_w, ds_complemento_w, ds_bairro_w, ds_municipio_w, cd_municipio_ibge_resid_w, sg_uf_w, cd_cep_w;
		
		if	((coalesce(dt_exclusao_w::text, '') = '') or (dt_exclusao_w > dt_mesano_referencia_w)) then
			ie_tipo_registro_w	:= 1;
		else
			ie_tipo_registro_w	:= 3;
		end if;
		
		nm_pessoa_fisica_w	:= trim(both upper(elimina_acentos(nm_pessoa_fisica_w)));
		nm_mae_w		:= trim(both upper(elimina_acentos(nm_mae_w)));
		ds_logradouro_w		:= trim(both upper(elimina_acentos(ds_logradouro_w)));
		ds_bairro_w		:= trim(both upper(elimina_acentos(ds_bairro_w)));
		
		/*1 - CPF do beneficiario invalido*/

		if (nr_cpf_w <> nr_cpf_sib_w) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,1,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		/*2 - Nome da mae do beneficiario invalido*/

		if (nm_mae_w <> upper(trim(both nm_mae_sib_w))) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,2,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		/*3 -Data de nascimento do beneficiario invalido*/

		if (dt_nascimento_w <> dt_nascimento_sib_w) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,3,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		/*4 - Sexo do beneficiario invalido*/

		if (ie_sexo_w <> ie_sexo_sib_w) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,4,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		/*5 - Produto do beneficiario invalido*/

		if (nr_protocolo_plano_w <> nr_protocolo_plano_sib_w) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,5,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		/*6 - CEP do beneficiario invalido*/

		if (cd_cep_w <> cd_cep_sib_w) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,6,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		/*7 - Nome diferente*/

		if (nm_pessoa_fisica_w <> trim(both nm_beneficiario_sib_w)) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,7,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		/*8 - Endereco invalido*/

		if (ds_logradouro_w <> trim(both upper(ds_logradouro_sib_w))) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,8,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		/*9 - Dt. Inclusao diferente*/

		if (dt_inclusao_w <> dt_inclusao_sib_w) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,9,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		if (dt_exclusao_w IS NOT NULL AND dt_exclusao_w::text <> '') then
			/*10 - Dt. Exclusao diferente*/

			if (coalesce(dt_exclusao_w,clock_timestamp()) <> coalesce(dt_exclusao_sib_w,clock_timestamp())) then
				CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,10,cd_estabelecimento_p,nm_usuario_p);
			end if;
		end if;
		
		/*11 - Status do beneficiario no sistema*/

		if (ie_tipo_registro_w <> ie_tipo_registro_sib_w) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,11,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		/*14 - Numero endereco invalido*/

		if (nr_endereco_w <> nr_endereco_sib_w) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,14,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		/*15 - Bairro invalido*/

		if (ds_bairro_w <> ds_bairro_sib_w) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,15,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		/*16 - Cod municipio IBGE invalido*/

		if (ds_municipio_w <> cd_municipio_ibge_w) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,16,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		/*17 - Numero do cartao nacional de saude invalido */

		if (nr_cartao_nac_sus_w <> nr_cns_sib_w) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,17,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		/*18 - Motivo de cancelamento invalido*/

		if (cd_motivo_cancelamento_w <> nr_seq_motivo_canc_sib_w) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,18,cd_estabelecimento_p,nm_usuario_p);
		end if;	
		
		/*19 - Indicacao de existencia de cobertura parcial temporaria (CPT) invalido*/

		if (ie_cobertura_parcial_w <> ie_cobertura_parcial_sib_w) then
			CALL pls_inserir_divergencia_sib(nr_seq_retorno_sib_w,19,cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_retorno_sib_diverg
		where	nr_seq_retorno_sib	= nr_seq_retorno_sib_w;
		
		if (qt_registros_w > 0) then
			update	pls_retorno_sib
			set	ie_divergencia	= 'S'
			where	nr_sequencia	= nr_seq_retorno_sib_w;
		else
			update	pls_retorno_sib
			set	ie_divergencia	= 'N'
			where	nr_sequencia	= nr_seq_retorno_sib_w;
		end if;
	else
		update	pls_retorno_sib
		set	ie_divergencia	= 'N'
		where	nr_sequencia	= nr_seq_retorno_sib_w;
	end if;
	
	/*Melhorar a performance realizando o commit a cada 100 registros*/

	if (i_w	> 100) then
		commit;
		i_w	:= 0;
	end if;
	
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_divergencia_sib ( nr_seq_lote_retorno_sib_p bigint, nr_seq_retorno_sib_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

