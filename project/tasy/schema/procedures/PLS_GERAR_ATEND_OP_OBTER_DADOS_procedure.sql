-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_atend_op_obter_dados ( nr_seq_atendimento_p bigint, nr_seq_operador_p text, qt_tempo_p bigint, nm_usuario_p text, ie_direcionamento_p text, cd_funcao_p bigint, qt_max_hist_atend_p INOUT bigint, qt_segundos_p INOUT bigint, nr_porta_p INOUT text) AS $body$
BEGIN

CALL pls_gerar_atendimento_operador(
	nr_seq_atendimento_p,
	nr_seq_operador_p,
	qt_tempo_p,
	nm_usuario_p,
	ie_direcionamento_p);

select	coalesce(pls_obter_max_hist_atendimento(nr_seq_atendimento_p), 0)
into STRICT	qt_max_hist_atend_p
;

select	round((clock_timestamp() - dt_inicio) * 86400,2)
into STRICT	qt_segundos_p
from	pls_atendimento
where	nr_sequencia	= nr_seq_atendimento_p;

select	nr_porta
into STRICT	nr_porta_p
from	usuario_conectado
where	cd_funcao		= cd_funcao_p
and	nm_usuario	= nm_usuario_p
and	coalesce(dt_fim_conexao::text, '') = '';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_atend_op_obter_dados ( nr_seq_atendimento_p bigint, nr_seq_operador_p text, qt_tempo_p bigint, nm_usuario_p text, ie_direcionamento_p text, cd_funcao_p bigint, qt_max_hist_atend_p INOUT bigint, qt_segundos_p INOUT bigint, nr_porta_p INOUT text) FROM PUBLIC;

