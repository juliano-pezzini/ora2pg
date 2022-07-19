-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_receber_carteira ( nr_seq_cart_emissao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_carteira_w		bigint;
ie_situacao_w			varchar(3);
cd_estabelecimento_w		smallint;


BEGIN

select	coalesce(max(ie_situacao),'P')
into STRICT	ie_situacao_w
from	pls_carteira_emissao
where	nr_sequencia	= nr_seq_cart_emissao_p;

if (ie_situacao_w	= 'P') then
	update	pls_carteira_emissao
	set	dt_recebimento 		= clock_timestamp(),
		nm_usuario_recebimento	= nm_usuario_p,
		ie_situacao 		= 'D'
	where	nr_sequencia		= nr_seq_cart_emissao_p;

	select	a.nr_sequencia,
		c.cd_estabelecimento
	into STRICT	nr_seq_carteira_w,
		cd_estabelecimento_w
	from	pls_segurado_carteira a,
		pls_carteira_emissao b,
		pls_lote_carteira	c
	where	a.nr_sequencia	= b.nr_seq_seg_carteira
	and	c.nr_sequencia	= b.nr_seq_lote
	and	b.nr_sequencia	= nr_seq_cart_emissao_p;

	update	pls_segurado_carteira a
	set	a.ie_situacao	= 'D'
	where	a.nr_sequencia	= nr_seq_carteira_w;

	CALL pls_alterar_estagios_cartao(nr_seq_carteira_w,clock_timestamp(),'6',cd_estabelecimento_w,nm_usuario_p);

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_receber_carteira ( nr_seq_cart_emissao_p bigint, nm_usuario_p text) FROM PUBLIC;

