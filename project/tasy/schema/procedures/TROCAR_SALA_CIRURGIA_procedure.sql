-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE trocar_sala_cirurgia ( nr_cirurgia_p bigint, dt_entrada_unidade_p timestamp, dt_inicio_real_p timestamp, cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_tipo_acomodacao_p bigint, nm_usuario_p text, cd_funcao_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE

								 
nr_atendimento_w	bigint;								
								 

BEGIN 
 
select	nr_atendimento 
into STRICT	nr_atendimento_w 
from	cirurgia 
where	nr_cirurgia = nr_cirurgia_p;
 
CALL alterar_dados_cirurgia(nr_cirurgia_p,1);
CALL iniciar_cirurgia(	nr_atendimento_w, 
		nr_cirurgia_p, 
		dt_entrada_unidade_p,								 
		dt_inicio_real_p, 
		cd_setor_atendimento_p, 
		cd_unidade_basica_p, 
		cd_unidade_compl_p, 
		cd_tipo_acomodacao_p, 
		nm_usuario_p, 
		cd_funcao_p, 
		cd_estabelecimento_p);
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE trocar_sala_cirurgia ( nr_cirurgia_p bigint, dt_entrada_unidade_p timestamp, dt_inicio_real_p timestamp, cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_tipo_acomodacao_p bigint, nm_usuario_p text, cd_funcao_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

