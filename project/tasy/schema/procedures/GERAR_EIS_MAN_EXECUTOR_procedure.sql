-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_man_executor ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE


dt_referencia_w  		timestamp;
nm_usuario_exec_w  	varchar(15);
ds_usuario_exec_w  	varchar(255);
qt_ordens_w   		bigint;
qt_total_os_w  		bigint;
nr_seq_planej_w	  	bigint;
nr_seq_estagio_w	  	bigint;
nr_seq_localizador_w  	bigint;
qt_encerrada_w 	 	bigint;
qt_pendente_w   		bigint;
nr_sequencia_w		bigint;
nr_seq_log_w		bigint;
ie_informacao_w		varchar(02);
nr_grupo_trabalho_w	bigint;
cd_estabelecimento_w	smallint;
cd_setor_local_w	setor_atendimento.cd_setor_atendimento%type;
nr_seq_motivo_cancel_w  man_ordem_servico.nr_seq_motivo_cancel%type;

c01 CURSOR FOR
/*Pendentes*/

SELECT	CASE WHEN a.dt_fim_real='' THEN '0'  ELSE CASE WHEN trunc(a.dt_fim_real,'month')=dt_referencia_w THEN '1'  ELSE '0' END  END  ie_informacao,
	count(distinct b.nm_usuario_exec),
	b.nm_usuario_exec,
	a.nr_grupo_planej,
	coalesce(a.nr_seq_estagio,0),
	a.nr_seq_localizacao,
	a.nr_grupo_trabalho,
	a.cd_estabelecimento,
	a.nr_seq_motivo_cancel
from	man_ordem_servico_exec b,
	man_ordem_servico_v a
where	a.nr_sequencia   = b.nr_seq_ordem
and	trunc(a.dt_ordem_servico, 'month') = dt_referencia_w
group by
	coalesce(a.nr_seq_estagio,0),
	b.nm_usuario_exec,
	a.nr_grupo_planej,
	a.dt_fim_real,
	a.nr_grupo_trabalho,
	a.nr_seq_localizacao,
	a.cd_estabelecimento,
	a.nr_seq_motivo_cancel

union all

/*Encerradas*/

select	'1' ie_informacao,
	count(distinct b.nm_usuario_exec),
	b.nm_usuario_exec,
	a.nr_grupo_planej,
	coalesce(a.nr_seq_estagio,0),
	a.nr_seq_localizacao,
	a.nr_grupo_trabalho,
	a.cd_estabelecimento,
	a.nr_seq_motivo_cancel
from	man_ordem_servico_exec b,
	man_ordem_servico_v a
where	a.nr_sequencia   = b.nr_seq_ordem
and	trunc(a.dt_ordem_servico, 'month') < dt_referencia_w
and	trunc(a.dt_fim_real, 'month') = dt_referencia_w
and	(a.dt_fim_real IS NOT NULL AND a.dt_fim_real::text <> '')
group by
	b.nm_usuario_exec,
	a.nr_grupo_planej,
	coalesce(a.nr_seq_estagio,0),
	a.nr_grupo_trabalho,
	a.nr_seq_localizacao,
	a.nr_sequencia,
	a.cd_estabelecimento,
	a.nr_seq_motivo_cancel

union all

/*Total de ordens*/

select	'2' ie_informacao,
	count(*),
	b.nm_usuario_exec,
	a.nr_grupo_planej,
	coalesce(a.nr_seq_estagio,0),
	a.nr_seq_localizacao,
	a.nr_grupo_trabalho,
	a.cd_estabelecimento,
	a.nr_seq_motivo_cancel
from	man_ordem_servico_exec b,
	man_ordem_servico_v a
where	a.nr_sequencia   = b.nr_seq_ordem
and	trunc(a.dt_ordem_servico, 'month') = dt_referencia_w
group by
	coalesce(a.nr_seq_estagio,0),
	b.nm_usuario_exec,
	a.nr_grupo_planej,
	a.nr_grupo_trabalho,
	a.nr_seq_localizacao,
	a.cd_estabelecimento,
	a.nr_seq_motivo_cancel;	
	

BEGIN
dt_referencia_w  := trunc(dt_referencia_p, 'month');

nr_seq_log_w := Gravar_Log_Indicador(405, wheb_mensagem_pck.get_texto(305888), clock_timestamp(), dt_referencia_w, nm_usuario_p, nr_seq_log_w);

delete	from eis_man_executor
where	dt_referencia = dt_referencia_w;

open c01;
loop
fetch c01 into
	ie_informacao_w,
	qt_ordens_w,
	nm_usuario_exec_w,
	nr_seq_planej_w,
	nr_seq_estagio_w,
	nr_seq_localizador_w,
	nr_grupo_trabalho_w,
	cd_estabelecimento_w,
	nr_seq_motivo_cancel_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
begin

select	count(*)
into STRICT	qt_pendente_w
from (	SELECT	distinct
		a.nr_sequencia,
		b.nm_usuario_exec
	from	man_ordem_servico_exec b,
		man_ordem_servico_v a
	where	a.nr_sequencia  = b.nr_seq_ordem
	and	coalesce(a.dt_fim_real::text, '') = ''
	and	trunc(a.dt_ordem_servico, 'month') 	= dt_referencia_w
	and	b.nm_usuario_exec 			= nm_usuario_exec_w
	and	coalesce(a.nr_grupo_planej,0) 		= coalesce(nr_seq_planej_w,0)
	and	coalesce(a.nr_seq_estagio,0) 		= coalesce(nr_seq_estagio_w,0)
	and	coalesce(nr_grupo_trabalho,0)		= coalesce(nr_grupo_trabalho_w,0)
	and	ie_informacao_w			= '0'
	and	coalesce(a.nr_seq_localizacao,0) 		= coalesce(nr_seq_localizador_w,0)) alias11;

select	count(*)
into STRICT	qt_total_os_w
from (	SELECT	distinct
		a.nr_sequencia,
		b.nm_usuario_exec
	from	man_ordem_servico_exec b,
		man_ordem_servico_v a
	where	a.nr_sequencia  = b.nr_seq_ordem
	and	trunc(a.dt_ordem_servico, 'month') 	= dt_referencia_w
	and	b.nm_usuario_exec 			= nm_usuario_exec_w
	and	coalesce(a.nr_grupo_planej,0) 		= coalesce(nr_seq_planej_w,0)
	and	coalesce(a.nr_seq_estagio,0) 		= coalesce(nr_seq_estagio_w,0)
	and	coalesce(nr_grupo_trabalho,0)		= coalesce(nr_grupo_trabalho_w,0)
	and	ie_informacao_w			= '2'
	and	coalesce(a.nr_seq_localizacao,0) 		= coalesce(nr_seq_localizador_w,0)) alias10;

select	max(ds_usuario)
into STRICT	ds_usuario_exec_w
from	usuario
where	nm_usuario = nm_usuario_exec_w;

select	coalesce(max(cd_setor),0)
into STRICT	cd_setor_local_w
from	man_localizacao
where	nr_sequencia = nr_seq_localizador_w;

insert	into eis_man_executor(
	nr_sequencia,
	cd_estabelecimento,
	dt_referencia,
	nm_usuario_executor,
	nr_seq_localizador,
	dt_atualizacao,
	nm_usuario,
	nr_seq_estagio,
	qt_ordem_servico,
	qt_pendente,
	qt_encerrada,
	nr_seq_planej,
	ie_informacao,
	nr_grupo_trabalho,
	ds_usuario_exec,
	cd_setor_atendimento,
	nr_seq_motivo_cancel)
values (	nextval('eis_man_executor_seq'),
	cd_estabelecimento_w,
	dt_referencia_w,
	nm_usuario_exec_w,
	nr_seq_localizador_w,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_estagio_w,
	qt_total_os_w,
	qt_pendente_w,
	CASE WHEN ie_informacao_w='1' THEN qt_ordens_w  ELSE 0 END ,
	nr_seq_planej_w,
	ie_informacao_w,
	nr_grupo_trabalho_w,
	ds_usuario_exec_w,
	cd_setor_local_w,
	nr_seq_motivo_cancel_w);
end;
end loop;
close c01;

CALL Atualizar_Log_Indicador(clock_timestamp(), nr_seq_log_w);

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_man_executor ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
