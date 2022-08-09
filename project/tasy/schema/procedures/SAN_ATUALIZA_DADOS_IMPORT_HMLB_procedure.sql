-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_atualiza_dados_import_hmlb ( nr_seq_lote_p bigint , nr_seq_exame_p bigint , dt_vencimento_p timestamp , nr_seq_kit_p bigint , ds_resultado_p text , nm_usuario_p text , ie_set_null_p bigint default 0) AS $body$
DECLARE

dt_vencimento_w timestamp;
ds_resultado_w varchar(255) := null;


BEGIN

if (nr_seq_lote_p > 0)  and (nr_seq_exame_p > 0) then
	
		if ( ie_set_null_p = 0 ) then
			select	CASE WHEN coalesce(ds_resultado_p::text, '') = '' THEN  ds_resultado  ELSE ds_resultado_p END
				into STRICT 	ds_resultado_w
			from	san_exame_realizado
			where	nr_seq_exame_lote  = nr_seq_lote_p
			and 	nr_seq_exame     = nr_seq_exame_p;
		end if;

		update	san_exame_realizado
		set	ds_resultado = ds_resultado_w,
			nr_kit_lote = CASE WHEN nr_seq_kit_p=0 THEN  nr_kit_lote  ELSE nr_seq_kit_p END ,
			dt_vencimento_lote = CASE WHEN dt_vencimento_p = NULL THEN  dt_vencimento_lote  ELSE dt_vencimento_p END
		where	nr_seq_exame_lote  = nr_seq_lote_p
		and	nr_seq_exame 	   = nr_seq_exame_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_atualiza_dados_import_hmlb ( nr_seq_lote_p bigint , nr_seq_exame_p bigint , dt_vencimento_p timestamp , nr_seq_kit_p bigint , ds_resultado_p text , nm_usuario_p text , ie_set_null_p bigint default 0) FROM PUBLIC;
