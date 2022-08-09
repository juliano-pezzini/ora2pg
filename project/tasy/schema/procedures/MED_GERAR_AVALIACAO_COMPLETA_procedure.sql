-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_gerar_avaliacao_completa (nr_seq_cliente_p bigint, cd_avaliador_p text, nm_usuario_p text, dt_avaliacao_p timestamp, ie_tipo_contato_p text) AS $body$
DECLARE


nr_seq_aval_w		bigint;
ie_aval_inicial_w	varchar(01);


BEGIN

select	coalesce(max('N'),'S')
into STRICT	ie_aval_inicial_w
from 	med_aval_completa_pac
where	nr_seq_cliente	= nr_seq_cliente_p;

select	nextval('med_aval_completa_pac_seq')
into STRICT	nr_seq_aval_w
;


insert	into med_aval_completa_pac(nr_sequencia,
	nr_seq_cliente,
	dt_atualizacao,
	nm_usuario,
	dt_avaliacao,
	ie_avaliacao_inicial,
	cd_avaliador,
	ie_tipo_contato,
	ds_observacao,
	ie_situacao)
values (nr_seq_aval_w,
	nr_seq_cliente_p,
	clock_timestamp(),
	nm_usuario_p,
	dt_avaliacao_p,
	ie_aval_inicial_w,
	cd_avaliador_p,
	ie_tipo_contato_p,
	null, 'A');


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_gerar_avaliacao_completa (nr_seq_cliente_p bigint, cd_avaliador_p text, nm_usuario_p text, dt_avaliacao_p timestamp, ie_tipo_contato_p text) FROM PUBLIC;
