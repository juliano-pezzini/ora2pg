-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_regras_exece_a300 ( nr_seq_lote_p bigint, nr_seq_empresa_p bigint, nr_seq_classificacao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w		bigint;
qt_registros_w			bigint;
nr_seq_regiao_w			bigint;
sg_uf_w				varchar(10);
cd_municipio_ibge_w		varchar(10);
ds_mensagem_w			varchar(255);
nr_seq_beneficiario_W		bigint;
ie_acao_regra_w			varchar(10);
qt_dias_rescisao_ant_w		bigint;
dt_exclusao_w			timestamp;
dt_mesano_referencia_w		timestamp;
qt_dias_rescindidos_w		bigint;

C01 CURSOR FOR
	SELECT	b.nr_seq_segurado,
		a.sg_uf,
		a.cd_municipio_ibge,
		b.nr_sequencia,
		b.dt_exclusao
	from	ptu_movimento_benef_compl	a,
		ptu_mov_produto_benef		b
	where	a.nr_seq_beneficiario	= b.nr_sequencia
	and	b.nr_seq_empresa	= nr_seq_empresa_p;


BEGIN

select	max(nr_seq_regiao),
	max(ie_acao_regra),
	coalesce(max(qt_dias_rescisao_ant),0)
into STRICT	nr_seq_regiao_w,
	ie_acao_regra_w,
	qt_dias_rescisao_ant_w
from	ptu_regra_excessao_a300
where	nr_seq_classificacao	= nr_seq_classificacao_p
and	ie_situacao		= 'A';

select	dt_mesano_referencia
into STRICT	dt_mesano_referencia_w
from	ptu_mov_produto_lote
where	nr_sequencia	= nr_seq_lote_p;

ds_mensagem_w	:= 'Beneficiário retirado do arquivo conforme a regra de execeção do A300 (OPS - Cadastros de Regras/OPS - Intercâmbio/PTU/Regra de execeção A300';

open C01;
loop
fetch C01 into
	nr_seq_segurado_w,
	sg_uf_w,
	cd_municipio_ibge_w,
	nr_seq_beneficiario_w,
	dt_exclusao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (nr_seq_regiao_w IS NOT NULL AND nr_seq_regiao_w::text <> '') then
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_regiao_local
		where	nr_seq_regiao		= nr_seq_regiao_w
		and	((cd_municipio_ibge	= cd_municipio_ibge_w) or (coalesce(cd_municipio_ibge::text, '') = ''))
		and	sg_uf_municipio		= sg_uf_w;
	else
		qt_registros_w	:= 1;
	end if;

	if (dt_exclusao_w IS NOT NULL AND dt_exclusao_w::text <> '') and (qt_dias_rescisao_ant_w > 0) then
		qt_dias_rescindidos_w	:= Obter_Dias_Entre_Datas(dt_exclusao_w,dt_mesano_referencia_w);
	else
		qt_dias_rescindidos_w	:= -1;
	end if;

	if	((qt_registros_w = 0) or (qt_dias_rescindidos_w  > qt_dias_rescisao_ant_w)) then
		if (ie_acao_regra_w = 'RB') then
			--ptu_gravar_log_erro_a300(nr_seq_lote_p,nr_seq_segurado_w,ds_mensagem_w,cd_estabelecimento_p,nm_usuario_p);
			/* Deletar os logs de erro dos registros que serão excluídos do lote pela regra de exceção */

			delete	FROM ptu_mov_produto_log
			where	nr_seq_segurado	= nr_seq_segurado_w
			and	nr_seq_lote	= nr_seq_lote_p;

			delete	FROM ptu_movimento_benef_compl
			where	nr_seq_beneficiario	= nr_seq_beneficiario_w;

			delete 	FROM ptu_intercambio_consist
			where	nr_seq_mov_prod_benef	= nr_seq_beneficiario_w;

			delete	FROM ptu_mov_produto_benef
			where	nr_sequencia	= nr_seq_beneficiario_w;
		end if;
	end if;
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_regras_exece_a300 ( nr_seq_lote_p bigint, nr_seq_empresa_p bigint, nr_seq_classificacao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

