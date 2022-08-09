-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_regra_autom ( nr_seq_contrato_p bigint, nr_seq_proposta_p bigint, nr_seq_simulacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ie_contrato_w			varchar(1)	:= 'N';
ie_proposta_w			varchar(1)	:= 'N';
ie_tipo_estipulante_w		varchar(2);
nr_seq_regra_w			bigint	:= 0;
nr_seq_regra_desconto_w		bigint;
nr_seq_contrato_w		bigint;
nr_seq_proposta_w		bigint;
nr_seq_preco_regra_w		bigint;
dt_vigencia_w			timestamp;
qt_registro_w			integer	:= 0;
nr_seq_plano_w			bigint;

C01 CURSOR FOR
	SELECT	nr_seq_regra
	from	pls_preco_regra_autom
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	ie_situacao		= 'A'
	and	dt_vigencia_w between trunc(dt_inicio_vigencia,'dd') and fim_dia(coalesce(dt_fim_vigencia,dt_vigencia_w))
	and	((ie_contrato = ie_contrato_w) or (ie_proposta = ie_proposta_w))
	and	((ie_tipo_estipulante = ie_tipo_estipulante_w) or (coalesce(ie_tipo_estipulante_w::text, '') = ''))
	and	coalesce(nr_seq_plano::text, '') = ''
	
union

	SELECT	nr_seq_regra
	from	pls_preco_regra_autom
	where	cd_estabelecimento	= 1
	and	ie_situacao		= 'A'
	and	nr_seq_plano		= nr_seq_plano_w
	and	dt_vigencia_w between trunc(dt_inicio_vigencia,'dd') and fim_dia(coalesce(dt_fim_vigencia,dt_vigencia_w))
	and	((ie_contrato = ie_contrato_w) or (ie_proposta = ie_proposta_w))
	and	((ie_tipo_estipulante = ie_tipo_estipulante_w) or (coalesce(ie_tipo_estipulante_w::text, '') = ''));

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_preco_regra
	where	nr_seq_regra	= nr_seq_regra_w;


BEGIN

if (coalesce(nr_seq_contrato_p,0) <> 0) then
	ie_contrato_w		:= 'S';
	nr_seq_contrato_w	:= nr_seq_contrato_p;

	select	CASE WHEN coalesce(cd_pf_estipulante::text, '') = '' THEN 'PJ'  ELSE 'PF' END ,
		dt_contrato
	into STRICT	ie_tipo_estipulante_w,
		dt_vigencia_w
	from	pls_contrato
	where	nr_sequencia	= nr_seq_contrato_p;

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_regra_desconto
	where	nr_seq_contrato	= nr_seq_contrato_p;
elsif (coalesce(nr_seq_proposta_p,0) <> 0) then
	ie_proposta_w		:= 'S';
	nr_seq_proposta_w	:= nr_seq_proposta_p;

	select	CASE WHEN coalesce(cd_estipulante::text, '') = '' THEN 'PJ'  ELSE 'PF' END ,
		dt_inicio_proposta
	into STRICT	ie_tipo_estipulante_w,
		dt_vigencia_w
	from	pls_proposta_adesao
	where	nr_sequencia	= nr_seq_proposta_p;

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_regra_desconto
	where	nr_seq_proposta	= nr_seq_proposta_p;
elsif (coalesce(nr_seq_simulacao_p,0) <> 0) then
	select	dt_simulacao
	into STRICT	dt_vigencia_w
	from	pls_simulacao_preco
	where	nr_sequencia	= nr_seq_simulacao_p;
end if;

select	max(nr_seq_plano)
into STRICT	nr_seq_plano_w
from (	SELECT	nr_seq_plano
		from	pls_contrato_plano
		where	nr_seq_contrato	= nr_seq_contrato_w
		
union

		SELECT	nr_seq_plano
		from	pls_proposta_plano
		where	nr_seq_proposta	= nr_seq_proposta_w) alias1;

if (qt_registro_w	= 0) then /* Felipe - OS 141052 */
	open C01;
	loop
	fetch C01 into
		nr_seq_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;

	if (nr_seq_regra_w	> 0) then
		select	nextval('pls_regra_desconto_seq')
		into STRICT	nr_seq_regra_desconto_w
		;

		insert into pls_regra_desconto(nr_sequencia, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, ds_regra,
			nr_seq_contrato, ie_situacao, dt_inicio_vigencia,
			dt_fim_vigencia, ie_tipo_regra, nr_seq_proposta,
			cd_estabelecimento)
		(SELECT	nr_seq_regra_desconto_w, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, ds_regra,
			nr_seq_contrato_w, ie_situacao, coalesce(dt_inicio_vigencia,clock_timestamp()),
			dt_fim_vigencia, ie_tipo_regra, nr_seq_proposta_w,
			cd_estabelecimento_p
		from	pls_regra_desconto
		where	nr_sequencia	= nr_seq_regra_w);

		open C02;
		loop
		fetch C02 into
			nr_seq_preco_regra_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			insert into pls_preco_regra(nr_sequencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, qt_min_vidas,
				qt_max_vidas, nr_seq_regra, tx_desconto,
				ie_tipo_segurado, vl_desconto)
			(SELECT	nextval('pls_preco_regra_seq'), clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p, qt_min_vidas,
				qt_max_vidas, nr_seq_regra_desconto_w, tx_desconto,
				ie_tipo_segurado, vl_desconto
			from	pls_preco_regra
			where	nr_sequencia	= nr_seq_preco_regra_w);
			end;
		end loop;
		close C02;
	end if;
end if;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_regra_autom ( nr_seq_contrato_p bigint, nr_seq_proposta_p bigint, nr_seq_simulacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
