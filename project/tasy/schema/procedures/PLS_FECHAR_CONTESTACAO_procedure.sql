-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_fechar_contestacao ( nr_seq_lote_contest_p bigint, dt_vencimento_p timestamp, ie_estorno_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_acao_w			bigint;
ie_envio_recebimento_w		varchar(3);
nr_seq_fatura_w			bigint;
nr_titulo_w			bigint;
nr_seq_contestacao_w		bigint;
vl_apresentado_w			double precision;
vl_contestado_w			double precision;
vl_contestado_conta_w		double precision;
vl_total_contestado_w		double precision;
nr_titulo_pag_w			bigint;
nr_titulo_rec_w			bigint;
qt_registro_w			bigint := 0;
nr_seq_conta_w			bigint;
qt_baixa_w			integer;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.vl_original,
		a.nr_seq_conta
	from	pls_contestacao a
	where	a.nr_seq_lote = nr_seq_lote_contest_p
	group by a.nr_sequencia,
		a.vl_original,
		a.nr_seq_conta;


BEGIN

-- Parâmetro [4] - Permite desfazer fechamento de lote de contestação
if (coalesce(ie_estorno_p,'N') = 'N') then
	if (nr_seq_lote_contest_p IS NOT NULL AND nr_seq_lote_contest_p::text <> '') then
		select	max(a.ie_envio_recebimento),
			coalesce(max(a.vl_apresentado),0),
			max(a.nr_seq_ptu_fatura)
		into STRICT	ie_envio_recebimento_w,
			vl_apresentado_w,
			nr_seq_fatura_w
		from	pls_lote_contestacao a
		where	a.nr_sequencia	= nr_seq_lote_contest_p;
		
		if (ie_envio_recebimento_w = 'R') then
			select	sum(vl_original)
			into STRICT	vl_total_contestado_w
			from	pls_contestacao a
			where	a.nr_seq_lote = nr_seq_lote_contest_p;
			
			if (vl_total_contestado_w <> vl_apresentado_w) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(177776,
									'VL_CONTESTACAO=' || campo_mascara_virgula(vl_total_contestado_w)||';'||
									'VL_APRESENTADO=' || campo_mascara_virgula(vl_apresentado_w));
			end if;
			
			open C01;
			loop
			fetch C01 into
				nr_seq_contestacao_w,
				vl_contestado_w,
				nr_seq_conta_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				select	sum(vl_contestado)
				into STRICT	vl_contestado_conta_w
				from (	SELECT	sum(a.vl_contestado) vl_contestado
					from	pls_contestacao_proc a
					where	a.nr_seq_contestacao = nr_seq_contestacao_w
					
union all

					SELECT	sum(a.vl_contestado) vl_contestado
					from	pls_contestacao_mat a
					where	a.nr_seq_contestacao = nr_seq_contestacao_w) alias3;
				
				if (vl_contestado_w <> vl_contestado_conta_w) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(177778,
								'NR_SEQ_CONTESTACAO=' || nr_seq_contestacao_w||';'||
								'VL_CONTESTADO_CONTA=' || campo_mascara_virgula(vl_contestado_conta_w)||';'||
								'VL_CONTESTADO=' || campo_mascara_virgula(vl_contestado_w));
				end if;
				
				CALL pls_atualiza_status_copartic(nr_seq_conta_w, 'LC', null, nm_usuario_p, cd_estabelecimento_p);
				end;
			end loop;
			close C01;
		end if;
		
		update	pls_lote_contestacao
		set	dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p,
			dt_fechamento	= clock_timestamp(),
			ie_status	= 'E'
		where	nr_sequencia	= nr_seq_lote_contest_p;
		
		select	max(a.nr_titulo)
		into STRICT	nr_titulo_w
		from	ptu_fatura a
		where	a.nr_sequencia = nr_seq_fatura_w;
		
		-- Somente tratar evento Geração de título a pagar caso contestação enviada
		if (ie_envio_recebimento_w = 'E') then
			nr_seq_acao_w := pls_obter_acao_intercambio(	'6',  -- Fechamento da contestação
							'20',  -- Validar baixa no título da fatura
							nr_seq_fatura_w, null, nr_seq_lote_contest_p, null, clock_timestamp(), 'A550', ie_estorno_p, nr_seq_acao_w);
							
			if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') and (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
				select	count(1)
				into STRICT	qt_baixa_w
				from	titulo_pagar_baixa
				where	nr_titulo	= nr_titulo_w
				and	vl_glosa	= 0;
				
				if (qt_baixa_w = 0) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(1072101); -- O título da fatura não possui baixa.
				end if;
			end if;
			
			nr_seq_acao_w := pls_obter_acao_intercambio(	'6',  -- Fechamento da contestação
							'2',  -- Geração de título a pagar
							nr_seq_fatura_w, null, nr_seq_lote_contest_p, null, clock_timestamp(), 'A550', ie_estorno_p, nr_seq_acao_w);
			
			if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') then
				CALL ptu_gerar_tit_pagar_contest(nr_seq_lote_contest_p,nr_seq_acao_w,cd_estabelecimento_p,nm_usuario_p);
			end if;
			
			nr_seq_acao_w := pls_obter_acao_intercambio(	'6',  -- Fechamento da contestação
							'5',  -- Liberar pagamento do título
							nr_seq_fatura_w, null, null, null, clock_timestamp(), 'A550', ie_estorno_p, nr_seq_acao_w);
			
			if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') and (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then				
				CALL pls_liberar_fatura_pagamento(nr_titulo_w,nm_usuario_p);
			end if;
			
			nr_seq_acao_w := pls_obter_acao_intercambio(	'6',  -- Fechamento da contestação
							'8',  -- Mudar status do título a pagar
							nr_seq_fatura_w, null, null, null, clock_timestamp(), 'A550', ie_estorno_p, nr_seq_acao_w);
			
			if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') and (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then			
				CALL pls_alterar_status_fatura_pag(nr_titulo_w,nm_usuario_p);
			end if;
			
			-- Tratar baixa de glosas do título a pagar 
			nr_seq_acao_w := pls_obter_acao_intercambio(	'6',  -- Fechamento da contestação
							'7',  -- Baixar glosas no título a pagar
							nr_seq_fatura_w, null, null, null, clock_timestamp(), 'A550', ie_estorno_p, nr_seq_acao_w);
			
			if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') and (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
				CALL pls_baixar_glosas_contestacao(nr_seq_lote_contest_p,nr_seq_acao_w,nr_titulo_w,nr_seq_fatura_w,'N','N',nm_usuario_p,cd_estabelecimento_p);
			end if;
			
			-- Quando houve pagamento antecipado 
			nr_seq_acao_w := pls_obter_acao_intercambio(	'6',  -- Fechamento da contestação
							'1',  -- Geração de título a receber
							nr_seq_fatura_w, null, null, null, clock_timestamp(), 'A550', ie_estorno_p, nr_seq_acao_w);
			
			if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') and (dt_vencimento_p IS NOT NULL AND dt_vencimento_p::text <> '') then
				CALL pls_gerar_tit_rec_contestacao(nr_seq_lote_contest_p,dt_vencimento_p,nm_usuario_p); -- Gerar título a receber para a contestação
			end if;
			
			/*open C01;
			loop
			fetch C01 into
				nr_seq_contestacao_w,
				vl_contestado_w,
				nr_seq_conta_w;
			exit when C01%notfound;
				begin
				pls_atualiza_status_copartic(nr_seq_conta_w, 'LC', nm_usuario_p, cd_estabelecimento_p);
				end;
			end loop;
			close C01;*/
		end if;
	end if;
end if;

-- Estorno das ações que podem ocorrer durante o fechamento da contestação
if (coalesce(ie_estorno_p,'N') = 'S') then
	update	pls_lote_contestacao
	set	dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		dt_fechamento	 = NULL,
		ie_status	= 'A'
	where	nr_sequencia	= nr_seq_lote_contest_p;
	
	select	max(a.nr_seq_ptu_fatura)
	into STRICT	nr_seq_fatura_w
	from	pls_lote_contestacao a
	where	a.nr_sequencia	= nr_seq_lote_contest_p;
	
	-- Gerar título a receber
	select	max(nr_titulo)
	into STRICT	nr_titulo_rec_w
	from	titulo_receber
	where	nr_seq_pls_lote_contest = nr_seq_lote_contest_p
	and	nr_seq_ptu_fatura	= nr_seq_fatura_w;
	
	if (nr_titulo_rec_w IS NOT NULL AND nr_titulo_rec_w::text <> '') then
		CALL cancelar_titulo_receber(nr_titulo_rec_w,nm_usuario_p,'N',clock_timestamp());
	end if;
	
	-- Baixar valor glosado no título
	select	max(a.nr_titulo)
	into STRICT	nr_titulo_pag_w
	from	ptu_fatura a
	where	a.nr_sequencia	= nr_seq_fatura_w;
	
	select	count(1)
	into STRICT	qt_registro_w
	from	titulo_pagar_baixa
	where	nr_titulo		= nr_titulo_pag_w
	and	nr_seq_pls_lote_contest	= nr_seq_lote_contest_p;
	
	nr_seq_acao_w := pls_obter_acao_intercambio(	'6',  -- Fechamento da contestação
					'7',  -- Baixar glosas no título a pagar
					nr_seq_fatura_w, null, null, null, clock_timestamp(), 'A550', ie_estorno_p, nr_seq_acao_w);
	
	if (qt_registro_w > 0) and (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') then
		CALL pls_baixar_glosas_contestacao(nr_seq_lote_contest_p,nr_seq_acao_w,nr_titulo_pag_w,nr_seq_fatura_w,'S','N',nm_usuario_p,cd_estabelecimento_p);
	end if;
	
	-- Liberar pagamento do título	
	if (nr_titulo_pag_w IS NOT NULL AND nr_titulo_pag_w::text <> '') then
		update	titulo_pagar
		set	dt_liberacao	 = NULL,
			nm_usuario_lib	 = NULL
		where	nr_titulo	= nr_titulo_pag_w;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_fechar_contestacao ( nr_seq_lote_contest_p bigint, dt_vencimento_p timestamp, ie_estorno_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

