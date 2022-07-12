-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_total_proposta_benef ( nr_seq_proposta_benef_p bigint) RETURNS bigint AS $body$
DECLARE


vl_retorno_w			double precision := 0;
nr_seq_tabela_sca_w		bigint;
vl_bonificacao_w		double precision := 0;
vl_tot_bonificacao_w		double precision := 0;
vl_bonific_w			double precision := 0;
qt_idade_benef_w		smallint;
cd_beneficiario_w		varchar(15);
vl_proposta_benef_w		double precision := 0;
vl_proposta_sca_w		double precision := 0;
vl_tot_sca_w			double precision := 0;
nr_seq_bonificacao_w		bigint;
nr_seq_sca_w			bigint;
nr_seq_proposta_w		bigint;
nr_seq_proposta_bonif_w		bigint;
vl_bonificacao_propos_w		double precision := 0;
vl_tot_bonif_propos_w		double precision := 0;
tx_desconto_w			double precision := 0;
nr_seq_regra_desconto_w		bigint;
cd_estabelecimento_w		integer;
dt_inicio_proposta_w		timestamp;
nr_seq_regra_w			bigint;
vl_inscricao_w			double precision := 0;
tx_inscricao_w			double precision;
ie_taxa_inscricao_w		varchar(3);
nr_seq_plano_w			bigint;
ie_tipo_proposta_w		bigint;
vl_total_tx_inscricao_w		double precision;
vl_adaptacao_plano_w		double precision;
nr_contrato_w			bigint;
nr_seq_contrato_w		bigint;
ie_beneficiario_titular_w	varchar(10);
vl_total_sca_contrato_w		double precision := 0;
ie_calcula_valor_sca_contr_w	varchar(10);
ie_acao_contrato_w		varchar(10);
qt_registros_w			bigint;
vl_via_carteira_w		double precision;
nr_seq_preco_sca_w		pls_plano_preco.nr_sequencia%type;
nr_seq_reaj_sca_w		pls_reajuste_preco.nr_sequencia%type;
vl_sca_w			pls_plano_preco.vl_preco_atual%type;
ie_grau_parentesco_w		varchar(2);

C00 CURSOR FOR
	SELECT	a.nr_seq_bonificacao
	from	pls_bonificacao_vinculo		a,
		pls_proposta_beneficiario	b
	where	a.nr_seq_segurado_prop	= b.nr_sequencia
	and	b.nr_sequencia		= nr_seq_proposta_benef_p;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_sca_vinculo			a,
		pls_proposta_beneficiario	b
	where	a.nr_seq_benef_proposta	= b.nr_sequencia
	and	b.nr_sequencia		= nr_seq_proposta_benef_p;

C04 CURSOR FOR
	SELECT	a.nr_seq_bonificacao
	from	pls_bonificacao_vinculo		a,
		pls_proposta_adesao		b
	where	a.nr_seq_proposta		= b.nr_sequencia
	and	b.nr_sequencia			= nr_seq_proposta_w
	
union all

	SELECT	a.nr_seq_bonificacao
	from	pls_bonificacao_vinculo		a
	where	a.nr_seq_contrato	= nr_seq_contrato_w;

C05 CURSOR FOR
	SELECT	nr_seq_tabela
	from	pls_sca_regra_contrato
	where	nr_seq_contrato	= nr_seq_contrato_w
	and	dt_inicio_proposta_w between coalesce(dt_inicio_vigencia,dt_inicio_proposta_w) and fim_dia(coalesce(dt_fim_vigencia,dt_inicio_proposta_w))
	and	((coalesce(ie_geracao_valores,'B') = ie_beneficiario_titular_w) or coalesce(ie_geracao_valores,'B') = 'B')
	and	((nr_seq_plano_benef	= nr_seq_plano_w) or (coalesce(nr_seq_plano_benef::text, '') = ''));

C06 CURSOR FOR
	SELECT	nr_sequencia,
		coalesce(vl_preco_atual,0)
	from	pls_plano_preco
	where	nr_seq_tabela = nr_seq_tabela_sca_w
	and	qt_idade_benef_w between qt_idade_inicial and qt_idade_final
	and	coalesce(ie_grau_titularidade,ie_grau_parentesco_w)	= ie_grau_parentesco_w
	order	by coalesce(ie_grau_titularidade,' ');


BEGIN

select	b.cd_beneficiario,
	b.nr_seq_proposta,
	b.ie_taxa_inscricao,
	a.nr_seq_contrato,
	CASE WHEN coalesce(nr_seq_titular::text, '') = '' THEN CASE WHEN coalesce(nr_seq_titular_contrato::text, '') = '' THEN 'T'  ELSE 'D' END   ELSE 'D' END
into STRICT	cd_beneficiario_w,
	nr_seq_proposta_w,
	ie_taxa_inscricao_w,
	nr_contrato_w,
	ie_beneficiario_titular_w
from	pls_proposta_beneficiario	b,
	pls_proposta_adesao		a
where	a.nr_sequencia	= b.nr_seq_proposta
and	b.nr_sequencia	= nr_seq_proposta_benef_p
and	((coalesce(b.dt_cancelamento::text, '') = '')
or (b.dt_cancelamento > a.dt_inicio_proposta));

select	ie_tipo_proposta,
	dt_inicio_proposta
into STRICT	ie_tipo_proposta_w,
	dt_inicio_proposta_w
from	pls_proposta_adesao
where	nr_sequencia	= nr_seq_proposta_w;


select	substr(Obter_Idade_PF(cd_beneficiario_w,dt_inicio_proposta_w,'A'),1,3)
into STRICT	qt_idade_benef_w
;

if (ie_tipo_proposta_w in (1,6,7)) then
	ie_acao_contrato_w	:= 'A';
elsif (ie_tipo_proposta_w in (2,8)) then
	ie_acao_contrato_w	:= 'L';
elsif (ie_tipo_proposta_w in (3,4,7,8)) then
	ie_acao_contrato_w	:= 'M';
end if;

select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	pls_proposta_adesao
where	nr_sequencia	= nr_seq_proposta_w;

if (nr_contrato_w IS NOT NULL AND nr_contrato_w::text <> '') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_contrato_w
	from	pls_contrato
	where	nr_contrato	= nr_contrato_w;
end if;

ie_calcula_valor_sca_contr_w	:= coalesce(obter_valor_param_usuario(1232, 77, Obter_Perfil_Ativo, wheb_usuario_pck.get_nm_usuario, cd_estabelecimento_w), 'N');

if (ie_tipo_proposta_w = 5) then
	open C01;
	loop
	fetch C01 into
		nr_seq_sca_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	nr_seq_tabela
		into STRICT	nr_seq_tabela_sca_w
		from	pls_sca_vinculo
		where	nr_sequencia	= nr_seq_sca_w;
		
		select	a.vl_preco_atual
		into STRICT	vl_proposta_sca_w
		from	pls_plano_preco		a,
			pls_tabela_preco	b
		where	a.nr_seq_tabela	= b.nr_sequencia
		and	b.nr_sequencia	= nr_seq_tabela_sca_w
		and	qt_idade_benef_w	between a.qt_idade_inicial and a.qt_idade_final;
		
		vl_tot_sca_w	:= vl_tot_sca_w + vl_proposta_sca_w;
		end;
	end loop;
	close C01;
	
	vl_retorno_w := vl_tot_sca_w;
else
	ie_grau_parentesco_w := coalesce(substr(pls_obter_garu_dependencia_seg(nr_seq_proposta_benef_p,'P'),1,2),'X');
	
	select	nr_seq_plano
	into STRICT	nr_seq_plano_w
	from	pls_proposta_beneficiario
	where	nr_sequencia = nr_seq_proposta_benef_p;
	
	vl_proposta_benef_w	:= coalesce(pls_obter_valores_propostas(nr_seq_proposta_benef_p,null,'P'),0);
	
	/* Desconto ja e reduzido do valor na function PLS_OBTER_VALORES_PROPOSTAS - ebcabral - OS 714755 - 24/03/2014
	pls_obter_regra_desconto(nr_seq_proposta_benef_p, 2, cd_estabelecimento_w, tx_desconto_w, nr_seq_regra_desconto_w);
	
	vl_proposta_benef_w	:= vl_proposta_benef_w - dividir((vl_proposta_benef_w * tx_desconto_w), 100); */
	
	open C01;
	loop
	fetch C01 into
		nr_seq_sca_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	nr_seq_tabela
		into STRICT	nr_seq_tabela_sca_w
		from	pls_sca_vinculo
		where	nr_sequencia	= nr_seq_sca_w;
		
		open C06;
		loop
		fetch C06 into
			nr_seq_preco_sca_w,
			vl_proposta_sca_w;
		EXIT WHEN NOT FOUND; /* apply on C06 */
		end loop;
		close C06;
		
		select	min(nr_sequencia)
		into STRICT	nr_seq_reaj_sca_w
		from	pls_reajuste_preco
		where	nr_seq_preco = nr_seq_preco_sca_w
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	dt_reajuste > dt_inicio_proposta_w;
		
		if (nr_seq_reaj_sca_w IS NOT NULL AND nr_seq_reaj_sca_w::text <> '') then
			select	coalesce(vl_base,0)
			into STRICT	vl_sca_w
			from	pls_reajuste_preco
			where	nr_sequencia = nr_seq_reaj_sca_w;
		else
			vl_sca_w := vl_proposta_sca_w;
		end if;
		
		vl_tot_sca_w := vl_tot_sca_w + vl_sca_w;
		end;
	end loop;
	close C01;
	
	open C00;
	loop
	fetch C00 into
		nr_seq_bonificacao_w;
	EXIT WHEN NOT FOUND; /* apply on C00 */
		begin
		
		vl_bonific_w		:= coalesce(pls_obter_valores_propostas(nr_seq_proposta_benef_p,nr_seq_bonificacao_w,'B'),0);
		vl_tot_bonificacao_w	:= vl_tot_bonificacao_w + coalesce(vl_bonific_w,0);
		
		end;
	end loop;
	close C00;
	
	open C04;
	loop
	fetch C04 into
		nr_seq_proposta_bonif_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		vl_bonificacao_propos_w	:= pls_obter_valor_bonif_tot_prop(nr_seq_proposta_w,nr_seq_proposta_bonif_w,nr_seq_proposta_benef_p);
		vl_tot_bonif_propos_w	:= vl_tot_bonif_propos_w + vl_bonificacao_propos_w;
		end;
	end loop;
	close C04;
	
	if (ie_taxa_inscricao_w = 'S') and (ie_tipo_proposta_w <> 9) then
		
		qt_registros_w	:= 0;
		
		if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
			select	count(1)
			into STRICT	qt_registros_w
			from	pls_regra_inscricao
			where	nr_seq_contrato	= nr_seq_contrato_w;
		end if;
		
		if (qt_registros_w = 0) then
			SELECT * FROM pls_obter_taxa_inscricao(nr_seq_proposta_benef_p, null, null, nr_seq_plano_w, nr_seq_proposta_w, 1, dt_inicio_proposta_w, null, ie_acao_contrato_w, nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w) INTO STRICT nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w;
		else
			SELECT * FROM pls_obter_taxa_inscricao(nr_seq_proposta_benef_p, nr_seq_contrato_w, null, null, nr_seq_proposta_w, 1, dt_inicio_proposta_w, null, ie_acao_contrato_w, nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w) INTO STRICT nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w;
		end if;
		
		if (coalesce(tx_inscricao_w,0) <> 0) then
			vl_inscricao_w := dividir((vl_proposta_benef_w * tx_inscricao_w), 100);
		end if;
	end if;
	
	
	vl_adaptacao_plano_w	:= coalesce(pls_obter_valores_propostas(nr_seq_proposta_benef_p,0,'AP'),0);
	
	if (ie_calcula_valor_sca_contr_w = 'S') and (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
		open C05;
		loop
		fetch C05 into
			nr_seq_tabela_sca_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin
			open C06;
			loop
			fetch C06 into
				nr_seq_preco_sca_w,
				vl_proposta_sca_w;
			EXIT WHEN NOT FOUND; /* apply on C06 */
			end loop;
			close C06;
			
			select	min(nr_sequencia)
			into STRICT	nr_seq_reaj_sca_w
			from	pls_reajuste_preco
			where	nr_seq_preco = nr_seq_preco_sca_w
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	dt_reajuste > dt_inicio_proposta_w;
			
			if (nr_seq_reaj_sca_w IS NOT NULL AND nr_seq_reaj_sca_w::text <> '') then
				select	coalesce(vl_base,0)
				into STRICT	vl_sca_w
				from	pls_reajuste_preco
				where	nr_sequencia = nr_seq_reaj_sca_w;
			else
				vl_sca_w := vl_proposta_sca_w;
			end if;
			
			vl_total_sca_contrato_w	:= vl_total_sca_contrato_w + vl_sca_w;
			end;
		end loop;
		close C05;
	end if;
	if (ie_tipo_proposta_w not in (5,9)) then
		vl_via_carteira_w	:= coalesce(pls_obter_valores_propostas(nr_seq_proposta_benef_p,null,'VC'),0);
	else
		vl_via_carteira_w	:= 0;
	end if;
	
	vl_retorno_w		:=	vl_tot_sca_w + coalesce(vl_tot_bonificacao_w,0) + vl_proposta_benef_w +
					vl_tot_bonif_propos_w + coalesce(vl_inscricao_w,0) + coalesce(vl_adaptacao_plano_w,0) +
					coalesce(vl_total_sca_contrato_w,0) + coalesce(vl_via_carteira_w,0);
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_total_proposta_benef ( nr_seq_proposta_benef_p bigint) FROM PUBLIC;

