-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpw_gerar_os_classif_pendencia ( nr_sequencia_p bigint, nr_seq_regra_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_gerar_os_w			varchar(1) := 'S';
cd_pessoa_solicitante_w		varchar(10);
ie_prioridade_w			varchar(15);
ie_classificacao_w			varchar(15);
ds_dano_breve_w			varchar(80);
ds_dano_w			varchar(4000);
nm_usuario_exec_w		varchar(15);
nr_seq_localizacao_w		bigint;
nr_seq_equipamento_w		bigint;
nr_seq_estagio_w			bigint;
nr_seq_grupo_planej_w		bigint;
nr_seq_grupo_trab_w		bigint;
qt_min_prev_w			bigint;
nr_seq_mod_impl_w		bigint;
cd_funcao_w			integer;
nr_seq_ordem_serv_w		bigint;

C01 CURSOR FOR 
	SELECT	nm_usuario_exec, 
		qt_min_prev 
	from	gpw_regra_geracao_os_exec 
	where	nr_seq_mod_impl_w	= coalesce(nr_seq_modulo_impl,nr_seq_mod_impl_w) 
	and	cd_funcao_w		= coalesce(cd_funcao,cd_funcao_w) 
	and	nr_seq_regra		= nr_seq_regra_p;


BEGIN 
 
if (coalesce(nr_sequencia_p,0) <> 0) and (coalesce(nr_seq_regra_p,0) <> 0) and (coalesce(nm_usuario_p,'X') <> 'X') then 
	begin 
	 
	begin 
	select	substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10), 
		ie_prioridade, 
		ie_classificacao, 
		ds_dano_breve, 
		ds_dano, 
		nr_seq_localizacao, 
		nr_seq_equipamento, 
		nr_seq_estagio, 
		nr_seq_grupo_planej, 
		nr_seq_grupo_trab 
	into STRICT	cd_pessoa_solicitante_w, 
		ie_prioridade_w, 
		ie_classificacao_w, 
		ds_dano_breve_w, 
		ds_dano_w, 
		nr_seq_localizacao_w, 
		nr_seq_equipamento_w, 
		nr_seq_estagio_w, 
		nr_seq_grupo_planej_w, 
		nr_seq_grupo_trab_w 
	from	gpw_regra_geracao_os 
	where	nr_sequencia = nr_seq_regra_p;
	exception 
	when others then 
		ie_gerar_os_w := 'N';
	end;
	 
	if (ie_gerar_os_w = 'S') then 
		begin		 
		select	coalesce(max(d.nr_seq_mod_impl),0), 
			coalesce(max(d.cd_funcao),0) 
		into STRICT	nr_seq_mod_impl_w, 
			cd_funcao_w 
		from	funcao d, 
			man_ordem_servico c, 
			gpw_pendencia_classif b, 
			gpw_pendencia a 
		where	a.nr_sequencia	= b.nr_seq_pendencia 
		and	c.nr_sequencia	= a.nr_seq_ordem_serv 
		and	d.cd_funcao	= c.cd_funcao 
		and	b.nr_sequencia	= nr_sequencia_p;
		 
		select	nextval('man_ordem_servico_seq') 
		into STRICT	nr_seq_ordem_serv_w 
		;
		 
		insert	into man_ordem_servico( 
				cd_pessoa_solicitante, 
				nr_seq_localizacao, 
				nr_seq_equipamento, 
				ds_dano_breve, 
				ds_dano, 
				dt_atualizacao, 
				dt_ordem_servico, 
				ie_classificacao, 
				ie_origem_os, 
				ie_parado, 
				ie_prioridade, 
				ie_status_ordem, 
				ie_tipo_ordem, 
				nm_usuario, 
				nr_sequencia, 
				nr_seq_estagio, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				dt_inicio_desejado, 
				nr_grupo_trabalho, 
				nr_grupo_planej, 
				nr_seq_pend_classif_gpw) 
			values (	cd_pessoa_solicitante_w, 
				nr_seq_localizacao_w, 
				nr_seq_equipamento_w, 
				ds_dano_breve_w, 
				ds_dano_w, 
				clock_timestamp(), 
				clock_timestamp(), 
				ie_classificacao_w, 
				'1', 
				'N', 
				coalesce(ie_prioridade_w,'M'), 
				'1', 
				1, 
				nm_usuario_p, 
				nr_seq_ordem_serv_w, 
				nr_seq_estagio_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nr_seq_grupo_trab_w, 
				nr_seq_grupo_planej_w, 
				nr_sequencia_p);
		 
		open C01;
		loop 
		fetch C01 into	 
			nm_usuario_exec_w, 
			qt_min_prev_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			insert into man_ordem_servico_exec( 
					nr_sequencia, 
					nr_seq_ordem, 
					dt_atualizacao, 
					nm_usuario, 
					nm_usuario_exec, 
					qt_min_prev, 
					dt_recebimento, 
					nr_seq_funcao, 
					nr_seq_tipo_exec) 
				values (	nextval('man_ordem_servico_exec_seq'), 
					nr_seq_ordem_serv_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					nm_usuario_exec_w, 
					qt_min_prev_w, 
					clock_timestamp(), 
					null, 
					null);
			end;
		end loop;
		close C01;
		 
		commit;
		end;
	end if;
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpw_gerar_os_classif_pendencia ( nr_sequencia_p bigint, nr_seq_regra_p bigint, nm_usuario_p text) FROM PUBLIC;
