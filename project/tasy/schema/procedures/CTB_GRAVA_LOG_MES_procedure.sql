-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_grava_log_mes (nr_sequencia_p INOUT bigint, nm_usuario_p text, nr_seq_mes_ref_p bigint, cd_log_contabil_p text, ds_observacao_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;


BEGIN

if (coalesce(nr_sequencia_p,0) = 0) then
	begin
	if (cd_log_contabil_p IS NOT NULL AND cd_log_contabil_p::text <> '') and (nr_seq_mes_ref_p IS NOT NULL AND nr_seq_mes_ref_p::text <> '') then
		begin

		select	nextval('ctb_mes_log_seq')
		into STRICT	nr_sequencia_w
		;

		insert into ctb_mes_log(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					nr_seq_mes_ref,
					cd_log_contabil,
					ds_observacao,
					dt_fim)
				values (nr_sequencia_w,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_mes_ref_p,
					cd_log_contabil_p,
					ds_observacao_p,
					CASE WHEN cd_log_contabil_p='0' THEN clock_timestamp() WHEN cd_log_contabil_p='1' THEN clock_timestamp() WHEN cd_log_contabil_p='2' THEN clock_timestamp() WHEN cd_log_contabil_p='3' THEN clock_timestamp() WHEN cd_log_contabil_p='4' THEN clock_timestamp()  ELSE null END );
		end;

		nr_sequencia_p	:= nr_sequencia_w;
	end if;
	end;
elsif (coalesce(nr_sequencia_p,0) > 0) then
	begin
	update	ctb_mes_log
	set	dt_fim 		= clock_timestamp(),
		ds_observacao	= CASE WHEN ds_observacao_p='' THEN ds_observacao  ELSE ds_observacao_p END
	where	nr_sequencia 	= nr_sequencia_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_grava_log_mes (nr_sequencia_p INOUT bigint, nm_usuario_p text, nr_seq_mes_ref_p bigint, cd_log_contabil_p text, ds_observacao_p text) FROM PUBLIC;
