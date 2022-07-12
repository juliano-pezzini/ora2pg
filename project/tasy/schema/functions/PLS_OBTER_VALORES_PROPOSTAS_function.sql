-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valores_propostas ( nr_seq_proposta_benef_p bigint, nr_seq_boni_sca_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

/*
ie_opcao_p
B - Bonificacao
S -  SCA
P - Proposta do beneficiario
I - taxa de inscrição
IP - Taxa de inscrição do produto
AP - Adaptação ao plano de saúde
SC - SCA do contrato
IC - Taxa de inscrição do CONTRATO
VC - Via carteira
*/
vl_retorno_w			double precision := 0;
nr_seq_tabela_sca_w		bigint;
vl_bonificacao_w		double precision := 0;
vl_tot_bonificacao_w		double precision := 0;
tx_bonificacao_w		double precision;
qt_idade_benef_w		bigint;
cd_beneficiario_w		varchar(15);
nr_seq_tabela_benef_w		bigint;
vl_proposta_benef_w		double precision := 0;
vl_proposta_sca_w		double precision := 0;
cd_estabelecimento_w		smallint;
nr_seq_proposta_w		bigint;
tx_desconto_w			bigint;
nr_seq_regra_desconto_w		bigint;
dt_inicio_proposta_w		timestamp;
nr_seq_regra_w			bigint;
vl_inscricao_w 			double precision;
tx_inscricao_w			double precision;
ie_taxa_inscricao_w		varchar(5);
nr_seq_plano_w			bigint;
ie_grau_parentesco_w		varchar(2);
ie_tipo_item_w			varchar(255);
vl_total_tx_inscricao		double precision;
tx_adaptacao_w			double precision;
ie_tipo_proposta_w		bigint;
nr_contrato_w			bigint;
nr_seq_contrato_w		bigint;
ie_beneficiario_titular_w	varchar(10);
ie_acao_contrato_w		varchar(10);
qt_vidas_w			bigint;
ie_preco_vidas_contrato_w	varchar(10);
vl_via_carteira_w		double precision;
tx_via_carteira_w		double precision;
nr_seq_desconto_w		bigint;
ie_tipo_regra_w			varchar(10);
ie_possui_bonificacao_w		varchar(10);
nr_seq_preco_sca_w		pls_plano_preco.nr_sequencia%type;
nr_seq_reaj_sca_w		pls_reajuste_preco.nr_sequencia%type;

qt_idade_limite_reaj_param_w	pls_parametros.qt_idade_limite%type;
qt_anos_limite_reaj_param_w	pls_parametros.qt_tempo_limite%type;
ie_data_ref_reaj_adaptado_w	pls_parametros.ie_data_ref_reaj_adaptado%type;
dt_base_inclusao_w		timestamp;
nr_seq_beneficiario_w		bigint;
dt_contratacao_w		timestamp;
dt_inclusao_operadora_w		timestamp;
qt_idade_operadora_w		bigint;
dt_nascimento_w			timestamp;
nr_seq_preco_w			pls_plano_preco.nr_sequencia%type;
nr_seq_reaj_futuro_w 		pls_reajuste_preco.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	coalesce(c.vl_bonificacao,coalesce(a.vl_bonificacao,0)),
		coalesce(c.tx_bonificacao,coalesce(a.tx_bonificacao,0)),
		a.ie_tipo_item,
		coalesce(a.ie_tipo_regra,'M'),
		a.nr_seq_desconto,
		coalesce(ie_possui_bonificacao,'N')
	from	pls_bonificacao_regra	a,
		pls_bonificacao		b,
		pls_bonificacao_vinculo	c,
		pls_proposta_beneficiario d
	where	a.nr_seq_bonificacao	= b.nr_sequencia
	and	b.nr_sequencia		= nr_seq_boni_sca_p
	and	c.nr_seq_bonificacao	= b.nr_sequencia
	and	c.nr_seq_segurado_prop	= d.nr_sequencia
	and	d.nr_sequencia		= nr_seq_proposta_benef_p
	and	1 between coalesce(nr_parcela_inicial,1) and coalesce(nr_parcela_final,1);

C02 CURSOR FOR /* Valor total SCA */
	SELECT	nr_seq_tabela
	from	pls_sca_vinculo
	where	nr_seq_benef_proposta	= nr_seq_proposta_benef_p;

C03 CURSOR FOR
	SELECT	nr_seq_tabela
	from	pls_sca_regra_contrato
	where	nr_seq_contrato	= nr_seq_contrato_w
	and	dt_inicio_proposta_w between coalesce(dt_inicio_vigencia,dt_inicio_proposta_w) and fim_dia(coalesce(dt_fim_vigencia,dt_inicio_proposta_w))
	and	((coalesce(ie_geracao_valores,'B') = ie_beneficiario_titular_w) or coalesce(ie_geracao_valores,'B') = 'B');

C04 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_plano_preco
	where	nr_seq_tabela	= nr_seq_tabela_benef_w
	and	qt_idade_benef_w between qt_idade_inicial and qt_idade_final
	and	coalesce(ie_grau_titularidade,ie_grau_parentesco_w)	= ie_grau_parentesco_w
	and	(((ie_preco_vidas_contrato_w = 'S')
		and qt_vidas_w between coalesce(qt_vidas_inicial,qt_vidas_w) and coalesce(qt_vidas_final,qt_vidas_w))
	or (ie_preco_vidas_contrato_w = 'N'))
	order	by	coalesce(ie_grau_titularidade,' ');

C05 CURSOR FOR
	SELECT	nr_sequencia,
		coalesce(vl_preco_atual,0)
	from	pls_plano_preco
	where	nr_seq_tabela	= nr_seq_tabela_sca_w
	and	qt_idade_benef_w between qt_idade_inicial and qt_idade_final
	and	coalesce(ie_grau_titularidade,ie_grau_parentesco_w)	= ie_grau_parentesco_w
	order 	by coalesce(ie_grau_titularidade,' ');


BEGIN

select	b.cd_beneficiario,
	b.nr_seq_proposta,
	b.ie_taxa_inscricao,
	CASE WHEN coalesce(b.nr_seq_titular::text, '') = '' THEN CASE WHEN coalesce(b.nr_seq_titular_contrato::text, '') = '' THEN 'T'  ELSE 'D' END   ELSE 'D' END ,
	b.nr_seq_plano,
	trunc(months_between(c.dt_inicio_proposta, a.dt_nascimento) / 12),
	b.nr_seq_tabela,
	b.nr_seq_beneficiario,
	a.dt_nascimento,
	c.cd_estabelecimento,
	c.dt_inicio_proposta,
	c.ie_tipo_proposta,
	c.nr_seq_contrato
into STRICT	cd_beneficiario_w,
	nr_seq_proposta_w,
	ie_taxa_inscricao_w,
	ie_beneficiario_titular_w,
	nr_seq_plano_w,
	qt_idade_benef_w,
	nr_seq_tabela_benef_w,
	nr_seq_beneficiario_w,
	dt_nascimento_w,
	cd_estabelecimento_w,
	dt_inicio_proposta_w,
	ie_tipo_proposta_w,
	nr_contrato_w
from	pessoa_fisica			a,
	pls_proposta_beneficiario	b,
	pls_proposta_adesao		c
where	a.cd_pessoa_fisica	= b.cd_beneficiario
and	b.nr_seq_proposta	= c.nr_sequencia
and	b.nr_sequencia		= nr_seq_proposta_benef_p
and	coalesce(b.dt_cancelamento::text, '') = '';

ie_grau_parentesco_w	:= coalesce(substr(pls_obter_garu_dependencia_seg(nr_seq_proposta_benef_p,'P'),1,2),'X');

if (nr_seq_tabela_benef_w IS NOT NULL AND nr_seq_tabela_benef_w::text <> '') then
	select	coalesce(ie_preco_vidas_contrato,'N')
	into STRICT	ie_preco_vidas_contrato_w
	from	pls_tabela_preco
	where	nr_sequencia	= nr_seq_tabela_benef_w;
end if;

if (ie_preco_vidas_contrato_w = 'S') then
	qt_vidas_w		:= pls_obter_qt_vidas_proposta(nr_seq_proposta_w,nr_seq_proposta_benef_p);
else
	qt_vidas_w	:= 0;
end if;

if (ie_tipo_proposta_w in (1,6,7)) then
	ie_acao_contrato_w	:= 'A';
elsif (ie_tipo_proposta_w in (2,8)) then
	ie_acao_contrato_w	:= 'L';
elsif (ie_tipo_proposta_w in (3,4,7,8)) then
	ie_acao_contrato_w	:= 'M';
end if;

if (nr_contrato_w IS NOT NULL AND nr_contrato_w::text <> '') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_contrato_w
	from	pls_contrato
	where	nr_contrato = nr_contrato_w;
end if;

begin
select	coalesce(qt_idade_limite,0),
	coalesce(qt_tempo_limite,0),
	ie_data_ref_reaj_adaptado
into STRICT	qt_idade_limite_reaj_param_w,
	qt_anos_limite_reaj_param_w,
	ie_data_ref_reaj_adaptado_w
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_w;
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1072520);
end;

/*aaschlote 19/02/2013 OS - 695547*/

if (ie_tipo_proposta_w = 9) then
	select	dt_contratacao,
		dt_inclusao_operadora
	into STRICT	dt_contratacao_w,
		dt_inclusao_operadora_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_beneficiario_w;
	
	if (ie_data_ref_reaj_adaptado_w = 'A') then
		dt_base_inclusao_w	:= dt_contratacao_w;
	elsif (ie_data_ref_reaj_adaptado_w = 'D') then
		dt_base_inclusao_w	:= dt_inicio_proposta_w;
	else
		dt_base_inclusao_w	:= dt_inclusao_operadora_w;
	end if;
	
	qt_idade_operadora_w	:= round((obter_idade(dt_base_inclusao_w, dt_inicio_proposta_w, 'A'))::numeric );
	
	if (qt_idade_benef_w >= qt_idade_limite_reaj_param_w) and (qt_idade_operadora_w >= qt_anos_limite_reaj_param_w) then
		begin -- OS 950859
		select	qt_idade
		into STRICT	qt_idade_benef_w
		from	pls_segurado_preco
		where	nr_sequencia = pls_obter_seg_preco_ativo(nr_seq_beneficiario_w, dt_inicio_proposta_w);
		exception
		when others then
			qt_idade_benef_w := 0;
		end;
	end if;
end if;

open c04;
loop
fetch c04 into
	nr_seq_preco_w;
EXIT WHEN NOT FOUND; /* apply on c04 */
	begin
	select	min(nr_sequencia)
	into STRICT 	nr_seq_reaj_futuro_w
	from 	pls_reajuste_preco
	where 	nr_seq_preco  = nr_seq_preco_w
	and 	dt_reajuste  > dt_inicio_proposta_w
	and 	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
	
	if (coalesce(nr_seq_reaj_futuro_w::text, '') = '') then
		select 	coalesce(vl_preco_atual, 0)
		into STRICT 	vl_proposta_benef_w
		from 	pls_plano_preco 
		where 	nr_sequencia = nr_seq_preco_w;
	else
		select 	coalesce(a.vl_base, 0)
		into STRICT	vl_proposta_benef_w
		from 	pls_reajuste_preco  a,
			pls_plano_preco b
		where 	b.nr_sequencia = a.nr_seq_preco
		and	a.nr_sequencia = nr_seq_reaj_futuro_w;
	end if;
	end;
end loop;
close c04;

SELECT * FROM pls_obter_regra_desconto(nr_seq_proposta_benef_p, 2, cd_estabelecimento_w, tx_desconto_w, nr_seq_regra_desconto_w) INTO STRICT tx_desconto_w, nr_seq_regra_desconto_w;

vl_proposta_benef_w	:= vl_proposta_benef_w - dividir((vl_proposta_benef_w * tx_desconto_w), 100);

vl_retorno_w	:= 0;
if (ie_opcao_p = 'B') then
	open C02;
	loop
	fetch C02 into
		nr_seq_tabela_sca_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
			select	coalesce(vl_preco_atual,0) + coalesce(vl_proposta_sca_w,0)
			into STRICT	vl_proposta_sca_w
			from	pls_plano_preco
			where	nr_seq_tabela	= nr_seq_tabela_sca_w
			and	qt_idade_benef_w	between qt_idade_inicial and qt_idade_final;
		exception
		when others then
			vl_proposta_sca_w	:= 0;
		end;
	end loop;
	close C02;
	
	SELECT * FROM pls_obter_taxa_inscricao(nr_seq_proposta_benef_p, null, null, null, nr_seq_proposta_w, 1, dt_inicio_proposta_w, null, null, nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w) INTO STRICT nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w;
	
	if (coalesce(tx_inscricao_w,0) <> 0) then
		vl_total_tx_inscricao := dividir((vl_proposta_benef_w * tx_inscricao_w), 100);
	elsif (coalesce(vl_inscricao_w,0) <> 0) then
		vl_total_tx_inscricao := vl_inscricao_w;
	end if;
	
	open C01;
	loop
	fetch C01 into
		vl_bonificacao_w,
		tx_bonificacao_w,
		ie_tipo_item_w,
		ie_tipo_regra_w,
		nr_seq_desconto_w,
		ie_possui_bonificacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (ie_tipo_regra_w = 'M') then
			if (pls_obter_se_item_lista(ie_tipo_item_w,'1') = 'S') then
				vl_tot_bonificacao_w	:= (((tx_bonificacao_w /100) * vl_proposta_benef_w) + vl_bonificacao_w);
				vl_retorno_w	:= vl_retorno_w + coalesce(vl_tot_bonificacao_w,0)*-1;
			end if;
			
			if (pls_obter_se_item_lista(ie_tipo_item_w,'15') = 'S') then
				vl_tot_bonificacao_w	:= (((tx_bonificacao_w /100) * vl_proposta_sca_w) + vl_bonificacao_w);
				vl_retorno_w	:= vl_retorno_w + coalesce(vl_tot_bonificacao_w,0)*-1;
			end if;
			
			if (pls_obter_se_item_lista(ie_tipo_item_w,'2') = 'S') then
				vl_tot_bonificacao_w	:= (((tx_bonificacao_w /100) * vl_total_tx_inscricao) + vl_bonificacao_w);
				vl_retorno_w	:= vl_retorno_w + coalesce(vl_tot_bonificacao_w,0)*-1;
			end if;
		elsif (ie_tipo_regra_w = 'D') and (nr_seq_desconto_w IS NOT NULL AND nr_seq_desconto_w::text <> '') then
			
			qt_vidas_w	:= pls_obter_qt_vidas_bonif_prop(nr_seq_proposta_w,nr_seq_boni_sca_p,ie_possui_bonificacao_w);
			
			select	max(tx_desconto)
			into STRICT	tx_desconto_w
			from	pls_preco_regra
			where	nr_seq_regra = nr_seq_desconto_w
			and	qt_vidas_w between coalesce(qt_min_vidas,qt_vidas_w) and coalesce(qt_max_vidas,qt_vidas_w);
			
			if (pls_obter_se_item_lista(ie_tipo_item_w,'1') = 'S') then
				vl_tot_bonificacao_w	:= (((tx_desconto_w /100) * vl_proposta_benef_w));
				vl_retorno_w	:= vl_retorno_w + coalesce(vl_tot_bonificacao_w,0)*-1;
			end if;
			
			if (pls_obter_se_item_lista(ie_tipo_item_w,'15') = 'S') then
				vl_tot_bonificacao_w	:= (((tx_desconto_w /100) * vl_proposta_sca_w));
				vl_retorno_w	:= vl_retorno_w + coalesce(vl_tot_bonificacao_w,0)*-1;
			end if;
			
			if (pls_obter_se_item_lista(ie_tipo_item_w,'2') = 'S') then
				vl_tot_bonificacao_w	:= (((tx_desconto_w /100) * vl_total_tx_inscricao));
				vl_retorno_w	:= vl_retorno_w + coalesce(vl_tot_bonificacao_w,0)*-1;
			end if;
		end if;
		end;
	end loop;
	close C01;
elsif (ie_opcao_p = 'S') then
	select	nr_seq_tabela
	into STRICT	nr_seq_tabela_sca_w
	from	pls_sca_vinculo
	where	nr_sequencia	= nr_seq_boni_sca_p;
	
	open C05;
	loop
	fetch C05 into
		nr_seq_preco_sca_w,
		vl_proposta_sca_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
	end loop;
	close C05;
	
	select	min(nr_sequencia)
	into STRICT	nr_seq_reaj_sca_w
	from	pls_reajuste_preco
	where	nr_seq_preco = nr_seq_preco_sca_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	dt_reajuste > dt_inicio_proposta_w;
	
	if (nr_seq_reaj_sca_w IS NOT NULL AND nr_seq_reaj_sca_w::text <> '') then
		select	coalesce(vl_base,0)
		into STRICT	vl_retorno_w
		from	pls_reajuste_preco
		where	nr_sequencia = nr_seq_reaj_sca_w;
	else	
		vl_retorno_w := vl_proposta_sca_w;
	end if;
elsif (ie_opcao_p	= 'P') then
	vl_retorno_w	:= vl_proposta_benef_w;
elsif (ie_opcao_p	= 'I') then
	
	SELECT * FROM pls_obter_taxa_inscricao(nr_seq_proposta_benef_p, null, null, null, nr_seq_proposta_w, 1, dt_inicio_proposta_w, null, null, nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w) INTO STRICT nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w;
	
	if (ie_taxa_inscricao_w = 'S') then
		if (coalesce(tx_inscricao_w,0) <> 0) then
			vl_retorno_w := dividir((vl_proposta_benef_w * tx_inscricao_w), 100);
		elsif (coalesce(vl_inscricao_w,0) <> 0) then
			vl_retorno_w := vl_inscricao_w;
		end if;
	end if;
elsif (ie_opcao_p	= 'IP') then
	SELECT * FROM pls_obter_taxa_inscricao(nr_seq_proposta_benef_p, null, null, nr_seq_plano_w, null, 1, dt_inicio_proposta_w, null, ie_acao_contrato_w, nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w) INTO STRICT nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w;
	
	if (ie_taxa_inscricao_w = 'S') then
		if (coalesce(tx_inscricao_w,0) <> 0) then
			vl_retorno_w := dividir((vl_proposta_benef_w * tx_inscricao_w), 100);
		elsif (coalesce(vl_inscricao_w,0) <> 0) then
			vl_retorno_w := vl_inscricao_w;
		end if;
	end if;
elsif (ie_opcao_p	= 'AP') then
	vl_retorno_w	:= 0;
	if (ie_tipo_proposta_w = 9) then
		select	max(tx_adaptacao)
		into STRICT	tx_adaptacao_w
		from	pls_regra_adaptacao_plano
		where	cd_estabelecimento	= cd_estabelecimento_w
		and	dt_inicio_proposta_w between dt_inicio_vigencia and fim_dia(coalesce(dt_fim_vigencia,dt_inicio_proposta_w))
		and	((coalesce(nr_seq_grupo_produto::text, '') = '') or (nr_seq_grupo_produto IS NOT NULL AND nr_seq_grupo_produto::text <> '') and (pls_se_grupo_preco_produto(nr_seq_grupo_produto,nr_seq_plano_w)) = 'S');
		
		if (tx_adaptacao_w IS NOT NULL AND tx_adaptacao_w::text <> '') then
			vl_retorno_w	:= dividir((vl_proposta_benef_w * tx_adaptacao_w), 100);
		else
			vl_retorno_w	:= 0;
		end if;
	end if;
elsif (ie_opcao_p	= 'SC') then
	if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
		select	max(nr_seq_tabela)
		into STRICT	nr_seq_tabela_sca_w
		from	pls_sca_regra_contrato
		where	nr_seq_contrato	= nr_seq_contrato_w
		and	nr_seq_plano	= nr_seq_boni_sca_p
		and	dt_inicio_proposta_w between coalesce(dt_inicio_vigencia,dt_inicio_proposta_w) and fim_dia(coalesce(dt_fim_vigencia,dt_inicio_proposta_w))
		and	substr(pls_obter_se_sca_incl_contr(nr_seq_proposta_benef_p,nr_seq_boni_sca_p),1,1) = 'S'
		and	((coalesce(ie_geracao_valores,'B') = ie_beneficiario_titular_w) or coalesce(ie_geracao_valores,'B') = 'B');
		
		if (nr_seq_tabela_sca_w IS NOT NULL AND nr_seq_tabela_sca_w::text <> '') then
			open C05;
			loop
			fetch C05 into
				nr_seq_preco_sca_w,
				vl_proposta_sca_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
			end loop;
			close C05;
			
			select	min(nr_sequencia)
			into STRICT	nr_seq_reaj_sca_w
			from	pls_reajuste_preco
			where	nr_seq_preco = nr_seq_preco_sca_w
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	dt_reajuste > dt_inicio_proposta_w;
			
			if (nr_seq_reaj_sca_w IS NOT NULL AND nr_seq_reaj_sca_w::text <> '') then
				select	coalesce(vl_base,0)
				into STRICT	vl_retorno_w
				from	pls_reajuste_preco
				where	nr_sequencia = nr_seq_reaj_sca_w;
			else	
				vl_retorno_w := vl_proposta_sca_w;
			end if;
		end if;
	end if;
elsif (ie_opcao_p	= 'IC') then
	if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') and (ie_tipo_proposta_w not in (5,9)) then
		
		SELECT * FROM pls_obter_taxa_inscricao(nr_seq_proposta_benef_p, nr_seq_contrato_w, null, null, nr_seq_proposta_w, 1, dt_inicio_proposta_w, null, ie_acao_contrato_w, nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w) INTO STRICT nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w;
		
		if (ie_taxa_inscricao_w = 'S') then
			if (coalesce(tx_inscricao_w,0) <> 0) then
				vl_retorno_w := dividir((vl_proposta_benef_w * tx_inscricao_w), 100);
			elsif (coalesce(vl_inscricao_w,0) <> 0) then
				vl_retorno_w := vl_inscricao_w;
			end if;
		end if;
	end if;
elsif (ie_opcao_p	= 'VC') then
	SELECT * FROM pls_obter_regra_via_adic(nr_seq_contrato_w, null, nr_seq_plano_w, 1, 'N', wheb_usuario_pck.get_nm_usuario, cd_estabelecimento_w, clock_timestamp(), nr_seq_regra_w, vl_via_carteira_w, tx_via_carteira_w) INTO STRICT nr_seq_regra_w, vl_via_carteira_w, tx_via_carteira_w;
	
	if (coalesce(tx_via_carteira_w,0) <> 0) then
		vl_retorno_w := coalesce(vl_via_carteira_w,0)+dividir((vl_proposta_benef_w * tx_via_carteira_w), 100);
	elsif (coalesce(vl_via_carteira_w,0) <> 0) then
		vl_retorno_w := vl_via_carteira_w;
	end if;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valores_propostas ( nr_seq_proposta_benef_p bigint, nr_seq_boni_sca_p bigint, ie_opcao_p text) FROM PUBLIC;
