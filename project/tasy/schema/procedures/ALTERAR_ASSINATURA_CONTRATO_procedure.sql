-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_assinatura_contrato ( nr_sequencia_p bigint, dt_assinatura_p timestamp, nm_usuario_p text) AS $body$
DECLARE


ds_historico_w		varchar(4000)	:= '';
ds_titulo_w		varchar(255);
dt_assinat_anterior_w	timestamp;


BEGIN

select	max(dt_assinatura)
into STRICT	dt_assinat_anterior_w
from	contrato
where	nr_sequencia = nr_sequencia_p;

update	contrato
set	dt_assinatura			= dt_assinatura_p,
	nm_usuario_assinat		= nm_usuario_p
where	nr_sequencia			= nr_sequencia_p;

ds_titulo_w	:= wheb_mensagem_pck.get_texto(328832);
ds_historico_w	:= substr(wheb_mensagem_pck.get_texto(328834, 'DT_ANTERIOR='||to_char(dt_assinat_anterior_w, 'dd/mm/yyyy')||
							';DT_ATUAL='||to_char(dt_assinatura_p, 'dd/mm/yyyy')||
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
-- REVOKE ALL ON PROCEDURE alterar_assinatura_contrato ( nr_sequencia_p bigint, dt_assinatura_p timestamp, nm_usuario_p text) FROM PUBLIC;

