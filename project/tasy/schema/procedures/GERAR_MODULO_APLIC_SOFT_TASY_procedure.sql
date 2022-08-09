-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_modulo_aplic_soft_tasy ( nr_sequencia_p bigint, ds_modulo_p text, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(nr_sequencia_p,0) > 0) and (coalesce(ds_modulo_p,'X') <> 'X') then
	begin
	insert into aplicacao_soft_modulo(
			nr_sequencia,
			nr_seq_aplicacao,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ds_modulo,
			ie_situacao)
		values (	nextval('aplicacao_soft_modulo_seq'),
			nr_sequencia_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			ds_modulo_p,
			'A');

	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_modulo_aplic_soft_tasy ( nr_sequencia_p bigint, ds_modulo_p text, nm_usuario_p text) FROM PUBLIC;
