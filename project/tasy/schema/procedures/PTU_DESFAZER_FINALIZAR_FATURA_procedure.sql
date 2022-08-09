-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_desfazer_finalizar_fatura (nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

					
cd_estabelecimento_w		smallint;
nr_seq_protocolo_w		bigint;
nr_seq_lote_contest_w		bigint := null;
nr_seq_acao_w			bigint;
nr_titulo_w			bigint;
nr_titulo_pag_w			bigint;
qt_registro_w			bigint;
nr_titulo_ndc_w			bigint;
nr_seq_escrit_w			titulo_pagar_escrit.nr_seq_escrit%type;
nr_bordero_w			bordero_pagamento.nr_bordero%type;
ie_parametro_35_w		varchar(255);
qt_glosa_estorno_w		integer := 0; -- Contador de glosa para o estorno
qt_glosa_status_w		integer := 0; -- Contador de glosa para alteração de status
dt_mes_competencia_w		ptu_fatura.dt_mes_competencia%type;


BEGIN

-- Verifica se a fatura já está em um lote contábil
select	max(dt_mes_competencia)
into STRICT	dt_mes_competencia_w
from	ptu_fatura
where	nr_sequencia = nr_seq_fatura_p;

-- Não é possível executar esta ação, pois existe lote do tipo 'OPS Despesas - Contas Intercâmbio' gerado para a competência. 
if (obter_se_lote_contabil_gerado(33, dt_mes_competencia_w) = 'S') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(682676);
end if;

-- Busca o valor do parâmetro [35] - Permite desfazer encerramento da fatura
ie_parametro_35_w := Obter_Param_Usuario(1293, 35, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_parametro_35_w);

CALL ptu_atualizar_status_fatura(nr_seq_fatura_p, 'AF', null, nm_usuario_p);

select	max(nr_sequencia)
into STRICT	nr_seq_lote_contest_w
from	pls_lote_contestacao
where	nr_seq_ptu_fatura = nr_seq_fatura_p;

select	max(a.nr_titulo),
	max(a.nr_titulo_ndc)
into STRICT	nr_titulo_pag_w,
	nr_titulo_ndc_w
from	ptu_fatura a
where	a.nr_sequencia = nr_seq_fatura_p;

select	max(b.nr_bordero)
into STRICT	nr_bordero_w
from	bordero_pagamento b,
	titulo_pagar_bordero_v a
where	a.nr_titulo = nr_titulo_pag_w
and	a.nr_bordero = b.nr_bordero
and	coalesce(b.dt_cancelamento::text, '') = '';

if (nr_bordero_w IS NOT NULL AND nr_bordero_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(329226,'NR_BORDERO=' ||nr_bordero_w); /*Não é possível desfazer o encerramento desta fatura!
											O título a pagar desta fatura já está inserido no borderô de pagamento #@NR_BORDERO#@.*/
end if;

select	max(b.nr_bordero)
into STRICT	nr_bordero_w
from	bordero_pagamento b,
	titulo_pagar_bordero_v a
where	a.nr_titulo = nr_titulo_ndc_w
and	a.nr_bordero = b.nr_bordero
and	coalesce(b.dt_cancelamento::text, '') = '';

if (nr_bordero_w IS NOT NULL AND nr_bordero_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(329226,'NR_BORDERO=' ||nr_bordero_w); /*Não é possível desfazer o encerramento desta fatura!
											O título a pagar desta fatura já está inserido no borderô de pagamento #@NR_BORDERO#@.*/
end if;

select	max(b.nr_seq_escrit)
into STRICT	nr_seq_escrit_w
from	titulo_pagar_escrit b
where	b.nr_titulo = nr_titulo_pag_w;

if (nr_seq_escrit_w IS NOT NULL AND nr_seq_escrit_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(329234,'NR_SEQ_ESCRIT=' ||nr_seq_escrit_w); /*Não é possível desfazer o encerramento desta fatura!
											O título a pagar desta fatura já está inserido no pagamento escritural #@NR_SEQ_ESCRIT#@.*/
end if;

select	max(b.nr_seq_escrit)
into STRICT	nr_seq_escrit_w
from	titulo_pagar_escrit b
where	b.nr_titulo = nr_titulo_ndc_w;

if (nr_seq_escrit_w IS NOT NULL AND nr_seq_escrit_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(329234,'NR_SEQ_ESCRIT=' ||nr_seq_escrit_w); /*Não é possível desfazer o encerramento desta fatura!
											O título a pagar desta fatura já está inserido no pagamento escritural #@NR_SEQ_ESCRIT#@.*/
end if;

-- Parâmetro [35] - Permite desfazer encerramento da fatura = 'Sim'
if (ie_parametro_35_w = 'S') then
	if (nr_seq_lote_contest_w IS NOT NULL AND nr_seq_lote_contest_w::text <> '') then
		-- Baixar valor glosado no título
		select	count(1)
		into STRICT	qt_registro_w
		from	titulo_pagar_baixa
		where	nr_titulo = nr_titulo_pag_w
		and	nr_seq_pls_lote_contest	= nr_seq_lote_contest_w;
		
		nr_seq_acao_w := pls_obter_acao_intercambio(	'12',  -- Encerrar fatura/reconhecer glosas
						'7',  -- Baixar glosas no título a pagar
						nr_seq_fatura_p, null, null, null, clock_timestamp(), 'A500', 'S', nr_seq_acao_w);
						
		if (qt_registro_w > 0) and (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') then
			CALL pls_baixar_glosas_contestacao(nr_seq_lote_contest_w,nr_seq_acao_w,nr_titulo_pag_w,nr_seq_fatura_p,'S','N',nm_usuario_p,cd_estabelecimento_p);
			
			update	titulo_pagar_baixa
			set	nr_seq_pls_lote_contest  = NULL
			where	nr_titulo = nr_titulo_pag_w
			and	nr_seq_pls_lote_contest	= nr_seq_lote_contest_w;
		end if;
		
		nr_seq_acao_w := pls_obter_acao_intercambio(	'12',  -- Encerrar fatura/reconhecer glosas
						'12',  -- Baixar glosas no título a pagar FATURA
						nr_seq_fatura_p, null, null, null, clock_timestamp(), 'A500', 'S', nr_seq_acao_w);
						
		if (qt_registro_w > 0) and (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') then
			CALL pls_baixar_glosas_contestacao(nr_seq_lote_contest_w,nr_seq_acao_w,nr_titulo_pag_w,nr_seq_fatura_p,'S','N',nm_usuario_p,cd_estabelecimento_p);
			
			update	titulo_pagar_baixa
			set	nr_seq_pls_lote_contest  = NULL
			where	nr_titulo = nr_titulo_pag_w
			and	nr_seq_pls_lote_contest	= nr_seq_lote_contest_w;
		end if;
		
		select	count(1)
		into STRICT	qt_registro_w
		from	titulo_pagar_baixa
		where	nr_titulo = nr_titulo_ndc_w
		and	nr_seq_pls_lote_contest	= nr_seq_lote_contest_w;
		
		nr_seq_acao_w := pls_obter_acao_intercambio(	'12',  -- Encerrar fatura/reconhecer glosas
						'13',  -- Baixar glosas no título a pagar NDC
						nr_seq_fatura_p, null, null, null, clock_timestamp(), 'A500', 'S', nr_seq_acao_w);
						
		if (qt_registro_w > 0) and (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') then
			CALL pls_baixar_glosas_contestacao(nr_seq_lote_contest_w,nr_seq_acao_w,nr_titulo_ndc_w,nr_seq_fatura_p,'S','N',nm_usuario_p,cd_estabelecimento_p);
			
			update	titulo_pagar_baixa
			set	nr_seq_pls_lote_contest  = NULL
			where	nr_titulo = nr_titulo_ndc_w
			and	nr_seq_pls_lote_contest	= nr_seq_lote_contest_w;
		end if;
		
		CALL pls_desfazer_lote_contestacao(nr_seq_lote_contest_w,cd_estabelecimento_p,nm_usuario_p);
	end if;
-- Parâmetro [35] - Permite desfazer encerramento da fatura = 'Permitir com baixas no título'
elsif (ie_parametro_35_w = 'P') then
	if (nr_titulo_pag_w IS NOT NULL AND nr_titulo_pag_w::text <> '') then
		select	count(1)
		into STRICT	qt_glosa_estorno_w
		from	titulo_pagar_baixa
		where	vl_glosa	> 0
		and	nr_titulo	= nr_titulo_pag_w;
	
		if (qt_glosa_estorno_w > 0) then
			CALL pls_estornar_tit_pag_fat(nr_titulo_pag_w, nm_usuario_p);
			qt_glosa_status_w := qt_glosa_estorno_w;
		end if;
	end if;
	
	if (nr_titulo_ndc_w IS NOT NULL AND nr_titulo_ndc_w::text <> '') then
		select	count(1)
		into STRICT	qt_glosa_estorno_w
		from	titulo_pagar_baixa
		where	vl_glosa	> 0
		and	nr_titulo	= nr_titulo_ndc_w;
	
		if (qt_glosa_estorno_w > 0) then
			CALL pls_estornar_tit_pag_fat(nr_titulo_ndc_w, nm_usuario_p);
			qt_glosa_status_w := qt_glosa_estorno_w;
		end if;
	end if;
	
	if (nr_seq_lote_contest_w IS NOT NULL AND nr_seq_lote_contest_w::text <> '') then
		CALL pls_desfazer_lote_contestacao(nr_seq_lote_contest_w,cd_estabelecimento_p,nm_usuario_p);
	end if;
end if;

-- Liberar pagamento do título
nr_seq_acao_w := pls_obter_acao_intercambio(	'12',  -- Encerrar fatura/reconhecer glosas
				'5',  -- Liberar pagamento do título
				nr_seq_fatura_p, null, null, null, clock_timestamp(), 'A500', 'S', nr_seq_acao_w);
				
if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') then
	if (nr_titulo_pag_w IS NOT NULL AND nr_titulo_pag_w::text <> '') then
		update	titulo_pagar
		set	dt_liberacao  = NULL,
			nm_usuario_lib  = NULL
		where	nr_titulo = nr_titulo_pag_w;
	end if;
	
	if (nr_titulo_ndc_w IS NOT NULL AND nr_titulo_ndc_w::text <> '') then
		update	titulo_pagar
		set	dt_liberacao  = NULL,
			nm_usuario_lib  = NULL
		where	nr_titulo = nr_titulo_ndc_w;
	end if;
end if;

nr_seq_acao_w := pls_obter_acao_intercambio(	'12',  -- Encerrar fatura/reconhecer glosas
				'8',  -- Mudar status do título a pagar
				nr_seq_fatura_p, null, null, null, clock_timestamp(), 'A500', 'N', nr_seq_acao_w);
				
if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') then
	-- Se tiver 'nr_titulo' e o parâmetro [35] - 'Permite desfazer encerramento da fatura' for 'Sim' ou 'Permitir com baixas no título' atualiza para'
	if (nr_titulo_pag_w IS NOT NULL AND nr_titulo_pag_w::text <> '') and (ie_parametro_35_w in ('S','P')) and (qt_glosa_status_w > 0) then
		update	titulo_pagar
		set	ie_status = 'P'
		where	nr_titulo = nr_titulo_pag_w;
	end if;
	
	-- Se tiver 'nr_titulo_ndc' e o parâmetro [35] - 'Permite desfazer encerramento da fatura' for 'Sim' ou 'Permitir com baixas no título'
	if (nr_titulo_ndc_w IS NOT NULL AND nr_titulo_ndc_w::text <> '') and (ie_parametro_35_w in ('S','P')) and (qt_glosa_status_w > 0) then
		update	titulo_pagar
		set	ie_status = 'P'
		where	nr_titulo = nr_titulo_ndc_w;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_desfazer_finalizar_fatura (nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
