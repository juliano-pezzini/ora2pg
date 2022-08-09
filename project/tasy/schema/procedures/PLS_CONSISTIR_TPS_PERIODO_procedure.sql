-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_tps_periodo ( dt_inicial_p timestamp, dt_final_p timestamp, nr_sequencia_p bigint, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


nr_seq_lote_w	bigint;					
					

BEGIN
if (dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '') and (dt_final_p IS NOT NULL AND dt_final_p::text <> '') then
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_lote_w
	from	pls_tps a
	where	nr_sequencia 		<> nr_sequencia_p
	and	cd_estabelecimento	= cd_estabelecimento_p
	and (dt_inicial_p between dt_periodo_inicial and dt_periodo_final
	or	dt_final_p between dt_periodo_inicial and dt_periodo_final);
	
	if (nr_seq_lote_w IS NOT NULL AND nr_seq_lote_w::text <> '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(188962,'NR_SEQ_LOTE='||nr_seq_lote_w);
	end if;	
end if;	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_tps_periodo ( dt_inicial_p timestamp, dt_final_p timestamp, nr_sequencia_p bigint, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
