-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_aplic_alt_lote_cart_inter ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nr_seq_motivo_via_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_via_cart_inter_w		bigint;
nr_via_solicitacao_w		integer;
dt_validade_carteira_w		timestamp;
dt_emissao_w			timestamp;
nr_seq_segurado_w		bigint;
ie_alterou_via_adic_w		varchar(10);
-------------------------------------------------------------------------
nr_seq_carteira_w		bigint;
nr_via_solicitacao_atual_w	integer;
dt_validade_carteira_atual_w	timestamp;
ie_gerar_valor_w		varchar(10);
vl_via_adicional_w		double precision := 0;
nr_seq_regra_via_w		bigint;
pr_via_adicional_w		double precision;
nr_seq_segurado_preco_w		bigint;
vl_preco_pre_w			double precision := 0;
-------------------------------------------------------------------------------
ds_trilha1_w			pls_segurado_carteira.ds_trilha1%type;
ds_trilha2_w			pls_segurado_carteira.ds_trilha2%type;
ds_trilha3_w			pls_segurado_carteira.ds_trilha3%type;
ds_trilha_qr_code_w		pls_segurado_carteira.ds_trilha_qr_code%type;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_via_cart_inter
	where	nr_seq_lote	= nr_seq_lote_p
	and	(nr_seq_segurado IS NOT NULL AND nr_seq_segurado::text <> '');


BEGIN

select	ie_gerar_valor
into STRICT	ie_gerar_valor_w
from	pls_motivo_via_adicional
where	nr_sequencia	= nr_seq_motivo_via_p;

open C01;
loop
fetch C01 into
	nr_seq_via_cart_inter_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_alterou_via_adic_w	:= 'N';
	vl_via_adicional_w	:= 0;
	nr_seq_regra_via_w	:= null;
	
	select	nr_via_solicitacao,
		dt_validade_carteira,
		dt_emissao,
		nr_seq_segurado,
		dt_validade_anterior,
		nr_via_anterior
	into STRICT	nr_via_solicitacao_w,
		dt_validade_carteira_w,
		dt_emissao_w,
		nr_seq_segurado_w,
		dt_validade_carteira_atual_w,
		nr_via_solicitacao_atual_w
	from	pls_via_cart_inter
	where	nr_sequencia	= nr_seq_via_cart_inter_w;
	
	select	nr_sequencia
	into STRICT	nr_seq_carteira_w
	from	pls_segurado_carteira
	where	nr_seq_segurado	= nr_seq_segurado_w;
	
	if	((nr_via_solicitacao_w <> nr_via_solicitacao_atual_w) or (dt_validade_carteira_w	<> dt_validade_carteira_atual_w)) then
		
		if (nr_via_solicitacao_w <> nr_via_solicitacao_atual_w) then
			ie_alterou_via_adic_w	:= 'S';
		end if;
			insert into pls_segurado_cart_ant(	nr_sequencia, nm_usuario, dt_atualizacao, nm_usuario_nrec, dt_atualizacao_nrec,
					cd_usuario_ant, dt_validade, dt_inicio_vigencia,nr_seq_segurado, dt_alteracao,
					ds_observacao,ie_status_carteira, nr_via_anterior, ie_sistema_anterior,nr_seq_regra_via,
					vl_via_adicional, nr_seq_motivo_via,nm_usuario_solicitacao, dt_solicitacao,
					nr_seq_lote_emissao,ds_trilha1, ds_trilha2, ds_trilha3,ds_trilha_qr_code,
					dt_desbloqueio, nm_usuario_desbloqueio, ie_tipo_desbloqueio)
			(SELECT		nextval('pls_segurado_cart_ant_seq'), nm_usuario_p, clock_timestamp(),nm_usuario_p, clock_timestamp(),
					cd_usuario_plano, dt_validade_carteira, dt_inicio_vigencia,nr_seq_segurado,
					clock_timestamp(), ds_observacao,'V', nr_via_solicitacao, 'N',nr_seq_regra_via,
					vl_via_adicional, nr_seq_motivo_via_p,nm_usuario_solicitante, dt_solicitacao,
					nr_seq_lote_emissao,ds_trilha1, ds_trilha2, ds_trilha3,ds_trilha_qr_code,
					dt_desbloqueio, nm_usuario_desbloqueio, ie_tipo_desbloqueio
				from	pls_segurado_carteira
				where	nr_sequencia	= nr_seq_carteira_w);
		
		if (ie_alterou_via_adic_w = 'S') then
			if (ie_gerar_valor_w = 'S') then
				SELECT * FROM pls_obter_regra_via_adic(null, null, null, nr_via_solicitacao_w, 'N', nm_usuario_p, cd_estabelecimento_p, clock_timestamp(), nr_seq_regra_via_w, vl_via_adicional_w, pr_via_adicional_w) INTO STRICT nr_seq_regra_via_w, vl_via_adicional_w, pr_via_adicional_w;
			end if;
			
			if (coalesce(pr_via_adicional_w,0) <> 0) then
				select	max(a.nr_sequencia)
				into STRICT	nr_seq_segurado_preco_w
				from	pls_segurado_preco	a,
					pls_segurado		b
				where	a.nr_seq_segurado	= b.nr_sequencia
				and	b.nr_sequencia		= nr_seq_segurado_w
				and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
				and	clock_timestamp()		>= trunc(a.dt_reajuste, 'month');
				
				select	vl_preco_atual
				into STRICT	vl_preco_pre_w
				from	pls_segurado_preco
				where	nr_sequencia	= nr_seq_segurado_preco_w;
				
				vl_via_adicional_w	:= (pr_via_adicional_w * vl_preco_pre_w) / 100;
			end if;
		end if;
		
		delete	FROM pls_segurado_cart_estagio
		where	nr_seq_cartao_seg	= nr_seq_carteira_w
		and	ie_estagio_emissao	= '1';
		
		update	pls_segurado_carteira
		set	nr_via_solicitacao 	= nr_via_solicitacao_w,
			ie_situacao 		= 'P',
			nm_usuario 		= nm_usuario_p,
			dt_atualizacao 		= clock_timestamp(),
			vl_via_adicional 	= vl_via_adicional_w,
			nr_seq_regra_via 	= nr_seq_regra_via_w,
			nr_seq_motivo_via 	= CASE WHEN ie_alterou_via_adic_w='S' THEN nr_seq_motivo_via_p  ELSE null END ,
			nm_usuario_solicitante	= nm_usuario_p,
			dt_solicitacao		= dt_emissao_w,
			ds_observacao		= wheb_mensagem_pck.get_texto(1127395),
			nr_seq_lote_emissao	 = NULL,
			ie_processo		= 'M',
			dt_validade_carteira	= dt_validade_carteira_w
		where	nr_sequencia 		= nr_seq_carteira_w;
		
		CALL pls_alterar_estagios_cartao(nr_seq_carteira_w,clock_timestamp(),1,cd_estabelecimento_p,nm_usuario_p);
		
		SELECT * FROM pls_obter_trilhas_cartao(nr_seq_segurado_w, ds_trilha1_w, ds_trilha2_w, ds_trilha3_w, ds_trilha_qr_code_w, nm_usuario_p) INTO STRICT ds_trilha1_w, ds_trilha2_w, ds_trilha3_w, ds_trilha_qr_code_w;
		
		update	pls_segurado_carteira
		set	ds_trilha1		= ds_trilha1_w,
			ds_trilha2		= ds_trilha2_w,
			ds_trilha3		= ds_trilha3_w,
			ds_trilha_qr_code	= ds_trilha_qr_code_w
		where	nr_sequencia 		= nr_seq_carteira_w;
	end if;
	end;
end loop;
close C01;

update	pls_lote_via_cart_inter
set	ie_status		= '3',
	dt_aplicacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_aplic_alt_lote_cart_inter ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nr_seq_motivo_via_p bigint, nm_usuario_p text) FROM PUBLIC;

