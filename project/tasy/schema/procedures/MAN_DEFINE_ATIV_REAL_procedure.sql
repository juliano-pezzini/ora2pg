-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_define_ativ_real ( nr_sequencia_p bigint, nr_seq_funcao_p bigint, nm_usuario_p text, qt_min_real_p bigint, qt_min_cobrar_p bigint, nr_seq_grupo_trab_p bigint, ds_obs_ativ_p text default '') AS $body$
DECLARE

 
nr_seq_ordem_serv_w		bigint;
ds_observacao_w			varchar(4000);
nr_sequencia_w			bigint;
ds_atividade_w			varchar(2000);
nr_seq_ativ_prev_w		bigint;
ie_gerar_historico_w		varchar(2);
nr_seq_estagio_w		man_ordem_ativ_prev.nr_seq_estagio%type;


BEGIN 
select	nextval('man_ordem_serv_ativ_seq') 
into STRICT	nr_sequencia_w	
;
 
select	nr_sequencia, 
	nr_seq_ordem_serv,	 
	ds_observacao, 
	ds_atividade, 
	nr_seq_estagio 
into STRICT	nr_seq_ativ_prev_w, 
	nr_seq_ordem_serv_w, 
	ds_observacao_w, 
	ds_atividade_w, 
	nr_seq_estagio_w 
from	man_ordem_ativ_prev 
where	nr_sequencia	= nr_sequencia_p;
 
if (coalesce(ds_obs_ativ_p,'X') <> 'X') then 
	if (coalesce(ds_observacao_w,'X') <> 'X') then 
		ds_observacao_w := substr(ds_observacao_w || chr(13) || chr(10),1,4000);
	end if;
	 
	ds_observacao_w	:= substr(ds_observacao_w || ds_obs_ativ_p,1,4000);
end if;
 
update	man_ordem_ativ_prev 
set	dt_real		= clock_timestamp(), 
	nm_usuario_real	= nm_usuario_p 
where	nr_sequencia	= nr_sequencia_p;
 
insert into man_ordem_serv_ativ(	nr_sequencia, 
		nr_seq_ordem_serv, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atividade, 
		nr_seq_funcao, 
		qt_minuto, 
		nm_usuario_exec, 
		ds_observacao, 
		qt_minuto_cobr, 
		ds_atividade, 
		nr_seq_grupo_trabalho, 
		nr_seq_ativ_prev, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_estagio) 
values (	nr_sequencia_w, 
		nr_seq_ordem_serv_w, 
	   	clock_timestamp(), 
     	nm_usuario_p, 
	   	clock_timestamp(), 
	   	nr_seq_funcao_p, 
	   	qt_min_real_p, 
	   	nm_usuario_p, 
		ds_observacao_w, 
		qt_min_cobrar_p, 
		ds_atividade_w, 
		nr_seq_grupo_trab_p, 
		nr_seq_ativ_prev_w, 
		clock_timestamp(), 
     	nm_usuario_p, 
		nr_seq_estagio_w);
		 
ie_gerar_historico_w := obter_param_usuario(299, 373, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_gerar_historico_w);
 
if (ie_gerar_historico_w = 'S') then 
	man_gerar_hist_nova_ativ(	nr_seq_ordem_serv_w, 
					nr_sequencia_w, 
					nm_usuario_p, 
					'', 
					'R');
end if;
 
CALL man_calcular_preco_atividade(nr_sequencia_w);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_define_ativ_real ( nr_sequencia_p bigint, nr_seq_funcao_p bigint, nm_usuario_p text, qt_min_real_p bigint, qt_min_cobrar_p bigint, nr_seq_grupo_trab_p bigint, ds_obs_ativ_p text default '') FROM PUBLIC;
