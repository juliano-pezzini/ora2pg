-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_prescr_atend_futuro ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_atend_futuro_p bigint) AS $body$
DECLARE

			
cd_setor_atendimento_w	usuario.cd_setor_atendimento%type;
cd_pessoa_fisica_w		usuario.cd_pessoa_fisica%type;
nr_atendimento_w		atend_pac_futuro.nr_atendimento%type;
nr_sequencia_w			cpoe_procedimento.nr_sequencia%type;
cd_pessoa_fisica_ww		atend_pac_futuro.cd_pessoa_fisica%type;
dt_prevista_atend_fut_w	atend_pac_futuro.dt_prevista_atend_fut%type;
nr_seq_proc_interno_w	atend_pac_proced_previsto.nr_seq_proc_interno%type;
ie_lado_w				atend_pac_proced_previsto.ie_lado%type;

C01 CURSOR FOR
	SELECT 	nr_seq_proc_interno,
			ie_lado
	from	atend_pac_proced_previsto
	where	nr_seq_atend_futuro = nr_seq_atend_futuro_p;


BEGIN

select 	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from   	usuario
where  	nm_usuario = nm_usuario_p;

select	max(cd_setor_atendimento)
into STRICT	cd_setor_atendimento_w
from 	usuario
where 	nm_usuario = nm_usuario_p;

select	max(nr_atendimento),
		max(cd_pessoa_fisica),
		coalesce(max(dt_prevista_atend_fut),max(dt_registro))
into STRICT	nr_atendimento_w,
		cd_pessoa_fisica_ww,
		dt_prevista_atend_fut_w
from	atend_pac_futuro
where	nr_sequencia = nr_seq_atend_futuro_p;

open C01;
loop
fetch C01 into	
	nr_seq_proc_interno_w,
	ie_lado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	select  nextval('cpoe_procedimento_seq')
	into STRICT  	nr_sequencia_w
	;

	insert into cpoe_procedimento(
		nr_sequencia,
		qt_procedimento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_atendimento,
		nr_seq_proc_interno,
		ie_lado,
		cd_perfil_ativo,
		cd_pessoa_fisica,
		cd_funcao_origem,
		cd_medico,
		dt_prev_execucao,
		dt_inicio,
		ie_duracao,
		dt_fim,
		ie_administracao,
		nr_seq_atend_futuro)
	values (
		nr_sequencia_w,
		1,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_atendimento_w,
		nr_seq_proc_interno_w,
		ie_lado_w,
		obter_perfil_ativo,
		cd_pessoa_fisica_ww,
		10000,
		cd_pessoa_fisica_w,
		dt_prevista_atend_fut_w,
		dt_prevista_atend_fut_w,
		'P',
		trunc((dt_prevista_atend_fut_w + 1),'mi') - 1/86400,
		'P',
		nr_seq_atend_futuro_p);

	commit;

end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_prescr_atend_futuro ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_atend_futuro_p bigint) FROM PUBLIC;

