-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_lanc_auto_alt_produto ( nr_seq_beneficiario_p bigint, ie_origem_alt_prod_p text, ie_copiar_carencia_prod_novo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_regra_w			bigint	:= 0;
nr_seq_tipo_carencia_w		bigint;
qt_dias_carencia_w		integer;
ie_inicio_vig_carencia_w	varchar(3);
nr_seq_plano_ant_w		bigint;
nr_seq_plano_atual_w		bigint;
ie_acomodacao_antigo_w		varchar(1);
ie_acomodacao_atual_w		varchar(1);
dt_inicio_vigencia_w		timestamp;
ie_tipo_regra_w			varchar(2);
vl_mensalidade_w		double precision;
ie_preco_atual_w		varchar(10);
ie_preco_ant_w			varchar(10);
nr_seq_segurado_ant_w		bigint;
--------------------------------------------------------------------------------
ie_adaptar_carencia_rede_w	varchar(10);
ie_mes_posterior_w		varchar(10);
nr_seq_grupo_carencia_w		bigint;
qt_registros_w			bigint;
nr_seq_contrato_w		bigint;
ie_consistir_carencia_rede_w	varchar(10) := 'N';
nr_seq_tipo_carencia_ww		bigint;
qt_dias_w			bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_regra_lanc_automatico
	where	ie_evento		= 1
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	ie_situacao		= 'A'
	and	((coalesce(ie_acomodacao_origem,'N') = 'N') or (ie_acomodacao_origem = ie_acomodacao_antigo_w))
	and	((coalesce(ie_acomodacao_destino,'N') = 'N') or (ie_acomodacao_destino = ie_acomodacao_atual_w))
	and	((ie_preco	= ie_preco_atual_w) or (coalesce(ie_preco::text, '') = ''))
	and	((ie_preco_ant	= ie_preco_ant_w) or (coalesce(ie_preco::text, '') = ''))
	and	((ie_origem_alt_produto	= ie_origem_alt_prod_p) or (ie_origem_alt_produto = 'T'))
	and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp());
	
C02 CURSOR FOR
	SELECT	coalesce(nr_seq_tipo_carencia,0),
		coalesce(qt_dias_carencia,0),
		coalesce(ie_inicio_vig_carencia,'N'),
		coalesce(vl_mensalidade,0),
		ie_tipo_regra,
		coalesce(ie_adaptar_carencia_rede,'N')
	from	pls_regra_lanc_aut_item
	where	nr_seq_regra	= nr_seq_regra_w
	and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp());


BEGIN
/*Caso a acao venha da alteracao manual do produto*/

if (ie_origem_alt_prod_p	= 'A') then
	/* Obter o produto antigo e atual do beneficiario */

	begin
	select	nr_seq_plano_ant,
		nr_seq_plano_atual
	into STRICT	nr_seq_plano_ant_w,
		nr_seq_plano_atual_w
	from	pls_segurado_alt_plano
	where	nr_seq_segurado	= nr_seq_beneficiario_p
	and	nr_sequencia	=	(	SELECT	max(nr_sequencia)
						from 	pls_segurado_alt_plano 
						where 	nr_seq_segurado = nr_seq_beneficiario_p
						and	ie_situacao = 'A'
						and	trunc(dt_atualizacao) = trunc(clock_timestamp()));
	exception
		when others then
		nr_seq_plano_ant_w	:= 0;
		nr_seq_plano_atual_w	:= 0;
	end;
/*Caso a alteracao venha da migracao de contratos*/

elsif (ie_origem_alt_prod_p	= 'M') then
	select	nr_seq_segurado_ant,
		nr_seq_plano
	into STRICT	nr_seq_segurado_ant_w,
		nr_seq_plano_atual_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_beneficiario_p;
	
	select	nr_seq_plano
	into STRICT	nr_seq_plano_ant_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_ant_w;
end if;

/*Caso o o beneficiario nao tiver um produto atual*/

if	((coalesce(nr_seq_plano_atual_w::text, '') = '') or (nr_seq_plano_atual_w = 0)) then
	goto final;
end if;

/* Obter dados do produto antigo */

select	ie_acomodacao,
	ie_preco
into STRICT	ie_acomodacao_antigo_w,
	ie_preco_ant_w
from	pls_plano
where	nr_sequencia	= nr_seq_plano_ant_w;

/* Obter dados do produto atual */

select	ie_acomodacao,
	ie_preco
into STRICT	ie_acomodacao_atual_w,
	ie_preco_atual_w
from	pls_plano
where	nr_sequencia	= nr_seq_plano_atual_w;

open C01;
loop
fetch C01 into	
	nr_seq_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	open C02;
	loop
	fetch C02 into	
		nr_seq_tipo_carencia_w,
		qt_dias_carencia_w,
		ie_inicio_vig_carencia_w,
		vl_mensalidade_w,
		ie_tipo_regra_w,
		ie_adaptar_carencia_rede_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (ie_tipo_regra_w = 'C') then
			if (ie_adaptar_carencia_rede_w = 'N') then
				CALL pls_lanc_auto_item_carencia(nr_seq_beneficiario_p, nr_seq_regra_w, nr_seq_tipo_carencia_w,
							qt_dias_carencia_w, ie_inicio_vig_carencia_w, nm_usuario_p);
			else
				select	max(nr_seq_contrato)
				into STRICT	nr_seq_contrato_w
				from	pls_segurado
				where	nr_sequencia	= nr_seq_beneficiario_p;

				if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
					select	coalesce(ie_consistir_carencia_rede,'N')
					into STRICT	ie_consistir_carencia_rede_w
					from	pls_contrato
					where	nr_sequencia	= nr_seq_contrato_w;
				end if;
				if (ie_consistir_carencia_rede_w = 'S') then
					
					if (ie_inicio_vig_carencia_w	= 'A') then
						dt_inicio_vigencia_w		:= clock_timestamp();
					elsif (ie_inicio_vig_carencia_w	= 'I') then
						select	coalesce(max(dt_inclusao_operadora),'')
						into STRICT	dt_inicio_vigencia_w
						from	pls_segurado
						where	nr_sequencia	= nr_seq_beneficiario_p;
					elsif (ie_inicio_vig_carencia_w	= 'P') then
						if (ie_origem_alt_prod_p	= 'A') then
							select	dt_alteracao
							into STRICT	dt_inicio_vigencia_w
							from	pls_segurado_alt_plano
							where	nr_seq_segurado	= nr_seq_beneficiario_p
							and	nr_sequencia	=	(	SELECT	max(nr_sequencia)
												from 	pls_segurado_alt_plano 
												where 	nr_seq_segurado = nr_seq_beneficiario_p
												and	ie_situacao = 'A'
												and	trunc(dt_atualizacao) = trunc(clock_timestamp()));
						else
							dt_inicio_vigencia_w		:= clock_timestamp();
						end if;
					end if;
					
					pls_adaptar_rede_atend_produto(nr_seq_plano_atual_w,nr_seq_plano_ant_w,nr_seq_beneficiario_p,dt_inicio_vigencia_w,nr_seq_regra_w,cd_estabelecimento_p,nm_usuario_p);
				end if;
			end if;
		elsif (ie_tipo_regra_w = 'M') then
			CALL pls_lanc_auto_item_mensalidade(nr_seq_beneficiario_p, vl_mensalidade_w, cd_estabelecimento_p, nm_usuario_p);
		end if;
		end;
	end loop;
	close C02;	
	end;
end loop;
close C01;

/*Copiar as carencias para o beneficiario quando for alteracao de produto, migracao nao e necessario*/

if (ie_origem_alt_prod_p	= 'A') and (ie_copiar_carencia_prod_novo_p = 'S') then
	CALL pls_copiar_carencia_alt_prod(nr_seq_beneficiario_p,nr_seq_plano_atual_w,nr_seq_plano_ant_w,cd_estabelecimento_p,'N',nm_usuario_p);
end if;

<<final>>
nr_seq_plano_atual_w	:= nr_seq_plano_atual_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_lanc_auto_alt_produto ( nr_seq_beneficiario_p bigint, ie_origem_alt_prod_p text, ie_copiar_carencia_prod_novo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

