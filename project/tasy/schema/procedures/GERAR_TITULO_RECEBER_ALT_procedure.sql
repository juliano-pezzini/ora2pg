-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_titulo_receber_alt ( nr_titulo_p bigint, nm_usuario_p text, ds_valor_atual_p text, ds_valor_ant_p text, nm_atributo text) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN


	if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then
		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	nr_sequencia_w
		from	titulo_receber_alt
		where	nr_titulo = nr_titulo_p;

		insert	into titulo_receber_alt(
			nr_titulo,
			nr_sequencia,
			nm_usuario,
			nm_atributo,
			dt_atualizacao,
			ds_valor_atual,
			ds_valor_ant)
		values ( nr_titulo_p,
			nr_sequencia_w,
			nm_usuario_p,
			nm_atributo,
			clock_timestamp(),
			ds_valor_atual_p,
			ds_valor_ant_p);
		
	end if;

	commit;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_titulo_receber_alt ( nr_titulo_p bigint, nm_usuario_p text, ds_valor_atual_p text, ds_valor_ant_p text, nm_atributo text) FROM PUBLIC;
