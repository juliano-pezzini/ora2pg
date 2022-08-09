-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_alerta_alt_prod ( nr_seq_segurado_p bigint, nm_plano_ant_p text, nm_plano_novo_p text, dt_adesao_p timestamp, nm_usuario_p text) AS $body$
DECLARE


ds_alerta_w		varchar(500);
nr_seq_alerta_w		bigint;


BEGIN

ds_alerta_w	:= 'Alteração do produto ' || nm_plano_ant_p || ' para ' || nm_plano_novo_p || ' com data de adesão desse novo plano a partir do dia ' || to_char(dt_adesao_p,'dd/mm/yyyy');

select	nextval('pls_alerta_seq')
into STRICT	nr_seq_alerta_w
;

insert into PLS_ALERTA(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
		nr_seq_segurado,DT_INICIO_VIGENCIA,DT_FIM_VIGENCIA,DT_ALERTA,NM_USUARIO_CRIACAO,
		ds_alerta,IE_SITUACAO)
values (	nr_seq_alerta_w,clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
		nr_seq_segurado_p,clock_timestamp(),dt_adesao_p,clock_timestamp(),nm_usuario_p,
		ds_alerta_w,'A');

insert into PLS_ALERTA_EVENTO(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
		NR_SEQ_ALERTA,IE_EVENTO)
values (	nextval('pls_alerta_evento_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
		nr_seq_alerta_w,'DB');


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_alerta_alt_prod ( nr_seq_segurado_p bigint, nm_plano_ant_p text, nm_plano_novo_p text, dt_adesao_p timestamp, nm_usuario_p text) FROM PUBLIC;
