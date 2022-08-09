-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_carteira_usuario ( nr_seq_segurado_p bigint, nr_seq_titular_p bigint, dt_inicio_vigencia_p timestamp, dt_validade_p timestamp, ie_situacao_p text, ie_alteracao_carteira_p text, nr_seq_emissor_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*
IE_ALTERACAO_CARTEIRA_P
S = Alteracao do produto
MF = Alteracao a partir da matricula da familia
ME = Alteracao a partir da matrticula do estipulante
*/

/*
	A - Sequencia do produto
	S - Sequencial
	V - Digito verificador (Modulo 11 base 2)
	E - Sequencia do contrato
	CA - Codigo do contrato no sistema anterior;
	BA - Codigo do beneficiario no sistema anterior;
	I - Sequencia interna do beneficiario no contrato.
	T - Sequencia do titular
	TI - Titularidade
	NC - Numero do contrato
	CE - Codigo de controle de empresa na OPS
	MA - Codigo da matricula da familia do beneficiario
	CM - Codigo da cooperativa medica
	SC - Codigo do sistema cooperativista
	ME - Codigo da matricula do estipulante do beneficiario
	CP - Codigo da carteira no produto
	VF - Valor fixo
	GI - Grupo de intercambio
*/
nr_seq_regra_w			bigint;
nr_seq_apresentacao_w		smallint;
ie_tipo_campo_w			varchar(5);
ds_mascara_w			varchar(30);
nr_seq_atual_w			bigint;
cd_segurado_familia_w		varchar(20);
cd_segurado_contrato_w		varchar(20);
cd_contrato_w			varchar(20);
cd_plano_w			varchar(20);
nr_seq_plano_w			bigint;
nr_seq_contrato_w		bigint;
dt_contratacao_w		timestamp;
nr_seq_regra_carteira_w		bigint;
nr_digito_w			varchar(2);
cd_carteira_usuario_w		varchar(30)	:= '';
ds_erro_w			varchar(2000)	:= '';
qt_registros_w			bigint;
nr_seq_titular_w		bigint;
nr_seq_emissor_w		bigint;
nr_seq_cart_numero_w		bigint;
ie_tipo_segurado_w		varchar(10);
nr_seq_seg_contrato_w		bigint;
cd_cod_segurado_anterior_w	varchar(20);
cd_cod_contrato_anterior_w	varchar(20);
nr_via_solicitacao_w		integer;
ds_trilha1_w			pls_segurado_carteira.ds_trilha1%type;
ds_trilha2_w			pls_segurado_carteira.ds_trilha2%type;
ds_trilha3_w			pls_segurado_carteira.ds_trilha3%type;
ds_trilha_qr_code_w		pls_segurado_carteira.ds_trilha_qr_code%type;
nr_seq_segurado_carteira_w	bigint;
nr_seq_segurado_w		bigint;
nr_identificacao_titular_w	smallint	:= 00;
nr_seq_identific_w		bigint;
nr_contrato_w			bigint;
cd_cooperativa_w		varchar(10);
cd_matricula_familia_w		bigint;
cd_operadora_empresa_w		bigint;
cd_estabelecimento_w		smallint;
nr_seq_carteira_w		bigint;
cd_matricula_estipulante_w	varchar(30);
nr_seq_congenere_w		bigint;
nr_seq_intercambio_w		bigint;
cd_cd_codigo_carteira_w		varchar(30);
ie_tipo_estipulante_w		varchar(2) := 'A';
cd_fixo_w			varchar(30);
nr_seq_proposta_w		bigint;
nr_seq_pessoa_proposta_w	bigint;
ds_mensagem_w			varchar(255);
nr_seq_plano_ww			bigint;
nr_seq_segurado_obito_w		bigint;
ie_titularidade_w		varchar(10);
cd_pessoa_fisica_w		bigint;
qt_carteira_pessoa_w		bigint;
nr_seq_grupo_intercambio_w	bigint;
cd_grupo_w			varchar(30);
ie_dependente_a100_w		varchar(10);
dt_importacao_arquivo_w		timestamp;
cd_usuario_plano_imp_w		varchar(20);
nr_seq_benef_inclusao_w		bigint;
ie_tipo_sequencial_w		varchar(10);
nr_sequencial_empresa_w		bigint;
nr_inicial_w			bigint;
nr_seq_tabela_w			bigint;
cd_codigo_ant_w			varchar(20);

c01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_apresentacao,
		ie_tipo_campo,
		ds_mascara
	from	pls_regra_carteira_campo
	where	nr_seq_regra_carteira	= nr_seq_regra_carteira_w
	order by nr_seq_apresentacao;


BEGIN

-- A sistema deve pegar o codigo da operadora do beneficiario
select	max(cd_operadora_empresa)
into STRICT	cd_operadora_empresa_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

select	nr_seq_plano,
	nr_seq_contrato,
	coalesce(dt_contratacao,dt_inclusao_operadora),
	nr_seq_titular,
	coalesce(ie_tipo_segurado,'B'),
	nr_seq_seg_contrato,
	cd_cod_anterior,
	nr_seq_congenere,
	nr_seq_intercambio,
	nr_seq_pessoa_proposta,
	nr_seq_segurado_obito,
	ie_titularidade,
	cd_pessoa_fisica,
	nr_seq_benef_inclusao,
	coalesce(ie_dependente_a100,'N'),
	nr_sequencia
into STRICT	nr_seq_plano_w,
	nr_seq_contrato_w,
	dt_contratacao_w,
	nr_seq_titular_w,
	ie_tipo_segurado_w,
	nr_seq_seg_contrato_w,
	cd_cod_segurado_anterior_w,
	nr_seq_congenere_w,
	nr_seq_intercambio_w,
	nr_seq_pessoa_proposta_w,
	nr_seq_segurado_obito_w,
	ie_titularidade_w,
	cd_pessoa_fisica_w,
	nr_seq_benef_inclusao_w,
	ie_dependente_a100_w,
	nr_seq_segurado_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

nr_identificacao_titular_w	:= pls_obter_identifica_titular(nr_seq_titular_w,nr_seq_segurado_w);

if (ie_tipo_segurado_w in ('A','B')) then
	select	CASE WHEN coalesce(cd_pf_estipulante::text, '') = '' THEN  'PJ'  ELSE 'PF' END ,
		nr_contrato
	into STRICT	ie_tipo_estipulante_w,
		nr_contrato_w
	from	pls_contrato
	where	nr_sequencia	= nr_seq_contrato_w;
elsif (ie_tipo_segurado_w in ('T','C')) then
	select	CASE WHEN coalesce(cd_pessoa_fisica::text, '') = '' THEN  'PJ'  ELSE 'PF' END ,
		null
	into STRICT	ie_tipo_estipulante_w,
		nr_contrato_w
	from	pls_intercambio
	where	nr_sequencia	= nr_seq_intercambio_w;
elsif (ie_tipo_segurado_w = 'P') then
	if (nr_seq_pessoa_proposta_w IS NOT NULL AND nr_seq_pessoa_proposta_w::text <> '') then
		select	nr_seq_proposta
		into STRICT	nr_seq_proposta_w
		from	pls_proposta_beneficiario
		where	nr_sequencia	= nr_seq_pessoa_proposta_w;
		
		select	CASE WHEN coalesce(cd_estipulante::text, '') = '' THEN  'PJ'  ELSE 'PF' END ,
			null
		into STRICT	ie_tipo_estipulante_w,
			nr_contrato_w
		from	pls_proposta_adesao
		where	nr_sequencia	= nr_seq_proposta_w;
	else
		ie_tipo_estipulante_w	:= 'A';
		nr_contrato_w		:= null;
	end if;
elsif (ie_tipo_segurado_w = 'R') then
	if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
		select	CASE WHEN coalesce(cd_pf_estipulante::text, '') = '' THEN  'PJ'  ELSE 'PF' END ,
			nr_contrato
		into STRICT	ie_tipo_estipulante_w,
			nr_contrato_w
		from	pls_contrato
		where	nr_sequencia	= nr_seq_contrato_w;
	elsif (nr_seq_intercambio_w IS NOT NULL AND nr_seq_intercambio_w::text <> '') then
		select	CASE WHEN coalesce(cd_pessoa_fisica::text, '') = '' THEN  'PJ'  ELSE 'PF' END ,
			null
		into STRICT	ie_tipo_estipulante_w,
			nr_contrato_w
		from	pls_intercambio
		where	nr_sequencia	= nr_seq_intercambio_w;
	end if;
end if;

if (ie_tipo_segurado_w in ('B','A')) then
	select	coalesce(nr_seq_emissor,0),
		cd_estabelecimento
	into STRICT	nr_seq_emissor_w,
		cd_estabelecimento_w
	from	pls_contrato
	where	nr_sequencia	= nr_seq_contrato_w;
	
	select	coalesce(cd_cod_anterior, nr_contrato)
	into STRICT	cd_cod_contrato_anterior_w
	from	pls_contrato
	where	nr_sequencia	= nr_seq_contrato_w;
elsif (ie_tipo_segurado_w	= 'P') then
	begin
	select	coalesce(max(obter_valor_param_usuario(1235, 1, Obter_Perfil_Ativo, nm_usuario_p, 0)), 0)
	into STRICT	nr_seq_emissor_w
	;
	exception
	when others then
		nr_seq_emissor_w	:= 0;
	end;
	
	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_p;
elsif (ie_tipo_segurado_w	= 'I') then
	select	nr_seq_emissor,
		cd_estabelecimento
	into STRICT	nr_seq_emissor_w,
		cd_estabelecimento_w
	from	pls_congenere
	where	nr_sequencia	= nr_seq_congenere_w;
elsif (ie_tipo_segurado_w	in ('T','C','H') ) then
	select	nr_seq_emissor,
		cd_estabelecimento
	into STRICT	nr_seq_emissor_w,
		cd_estabelecimento_w
	from	pls_intercambio
	where	nr_sequencia	= nr_seq_intercambio_w;
elsif (ie_tipo_segurado_w = 'R') then
	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_p;
	
	--Se o beneficiario nao for seguro de obito, entao ele busca informacoes do repasse, senao busca do contrato ou do intercambio
	if (coalesce(nr_seq_segurado_obito_w::text, '') = '') then
		begin
		select	max(nr_seq_emissor),
			max(nr_seq_plano)
		into STRICT	nr_seq_emissor_w,
			nr_seq_plano_ww
		from	pls_segurado_repasse
		where	nr_seq_segurado	= nr_seq_segurado_p
		and	ie_cartao_provisorio	= 'S';
		
		if (coalesce(nr_seq_emissor_w::text, '') = '') then
			select	max(a.nr_seq_emissor)
			into STRICT	nr_seq_emissor_w
			from	pls_contrato a,
				pls_segurado b
			where	a.nr_sequencia = b.nr_seq_contrato
			and	b.nr_sequencia = nr_seq_segurado_p;
		end if;
		
		exception
		when others then
			
			select	max(nr_seq_emissor_provisorio)
			into STRICT	nr_seq_emissor_w
			from	pls_parametros
			where	cd_estabelecimento	= cd_estabelecimento_w;
			nr_seq_plano_ww		:= null;
		end;
		
		if (nr_seq_plano_ww IS NOT NULL AND nr_seq_plano_ww::text <> '') then
			nr_seq_plano_w	:= nr_seq_plano_ww;
		end if;
		nr_seq_emissor_w	:= coalesce(nr_seq_emissor_w,0);
	elsif (nr_seq_segurado_obito_w IS NOT NULL AND nr_seq_segurado_obito_w::text <> '') then
		if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
			select	coalesce(nr_seq_emissor,0),
				cd_estabelecimento
			into STRICT	nr_seq_emissor_w,
				cd_estabelecimento_w
			from	pls_contrato
			where	nr_sequencia	= nr_seq_contrato_w;
			
			select	coalesce(cd_cod_anterior, nr_contrato)
			into STRICT	cd_cod_contrato_anterior_w
			from	pls_contrato
			where	nr_sequencia	= nr_seq_contrato_w;
		elsif (nr_seq_intercambio_w IS NOT NULL AND nr_seq_intercambio_w::text <> '') then
			select	nr_seq_emissor,
				cd_estabelecimento
			into STRICT	nr_seq_emissor_w,
				cd_estabelecimento_w
			from	pls_intercambio
			where	nr_sequencia	= nr_seq_intercambio_w;
		end if;
	end if;
end if;


--Gerar o sequencial da empresa para o beneficiario
if (cd_operadora_empresa_w IS NOT NULL AND cd_operadora_empresa_w::text <> '') then
	CALL pls_gerar_seq_segurado_empresa(nr_seq_segurado_p,cd_estabelecimento_w,nm_usuario_p);
end if;

if (nr_seq_emissor_p IS NOT NULL AND nr_seq_emissor_p::text <> '') then
	nr_seq_emissor_w	:= nr_seq_emissor_p;
end if;

if (nr_seq_emissor_w = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(203140);
end if;

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_cart_numero_w
from	pls_emissor_cart_numero
where	nr_seq_emissor	= nr_seq_emissor_w;

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_regra_carteira_w
from	pls_regra_carteira
where	nr_seq_emissor	= nr_seq_emissor_w
and	((ie_tipo_estipulante = ie_tipo_estipulante_w) or (ie_tipo_estipulante = 'A'))
and	ie_situacao	= 'A';

if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') and (coalesce(nr_seq_segurado_p,0) <> 0) and (nr_seq_regra_carteira_w <> 0) then
	
	open c01;
	loop
	fetch c01 into
		nr_seq_regra_w,
		nr_seq_apresentacao_w,
		ie_tipo_campo_w,
		ds_mascara_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (ie_tipo_campo_w = 'V') then --Digito verificador (Modulo 11 base 2)
			select	substr(calcula_digito('Modulo11',somente_numero(cd_carteira_usuario_w)),1,2)
			into STRICT	nr_digito_w
			;
			
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || nr_digito_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(nr_digito_w,0), length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'S') then --Sequencial
			begin
			select	coalesce(ie_tipo_sequencia,'S')
			into STRICT	ie_tipo_sequencial_w
			from	pls_emissor_cart_numero
			where	nr_sequencia	= nr_seq_cart_numero_w;
			exception
			when others then
				ie_tipo_sequencial_w	:= 'S';
			end;
			
			--Sequencial da regra
			if (ie_tipo_sequencial_w = 'S') then
				begin
				select	coalesce(nr_atual, nr_inicial) + 1
				into STRICT	nr_seq_atual_w
				from	pls_emissor_cart_numero
				where	nr_sequencia	= nr_seq_cart_numero_w;
				exception
					when others then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(203141);
				end;
				
				update	pls_emissor_cart_numero
				set	nr_atual	= nr_seq_atual_w,
					nm_usuario	= nm_usuario_p,
					dt_atualizacao	= clock_timestamp()
				where	nr_sequencia	= nr_seq_cart_numero_w;
			--Sequencial por empresa
			elsif (ie_tipo_sequencial_w = 'E') then
				begin
				select	nr_inicial
				into STRICT	nr_inicial_w
				from	pls_emissor_cart_numero
				where	nr_sequencia	= nr_seq_cart_numero_w;
				exception
				when others then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(203141);
				end;
				
				select	max(nr_sequencial_empresa)
				into STRICT	nr_sequencial_empresa_w
				from	pls_segurado
				where	nr_sequencia	= nr_seq_segurado_p;
				
				nr_seq_atual_w	:= nr_inicial_w + nr_sequencial_empresa_w-1;
			end if;
			
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || nr_seq_atual_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(nr_seq_atual_w,0), length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'A') then --Sequencia do produto
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || nr_seq_plano_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(nr_seq_plano_w,0), length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'E') then --Sequencia do contrato
			if (ie_tipo_segurado_w not in ('T','C')) then
				if (position('_' in ds_mascara_w) > 0) then
					cd_carteira_usuario_w	:= cd_carteira_usuario_w || nr_seq_contrato_w;
				else
					cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(nr_seq_contrato_w,0), length(ds_mascara_w), '0');
				end if;
			elsif (ie_tipo_segurado_w in ('T','C')) then
				if (position('_' in ds_mascara_w) > 0) then
					cd_carteira_usuario_w	:= cd_carteira_usuario_w || nr_seq_intercambio_w;
				else
					cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(nr_seq_intercambio_w,0), length(ds_mascara_w), '0');
				end if;
			end if;
		elsif (ie_tipo_campo_w = 'CA') then --Codigo do contrato no sistema anterior
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || cd_cod_contrato_anterior_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(cd_cod_contrato_anterior_w,' '), length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'BA') then --Codigo do beneficiario no sistema anterior
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || cd_cod_segurado_anterior_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(cd_cod_segurado_anterior_w,' '), length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'I') then --Sequencia interna do beneficiario no contrato
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || nr_seq_seg_contrato_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(nr_seq_seg_contrato_w,0), length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'T') then --Sequencia do titular
			if (position('_' in ds_mascara_w) > 0) then
				if (nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') then
					cd_carteira_usuario_w	:= cd_carteira_usuario_w || substr(nr_seq_titular_w,1,8);
				else
					cd_carteira_usuario_w	:= cd_carteira_usuario_w || substr(nr_seq_segurado_w,1,8);
				end if;
			else
				if (nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') then
					cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(substr(nr_seq_titular_w,1,8), length(ds_mascara_w), '0');
				else	
					cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(substr(nr_seq_segurado_w,1,8), length(ds_mascara_w), '0');
				end if;
			end if;
		elsif (ie_tipo_campo_w = 'TI') then --Titularidade
			if (ie_titularidade_w IS NOT NULL AND ie_titularidade_w::text <> '') then
				nr_identificacao_titular_w	:= ie_titularidade_w;
			end if;
			
			if (coalesce(nr_seq_titular_w::text, '') = '') and (ie_dependente_a100_w = 'N') then
				nr_identificacao_titular_w := 0;
			end if;
			
			cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(nr_identificacao_titular_w, 2, '0');
		elsif (ie_tipo_campo_w = 'NC') then --Numero do contrato
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || nr_contrato_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(nr_contrato_w,0), length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'VD') then --Digito verificador (Modulo 10)
			select	substr(calcula_digito('Modulo10',somente_numero(cd_carteira_usuario_w)),1,2)
			into STRICT	nr_digito_w
			;
			
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || nr_digito_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(nr_digito_w, length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'CE') then --CE - Codigo de controle de empresa na OPS
			if (coalesce(cd_operadora_empresa_w,-999) <> -999) then
				if (position('_' in ds_mascara_w) > 0) then
					cd_carteira_usuario_w	:= cd_carteira_usuario_w || cd_operadora_empresa_w;
				else
					cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(cd_operadora_empresa_w,'0'), length(ds_mascara_w), '0');
				end if;
			end if;
		elsif (ie_tipo_campo_w = 'MA') then --MA - Codigo da matricula da familia do beneficiario
			select	cd_matricula_familia
			into STRICT	cd_matricula_familia_w
			from	pls_segurado
			where	nr_sequencia = nr_seq_segurado_p;
			
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || cd_matricula_familia_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(cd_matricula_familia_w,0), length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'CM') then --CM - Codigo da cooperativa medica
			if (ie_tipo_segurado_w in ('A','B')) then
				select	max(b.cd_cooperativa)
				into STRICT	cd_cooperativa_w
				from	pls_contrato	a,
					pls_congenere	b,
					pls_outorgante	c
				where	c.nr_sequencia	= a.nr_seq_operadora
				and	b.cd_cgc	= c.cd_cgc_outorgante
				and	a.nr_sequencia	= nr_seq_contrato_w;
			elsif (ie_tipo_segurado_w in ('T','C','H')) then
				select	max(b.cd_cooperativa)
				into STRICT	cd_cooperativa_w
				from	pls_congenere	b,
					pls_intercambio	a
				where	coalesce(a.nr_seq_congenere,a.nr_seq_congenere)	= b.nr_sequencia
				and	a.nr_sequencia		= nr_seq_intercambio_w;
			elsif (ie_tipo_segurado_w in ('I','P')) then
				select	max(b.cd_cooperativa)
				into STRICT	cd_cooperativa_w
				from	pls_congenere	b,
					pls_outorgante	a
				where	b.cd_cgc		= a.cd_cgc_outorgante
				and	a.cd_estabelecimento	= cd_estabelecimento_w;
			elsif (ie_tipo_segurado_w	= 'R') then
				if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
					select	max(b.cd_cooperativa)
					into STRICT	cd_cooperativa_w
					from	pls_contrato	a,
						pls_congenere	b,
						pls_outorgante	c
					where	c.nr_sequencia	= a.nr_seq_operadora
					and	b.cd_cgc	= c.cd_cgc_outorgante
					and	a.nr_sequencia	= nr_seq_contrato_w;
				elsif (nr_seq_intercambio_w IS NOT NULL AND nr_seq_intercambio_w::text <> '') then
					select	max(b.cd_cooperativa)
					into STRICT	cd_cooperativa_w
					from	pls_congenere	b,
						pls_intercambio	a
					where	coalesce(a.nr_seq_congenere,a.nr_seq_congenere)	= b.nr_sequencia
					and	a.nr_sequencia		= nr_seq_intercambio_w;
				end if;
			end if;
			
			if (length(cd_cooperativa_w) = 4) then
				cd_cooperativa_w	:= substr(cd_cooperativa_w,2,4);
			end if;
			
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || cd_cooperativa_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(cd_cooperativa_w,0), length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'SC') then --SC - Codigo do sistema cooperativista
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || 0;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(0, length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'ME') then --ME - Codigo da matricula do estipulante do beneficiario
			select	max(cd_matricula_estipulante)
			into STRICT	cd_matricula_estipulante_w
			from	pls_segurado
			where	nr_sequencia = nr_seq_segurado_p;
			
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || cd_matricula_estipulante_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(cd_matricula_estipulante_w,0), length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'CP') then --CP - Codigo da carteira no produto
			select	max(cd_codigo_carteira)
			into STRICT	cd_cd_codigo_carteira_w
			from	pls_plano
			where	nr_sequencia	= nr_seq_plano_w;
			
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || cd_cd_codigo_carteira_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(cd_cd_codigo_carteira_w,0), length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'VF') then --VF - Valor fixo
			select	max(cd_fixo)
			into STRICT	cd_fixo_w
			from	pls_regra_carteira_campo
			where	nr_sequencia	= nr_seq_regra_w;
			
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || cd_fixo_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(cd_fixo_w,0), length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'GI') then --GI - Grupo de intercambio
			select	max(nr_seq_grupo_intercambio)
			into STRICT	nr_seq_grupo_intercambio_w
			from	pls_segurado
			where	nr_sequencia	= nr_seq_segurado_p;
			
			if (nr_seq_grupo_intercambio_w IS NOT NULL AND nr_seq_grupo_intercambio_w::text <> '') then
				select	cd_grupo
				into STRICT	cd_grupo_w
				from	pls_regra_grupo_inter
				where	nr_sequencia	= nr_seq_grupo_intercambio_w;
			else
				cd_grupo_w	:= '0';
			end if;
			
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || cd_grupo_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(cd_grupo_w,0), length(ds_mascara_w), '0');
			end if;
		elsif (ie_tipo_campo_w = 'CT') then
			select	max(nr_seq_tabela)
			into STRICT	nr_seq_tabela_w
			from	pls_segurado
			where	nr_sequencia	= nr_seq_segurado_p;
			
			if (nr_seq_tabela_w IS NOT NULL AND nr_seq_tabela_w::text <> '') then
				select	cd_codigo_ant
				into STRICT	cd_codigo_ant_w
				from	pls_tabela_preco
				where	nr_sequencia	= nr_seq_tabela_w;
			else
				cd_codigo_ant_w	:= '0';
			end if;
			
			if (position('_' in ds_mascara_w) > 0) then
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || cd_codigo_ant_w;
			else
				cd_carteira_usuario_w	:= cd_carteira_usuario_w || lpad(coalesce(cd_codigo_ant_w,0), length(ds_mascara_w), '0');
			end if;
		end if;
		end;
	end loop;
	close c01;
	
	if (coalesce(nr_seq_contrato_w,0) <> 0) then
		if (coalesce(nr_seq_pessoa_proposta_w,0) <> 0) then
			--Nao permite liberar beneficiario com numero da carteirinha diferente
			select	max(b.cd_usuario_plano),
				max(c.dt_importacao_arquivo)
			into STRICT	cd_usuario_plano_imp_w,
				dt_importacao_arquivo_w
			from	pls_proposta_beneficiario	a,
				pls_inclusao_beneficiario	b,
				pls_lote_inclusao_benef		c
			where	a.nr_seq_inclusao_benef	= b.nr_sequencia
			and	b.nr_seq_lote_inclusao	= c.nr_sequencia
			and	a.nr_sequencia		= nr_seq_pessoa_proposta_w;
			
			if	((dt_importacao_arquivo_w IS NOT NULL AND dt_importacao_arquivo_w::text <> '') and (cd_carteira_usuario_w <> cd_usuario_plano_imp_w) and (cd_usuario_plano_imp_w IS NOT NULL AND cd_usuario_plano_imp_w::text <> '')) then
				cd_carteira_usuario_w	:= cd_usuario_plano_imp_w;
			end if;
		end if;
	elsif (coalesce(nr_seq_intercambio_w,0) <> 0) then
		if (coalesce(nr_seq_benef_inclusao_w,0) <> 0) then
			select	max(a.cd_usuario_plano),
				max(b.dt_importacao_arquivo)
			into STRICT	cd_usuario_plano_imp_w,
				dt_importacao_arquivo_w
			from	pls_inclusao_beneficiario	a,
				pls_lote_inclusao_benef		b
			where	a.nr_seq_lote_inclusao	= b.nr_sequencia
			and	a.nr_sequencia		= nr_seq_benef_inclusao_w;
			
			if	((dt_importacao_arquivo_w IS NOT NULL AND dt_importacao_arquivo_w::text <> '') and (cd_carteira_usuario_w <> cd_usuario_plano_imp_w) and (cd_usuario_plano_imp_w IS NOT NULL AND cd_usuario_plano_imp_w::text <> '')) then
				cd_carteira_usuario_w	:= cd_usuario_plano_imp_w;
			end if;
		end if;
	end if;
	
	if	((cd_carteira_usuario_w = '') or (coalesce(cd_carteira_usuario_w::text, '') = '')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(203142);
	end if;
	
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_segurado_carteira
	where	cd_usuario_plano	= cd_carteira_usuario_w
	and	nr_seq_segurado		<> nr_seq_segurado_p
	and	cd_estabelecimento	= cd_estabelecimento_w;
	
	if (qt_registros_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(203143,'CD_USUARIO_PLANO='||cd_carteira_usuario_w);
	end if;
	
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_segurado_cart_ant
	where	cd_usuario_ant	= cd_carteira_usuario_w
	and	nr_seq_segurado	<> nr_seq_segurado_p;
	
	if (qt_registros_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(203144,'CD_USUARIO_PLANO='||cd_carteira_usuario_w);
	end if;
	
	insert into pls_segurado_cart_ant(nr_sequencia, nm_usuario, dt_atualizacao,
		cd_usuario_ant, dt_validade, dt_inicio_vigencia,
		nr_seq_segurado, dt_alteracao, nm_usuario_solicitacao,
		dt_solicitacao, ds_observacao, ds_trilha1, ds_trilha2,
		ds_trilha3, ds_trilha_qr_code, dt_desbloqueio, nm_usuario_desbloqueio,
		ie_tipo_desbloqueio)
	SELECT	nextval('pls_segurado_cart_ant_seq'), nm_usuario_p, clock_timestamp(),
		cd_usuario_plano, dt_validade_carteira, dt_inicio_vigencia,
		nr_seq_segurado, clock_timestamp(), nm_usuario_solicitante,
		dt_solicitacao, ds_observacao, ds_trilha1, ds_trilha2,
		ds_trilha3, ds_trilha_qr_code, dt_desbloqueio, nm_usuario_desbloqueio, 
		ie_tipo_desbloqueio
	from	pls_segurado_carteira
	where	nr_seq_segurado	= nr_seq_segurado_p;
	
	select	coalesce(max(nr_via_solicitacao),0) + 1
	into STRICT	nr_via_solicitacao_w
	from	pls_segurado_carteira
	where	nr_seq_segurado	= nr_seq_segurado_p;
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_carteira_w
	from	pls_segurado_carteira
	where	nr_seq_segurado	= nr_seq_segurado_p;
	
	if (ie_alteracao_carteira_p = 'S') then
		update	pls_segurado_carteira
		set	cd_usuario_plano	= cd_carteira_usuario_w,
			ie_situacao		= 'P',
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			ds_observacao		= wheb_mensagem_pck.get_texto(1127412),
			nr_seq_lote_emissao	 = NULL,
			nm_usuario_solicitante	= nm_usuario_p,
			dt_solicitacao		= clock_timestamp(),
			nr_seq_motivo_via	 = NULL
		where	nr_sequencia		= nr_seq_carteira_w;
	elsif (ie_alteracao_carteira_p = 'MF') then
		update	pls_segurado_carteira
		set	cd_usuario_plano	= cd_carteira_usuario_w,
			ie_situacao		= 'P',
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			ds_observacao		= wheb_mensagem_pck.get_texto(1127414),
			nr_seq_lote_emissao	 = NULL,
			nm_usuario_solicitante	= nm_usuario_p,
			dt_solicitacao		= clock_timestamp(),
			nr_seq_motivo_via	 = NULL
		where	nr_sequencia		= nr_seq_carteira_w;
	elsif (ie_alteracao_carteira_p = 'ME') then
		update	pls_segurado_carteira
		set	cd_usuario_plano	= cd_carteira_usuario_w,
			ie_situacao		= 'P',
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			ds_observacao		= wheb_mensagem_pck.get_texto(1127415),
			nr_seq_lote_emissao	 = NULL,
			nm_usuario_solicitante	= nm_usuario_p,
			dt_solicitacao		= clock_timestamp(),
			nr_seq_motivo_via	 = NULL
		where	nr_sequencia		= nr_seq_carteira_w;
	else
		delete	FROM pls_segurado_cart_estagio
		where	nr_seq_cartao_seg = nr_seq_carteira_w;
		
		delete	from pls_carteira_emissao a
		where	exists (SELECT	1
				from	pls_segurado_carteira x
				where	x.nr_sequencia = a.nr_seq_seg_carteira
				and	x.nr_seq_segurado = nr_seq_segurado_p);
		
		delete	from pls_segurado_carteira
		where	nr_seq_segurado = nr_seq_segurado_p;
		
		select	nextval('pls_segurado_carteira_seq')
		into STRICT	nr_seq_segurado_carteira_w
		;
		
		if (ie_tipo_segurado_w in ('A','B','R')) then
			ds_mensagem_w := pls_gerar_mensagem_carteira(nr_seq_segurado_p, nr_seq_contrato_w, nr_seq_plano_w, ds_mensagem_w);
		end if;
		
		insert into pls_segurado_carteira(nr_sequencia, nm_usuario, dt_atualizacao,
			cd_usuario_plano, dt_inicio_vigencia, dt_validade_carteira,
			nr_seq_segurado, nr_seq_emissor, ie_situacao,
			nr_via_solicitacao, nm_usuario_solicitante, dt_solicitacao,
			ds_observacao, ds_trilha1, ds_trilha2,
			ds_trilha3, cd_estabelecimento, ds_mensagem_carteira,ie_processo)
		values (nr_seq_segurado_carteira_w, nm_usuario_p, clock_timestamp(),
			cd_carteira_usuario_w, coalesce(dt_inicio_vigencia_p, dt_contratacao_w), dt_validade_p,
			nr_seq_segurado_p, nr_seq_emissor_w, coalesce(ie_situacao_p,'P'),
			nr_via_solicitacao_w, nm_usuario_p, clock_timestamp(),
			wheb_mensagem_pck.get_texto(1127416, 'NR_VIA_SOLICITACAO='||nr_via_solicitacao_w), ds_trilha1_w, ds_trilha2_w,
			ds_trilha3_w, cd_estabelecimento_w, ds_mensagem_w,'M');
	end if;
	
	select	count(1)
	into STRICT	qt_carteira_pessoa_w
	from	pls_pessoa_carteira
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	cd_usuario_plano	= cd_carteira_usuario_w  LIMIT 1;
	
	if (qt_carteira_pessoa_w = 0) then
		--Gravar a carteirinha na pessoa fisica
		insert	into	pls_pessoa_carteira(	nr_sequencia, cd_pessoa_fisica, cd_usuario_plano,
				cd_estabelecimento, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec)
			values (	nextval('pls_pessoa_carteira_seq'), cd_pessoa_fisica_w, cd_carteira_usuario_w,
				cd_estabelecimento_w, clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p);
	end if;
	
	if (ie_tipo_segurado_w in ('B','A','I','T','C','R','H')) then
		SELECT * FROM pls_obter_trilhas_cartao(nr_seq_segurado_p, ds_trilha1_w, ds_trilha2_w, ds_trilha3_w, ds_trilha_qr_code_w, nm_usuario_p) INTO STRICT ds_trilha1_w, ds_trilha2_w, ds_trilha3_w, ds_trilha_qr_code_w;
		
		update	pls_segurado_carteira
		set	ds_trilha1		= ds_trilha1_w,
			ds_trilha2		= ds_trilha2_w,
			ds_trilha3		= ds_trilha3_w,
			ds_trilha_qr_code	= ds_trilha_qr_code_w
		where	nr_sequencia		= nr_seq_segurado_carteira_w;
		
		CALL pls_alterar_estagios_cartao(nr_seq_segurado_carteira_w,clock_timestamp(),1,cd_estabelecimento_w,nm_usuario_p);
	end if;
end if;

--commit; Nao pode dar commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_carteira_usuario ( nr_seq_segurado_p bigint, nr_seq_titular_p bigint, dt_inicio_vigencia_p timestamp, dt_validade_p timestamp, ie_situacao_p text, ie_alteracao_carteira_p text, nr_seq_emissor_p bigint, nm_usuario_p text) FROM PUBLIC;
