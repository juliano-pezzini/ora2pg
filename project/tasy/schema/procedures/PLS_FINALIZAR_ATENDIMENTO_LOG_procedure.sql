-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_finalizar_atendimento_log ( nr_seq_atendimento_p bigint, qt_tempo_p bigint, nr_seq_motivo_conclus_p text, nm_usuario_p text, ie_origem_historico_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nr_seq_evento_w	bigint;


BEGIN 
 
select	nr_sequencia 
into STRICT	nr_seq_evento_w 
from	pls_atendimento_evento 
where	nr_seq_atendimento	= nr_seq_atendimento_p 
and	coalesce(dt_fim_evento::text, '') = '';
 
CALL pls_finalizar_atendimento( 
	nr_seq_atendimento_p, 
	nr_seq_evento_w, 
	qt_tempo_p, 
	nr_seq_motivo_conclus_p, 
	nm_usuario_p);
 
CALL pls_gerar_hist_log_atend( 
	nr_seq_atendimento_p, 
	ie_origem_historico_p, 
	'', 
	nm_usuario_p, 
	cd_estabelecimento_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_finalizar_atendimento_log ( nr_seq_atendimento_p bigint, qt_tempo_p bigint, nr_seq_motivo_conclus_p text, nm_usuario_p text, ie_origem_historico_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
