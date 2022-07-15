-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_result_san_exame_js ( vl_resultado_p bigint, ds_resultado_p text, nr_seq_exame_p bigint, nr_seq_exame_lote_p bigint, ds_descricao_p text, nm_usuario_p text) AS $body$
BEGIN

if (vl_resultado_p > 0) then

	update	san_exame_realizado
	set   	ds_resultado   		= to_char(ds_resultado_p),
		nm_usuario     		= nm_usuario_p,
		vl_resultado   		= vl_resultado_p,
		dt_atualizacao 		= clock_timestamp()
	where  	nr_seq_exame      	= nr_seq_exame_p
	and    	nr_seq_exame_lote 	= nr_seq_exame_lote_p;

end if;

if	((ds_descricao_p <> '') or (ds_descricao_p IS NOT NULL AND ds_descricao_p::text <> '')) then

	update	san_exame_realizado
        set   	ds_resultado   		= ds_descricao_p,
                nm_usuario     		= nm_usuario_p,
                dt_atualizacao 		= clock_timestamp()
	where	nr_seq_exame      	= nr_seq_exame_p
        and    	nr_seq_exame_lote 	= nr_seq_exame_lote_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_result_san_exame_js ( vl_resultado_p bigint, ds_resultado_p text, nr_seq_exame_p bigint, nr_seq_exame_lote_p bigint, ds_descricao_p text, nm_usuario_p text) FROM PUBLIC;

