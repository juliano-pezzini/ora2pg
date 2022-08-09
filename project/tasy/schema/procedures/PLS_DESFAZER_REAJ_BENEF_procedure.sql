-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_reaj_benef ( nr_seq_reajuste_p bigint, ie_opcao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_segurado_w		bigint;
nr_seq_tabela_w			bigint;
nr_seq_contrato_w		bigint;
ie_geracao_valores_w		varchar(1);
nr_seq_titular_w		bigint;
qt_idade_w			bigint;
nr_seq_seg_preco_w		bigint;
nr_seq_reajuste_w		bigint;
vl_preco_atual_w		double precision;
vl_preco_ant_w			double precision;
pr_reajuste_w			double precision;
vl_nao_subsidiado_w		double precision;
ds_indice_w			varchar(255);
dt_reajuste_w			timestamp;
nr_seq_preco_w			bigint;
vl_preco_w			double precision;
vl_diferenca_w			double precision;
nr_seq_segurado_preco_w		bigint;
vl_adaptacao_w			double precision;
nr_seq_seg_preco_origem_w	bigint;
nr_seq_segurado_preco_origem_w	bigint;
ie_seg_sca_w			varchar(1);
nm_pessoa_fisica_w		varchar(255);
ie_grau_parentesco_w		varchar(2);
ie_calculo_vidas_w		varchar(2);
ie_preco_vidas_contrato_w	varchar(1);
qt_vidas_w			bigint	:= 0;
nr_seq_vinculo_sca_w		bigint;

C01 CURSOR FOR
	SELECT  'B' ie_seg_sca,
		b.nr_sequencia,
		b.nr_seq_tabela,
		c.nr_sequencia,
		c.ie_geracao_valores,
		b.nr_seq_titular,
		(obter_idade(a.dt_nascimento,fim_mes(dt_reajuste_w),'A'))::numeric ,
		a.nm_pessoa_fisica,
		null
	from	pessoa_fisica	a,
		pls_segurado	b,
		pls_contrato	c,
		pls_plano	d
	where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	d.nr_sequencia		= b.nr_seq_plano
	and	c.nr_sequencia		= b.nr_seq_contrato
	and	d.ie_preco in ('1','4')
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and	((d.ie_tipo_contratacao	= 'I') or (coalesce(d.ie_tipo_contratacao::text, '') = ''))
	and	exists (	SELECT	1
			from	pls_reajuste_tabela y
			where	y.nr_seq_tabela		= b.nr_seq_tabela
			and	y.nr_seq_reajuste	= nr_seq_reajuste_p)
	and	not exists (	select	1
				from	pls_segurado_preco x
				where	x.nr_seq_segurado	= b.nr_sequencia
				and	x.nr_seq_lote_reajuste	= nr_seq_reajuste_p)
	
union all

	select  'S' ie_seg_sca,
		b.nr_sequencia,
		e.nr_seq_tabela,
		c.nr_sequencia,
		c.ie_geracao_valores,
		b.nr_seq_titular,
		(obter_idade(a.dt_nascimento,fim_mes(dt_reajuste_w),'A'))::numeric ,
		a.nm_pessoa_fisica,
		e.nr_sequencia
	from	pessoa_fisica	a,
		pls_sca_vinculo	e,
		pls_segurado	b,
		pls_contrato	c
	where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	e.nr_seq_segurado	= b.nr_sequencia
	and	c.nr_sequencia		= b.nr_seq_contrato
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and	exists (	select	1
			from	pls_reajuste_tabela y
			where	y.nr_seq_tabela		= e.nr_seq_tabela
			and	y.nr_seq_reajuste	= nr_seq_reajuste_p)
	and	not exists (	select	1
				from	pls_segurado_preco_origem x
				where	x.nr_seq_segurado	= b.nr_sequencia
				and	x.nr_seq_reajuste	= nr_seq_reajuste_p);

c02 CURSOR FOR 		-- select das faixas etarias
	SELECT	a.nr_sequencia,
		a.vl_preco_atual
	from	pls_plano_preco a
	where	qt_idade_w	>= qt_idade_inicial
	and	qt_idade_w	<= qt_idade_final
	and	nr_seq_tabela	= nr_seq_tabela_w
	and	coalesce(ie_grau_titularidade,ie_grau_parentesco_w)	= ie_grau_parentesco_w
	and	qt_vidas_w between coalesce(qt_vidas_inicial,qt_vidas_w) and coalesce(qt_vidas_final,qt_vidas_w)
	order	by	coalesce(ie_grau_titularidade,' ');


BEGIN

select	dt_reajuste
into STRICT	dt_reajuste_w
from	pls_reajuste
where	nr_sequencia	= nr_seq_reajuste_p;

if (ie_opcao_p	= 'A') then
	open c01;
	loop
	fetch c01 into
		ie_seg_sca_w,
		nr_seq_segurado_w,
		nr_seq_tabela_w,
		nr_seq_contrato_w,
		ie_geracao_valores_w,
		nr_seq_titular_w,
		qt_idade_w,
		nm_pessoa_fisica_w,
		nr_seq_vinculo_sca_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (ie_seg_sca_w = 'S') then
			ie_grau_parentesco_w	:= coalesce(substr(pls_obter_garu_dependencia_seg(nr_seq_segurado_w,'C'),1,2),'X');

			select	max(nr_sequencia)
			into STRICT	nr_seq_seg_preco_origem_w
			from	pls_segurado_preco_origem
			where	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	nr_seq_segurado	= nr_seq_segurado_w
			and	dt_reajuste = (	SELECT	max(dt_reajuste)
						from	pls_segurado_preco
						where	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
						and	nr_seq_segurado	= nr_seq_segurado_w);

			if (coalesce(nr_seq_seg_preco_origem_w,0) <> 0) then
				select	max(qt_idade)
				into STRICT	qt_idade_w
				from	pls_segurado_preco_origem
				where	nr_sequencia	= nr_seq_seg_preco_origem_w;
			end if;

			if (qt_idade_w > 999) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort( 186269, 'NR_SEQ_SEGURADO='||nr_seq_segurado_w||';NM_SEGURADO='||nm_pessoa_fisica_w||';QT_IDADE='||qt_idade_w );
				/* O beneficiário #@NR_SEQ_SEGURADO#@ - #@NM_SEGURADO#@ possui #@QT_IDADE#@ anos. Verifique. */

			end if;

			begin
			select	coalesce(ie_preco_vidas_contrato,'N'),
				coalesce(ie_calculo_vidas,'A')
			into STRICT	ie_preco_vidas_contrato_w,
				ie_calculo_vidas_w
			from	pls_tabela_preco
			where	nr_sequencia	= nr_seq_tabela_w;
			exception
			when others then
				ie_calculo_vidas_w	:= 'A';
			end;

			if (ie_preco_vidas_contrato_w = 'S') then
				if (ie_calculo_vidas_w = 'A') then
					select	count(*)
					into STRICT	qt_vidas_w
					from	pls_segurado
					where	nr_seq_contrato = nr_seq_contrato_w
					and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
					and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > dt_reajuste_w));
				elsif (ie_calculo_vidas_w = 'T') then
					select	count(*)
					into STRICT	qt_vidas_w
					from	pls_segurado
					where	nr_seq_contrato = nr_seq_contrato_w
					and	coalesce(nr_seq_titular::text, '') = ''
					and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
					and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > dt_reajuste_w));
				elsif (ie_calculo_vidas_w = 'D') then
					select	count(*)
					into STRICT	qt_vidas_w
					from	pls_segurado
					where	nr_seq_contrato = nr_seq_contrato_w
					and	(nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '')
					and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
					and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > dt_reajuste_w));
				elsif (ie_calculo_vidas_w = 'TD') then
					select	count(*)
					into STRICT	qt_vidas_w
					from	pls_segurado a
					where	a.nr_seq_contrato = nr_seq_contrato_w
					and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
					and	((coalesce(a.dt_rescisao::text, '') = '') or (a.dt_rescisao > dt_reajuste_w))
					and	((coalesce(nr_seq_titular::text, '') = '') or ((nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '') and ((SELECT	count(*)
														from	grau_parentesco x
														where	x.nr_sequencia = a.nr_seq_parentesco
														and	x.ie_tipo_parentesco = '1') > 0)));
				elsif (ie_calculo_vidas_w = 'F') then
					qt_vidas_w	:= coalesce(pls_obter_qt_familia_benef(nr_seq_segurado_w,nr_seq_titular_w,'L',dt_reajuste_w),0);
				end if;
			else
				qt_vidas_w	:= 1;
			end if;

			open C02;
			loop
			fetch C02 into
				nr_seq_preco_w,
				vl_preco_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
			end loop;
			close C02;

			if (coalesce(nr_seq_preco_w::text, '') = '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort( 192352, 'QT_IDADE=' || qt_idade_w || ';NR_SEQ_TABELA=' + nr_seq_tabela_w );
				/*Faixa etária incompatível com idade do beneficiário.
				Idade: '|| qt_idade_w || chr(13) ||'Tabela: ' || to_char(nr_seq_tabela_w) */
			end if;

			select	max(nr_sequencia)
			into STRICT	nr_seq_reajuste_w
			from	pls_reajuste_preco
			where	nr_seq_preco	= nr_seq_preco_w
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	dt_reajuste_w between dt_periodo_inicial and fim_dia(dt_periodo_final);

			if (coalesce(nr_seq_reajuste_w,0) = 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort( 192353, 'NM_SEGURADO=' || substr(pls_obter_dados_segurado(nr_seq_segurado_w,'N'),1,255) );
				/*Reajuste não calculado para o beneficiário: ' || substr(pls_obter_dados_segurado(nr_seq_segurado_w,'N'),1,255) || chr(13) ||
				Não existe um reajuste válido para este período na tabela do beneficiário. Verifique! */
			else
				if 	((ie_geracao_valores_w = 'T' and coalesce(nr_seq_titular_w::text, '') = '')
					or (ie_geracao_valores_w = 'D' and (nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> ''))
					or (ie_geracao_valores_w = 'B')) then

					select	coalesce(vl_reajustado,0),
						coalesce(vl_base,0),
						coalesce(pr_reajustado,0),
						coalesce(vl_preco_nao_subsidiado,0),
						substr(pls_obter_desc_indice_reaj(obter_descricao_padrao('PLS_REAJUSTE','IE_INDICE_REAJUSTE',nr_seq_reajuste)),1,255),
						vl_adaptacao
					into STRICT	vl_preco_atual_w,
						vl_preco_ant_w,
						pr_reajuste_w,
						vl_nao_subsidiado_w,
						ds_indice_w,
						vl_adaptacao_w
					from	pls_reajuste_preco
					where	nr_sequencia	= nr_seq_reajuste_w;

					vl_diferenca_w := (coalesce(vl_preco_ant_w,0) * coalesce(pr_reajuste_w,0)) / 100;
					vl_nao_subsidiado_w	:= vl_nao_subsidiado_w + ((vl_nao_subsidiado_w * pr_reajuste_w) / 100);

					select	nextval('pls_segurado_preco_origem_seq')
					into STRICT	nr_seq_segurado_preco_origem_w
					;

					insert into pls_segurado_preco_origem(nr_sequencia, dt_atualizacao, nm_usuario,
						dt_reajuste, nr_seq_segurado, vl_preco_atual,
						vl_preco_ant, qt_idade, cd_motivo_reajuste,
						ds_observacao, nr_seq_reajuste_preco, nr_seq_reajuste,
						nr_seq_tabela, tx_reajuste, vl_reajuste, nr_seq_preco,
						cd_estabelecimento, nr_seq_vinculo_sca)
					values (	nr_seq_segurado_preco_origem_w, clock_timestamp(), nm_usuario_p,
						dt_reajuste_w, nr_seq_segurado_w, coalesce(vl_preco_atual_w,0),
						coalesce(vl_preco_ant_w,0), qt_idade_w, 'I',
						to_char(pr_reajuste_w) || '% de reajuste - ' || ds_indice_w, CASE WHEN nr_seq_reajuste_w=0 THEN null  ELSE nr_seq_reajuste_w END , nr_seq_reajuste_p,
						nr_seq_tabela_w, coalesce(pr_reajuste_w,0), coalesce(vl_diferenca_w,0), nr_seq_preco_w,
						cd_estabelecimento_p, nr_seq_vinculo_sca_w);
				end if;
			end if;
		else
			CALL pls_preco_beneficiario_pck.atualizar_reajuste_benef(nr_seq_segurado_w, dt_reajuste_w, nr_seq_reajuste_p, null, 'S', nm_usuario_p, cd_estabelecimento_p);
		end if;
		end;
	end loop;
	close c01;
elsif (ie_opcao_p	= 'D') then
	delete	from	pls_segurado_preco
	where	nr_seq_lote_reajuste	= nr_seq_reajuste_p;

	delete	from	pls_segurado_preco_origem
	where	nr_seq_reajuste		= nr_seq_reajuste_p;
elsif (ie_opcao_p	= 'L') then
	update	pls_segurado_preco
	set	dt_liberacao		= clock_timestamp(),
		nm_usuario_liberacao	= nm_usuario_p
	where	nr_seq_lote_reajuste	= nr_seq_reajuste_p;

	update	pls_segurado_preco_origem
	set	dt_liberacao		= clock_timestamp(),
		nm_usuario_liberacao	= nm_usuario_p
	where	nr_seq_reajuste		= nr_seq_reajuste_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_reaj_benef ( nr_seq_reajuste_p bigint, ie_opcao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
