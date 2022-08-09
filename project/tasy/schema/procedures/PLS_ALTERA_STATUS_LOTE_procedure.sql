-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_altera_status_lote ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*	1 - Provisorio
	2 - Definitivo		*/
ie_status_w			smallint;
ie_novo_status_w		smallint;
dt_mesano_referencia_w		timestamp;
ie_mes_fechado_w		varchar(1);
cd_estabelecimento_w		bigint;
ie_gerar_comissao_w		varchar(1);
ie_esquema_contabil_w		varchar(1);
qt_registros_w			bigint;
ie_liberar_portal_w		varchar(1);
qt_movimento_w			bigint;


BEGIN

select	ie_status,
	coalesce(dt_contabilizacao,dt_mesano_referencia),
	cd_estabelecimento
into STRICT	ie_status_w,
	dt_mesano_referencia_w,
	cd_estabelecimento_w
from	pls_lote_mensalidade
where	nr_sequencia	= nr_seq_lote_p;

select	pls_obter_se_mes_fechado(dt_mesano_referencia_w,'T', cd_estabelecimento_w),
	obter_valor_param_usuario(1205,9,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_w),
	coalesce(obter_valor_param_usuario(1205,35,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_w),'A')
into STRICT	ie_mes_fechado_w,
	ie_gerar_comissao_w,
	ie_liberar_portal_w
;

if (ie_mes_fechado_w = 'S') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 191856, null );
	/* Nao e possivel realizar esta operacao pois o mes de competencia ou a contabilidade do mes esta fechada! */

end if;

if (ie_status_w	= '1') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 191857, null );
	/* Lote nao foi gerado. Verifique! */

end if;

/*select	count(1)
into	qt_registros_w
from	pls_mensalidade_segurado	a,
	pls_mensalidade			b,
	pls_mensalidade_critica		c
where	a.nr_seq_mensalidade		= b.nr_sequencia
and	a.nr_sequencia			= c.nr_seq_mensalidade_seg
and	b.nr_seq_lote			= nr_seq_lote_p
and	dt_liberacao is null
and	rownum	= 1;*/


/*Existem mensalidades com criticas nao liberadas. Favor verificar!*/


--if	(qt_registros_w	> 0) then

--	wheb_mensagem_pck.exibir_mensagem_abort(263483);

--end if;
update	pls_lote_mensalidade
set	ie_status		= '2',
	dt_liberacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),
	ie_visualizar_portal	= CASE WHEN ie_liberar_portal_w='A' THEN 'S'  ELSE coalesce(ie_visualizar_portal,'N') END
where	nr_sequencia		= nr_seq_lote_p;

if (coalesce(ie_gerar_comissao_w,'N')	= 'S') then
	CALL pls_gerar_comissao_vendedor(nr_seq_lote_p, null, null, nm_usuario_p);
end if;

begin
select	coalesce(ie_esquema_contabil,'N')
into STRICT	ie_esquema_contabil_w
from	pls_parametro_contabil
where	cd_estabelecimento	= cd_estabelecimento_w;
exception
when others then
	ie_esquema_contabil_w	:= 'N';
end;

if (ie_esquema_contabil_w = 'S') then
	CALL pls_atualizar_codificacao_pck.pls_atualizar_codificacao(dt_mesano_referencia_w);
	qt_movimento_w := ctb_pls_atualizar_receita_in(nr_seq_lote_p, null, null, null, nm_usuario_p, cd_estabelecimento_w, null, 'P', qt_movimento_w);
	ctb_pls_atualizar_imposto_in(nr_seq_lote_p, null, nm_usuario_p, cd_estabelecimento_w);
else
	CALL CTB_PLS_Atualizar_mensal(nr_seq_lote_p, null, nm_usuario_p, cd_estabelecimento_w);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_altera_status_lote ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
