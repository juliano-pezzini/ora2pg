-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_encerrar_os ( nr_sequencia_p bigint, nr_seq_estagio_p bigint, nm_usuario_p text, ds_justificativa_p text, ie_commit_p text default 'S') AS $body$
DECLARE

 
dt_inicio_previsto_w		timestamp;
nr_seq_atend_pls_w			bigint;
nr_seq_evento_atend_w		bigint;
dt_fim_evento_w				timestamp;
dt_inicio_real_w			timestamp;
ie_dt_ativ_inicio_real_w	varchar(1);
ie_dt_ativ_fim_real_w		varchar(1);
dt_ativ_inicio_real_w		timestamp := null;
dt_ativ_fim_real_w			timestamp := null;
nr_seq_proj_cron_etapa_w	man_ordem_servico.nr_seq_proj_cron_etapa%type;
nr_seq_etapa_npi_w			proj_cron_etapa.nr_seq_etapa_npi%type;


BEGIN 
ie_dt_ativ_fim_real_w := obter_param_usuario(299, 234, Obter_perfil_Ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_dt_ativ_fim_real_w);
ie_dt_ativ_inicio_real_w := obter_param_usuario(299, 244, Obter_perfil_Ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_dt_ativ_inicio_real_w);
 
select	dt_inicio_previsto 
into STRICT	dt_inicio_previsto_w 
from	man_ordem_servico 
where	nr_sequencia = nr_sequencia_p;
 
select	max(nr_seq_proj_cron_etapa) 
into STRICT	nr_seq_proj_cron_etapa_w 
from	man_ordem_servico 
where	nr_sequencia = nr_sequencia_p;
 
if (nr_seq_proj_cron_etapa_w IS NOT NULL AND nr_seq_proj_cron_etapa_w::text <> '') then 
 
	select	max(nr_seq_etapa_npi) 
	into STRICT	nr_seq_etapa_npi_w 
	from	proj_cron_etapa 
	where	nr_sequencia = nr_seq_proj_cron_etapa_w;
	 
	if (nr_seq_etapa_npi_w IS NOT NULL AND nr_seq_etapa_npi_w::text <> '') then 
	 
		update	proj_cron_etapa 
		set		pr_etapa = 100, 
				ie_status_etapa = 4 
		where	nr_sequencia = nr_seq_proj_cron_etapa_w;
	 
	end if;
 
end if;
 
if (coalesce(ie_dt_ativ_inicio_real_w,'N') = 'S') then 
	begin 
	select	dt_inicio_real 
	into STRICT	dt_inicio_real_w 
	from	man_ordem_servico 
	where	nr_sequencia = nr_sequencia_p;
	 
	if (coalesce(dt_inicio_real_w::text, '') = '') then 
		select	min(dt_atividade) 
		into STRICT	dt_ativ_inicio_real_w 
		from  	man_ordem_serv_ativ 
		where	nr_seq_ordem_serv = nr_sequencia_p;
	end if;
	end;
end if;
 
if (coalesce(ie_dt_ativ_fim_real_w,'N') = 'S') then 
	begin 
	select	max(coalesce(dt_fim_atividade,dt_atividade)) 
	into STRICT	dt_ativ_fim_real_w 
	from  	man_ordem_serv_ativ 
	where	nr_seq_ordem_serv = nr_sequencia_p;
	end;
end if;
 
update	man_ordem_servico 
set	dt_inicio_real	= coalesce(dt_ativ_inicio_real_w,coalesce(dt_inicio_real,dt_inicio_previsto_w)), 
	dt_fim_real	= coalesce(dt_ativ_fim_real_w,coalesce(dt_fim_real,clock_timestamp())), 
	nr_seq_estagio	= nr_seq_estagio_p, 
	ie_status_ordem	= 3, 
	nm_usuario	= nm_usuario_p, 
	dt_atualizacao	= clock_timestamp(), 
	nm_usuario_encer= nm_usuario_p 
where	nr_sequencia	= nr_sequencia_p;
 
 
if (ds_justificativa_p IS NOT NULL AND ds_justificativa_p::text <> '') then 
	insert into man_ordem_serv_tecnico( 
			nr_sequencia, 
			nr_seq_ordem_serv, 
			dt_atualizacao, 
			nm_usuario, 
			ds_relat_tecnico, 
			dt_historico, 
			ie_origem, 
			dt_liberacao, 
			nm_usuario_lib) 
		values (	nextval('man_ordem_serv_tecnico_seq'), 
			nr_sequencia_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			ds_justificativa_p, 
			clock_timestamp(), 
			'I', 
			clock_timestamp(), 
			nm_usuario_p);
end if;
 
/*Alexandre (acjjunior) 23/11/2010 - OS 266412 */
 
begin 
select	nr_seq_atend_pls, 
	nr_seq_evento_atend 
into STRICT	nr_seq_atend_pls_w, 
	nr_seq_evento_atend_w 
from	man_ordem_servico 
where	nr_sequencia = nr_sequencia_p;
exception 
when others then 
	nr_seq_atend_pls_w := null;
	nr_seq_evento_atend_w := null;
end;
 
begin 
select	dt_fim_evento 
into STRICT	dt_fim_evento_w 
from	pls_atendimento_evento 
where	nr_sequencia = nr_seq_evento_atend_w;
exception 
when others then 
	dt_fim_evento_w := null;
end;
 
if (nr_seq_atend_pls_w IS NOT NULL AND nr_seq_atend_pls_w::text <> '') and (dt_fim_evento_w IS NOT NULL AND dt_fim_evento_w::text <> '') then 
	CALL pls_finalizar_atendimento(	nr_seq_atend_pls_w, 
					nr_seq_evento_atend_w, 
					null, 
					null, 
					nm_usuario_p);
end if;
 
if (coalesce(ie_commit_p,'S') = 'S') then 
	commit;
end if;	
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_encerrar_os ( nr_sequencia_p bigint, nr_seq_estagio_p bigint, nm_usuario_p text, ds_justificativa_p text, ie_commit_p text default 'S') FROM PUBLIC;

