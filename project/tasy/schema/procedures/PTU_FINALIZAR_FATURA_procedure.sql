-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_finalizar_fatura ( nr_seq_fatura_p ptu_fatura.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE


dt_mes_competencia_w		ptu_fatura.dt_mes_competencia%type;
cd_estabelecimento_w		smallint;
nr_seq_protocolo_w		bigint;
nr_seq_lote_contest_w		bigint := null;
nr_seq_acao_w			bigint;
nr_titulo_w			bigint;
qt_analise_w			bigint := 0;
nr_titulo_ndc_w			bigint;
vl_total_1_w			double precision;
vl_total_2_w			double precision;
ie_perm_desf_fat_baixa_w	varchar(255);
vl_titulo_w			titulo_pagar.vl_titulo%type;
vl_saldo_titulo_w		titulo_pagar.vl_saldo_titulo%type;
qt_baixas_tit_w			integer;
nr_seq_lote_w			pls_protocolo_conta.nr_seq_lote_conta%type;
qt_pre_analise_w		integer := 0;


BEGIN
select	max(a.dt_mes_competencia),
	max(a.nr_titulo),
	max(a.nr_titulo_ndc),
	max(a.cd_estabelecimento)
into STRICT	dt_mes_competencia_w,
	nr_titulo_w,
	nr_titulo_ndc_w,
	cd_estabelecimento_w
from	ptu_fatura a
where	a.nr_sequencia = nr_seq_fatura_p;

if (obter_se_lote_contabil_gerado(33, dt_mes_competencia_w) = 'S') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(682676);
end if;

select	count(1)
into STRICT	qt_analise_w
from	pls_conta
where	nr_seq_fatura = nr_seq_fatura_p
and	ie_status not in ('F','C');

if (qt_analise_w > 0) then	
	CALL wheb_mensagem_pck.exibir_mensagem_abort(236221);
end if;

-- Atualizar valores da fatura
CALL pls_atualizar_valor_ptu_fatura( nr_seq_fatura_p, 'N');

select	max(b.nr_seq_lote_conta)
into STRICT	nr_seq_lote_w
from	ptu_fatura a,
	pls_protocolo_conta b
where	a.nr_sequencia 	   = nr_seq_fatura_p
and	a.nr_seq_protocolo = b.nr_sequencia;

if (nr_seq_lote_w IS NOT NULL AND nr_seq_lote_w::text <> '') then
	select	count(1)
	into STRICT	qt_pre_analise_w
	from	pls_protocolo_conta a,
		pls_conta b,
		pls_analise_conta c
	where	a.nr_seq_lote_conta	= nr_seq_lote_w
	and 	a.nr_sequencia		= b.nr_seq_protocolo
	and 	b.nr_seq_analise	= c.nr_sequencia
	and 	ie_pre_analise		= 'S';

	if (qt_pre_analise_w > 0 ) then
		CALL pls_finalizar_pre_analise(nr_seq_lote_w, wheb_usuario_pck.get_cd_estabelecimento, nm_usuario_p);
	end if;
end if;

--Consistir se há diferença entre os valores liberados e contestados
select (coalesce(vl_total, 0) + coalesce(vl_glosa, 0) + coalesce(vl_liberado_ndc, 0) + coalesce(vl_glosa_ndc, 0)),	-- Vl liberado Doc 1 + Vl glosa Doc 1 + Vl liberado Doc 2 + Vl glosa Doc 2
	(coalesce(vl_total_fatura, 0) + coalesce(vl_total_ndc, 0))					-- Vl total Doc 1 + Vl total Doc 2
into STRICT	vl_total_1_w,
	vl_total_2_w
from	ptu_fatura
where	nr_sequencia = nr_seq_fatura_p;

if (vl_total_1_w != vl_total_2_w) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(495478, 'NR_SEQ_FATURA_P=' || nr_seq_fatura_p);
	-- Caso tenha entrado aqui, verificar a rotina PLS_ATUALIZAR_VALOR_PTU_FATURA
end if;	

-- Alterar status da fatura
CALL ptu_atualizar_status_fatura(nr_seq_fatura_p, 'E', null, nm_usuario_p);

-- Busca o valor do parâmetro [35] - Permite desfazer encerramento da fatura
ie_perm_desf_fat_baixa_w := Obter_Param_Usuario(1293, 35, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_perm_desf_fat_baixa_w);

select	max(a.nr_sequencia)
into STRICT	nr_seq_protocolo_w
from	pls_protocolo_conta	a,
	ptu_fatura		b
where	b.nr_seq_protocolo = a.nr_sequencia
and	coalesce(a.nr_seq_prestador::text, '') = ''
and	(a.nr_seq_congenere IS NOT NULL AND a.nr_seq_congenere::text <> '')
and	b.nr_sequencia = nr_seq_fatura_p;

-- Quando não tem prestador e tem operadora congenere (fundações), deve ser atualizado o status do lote protocolo

-- para liberado para pagamento, desta forma podendo gerar o faturamento - OS 479506 / William C Bernardino
if (nr_seq_protocolo_w IS NOT NULL AND nr_seq_protocolo_w::text <> '') then
	update	pls_protocolo_conta
	set	ie_status = '3'
	where	nr_sequencia = nr_seq_protocolo_w;
end if;

select	max(nr_sequencia)
into STRICT	nr_seq_lote_contest_w
from	pls_lote_contestacao
where	nr_seq_ptu_fatura = nr_seq_fatura_p;

if (nr_seq_lote_contest_w IS NOT NULL AND nr_seq_lote_contest_w::text <> '') then
	CALL pls_desfazer_lote_contestacao(nr_seq_lote_contest_w, cd_estabelecimento_w, nm_usuario_p);
	nr_seq_lote_contest_w	:= null;
end if;

nr_seq_lote_contest_w := pls_gerar_lote_contestacao(nr_seq_fatura_p, nr_seq_lote_contest_w, cd_estabelecimento_w, nm_usuario_p);

nr_seq_acao_w := pls_obter_acao_intercambio(	'12',  -- Encerrar fatura/reconhecer glosas
				'5',  -- Liberar pagamento do título
				nr_seq_fatura_p, null, null, null, clock_timestamp(), 'A500', 'N', nr_seq_acao_w);

if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') then	
	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
		CALL pls_liberar_fatura_pagamento(nr_titulo_w,nm_usuario_p);
	end if;
	
	if (nr_titulo_ndc_w IS NOT NULL AND nr_titulo_ndc_w::text <> '') then
		CALL pls_liberar_fatura_pagamento(nr_titulo_ndc_w,nm_usuario_p);
	end if;	
end if;

nr_seq_acao_w := pls_obter_acao_intercambio(	'12',  -- Encerrar fatura/reconhecer glosas
				'8',  -- Mudar status do título a pagar
				nr_seq_fatura_p, null, null, null, clock_timestamp(), 'A500', 'N', nr_seq_acao_w);

if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') then
	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
		CALL pls_alterar_status_fatura_pag(nr_titulo_w,nm_usuario_p);
	end if;
	
	if (nr_titulo_ndc_w IS NOT NULL AND nr_titulo_ndc_w::text <> '') then
		CALL pls_alterar_status_fatura_pag(nr_titulo_ndc_w,nm_usuario_p);
	end if;
end if;

if (nr_seq_lote_contest_w IS NOT NULL AND nr_seq_lote_contest_w::text <> '') then	
	nr_seq_acao_w := pls_obter_acao_intercambio(	'12',  -- Encerrar fatura/reconhecer glosas
					'7',  -- Baixar glosas no título a pagar
					nr_seq_fatura_p, null, null, null, clock_timestamp(), 'A500', 'N', nr_seq_acao_w);
					
	if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') and (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
		CALL pls_baixar_glosas_contestacao(nr_seq_lote_contest_w,nr_seq_acao_w,nr_titulo_w,nr_seq_fatura_p,'N',ie_perm_desf_fat_baixa_w,nm_usuario_p,cd_estabelecimento_w);
	end if;
	
	nr_seq_acao_w := pls_obter_acao_intercambio(	'12',  -- Encerrar fatura/reconhecer glosas
					'12',  -- Baixar glosas no título a pagar FATURA
					nr_seq_fatura_p, null, null, null, clock_timestamp(), 'A500', 'N', nr_seq_acao_w);
					
	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
		select	max(coalesce(vl_titulo,0)),
			max(coalesce(vl_saldo_titulo,0))
		into STRICT	vl_titulo_w,
			vl_saldo_titulo_w
		from	titulo_pagar
		where	nr_titulo = nr_titulo_w
		and	ie_situacao <> 'C';
		
		select	count(1)
		into STRICT	qt_baixas_tit_w
		from	titulo_pagar_baixa
		where	nr_titulo = nr_titulo_w;
		
		-- Realiza a baixa se tiver ação configurada em regra, ou quando o parâmetro 35 - 'Permite desfazer encerramento da fatura' estiver como 'Permitir com baixas no título', não tiver valor baixado e existir baixa no título
		if	((nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') or ((ie_perm_desf_fat_baixa_w = 'P') and (vl_titulo_w = vl_saldo_titulo_w) and (qt_baixas_tit_w > 0))) then
			CALL pls_baixar_glosas_contestacao(nr_seq_lote_contest_w,nr_seq_acao_w,nr_titulo_w,nr_seq_fatura_p,'N',ie_perm_desf_fat_baixa_w,nm_usuario_p,cd_estabelecimento_w);
		end if;
	end if;
	
	nr_seq_acao_w := pls_obter_acao_intercambio(	'12',  -- Encerrar fatura/reconhecer glosas
					'13',  -- Baixar glosas no título a pagar NDC
					nr_seq_fatura_p, null, null, null, clock_timestamp(), 'A500', 'N', nr_seq_acao_w);
					
	if (nr_titulo_ndc_w IS NOT NULL AND nr_titulo_ndc_w::text <> '') then
		select	max(coalesce(vl_titulo,0)),
			max(coalesce(vl_saldo_titulo,0))
		into STRICT	vl_titulo_w,
			vl_saldo_titulo_w
		from	titulo_pagar
		where	nr_titulo = nr_titulo_ndc_w
		and	ie_situacao <> 'C';
		
		select	count(1)
		into STRICT	qt_baixas_tit_w
		from	titulo_pagar_baixa
		where	nr_titulo = nr_titulo_ndc_w;
		
		-- Realiza a baixa se tiver ação configurada em regra, ou quando o parâmetro 35 - 'Permite desfazer encerramento da fatura' estiver como 'Permitir com baixas no título', não tiver valor baixado e existir baixa no título
		if	((nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') or ((ie_perm_desf_fat_baixa_w = 'P') and (vl_titulo_w = vl_saldo_titulo_w) and (qt_baixas_tit_w > 0))) then
			CALL pls_baixar_glosas_contestacao(nr_seq_lote_contest_w,nr_seq_acao_w,nr_titulo_ndc_w,nr_seq_fatura_p,'N',ie_perm_desf_fat_baixa_w,nm_usuario_p,cd_estabelecimento_w);
		end if;
	end if;
	
	-- Para garantir, se ocorreu alguma baixa, tem que atualizar os valores da contestação
	CALL pls_ajustar_vl_fat_ndc_contest( nr_seq_fatura_p, nr_seq_lote_contest_w, 'N');
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_finalizar_fatura ( nr_seq_fatura_p ptu_fatura.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;
