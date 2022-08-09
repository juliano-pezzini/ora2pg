-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_valor_tabela_sca ( nr_seq_segurado_p bigint, nr_seq_vinculo_sca_p bigint, ie_motivo_reajuste_p text, dt_reajuste_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ie_geracao_valores_w		varchar(10);
ie_origem_sca_w			varchar(3);
ie_titularidade_w		varchar(1);
ie_geracao_valores_sca_w	varchar(1);
vl_preco_sca_w			double precision	:= 0;
nr_seq_plano_w			bigint;
nr_seq_contrato_w		bigint;
nr_seq_tabela_w			bigint;
nr_seq_plano_preco_w		bigint;
nr_seq_contrato_sca_w		bigint;
nr_seq_segurado_sca_w		bigint;
qt_idade_w			smallint;
vl_preco_ant_w			double precision;
dt_adesao_sca_w			timestamp;
dt_reajuste_w			timestamp;
ie_grau_parentesco_w		varchar(10);

C01 CURSOR FOR
	SELECT	nr_sequencia,
		coalesce(vl_preco_atual, 0)
	from	pls_plano_preco
	where	qt_idade_w	>= qt_idade_inicial
	and	qt_idade_w	<= qt_idade_final
	and	nr_seq_tabela	= nr_seq_tabela_w
	and	coalesce(ie_grau_titularidade, ie_grau_parentesco_w)	= ie_grau_parentesco_w
	order by
		coalesce(ie_grau_titularidade, ' ');


BEGIN

select	a.nr_seq_contrato,
	c.ie_geracao_valores,
	CASE WHEN coalesce(a.nr_seq_titular::text, '') = '' THEN 'T'  ELSE 'D' END
into STRICT	nr_seq_contrato_w,
	ie_geracao_valores_w,
	ie_titularidade_w
from	pls_segurado a,
	pessoa_fisica b,
	pls_contrato c
where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
and	c.nr_sequencia		= a.nr_seq_contrato
and	a.nr_sequencia		= nr_seq_segurado_p;

select	a.nr_seq_plano,
	a.nr_seq_tabela,
	a.nr_seq_contrato,
	a.nr_seq_segurado,
	a.ie_geracao_valores,
	a.dt_inicio_vigencia
into STRICT	nr_seq_plano_w,
	nr_seq_tabela_w,
	nr_seq_contrato_sca_w,
	nr_seq_segurado_sca_w,
	ie_geracao_valores_sca_w,
	dt_adesao_sca_w
from	pls_sca_vinculo a
where	a.nr_sequencia	= nr_seq_vinculo_sca_p;

if (dt_adesao_sca_w > dt_reajuste_p) then
	dt_reajuste_w	:= dt_adesao_sca_w;
else
	dt_reajuste_w	:= dt_reajuste_p;
end if;

if (ie_geracao_valores_sca_w = ie_titularidade_w) or (ie_geracao_valores_sca_w = 'B') then
	select	max(a.qt_idade)
	into STRICT	qt_idade_w
	from	pls_segurado_preco_origem a
	where	nr_seq_vinculo_sca = nr_seq_vinculo_sca_p;

	if (coalesce(qt_idade_w,-1) = -1) then
		qt_idade_w	:= pls_obter_idade_segurado(nr_seq_segurado_p,clock_timestamp(),'A');
	end if;

	ie_grau_parentesco_w	:= coalesce(substr(pls_obter_garu_dependencia_seg(nr_seq_segurado_p, 'C'), 1, 2), 'X');

	open C01;
	loop
	fetch C01 into
		nr_seq_plano_preco_w,
		vl_preco_sca_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;

	if (coalesce(nr_seq_plano_preco_w,0) <> 0) then
		select	max(vl_preco_atual)
		into STRICT	vl_preco_ant_w
		from	pls_segurado_preco_origem
		where	nr_seq_vinculo_sca	= nr_seq_vinculo_sca_p;

		if (coalesce(vl_preco_sca_w,0) >= 0) then
			if (coalesce(nr_seq_contrato_sca_w,0) <> 0) then
				ie_origem_sca_w	:= 'SC';
			elsif (coalesce(nr_seq_segurado_sca_w,0) <> 0) then
				ie_origem_sca_w	:= 'SB';
			end if;

			insert into pls_segurado_preco_origem(	nr_sequencia, cd_estabelecimento, dt_atualizacao, nm_usuario, nr_seq_segurado,
				nr_seq_plano, dt_atualizacao_nrec, nm_usuario_nrec, vl_preco_atual,
				nr_seq_tabela, ie_origem_preco, dt_liberacao, cd_motivo_reajuste, dt_reajuste,
				vl_preco_ant, qt_idade, nm_usuario_liberacao, nr_seq_preco, nr_seq_vinculo_sca,
				ds_observacao)
			values (	nextval('pls_segurado_preco_origem_seq'), cd_estabelecimento_p, clock_timestamp(), nm_usuario_p, nr_seq_segurado_p,
				nr_seq_plano_w, clock_timestamp(), nm_usuario_p, vl_preco_sca_w,
				nr_seq_tabela_w, ie_origem_sca_w, clock_timestamp(), ie_motivo_reajuste_p, dt_reajuste_w,
				vl_preco_ant_w, qt_idade_w, nm_usuario_p, nr_seq_plano_preco_w, nr_seq_vinculo_sca_p,
				'Data alteração: '||dt_reajuste_p);
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_valor_tabela_sca ( nr_seq_segurado_p bigint, nr_seq_vinculo_sca_p bigint, ie_motivo_reajuste_p text, dt_reajuste_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
