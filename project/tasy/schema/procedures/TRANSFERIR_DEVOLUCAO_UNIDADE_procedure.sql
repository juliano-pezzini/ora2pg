-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE transferir_devolucao_unidade (nr_unidade_dest_p bigint, nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_entrada_unidade_w		timestamp;
nr_atendimento_w		bigint;


BEGIN

select	dt_entrada_unidade,
	nr_atendimento
into STRICT	dt_entrada_unidade_w,
	nr_atendimento_w
from	atend_paciente_unidade
where	nr_seq_interno = nr_unidade_dest_p;

if (dt_entrada_unidade_w IS NOT NULL AND dt_entrada_unidade_w::text <> '') then

	update	devolucao_material_pac
	set	dt_entrada_unidade	= dt_entrada_unidade_w,
		nr_atendimento		= nr_atendimento_w,
		nm_usuario		= nm_usuario_p
	where	nr_atendimento		= nr_atendimento_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE transferir_devolucao_unidade (nr_unidade_dest_p bigint, nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
