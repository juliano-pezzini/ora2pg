-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_inserir_evolucao (cd_medico_p text, nr_ficha_p bigint, ds_evolucao_p text, dt_evolucao_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_seq_cliente_w	bigint;
nr_seq_evolucao_w	bigint;


BEGIN


select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_cliente_w
from	med_cliente
where	cd_medico		= cd_medico_p
and	cd_pessoa_sist_orig	= nr_ficha_p;

if (nr_seq_cliente_w > 0) and (coalesce(dt_evolucao_p, trunc(clock_timestamp())) <= clock_timestamp() + interval '100 days') then
	begin

	select	nextval('med_evolucao_seq')
	into STRICT	nr_seq_evolucao_w
	;

	insert	into med_evolucao(nr_sequencia,
		dt_evolucao,
		nr_seq_cliente,
		dt_atualizacao,
		nm_usuario,
		ds_evolucao)
	values (nr_seq_evolucao_w,
		coalesce(dt_evolucao_p, trunc(clock_timestamp())),
		nr_seq_cliente_w,
		clock_timestamp(), nm_usuario_p,
		ds_evolucao_p);

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_inserir_evolucao (cd_medico_p text, nr_ficha_p bigint, ds_evolucao_p text, dt_evolucao_p timestamp, nm_usuario_p text) FROM PUBLIC;
