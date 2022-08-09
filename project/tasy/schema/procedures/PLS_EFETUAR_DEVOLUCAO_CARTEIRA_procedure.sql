-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_efetuar_devolucao_carteira ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_devolucao_p timestamp) AS $body$
DECLARE


cd_usuario_plano_w		varchar(30);
nr_seq_cartao_segurado_w	bigint;
nr_via_solicitacao_w		bigint;
nr_seq_estagio_cartao_w		bigint;
dt_validade_carteira_w		timestamp;
nr_seq_devolucao_w		pls_carteira_devolucao.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_usuario_plano,
		nr_via,
		dt_validade_carteira
	from	pls_carteira_devolucao
	where	nr_seq_lote	= nr_seq_lote_p;


BEGIN

update	pls_cart_lote_devolucao
set	dt_devolucao		= dt_devolucao_p,
	nm_usuario_devolucao	= nm_usuario_p,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia = nr_seq_lote_p;

/*aaschlote 24/11/2011 OS - 382588*/

open C01;
loop
fetch C01 into
	nr_seq_devolucao_w,
	cd_usuario_plano_w,
	nr_via_solicitacao_w,
	dt_validade_carteira_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	max(nr_sequencia)
	into STRICT	nr_seq_cartao_segurado_w
	from	pls_segurado_carteira
	where	cd_usuario_plano	= cd_usuario_plano_w
	and	cd_estabelecimento	= cd_estabelecimento_p;

	if (nr_seq_cartao_segurado_w IS NOT NULL AND nr_seq_cartao_segurado_w::text <> '') then
		CALL pls_alterar_estagios_cartao(nr_seq_cartao_segurado_w, dt_devolucao_p, 8, cd_estabelecimento_p, nm_usuario_p);
		--Gravar a sequência da devolução no estágio da carteira
		update	pls_segurado_cart_estagio
		set	nr_seq_devolucao	= nr_seq_devolucao_w
		where	nr_sequencia = (SELECT	max(nr_sequencia)
					from	pls_segurado_cart_estagio
					where	nr_seq_cartao_seg	= nr_seq_cartao_segurado_w
					and	ie_estagio_emissao	= '8');

		select	max(nr_sequencia)
		into STRICT	nr_seq_estagio_cartao_w
		from	pls_segurado_cart_estagio
		where	nr_seq_cartao_seg	= nr_seq_cartao_segurado_w
		and	ie_estagio_emissao	= '8'
		and	nr_via			<> nr_via_solicitacao_w;

		if (coalesce(nr_seq_estagio_cartao_w::text, '') = '') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_estagio_cartao_w
			from	pls_segurado_cart_estagio
			where	nr_seq_cartao_seg	= nr_seq_cartao_segurado_w
			and	ie_estagio_emissao	= '8'
			and	dt_validade_carteira	<> dt_validade_carteira_w;
		end if;

		if (nr_seq_estagio_cartao_w IS NOT NULL AND nr_seq_estagio_cartao_w::text <> '') then
			update	pls_segurado_cart_estagio
			set	nr_via			= nr_via_solicitacao_w,
				dt_validade_carteira	= dt_validade_carteira_w
			where	nr_sequencia		= nr_seq_estagio_cartao_w;
		end if;
	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_efetuar_devolucao_carteira ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_devolucao_p timestamp) FROM PUBLIC;
