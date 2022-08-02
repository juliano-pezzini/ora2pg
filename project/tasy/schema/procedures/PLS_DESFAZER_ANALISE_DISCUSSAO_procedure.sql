-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_analise_discussao ( nr_seq_lote_conta_p bigint, ie_liberado_manual_p text, nm_usuario_p text) AS $body$
DECLARE

 
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Desfazer a análise da discussão 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [X] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: Cuidado 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ 
 
nr_seq_analise_w	bigint;
qt_registro_w		bigint := 0;
nr_titulo_w		bigint;
nr_seq_pls_fatura_w	bigint;
nr_seq_acao_w		bigint;

C01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_analise_conta 
	where	nr_seq_lote_protocolo = nr_seq_lote_conta_p;


BEGIN 
select	count(1) 
into STRICT	qt_registro_w 
from	pls_analise_conta 
where	ie_status not in ('G','C','S') 
and	nr_seq_lote_protocolo = nr_seq_lote_conta_p;
 
-- Desfaz a análise apenas se não houver análise com status que não esteja como 'G - Aguardando auditoria', 'C - Atendimento cancelado' ou 'S - Atendimento sem auditoria', ou ainda, se o parâmetro [9] - 'Permite desfazer o envio para a análise' do módulo 
-- 'OPS - Controle de Contestações', estiver como 'C - Necessita da confirmação', ao utilizar a ação de menu 'Desfazer o envio para análise da discussão' o usuário será questionado se deseja desfazer mesmo assim, se for confirmado, o processo segue normalmente 
if (qt_registro_w = 0) or (ie_liberado_manual_p = 'S') then 
	open C01;
	loop 
	fetch C01 into 
		nr_seq_analise_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		delete	FROM pls_hist_analise_conta 
		where	nr_seq_analise = nr_seq_analise_w;
		 
		delete	FROM pls_analise_parecer_disc 
		where	nr_seq_w_disc_item in (	SELECT	nr_sequencia 
						from	w_pls_discussao_item 
						where	nr_seq_analise = nr_seq_analise_w);
						 
		delete	FROM pls_tempo_conta_grupo 
		where	nr_seq_auditoria in (	SELECT	nr_sequencia 
						from	pls_auditoria_conta_grupo 
						where	nr_seq_analise = nr_seq_analise_w);
						 
		delete	FROM pls_auditoria_conta_grupo 
		where	nr_seq_analise = nr_seq_analise_w;
		 
		delete	FROM pls_analise_conta_item 
		where	nr_seq_analise = nr_seq_analise_w;
		 
		delete	FROM w_pls_discussao_item 
		where	nr_seq_analise = nr_seq_analise_w;
		 
		update	pls_contestacao_discussao 
		set	nr_seq_analise	 = NULL 
		where	nr_seq_analise	= nr_seq_analise_w;
		 
		delete	FROM pls_analise_conta 
		where	nr_sequencia = nr_seq_analise_w;
		end;
	end loop;
	close C01;
	 
	select	max(nr_seq_pls_fatura) 
	into STRICT	nr_seq_pls_fatura_w 
	from	pls_lote_contestacao x, 
		pls_lote_discussao z 
	where	x.nr_sequencia = z.nr_seq_lote_contest 
	and	nr_seq_lote_conta = nr_seq_lote_conta_p;
	 
	-- Cancelar o título gerado pelo o envio da discussão para a análise 
	if (nr_seq_pls_fatura_w IS NOT NULL AND nr_seq_pls_fatura_w::text <> '') then 
		nr_seq_acao_w := pls_obter_acao_intercambio(	'9',  -- Encaminhamento da discussão para análise 
						'2',  -- Gerar título a pagar 
						null, nr_seq_pls_fatura_w, null, null, clock_timestamp(), 'A550', 'S', nr_seq_acao_w);
						 
		if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') then 
			select	max(nr_titulo_pagar) 
			into STRICT	nr_titulo_w 
			from	pls_lote_discussao 
			where	nr_seq_lote_conta = nr_seq_lote_conta_p;
			 
			if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then 
				CALL cancelar_titulo_pagar(nr_titulo_w,nm_usuario_p,clock_timestamp());
			end if;
		end if;
	end if;
	 
	update	pls_lote_discussao 
	set	nr_seq_lote_conta  = NULL, 
		ie_status	= 'A' 
	where	nr_seq_lote_conta = nr_seq_lote_conta_p;
	 
	update	pls_lote_protocolo_conta 
	set	ie_status	= 'C' 
	where	nr_sequencia	= nr_seq_lote_conta_p;
	 
	commit;
else	 
	-- Não é permitido desfazer o envio para análise, pois existe análise iniciada. 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(357730);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_analise_discussao ( nr_seq_lote_conta_p bigint, ie_liberado_manual_p text, nm_usuario_p text) FROM PUBLIC;

