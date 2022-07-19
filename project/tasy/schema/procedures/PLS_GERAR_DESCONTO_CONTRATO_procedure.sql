-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_desconto_contrato ( nr_seq_contrato_p bigint, dt_reajuste_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


qt_registro_contrato_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_titular_w		bigint;
nr_seq_parentesco_w		bigint;
nr_segurado_preco_w		bigint;
vl_desconto_w			double precision;
vl_preco_atual_w		double precision;
vl_desconto_atual_w		double precision;
vl_preco_ant_w			double precision;
nr_seq_regra_desconto_w		bigint;
nr_seq_regra_atual_w		bigint;
nr_seq_seg_preco_w		bigint;
qt_idade_w			smallint;
dt_reajuste_w			timestamp;
cd_motivo_reajuste_w		varchar(2);
tx_desconto_w			double precision;
nr_seq_plano_w			bigint;
nr_seq_tabela_w			bigint;
nr_seq_tabela_seg_preco_w	bigint;
nr_seq_preco_w			bigint;
nr_seq_reajuste_w		bigint;
nr_seq_lote_reajuste_w		bigint;
nr_seq_lote_w			bigint;
vl_minimo_mensalidade_w		double precision;
vl_adaptacao_w			double precision;

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_plano,
		a.nr_seq_tabela
	from	pls_segurado	a,
		pls_contrato	b
	where	a.nr_seq_contrato	= b.nr_sequencia
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	coalesce(a.dt_rescisao::text, '') = ''
	and	b.nr_sequencia	= nr_seq_contrato_p;


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_segurado_w,
	nr_seq_plano_w,
	nr_seq_tabela_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select 	max(nr_sequencia)
	into STRICT	nr_seq_seg_preco_w
	from	pls_segurado_preco
	where	nr_seq_segurado = nr_seq_segurado_w;

	if (nr_seq_seg_preco_w > 0) then
		select	coalesce(vl_preco_atual,0),
			coalesce(vl_desconto,0),
			coalesce(nr_seq_regra,0),
			qt_idade,
			coalesce(vl_preco_ant,0),
			dt_reajuste,
			cd_motivo_reajuste,
			dividir_sem_round(vl_desconto, vl_preco_atual)*100,
			nr_seq_tabela,
			nr_seq_preco,
			nr_seq_reajuste,
			nr_seq_lote_reajuste,
			nr_seq_lote,
			vl_minimo_mensalidade,
			vl_adaptacao
		into STRICT	vl_preco_atual_w,
			vl_desconto_atual_w,
			nr_seq_regra_atual_w,
			qt_idade_w,
			vl_preco_ant_w,
			dt_reajuste_w,
			cd_motivo_reajuste_w,
			tx_desconto_w,
			nr_seq_tabela_seg_preco_w,
			nr_seq_preco_w,
			nr_seq_reajuste_w,
			nr_seq_lote_reajuste_w,
			nr_seq_lote_w,
			vl_minimo_mensalidade_w,
			vl_adaptacao_w
		from	pls_segurado_preco
		where 	nr_sequencia	= nr_seq_seg_preco_w
		and	nr_seq_segurado	= nr_seq_segurado_w;

		SELECT * FROM pls_obter_regra_desconto(nr_seq_segurado_w, 1, cd_estabelecimento_p, vl_desconto_w, nr_seq_regra_desconto_w) INTO STRICT vl_desconto_w, nr_seq_regra_desconto_w;

		if 	((coalesce(nr_seq_regra_atual_w,0) <> coalesce(nr_seq_regra_desconto_w,0)) or (coalesce(tx_desconto_w,0) <> coalesce(vl_desconto_w,0))) then
			select	nextval('pls_segurado_preco_seq')
			into STRICT	nr_segurado_preco_w
			;

			insert into pls_segurado_preco(nr_sequencia, dt_atualizacao, nm_usuario,
				dt_reajuste, nr_seq_segurado, vl_preco_atual,
				vl_preco_ant, qt_idade, cd_motivo_reajuste,
				ds_observacao, vl_desconto, nr_seq_regra,
				dt_liberacao, nm_usuario_liberacao, vl_preco_nao_subsid_desc,
				nr_seq_tabela, nr_seq_preco, nr_seq_reajuste,
				nr_seq_lote_reajuste, nr_seq_lote, vl_minimo_mensalidade,
				vl_adaptacao,ie_situacao)
			values (	nr_segurado_preco_w, clock_timestamp(), nm_usuario_p,
				coalesce(dt_reajuste_p,clock_timestamp()), nr_seq_segurado_w, vl_preco_atual_w,
				vl_preco_atual_w, qt_idade_w, 'M',
				'Desconto gerado', coalesce(vl_desconto_w,0), nr_seq_regra_desconto_w,
				clock_timestamp() + interval '86401 days'/86400, nm_usuario_p, 0,
				nr_seq_tabela_w, nr_seq_preco_w, nr_seq_reajuste_w,
				nr_seq_lote_reajuste_w, nr_seq_lote_w, vl_minimo_mensalidade_w,
				vl_adaptacao_w,'A');

			/* Felipe - Geração do desconto - comentei a rotina PLS_GERAR_DESCONTO_BENEF acima */

			CALL pls_gerar_desc_beneficiario(nr_segurado_preco_w, vl_preco_atual_w, nm_usuario_p, cd_estabelecimento_p, 'N');
		end if;
	end if;
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_desconto_contrato ( nr_seq_contrato_p bigint, dt_reajuste_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

