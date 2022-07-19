-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reaproveitamento_ordem_quimio ( nr_seq_atendimento_p bigint, dt_inicio_preparo_p timestamp, nr_ordem_origem_p bigint, nr_ordem_destino_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
BEGIN

update	can_ordem_prod
set	dt_inicio_preparo		= dt_inicio_preparo_p,
	nm_usuario_inic_prep	= nm_usuario_p
where	nr_seq_atendimento	= nr_seq_atendimento_p;

commit;

CALL can_reaproveitamento_op(
	nr_ordem_origem_p,
	nr_ordem_destino_p,
	cd_pessoa_fisica_p,
	nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reaproveitamento_ordem_quimio ( nr_seq_atendimento_p bigint, dt_inicio_preparo_p timestamp, nr_ordem_origem_p bigint, nr_ordem_destino_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;

