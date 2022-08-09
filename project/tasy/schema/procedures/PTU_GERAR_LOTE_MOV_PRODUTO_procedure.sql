-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_lote_mov_produto ( nr_seq_lote_p ptu_mov_produto_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ie_tipo_movimentacao_w		ptu_mov_produto_lote.ie_tipo_movimento%type;
dt_mesano_referencia_w		ptu_mov_produto_lote.dt_mesano_referencia%type;
dt_movimento_inicial_w		ptu_mov_produto_lote.dt_movimento_inicial%type;
dt_movimento_final_w		ptu_mov_produto_lote.dt_movimento_final%type;
nr_seq_classificacao_w		pls_sca_classificacao.nr_sequencia%type;
ie_tipo_classificacao_w		pls_sca_classificacao.ie_tipo_classificacao%type;
cd_interface_w			pls_sca_classificacao.cd_interface%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_unimed_origem_w		pls_congenere.cd_cooperativa%type;
nr_seq_mov_produto_w		ptu_movimentacao_produto.nr_sequencia%type;
qt_reg_w			integer;
qt_reg_empresas_w		integer;
qt_reg_benef_w			integer;
qt_reg_compl_benf_w		integer;
nr_versao_transacao_w		bigint;
cd_versao_ptu_w			ptu_regra_interface.cd_versao_ptu%type;

C01 CURSOR FOR
	SELECT	d.cd_operadora_empresa cd_destino
	from	pls_plano		a,
		pls_plano_fornecedor	b,
		pls_prestador		c,
		pessoa_juridica		d
	where	b.nr_seq_plano		= a.nr_sequencia
	and	b.nr_seq_prestador	= c.nr_sequencia
	and	c.cd_cgc		= d.cd_cgc
	and	a.nr_seq_classificacao	= nr_seq_classificacao_w
	and	a.cd_estabelecimento	= cd_estabelecimento_p
	and	b.cd_estabelecimento	= cd_estabelecimento_p
	and	a.ie_tipo_operacao	= 'A'
	and	(c.cd_cgc IS NOT NULL AND c.cd_cgc::text <> '')
	and	(d.cd_operadora_empresa IS NOT NULL AND d.cd_operadora_empresa::text <> '')
	and	dt_mesano_referencia_w >= coalesce(b.dt_inicio_vigencia,dt_mesano_referencia_w)
	and	dt_mesano_referencia_w <= coalesce(b.dt_fim_vigencia,dt_mesano_referencia_w)
	group by d.cd_operadora_empresa;

BEGIN

select	cd_estabelecimento,
	ie_tipo_movimento,
	nr_seq_classificacao,
	dt_mesano_referencia,
	coalesce(dt_movimento_inicial,trunc(dt_mesano_referencia,'mm')) dt_movimento_inicial,
	coalesce(dt_movimento_final, fim_mes(dt_mesano_referencia)) dt_movimento_final
into STRICT	cd_estabelecimento_w,
	ie_tipo_movimentacao_w,
	nr_seq_classificacao_w,
	dt_mesano_referencia_w,
	dt_movimento_inicial_w,
	dt_movimento_final_w
from	ptu_mov_produto_lote
where	nr_sequencia	= nr_seq_lote_p;

if (nr_seq_classificacao_w IS NOT NULL AND nr_seq_classificacao_w::text <> '') then
	select	ie_tipo_classificacao,
		cd_interface
	into STRICT	ie_tipo_classificacao_w,
		cd_interface_w
	from	pls_sca_classificacao
	where	nr_sequencia	= nr_seq_classificacao_w;
else --Favor informar a classificacao de SCA para a geracao do lote
	CALL wheb_mensagem_pck.exibir_mensagem_abort(308811);
end if;

nr_versao_transacao_w	:= ptu_batch_xml_pck.obter_versao_transacao(cd_estabelecimento_p, null, null, dt_mesano_referencia_w, 'A300');

if (coalesce(nr_versao_transacao_w::text, '') = '') then
	cd_versao_ptu_w	:= pls_obter_versao_ptu(cd_estabelecimento_p, null, dt_mesano_referencia_w, 'A300');

	if (cd_versao_ptu_w IS NOT NULL AND cd_versao_ptu_w::text <> '') then
		if (cd_versao_ptu_w = '8.0') then
			nr_versao_transacao_w	:= 14;
		else
			nr_versao_transacao_w	:= 15;
		end if;
	elsif (cd_interface_w = 2652) or (cd_interface_w = 2653) or (cd_interface_w = 2654) or (cd_interface_w = 2655) or (cd_interface_w = 2656) or (cd_interface_w = 2763) then
		nr_versao_transacao_w := 13; /* PTU 6.2 e PTU 7.0 */
	elsif (cd_interface_w = 2594) or (cd_interface_w = 2598) or (cd_interface_w = 2597) or (cd_interface_w = 2596) or (cd_interface_w = 2595) or (cd_interface_w = 2709) then -- A interface 2709 e do PTU 7.0 mas a Unimed Litoral solicitou que nesta interface em especifico fosse trazido o codigo 12 como numero da versao da transacao. (OS 1134669)
		nr_versao_transacao_w := 12; /* PTU 6.0 */
	elsif (cd_interface_w = 2453) or (cd_interface_w = 2506) or (cd_interface_w = 2507) or (cd_interface_w = 2509) or (cd_interface_w = 2512) then
		nr_versao_transacao_w := 11; /* PTU 5.0 */
	else
		nr_versao_transacao_w := 10;
	end if;
end if;

select	max(cd_cooperativa)
into STRICT	cd_unimed_origem_w
from	pls_congenere	a,
	pls_outorgante	b
where	a.cd_cgc		= b.cd_cgc_outorgante
and	b.cd_estabelecimento	= cd_estabelecimento_w;

delete	FROM ptu_mov_produto_log
where	nr_seq_lote	= nr_seq_lote_p;

for c01_w in C01 loop
	begin
	
	insert into ptu_movimentacao_produto(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
			dt_geracao,cd_unimed_destino,cd_unimed_origem,dt_mov_inicio,dt_mov_fim,
			ie_tipo_mov,ie_operacao,nr_seq_lote,nr_versao_transacao,ie_tipo_produto)
	values (	nextval('ptu_movimentacao_produto_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
			trunc(dt_mesano_referencia_w,'Month'),c01_w.cd_destino,cd_unimed_origem_w,dt_movimento_inicial_w,dt_movimento_final_w,
			ie_tipo_movimentacao_w,'E',nr_seq_lote_p,nr_versao_transacao_w,ie_tipo_classificacao_w)
		returning nr_sequencia into nr_seq_mov_produto_w;
	
	if (nr_versao_transacao_w >= 14) then
		CALL ptu_gerar_prod_empresa_a300_80(nr_seq_mov_produto_w,nm_usuario_p);
	elsif (nr_versao_transacao_w = 13) then
		CALL ptu_gerar_prod_empresa_a300_62(nr_seq_mov_produto_w,nm_usuario_p);
	elsif (nr_versao_transacao_w = 12) then
		CALL ptu_gerar_prod_empresa_a300_60(nr_seq_mov_produto_w,nm_usuario_p);
	elsif (nr_versao_transacao_w = 11) then
		CALL ptu_gerar_prod_empresa_a300_50(nr_seq_mov_produto_w,nm_usuario_p);
	else
		CALL ptu_gerar_produto_empresa_a300(nr_seq_mov_produto_w,nm_usuario_p);
	end if;
	
	qt_reg_empresas_w	:= obter_qt_registro_ptu_a300(nr_seq_mov_produto_w,'302');
	qt_reg_benef_w		:= obter_qt_registro_ptu_a300(nr_seq_mov_produto_w,'304');
	qt_reg_compl_benf_w	:= obter_qt_registro_ptu_a300(nr_seq_mov_produto_w,'306');
	
	update	ptu_movimentacao_produto
	set	qt_reg_empresas		= qt_reg_empresas_w,
		qt_reg_benef		= qt_reg_benef_w,
		qt_reg_compl_benf	= qt_reg_compl_benf_w
	where	nr_sequencia		= nr_seq_mov_produto_w;
	
	select	count(1)
	into STRICT	qt_reg_w
	from	ptu_mov_produto_empresa
	where	nr_seq_mov_produto	= nr_seq_mov_produto_w;
	
	if (qt_reg_w = 0) then
		delete	FROM ptu_movimentacao_produto
		where	nr_sequencia	= nr_seq_mov_produto_w;
	end if;
	
	end;
end loop; --C01
select	count(1)
into STRICT	qt_reg_w
from	ptu_movimentacao_produto
where	nr_seq_lote	= nr_seq_lote_p;

if (qt_reg_w > 0) then
	CALL ptu_consistir_lote_a300(nr_seq_lote_p, cd_estabelecimento_p, nm_usuario_p);
	
	update	ptu_mov_produto_lote
	set	dt_geracao_arquivo	= clock_timestamp()
	where	nr_sequencia		= nr_seq_lote_p;
	
	/*aachlote 03/03/2011 OS - 289459 - Gearr o Uniodonto*/

	if (cd_interface_w = 1996) then
		CALL ptu_gerar_interface_uniodonto(nr_seq_lote_p,cd_estabelecimento_p,nm_usuario_p);
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_lote_mov_produto ( nr_seq_lote_p ptu_mov_produto_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
