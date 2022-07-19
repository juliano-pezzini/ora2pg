-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_benef_lote_cart ( nr_sequencia_p bigint, ie_tipo_lote_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_lote_w		bigint;
nm_beneficiario_w	varchar(100);
nr_seq_seg_carteira_w	pls_carteira_emissao.nr_seq_seg_carteira%type;


BEGIN
 
if (ie_tipo_lote_p = 'S') then 
	select	substr(pls_obter_dados_carteira(nr_seq_seg_carteira,null,'N'),1,100),
		nr_seq_lote,
		nr_seq_seg_carteira
	into STRICT	nm_beneficiario_w,
		nr_seq_lote_w,
		nr_seq_seg_carteira_w
	from	pls_carteira_emissao 
	where	nr_sequencia	= nr_sequencia_p;
	 
	delete from	pls_carteira_emissao 
	where	nr_sequencia	= nr_sequencia_p;
	
	update	pls_segurado_carteira
	set	nr_seq_lote_emissao	 = NULL,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_seg_carteira_w;
	
elsif (ie_tipo_lote_p = 'V') then
	select	nr_seq_lote 
	into STRICT	nr_seq_lote_w 
	from	pls_carteira_vencimento 
	where	nr_sequencia	= nr_sequencia_p;
	 
	select	substr(pls_obter_dados_carteira(nr_seq_seg_carteira,null,'N'),1,100) 
	into STRICT	nm_beneficiario_w 
	from	pls_carteira_vencimento 
	where	nr_sequencia	= nr_sequencia_p;
	 
	delete from	pls_carteira_vencimento 
	where	nr_sequencia	= nr_sequencia_p;
elsif (ie_tipo_lote_p = 'A')then
	delete from	pls_via_adic_cart 
	where	nr_sequencia = nr_sequencia_p;
end if;

if (ie_tipo_lote_p in ('S','V')) then 
	insert into pls_lote_cart_historico(nr_sequencia, dt_atualizacao, nm_usuario,
		cd_estabelecimento, nr_seq_lote_carteira, dt_atualizacao_nrec,
		nm_usuario_nrec, dt_historico, nm_usuario_historico,
		ds_historico, dt_liberacao, nm_usuario_liberacao)
	values (nextval('pls_lote_cart_historico_seq'), clock_timestamp(), nm_usuario_p,
		cd_estabelecimento_p, nr_seq_lote_w, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		wheb_mensagem_pck.get_texto(1180016,'NM_BENEFICIARIO='||nm_beneficiario_w||';DS_USUARIO='||Obter_Nome_Usuario(nm_usuario_p)||';DT_EXCLUSAO='||to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss')), clock_timestamp(), nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_benef_lote_cart ( nr_sequencia_p bigint, ie_tipo_lote_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

