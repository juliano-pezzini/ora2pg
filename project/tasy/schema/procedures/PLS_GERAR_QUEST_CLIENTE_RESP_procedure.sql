-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_quest_cliente_resp ( nr_seq_restricao_p bigint, nr_seq_pergunta_p bigint, nm_usuario_p text, ds_resultado_p text, vl_resultado_p bigint, dt_resultado_p timestamp, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


qt_reg_w	smallint;


BEGIN
select	count(*)
into STRICT	qt_reg_w
from	pls_quest_cliente_resposta
where	nr_seq_questionario	= nr_seq_restricao_p
and	nr_seq_pergunta		= nr_seq_pergunta_p;

if (qt_reg_w > 0) then
	update	pls_quest_cliente_resposta
	set	ds_resultado		= ds_resultado_p,
		vl_resultado		= vl_resultado_p,
		dt_resultado		= dt_resultado_p
	where	nr_seq_questionario	= nr_seq_restricao_p
	and	nr_seq_pergunta		= nr_seq_pergunta_p;

	nr_sequencia_p	:= 0;
else
	select	nextval('pls_quest_cliente_resposta_seq')
	into STRICT	nr_sequencia_p
	;

	insert into pls_quest_cliente_resposta(
		nr_sequencia,
		nr_seq_questionario,
		dt_atualizacao,
		nm_usuario,
		nr_seq_pergunta,
		ds_resultado,
		vl_resultado,
		dt_resultado)
	values (nr_sequencia_p,
		nr_seq_restricao_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_pergunta_p,
		ds_resultado_p,
		vl_resultado_p,
		dt_resultado_p);
end if;

commit;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_quest_cliente_resp ( nr_seq_restricao_p bigint, nr_seq_pergunta_p bigint, nm_usuario_p text, ds_resultado_p text, vl_resultado_p bigint, dt_resultado_p timestamp, nr_sequencia_p INOUT bigint) FROM PUBLIC;
