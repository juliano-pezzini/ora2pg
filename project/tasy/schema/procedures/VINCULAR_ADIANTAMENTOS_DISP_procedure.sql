-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_adiantamentos_disp ( nr_interno_conta_p bigint, nr_adiantamento_p bigint, vl_adiantamento_p bigint, dt_atualizacao_p timestamp, nm_usuario_p text, nr_sequencia_p bigint, ie_tipo_adiant_p bigint) AS $body$
BEGIN

insert into conta_paciente_adiant(nr_interno_conta,
	nr_adiantamento,
	vl_adiantamento,
	dt_atualizacao,
	nm_usuario,
	nr_sequencia,
	ie_tipo_adiant)
values (nr_interno_conta_p,
	nr_adiantamento_p,
	vl_adiantamento_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_sequencia_p,
	ie_tipo_adiant_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_adiantamentos_disp ( nr_interno_conta_p bigint, nr_adiantamento_p bigint, vl_adiantamento_p bigint, dt_atualizacao_p timestamp, nm_usuario_p text, nr_sequencia_p bigint, ie_tipo_adiant_p bigint) FROM PUBLIC;

