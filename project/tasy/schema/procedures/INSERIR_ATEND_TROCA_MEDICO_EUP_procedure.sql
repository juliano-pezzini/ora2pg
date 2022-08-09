-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_atend_troca_medico_eup ( nr_atendimento_p bigint, cd_medico_resp_p text, nm_usuario_p text, cd_especialidade_p bigint default null) AS $body$
DECLARE

							 
ie_atualizar_medico_w	varchar(1);

BEGIN
 
ie_atualizar_medico_w := Obter_param_Usuario(3111, 270, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_atualizar_medico_w);
 
insert into	atendimento_troca_medico( 
		nr_sequencia, 
		nr_atendimento, 
		dt_atualizacao, 
		nm_usuario, 
		dt_troca, 
		cd_medico_anterior, 
		cd_medico_atual, 
		ie_forma_aviso, 
		dt_ciente, 
		nm_usuario_ciente, 
		nm_usuario_nrec, 
		dt_atualizacao_nrec, 
		cd_especialidade) 
Values ( 
		nextval('atendimento_troca_medico_seq'), 
		nr_atendimento_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		cd_medico_resp_p, 
		cd_medico_resp_p, 
		'T', 
		clock_timestamp(), 
		nm_usuario_p, 
		nm_usuario_p, 
		clock_timestamp(), 
		CASE WHEN coalesce(cd_especialidade_p::text, '') = '' THEN  null  ELSE cd_especialidade_p END );
		 
if (ie_atualizar_medico_w = 'S') then 
		update	atendimento_paciente 
		set		cd_medico_resp = cd_medico_resp_p 
		where	nr_atendimento = nr_atendimento_p;
end if;
 
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_atend_troca_medico_eup ( nr_atendimento_p bigint, cd_medico_resp_p text, nm_usuario_p text, cd_especialidade_p bigint default null) FROM PUBLIC;
