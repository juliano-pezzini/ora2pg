-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integracao_ret_pck.insert_convenio_retorno ( nr_seq_retorno_p convenio_retorno.nr_sequencia%type, cd_convenio_p convenio.cd_convenio%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, dt_retorno_p convenio_retorno.dt_retorno%type) AS $body$
DECLARE

	
nr_seq_retorno_w	convenio_retorno.nr_sequencia%type 	:= nr_seq_retorno_p;
cd_convenio_w		convenio.cd_convenio%type 		:= cd_convenio_p;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type := cd_estabelecimento_p;
dt_retorno_w		convenio_retorno.dt_retorno%type 	:= dt_retorno_p;


BEGIN

	insert into convenio_retorno(
		nr_sequencia,
		cd_convenio,
		cd_estabelecimento,
		ie_status_retorno,
		nm_usuario,
		nm_usuario_retorno,
		dt_atualizacao,
		dt_retorno
	) values (
		nr_seq_retorno_w,
		cd_convenio_w,
		cd_estabelecimento_w,
		current_setting('conciliar_integracao_ret_pck.ins_ret_open_status_c')::varchar(1),
		current_setting('conciliar_integracao_ret_pck.integration_c')::varchar(11),
		current_setting('conciliar_integracao_ret_pck.integration_c')::varchar(11),
		clock_timestamp(),
		dt_retorno_w
	);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integracao_ret_pck.insert_convenio_retorno ( nr_seq_retorno_p convenio_retorno.nr_sequencia%type, cd_convenio_p convenio.cd_convenio%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, dt_retorno_p convenio_retorno.dt_retorno%type) FROM PUBLIC;