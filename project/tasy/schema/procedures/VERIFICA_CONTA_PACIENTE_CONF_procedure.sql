-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_conta_paciente_conf ( nr_interno_conta_p bigint, nm_usuario_p text, ie_opcao_p bigint, ds_resultado_p INOUT text) AS $body$
DECLARE


/*
ie_opcao_p
	1 - verificar último o status da conferência  - utilizado para alterar o caption do conferir_conta_mi no FatAct_F5
	2 - marcar a conta como conferida
	3 - desmarcar a conta como conferida
*/
ie_conferencia_w	varchar(1);
ds_resultado_w		varchar(1);

C01 CURSOR FOR
	SELECT	coalesce(ie_conferencia,'N')
	from	conta_paciente_conferencia
	where	nr_interno_conta = nr_interno_conta_p
	order by	dt_atualizacao;


BEGIN

ds_resultado_w	:= '';

if (ie_opcao_p = 1) then

	open C01;
	loop
	fetch C01 into
		ie_conferencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ie_conferencia_w	:= ie_conferencia_w;
		end;
	end loop;
	close C01;

	ds_resultado_w	:= ie_conferencia_w;

elsif (ie_opcao_p = 2) then

	insert into conta_paciente_conferencia(
		nr_sequencia,
		nr_interno_conta,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_conferencia )
	values (
		nextval('conta_paciente_conferencia_seq'),
		nr_interno_conta_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		'S' );

elsif (ie_opcao_p = 3) then

	insert into conta_paciente_conferencia(
		nr_sequencia,
		nr_interno_conta,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_conferencia )
	values (
		nextval('conta_paciente_conferencia_seq'),
		nr_interno_conta_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		'N' );

end if;

ds_resultado_p	:= ds_resultado_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_conta_paciente_conf ( nr_interno_conta_p bigint, nm_usuario_p text, ie_opcao_p bigint, ds_resultado_p INOUT text) FROM PUBLIC;
