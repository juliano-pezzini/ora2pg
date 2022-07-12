-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_faturamento_pck.verificar_se_inicia_geracao ( nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


current_setting('pls_faturamento_pck.qt_registro_w')::integer			integer;
qt_lote_fat_w			integer;
dt_mesano_competencia_w		timestamp;
ie_mes_fechado_w		varchar(1) := 'N';


BEGIN

---------- -----  1 - Verifica se a integridade entre o lote de faturamento e o item de contas medicas esta desabilitada ----- ----------
select	count(1)
into STRICT	current_setting('pls_faturamento_pck.qt_registro_w')::integer
from 	user_constraints
where 	constraint_name = 'PLSCOVB_PLSLOFA_FK'
and	status = 'DISABLED';

if (current_setting('pls_faturamento_pck.qt_registro_w')::integer > 0) then
	-- A integridade entre o lote de faturamento e o item de contas medicas esta desabilitada, verifique com o suporte. (PLSCOVB_PLSLOFA_FK)
	CALL wheb_mensagem_pck.exibir_mensagem_abort(817971);
end if;

---------- ---------- ---------- ---------- --- 2 - Verificar se existe competencia para o mes e se a competencia nao esteja fechada --- ---------- ---------- ---------- ----------
select	count(1),
	max(trunc(a.dt_mesano_referencia, 'month'))
into STRICT	qt_lote_fat_w,
	dt_mesano_competencia_w
from	pls_competencia		b,
	pls_lote_faturamento	a
where	a.nr_sequencia 		= nr_seq_lote_p
and	a.cd_estabelecimento	= cd_estabelecimento_p
and	trunc(b.dt_mes_competencia, 'month') = trunc(a.dt_mesano_referencia, 'month')  LIMIT 1;

if (qt_lote_fat_w = 0) then
	-- Lote nao gerado, pois nao existe competencia para o mes deste lote.
	-- Favor verificar a regra de competencia, em OPS - Gestao de Operadoras -> Competencias -> Mes competencia.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(821695);
else
	select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
	into STRICT	ie_mes_fechado_w
	from	pls_competencia
	where	cd_estabelecimento = cd_estabelecimento_p
	and	trunc(dt_mes_competencia, 'month') = dt_mesano_competencia_w
	and	(dt_fechamento IS NOT NULL AND dt_fechamento::text <> '');
	
	if (ie_mes_fechado_w = 'S') then
		-- Lote nao gerado, pois a competencia para o mes deste lote esta fechada.
		-- Favor verificar a regra de competencia, em OPS - Gestao de Operadoras -> Competencias -> Mes competencia.
		CALL wheb_mensagem_pck.exibir_mensagem_abort(821696);
	end if;
end if;

-- Iniciar geracao do lote de faturamento
CALL pls_gerar_fatura_log( nr_seq_lote_p, null, null, 'PLS_FATURAMENTO_PCK.GERAR_LOTE_FATURAMENTO()', 'GL', 'S', nm_usuario_p);
PERFORM set_config('pls_faturamento_pck.dt_inicio_geracao_w', clock_timestamp(), false);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_faturamento_pck.verificar_se_inicia_geracao ( nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
