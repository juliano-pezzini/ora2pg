-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_proxima_os_proj ( nr_seq_proj_etapa_p bigint, -- 86174 
 nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_cronograma_w	bigint;			
nr_sequencia_w		bigint;
nm_usuario_exec_w	varchar(15);
nr_seq_gerencia_w	bigint;
cd_estabelecimento_w	smallint;
nr_seq_grupo_des_w	bigint;
nr_seq_cliente_w	bigint;
nr_seq_localizacao_w	bigint;
nr_seq_equipamento_w	bigint;
nr_seq_proj_cron_etp_w	bigint;
cd_funcao_w		integer;
ds_etapa_w		varchar(4000);
ds_atividade_w		varchar(255);
cd_coordenador_w	varchar(10);
nr_seq_ordem_w		bigint;
nr_seq_projeto_w	bigint;		
ie_possui_regra_w	varchar(1);
			

BEGIN 
select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
into STRICT	ie_possui_regra_w 
from	proj_cronograma a, 
	proj_cron_etapa b 
where	a.nr_sequencia = b.nr_seq_cronograma 
and	b.nr_Sequencia = nr_Seq_proj_etapa_p 
and	a.ie_gera_ordem_auto = 'S';
 
if (ie_possui_regra_w = 'S') then 
 
	select	max(p.nr_sequencia), 
		max(p.nr_seq_cliente), 
		max(p.cd_estabelecimento), 
		max(p.cd_funcao), 
		max(substr(obter_usuario_pessoa(p.cd_coordenador),1,15)), 
		max(p.cd_coordenador), 
		max(p.nr_seq_grupo_des) 
	into STRICT	nr_seq_projeto_w, 
		nr_seq_cliente_w, 
		cd_estabelecimento_w, 
		cd_funcao_w, 
		nm_usuario_exec_w, 
		cd_coordenador_w, 
		nr_seq_grupo_des_w	 
	from 	proj_projeto p 
	where 	1 = 1 
	and 	ie_status = 'E' 
	and 	ie_origem = 'D' 
	and 	coalesce(ie_nivel_projeto,0) <> '3' 
	and	nr_seq_estagio <> 17 
	--and	p.nr_seq_classif <> 14 
	and	p.nr_sequencia = (SELECT max(a.nr_seq_proj) 
				from	PROJ_CRONOGRAMA a, 
					PROJ_CRON_ETAPA b 
				where	a.nr_sequencia = b.nr_seq_cronograma 
				and	a.nr_seq_proj = p.nr_sequencia 
				and	b.nr_sequencia = nr_seq_proj_etapa_p);
 
	select	max(e.nr_sequencia) 
	into STRICT	nr_seq_proj_cron_etp_w 
	from	proj_projeto p, 
		proj_cronograma c, 
		proj_cron_etapa e 
	where	p.nr_sequencia = nr_seq_projeto_w 
	and	p.nr_sequencia = c.nr_seq_proj 
	and	c.nr_sequencia = e.nr_seq_cronograma 
	and	c.ie_tipo_cronograma = 'E' 
	and	c.ie_situacao = 'A' 
	and 	e.pr_etapa <> 100 
	and	(c.dt_aprovacao IS NOT NULL AND c.dt_aprovacao::text <> '') 
	and	trunc(e.dt_inicio_prev) >= trunc(clock_timestamp()) 
	and   not exists (	SELECT	1 
				from	man_ordem_servico_v x 
				where	x.nr_seq_proj_cron_etapa = e.nr_sequencia) 
	and	not exists (	select	1 
				from	proj_cron_etapa x 
				where	x.nr_seq_superior = e.nr_sequencia) 
	and	e.nr_sequencia <> nr_seq_proj_etapa_p 
	and	trunc(e.dt_inicio_prev) = (	select	trunc(min(z.dt_inicio_prev)) 
						 	  	 	from	proj_cron_etapa z, 
							  				proj_cronograma y 
									where	y.nr_sequencia = z.nr_seq_cronograma 
									and	c.nr_sequencia = y.nr_sequencia 
									and	z.nr_sequencia <> nr_seq_proj_etapa_p 
									AND 	z.pr_etapa <> 100 
									and	not exists (	select	1 
												from	man_ordem_servico_v x 
												where	x.nr_seq_proj_cron_etapa = z.nr_sequencia) 
									and	not exists (	select	1 
												from	proj_cron_etapa x 
												where	x.nr_seq_superior = z.nr_sequencia));
				 
	select	max(coalesce(e.ds_etapa,e.ds_atividade)) ds_etapa, 
		max(e.ds_atividade) 
	into STRICT	ds_etapa_w, 
		ds_atividade_w	 
	from	proj_cron_etapa e 
	where	e.nr_Sequencia = nr_Seq_proj_cron_etp_w;
				 
	select	coalesce(max(a.nr_sequencia),1272) 
	into STRICT	nr_seq_localizacao_w 
	from	com_cliente b, 
		man_localizacao a 
	where	a.cd_cnpj = b.cd_cnpj 
	and	b.nr_sequencia = nr_seq_cliente_w;
 
	nr_seq_equipamento_w:= 1;
 
	if (nr_seq_cliente_w = 5075) then 
 
		if (cd_estabelecimento_w = 22) then 
		 
			nr_seq_localizacao_w := 4976;
			select	max(nr_sequencia) 
			into STRICT	nr_seq_equipamento_w 
			from	man_equipamento 
			where	nr_seq_local = nr_seq_localizacao_w;
			 
		elsif (cd_estabelecimento_w = 1) then 
		 
			nr_seq_localizacao_w := 1272;
			nr_seq_equipamento_w := 1395;
			 
		else 
 
			nr_seq_localizacao_w := 4604;
			nr_seq_equipamento_w := 4758;	
			 
		end if;
	end if;			
				 
	if (cd_coordenador_w IS NOT NULL AND cd_coordenador_w::text <> '') then 
		 
		if (nr_seq_proj_cron_etp_w IS NOT NULL AND nr_seq_proj_cron_etp_w::text <> '') then 
			nr_seq_ordem_w := man_gerar_os_proj_etapa(nr_seq_ordem_w, /*nr_sequencia_w*/
 
						cd_coordenador_w, /*cd_pessoa_solicitante_p*/
 
						nr_seq_localizacao_w, /*nr_seq_localizacao_p*/
 
						nr_seq_equipamento_w, /*nr_seq_equipamento_p*/
 
						'Proj. ' ||nr_seq_projeto_w|| ' - ' || ds_atividade_w, /*ds_dano_breve_p*/
 
						coalesce(ds_etapa_w,ds_atividade_w), /*ds_dano_p*/
 
						cd_funcao_w, /*cd_funcao_p*/
 
						'S', /*ie_classificacao_p*/
 
						'U', /*ie_forma_receb_p*/
 
						clock_timestamp(), /*dt_inicio_previsto_p*/
 
						clock_timestamp() + interval '20 days', /*dt_fim_previsto_p*/
 
						4, /*nr_seq_estagio_p*/
 
						'1', /*ie_tipo_ordem_p*/
 
						'1', /*nr_grupo_planej_p*/
 
						'1', /*nr_grupo_trabalho_p*/
 
						'M', /*ie_prioridade_p*/
 
						'1', /*ie_status_ordem_p*/
 
						substr(obter_usuario_pessoa(cd_coordenador_w),1,15), /*nm_usuario_p*/
 
						nr_seq_proj_cron_etp_w, /*nr_seq_proj_cron_etapa_p*/
 
						nr_seq_grupo_des_w, /*nr_seq_grupo_des_p*/
 
						nr_seq_projeto_w, /*nr_seq_projeto_w*/
 
						10, null, null, cd_estabelecimento_w); 						/*nr_seq_ativ_exec_p*/
		end if;				
	end if;	
			 
end if;			
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gerar_proxima_os_proj ( nr_seq_proj_etapa_p bigint, nm_usuario_p text) FROM PUBLIC;

