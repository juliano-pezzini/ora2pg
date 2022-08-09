-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_status_fat_pos ( nr_seq_conta_p bigint, nr_seq_mat_p bigint, nr_seq_proc_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*

	ESSA ROTINA DEU ORIGEM  DA PLS_ATUAL_STATUS_FAT_POS_ESTAB DEVIDO A REESTRUTURAÇÃO
	DE GERAÇÃO DE PÓS-ETABELECIDO. ENQUANTO A ANTIGA GERAÇÃO DE PÓS-ESTABELECIDO NÃO
	FOR DESCONTINUADA, AS ALTERAÇÕES EM UMA DAS ROTINAS DEVEM SER REFLETIDAS NA OUTRA.

*/
nr_seq_proc_w		bigint;
nr_seq_mat_w		bigint;
nr_seq_item_analise_w	bigint;
ie_pagamento_w		varchar(1);
nr_seq_item_princ_w	bigint;
qt_itens_w		bigint;
nr_seq_analise_ref_w	bigint;
ie_faturamento_w	varchar(2);
ie_status_faturamento_w	varchar(2);
ie_status_w		varchar(2);
C01 CURSOR FOR
	SELECT	CASE WHEN ie_tipo_item='P' THEN nr_seq_item  ELSE null END ,
		CASE WHEN ie_tipo_item='M' THEN nr_seq_item  ELSE null END
	from	w_pls_resumo_conta
	where	nr_seq_conta	= nr_seq_conta_p
	and	nr_seq_analise	= nr_seq_analise_p;


BEGIN

/*
A rotina de status de faturamento pós. verifica o status de pagamento e faturamento do item  na análise de produção médica e retorna este
para ser atualizado no campo ie_status fatura na pls_conta_pos_estabelecido.
*/
if (coalesce(nr_seq_mat_p,0) = 0) and (coalesce(nr_seq_proc_p,0) = 0) then

	open C01;
	loop
	fetch C01 into
		nr_seq_proc_w,
		nr_seq_mat_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if	((coalesce(nr_seq_proc_w,0) <> 0) or (coalesce(nr_seq_mat_w,0) <> 0)) then
			CALL pls_atualizar_status_fat_pos(	nr_seq_conta_p,	nr_seq_mat_w, nr_seq_proc_w,
							nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p);
		end if;

		end;
	end loop;
	close C01;

else
	select	max(ie_faturamento),
		max(ie_pagamento),
		max(ie_status)
	into STRICT	ie_faturamento_w,
		ie_pagamento_w,
		ie_status_w
	from	w_pls_resumo_conta
	where	nr_seq_conta = nr_seq_conta_p
	and 	((nr_seq_item = nr_seq_proc_p AND ie_tipo_item = 'P')
	or 	 (nr_seq_item = nr_seq_mat_p AND ie_tipo_item = 'M'))
	and	nr_seq_analise = nr_seq_analise_p;

	if (ie_status_w = 'P') then
		if 	(ie_faturamento_w <> 'G' AND ie_pagamento_w <> 'G' ) then
			ie_status_faturamento_w := 'P';
		else
			ie_status_faturamento_w := 'N';
		end if;
	elsif (ie_status_w = 'L') then
		if 	(ie_faturamento_w <> 'G' AND ie_pagamento_w <> 'G' ) then
			ie_status_faturamento_w := 'L';
		else
			ie_status_faturamento_w := 'N';
		end if;
	else
		ie_status_faturamento_w := 'D';
	end if;

	if (coalesce(nr_seq_proc_p,0) > 0) then
		update	pls_conta_pos_estabelecido
		set	ie_status_faturamento  	= ie_status_faturamento_w,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_seq_conta_proc	= nr_seq_proc_p
		and	nr_seq_conta		= nr_seq_conta_p
		and	coalesce(nr_seq_lote_fat::text, '') = ''
		and	((coalesce(nr_seq_analise::text, '') = '') or (nr_seq_analise	= nr_seq_analise_p))
		and	((ie_situacao		= 'A') or (coalesce(ie_situacao::text, '') = ''));
	elsif (coalesce(nr_seq_mat_p,0) > 0) then
		update	pls_conta_pos_estabelecido
		set	ie_status_faturamento  	= ie_status_faturamento_w,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_seq_conta_mat	= nr_seq_mat_p
		and	nr_seq_conta		= nr_seq_conta_p
		and	coalesce(nr_seq_lote_fat::text, '') = ''
		and	((coalesce(nr_seq_analise::text, '') = '') or (nr_seq_analise	= nr_seq_analise_p))
		and	((ie_situacao		= 'A') or (coalesce(ie_situacao::text, '') = ''));
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_status_fat_pos ( nr_seq_conta_p bigint, nr_seq_mat_p bigint, nr_seq_proc_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
