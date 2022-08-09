-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_partic_cir_prof ( cd_participante_p text, nr_cirurgia_p bigint, ie_funcao_p text, ie_opcao_funcao_p text, cd_especialidade_p bigint, nm_usuario_p text ) AS $body$
DECLARE

 
/* 
ie_opcao_funcao_p	 
'A' - Anestesista 
*/
 
 
nr_sequencia_w		bigint;
qt_registro_w		integer := 0;
ie_gera_inicio_fim_w	varchar(1);
dt_inicio_real_w	timestamp;
dt_termino_w		timestamp;

 

BEGIN 
 
ie_gera_inicio_fim_w := obter_param_usuario(900, 126, obter_perfil_ativo, nm_usuario_p, 0, ie_gera_inicio_fim_w);
 
if (ie_gera_inicio_fim_w = 'S') then 
	select	coalesce(dt_inicio_real,dt_inicio_prevista), 
		coalesce(dt_termino,clock_timestamp()) 
	into STRICT	dt_inicio_real_w, 
		dt_termino_w 
	from 	cirurgia 
	where	nr_cirurgia = nr_cirurgia_p;
end if;	
	 
if ((coalesce(dt_inicio_real_w::text, '') = '') or (coalesce(dt_termino_w::text, '') = '')) then 
	dt_inicio_real_w 	:= null;
	dt_termino_w		:= null;
end if;
 
select	coalesce(max(nr_sequencia),0) + 1 
into STRICT	nr_sequencia_w 
from 	cirurgia_participante 
where	nr_cirurgia	=	nr_cirurgia_p;
 
select 	count(*) 
into STRICT	qt_registro_w 
from	cirurgia_participante 
where	nr_cirurgia		=	nr_cirurgia_p 
and	cd_pessoa_fisica	=	cd_participante_p 
and	ie_funcao		=	ie_funcao_p;
 
if (qt_registro_w = 0) then 
	insert into cirurgia_participante( 
		nr_cirurgia, 
		nr_sequencia, 
		ie_funcao, 
		nm_usuario, 
		dt_atualizacao, 
		nm_usuario_nrec, 
		dt_atualizacao_nrec, 
		cd_pessoa_fisica, 
		nm_participante, 
		nr_seq_interno, 
		cd_especialidade, 
		dt_entrada, 
		dt_saida) 
	values ( 
		nr_cirurgia_p, 
		nr_sequencia_w, 
		ie_funcao_p, 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		cd_participante_p, 
		substr(obter_nome_pf(cd_participante_p),1,50), 
		nextval('cirurgia_participante_seq'), 
		cd_especialidade_p, 
		dt_inicio_real_w, 
		dt_termino_w);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_partic_cir_prof ( cd_participante_p text, nr_cirurgia_p bigint, ie_funcao_p text, ie_opcao_funcao_p text, cd_especialidade_p bigint, nm_usuario_p text ) FROM PUBLIC;
