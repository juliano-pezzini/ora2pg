-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_gerar_dem_fatura (nr_seq_demonstrativo_p bigint, nr_fatura_p text, vl_processado_p bigint, vl_liberado_p bigint, vl_glosado_p bigint, nm_usuario_p text, nr_seq_fatura_p INOUT bigint) AS $body$
DECLARE



nr_sequencia_w	bigint;


BEGIN

select	nextval('tiss_dem_fatura_seq')
into STRICT	nr_sequencia_w
;

insert into tiss_dem_fatura(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_seq_demonstrativo,
	nr_fatura,
	vl_processado,
	vl_liberado,
	vl_glosado)
values (	nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_demonstrativo_p,
	nr_fatura_p,
	vl_processado_p,
        vl_liberado_p,
	vl_glosado_p);

nr_seq_fatura_p	:= nr_sequencia_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_gerar_dem_fatura (nr_seq_demonstrativo_p bigint, nr_fatura_p text, vl_processado_p bigint, vl_liberado_p bigint, vl_glosado_p bigint, nm_usuario_p text, nr_seq_fatura_p INOUT bigint) FROM PUBLIC;

