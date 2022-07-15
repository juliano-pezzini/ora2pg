-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE assinar_contrato ( nr_sequencia_p bigint, dt_assinatura_p timestamp, nm_usuario_p text) AS $body$
DECLARE


ds_titulo_w	varchar(255);
ds_historico_w	varchar(255);


BEGIN


update	contrato
set	dt_assinatura			= dt_assinatura_p,
	nm_usuario_assinat		= nm_usuario_p,
	dt_assinatura_orig		= dt_assinatura_p,
	nm_usuario_assinat_orig		= nm_usuario_p
where	nr_sequencia			= nr_sequencia_p;

ds_titulo_w	:= wheb_mensagem_pck.get_texto(328837);
ds_historico_w	:= substr(wheb_mensagem_pck.get_texto(328840, 'DT_ASSINATURA='||to_char(dt_assinatura_p, 'dd/mm/yyyy')||
							';NM_USUARIO='||nm_usuario_p),1,2000);

insert into contrato_historico(
	nr_sequencia,
	nr_seq_contrato,
	dt_historico,
	ds_historico,
	dt_atualizacao,
	nm_usuario,
	ds_titulo,
	dt_liberacao,
	nm_usuario_lib)
values (	nextval('contrato_historico_seq'),
	nr_sequencia_p,
	clock_timestamp(),
	ds_historico_w,
	clock_timestamp(),
	nm_usuario_p,
	ds_titulo_w,
	clock_timestamp(),
	nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE assinar_contrato ( nr_sequencia_p bigint, dt_assinatura_p timestamp, nm_usuario_p text) FROM PUBLIC;

