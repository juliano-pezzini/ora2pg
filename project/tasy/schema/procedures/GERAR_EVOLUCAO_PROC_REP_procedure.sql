-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evolucao_proc_rep (cd_pessoa_fisica_p text, nr_atendimento_p bigint, nm_usuario_p text, ds_evolucao_p text, ie_evolucao_clinica_p text, ie_tipo_evolucao_p text, cd_profissional_p text) AS $body$
DECLARE


cd_evolucao_w	bigint;


BEGIN

select	nextval('evolucao_paciente_seq')
into STRICT	cd_evolucao_w
;

insert into evolucao_paciente(	cd_evolucao,
				dt_evolucao,
				ie_tipo_evolucao,
				cd_pessoa_fisica,
				dt_atualizacao,
				nm_usuario,
				ds_evolucao,
				dt_liberacao,
				ie_evolucao_clinica,
				ie_situacao,
				cd_medico,
				nr_atendimento)
values (cd_evolucao_w,
				clock_timestamp(),
				ie_tipo_evolucao_p,
				cd_pessoa_fisica_p,
				clock_timestamp(),
				nm_usuario_p,
				ds_evolucao_p,
				clock_timestamp(),
				ie_evolucao_clinica_p,
				'A',
				cd_profissional_p,
				nr_atendimento_p);

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evolucao_proc_rep (cd_pessoa_fisica_p text, nr_atendimento_p bigint, nm_usuario_p text, ds_evolucao_p text, ie_evolucao_clinica_p text, ie_tipo_evolucao_p text, cd_profissional_p text) FROM PUBLIC;

