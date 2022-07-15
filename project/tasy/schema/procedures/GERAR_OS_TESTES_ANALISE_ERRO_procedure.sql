-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_os_testes_analise_erro ( nr_seq_erro_p bigint, nm_usuario_p text, nr_ordem_servico_p INOUT bigint) AS $body$
DECLARE

 
nr_sequencia_w		bigint;
nr_seq_os_erro_w	bigint;
ds_dano_breve_w		varchar(255);
ds_dano_w		varchar(4000);
cd_funcao_w		integer;
nr_seq_gerencia_w	bigint;
nm_usuario_exec_w	varchar(15) := '';
qt_existe_w		bigint;
nr_seq_grupo_w		bigint;
nr_seq_localizacao_w	bigint;
ie_terceiro_w	varchar(1);
			

BEGIN 
select	b.nr_seq_gerencia, 
	b.nr_sequencia 
into STRICT	nr_seq_gerencia_w, 
	nr_seq_grupo_w 
from	grupo_desenvolvimento b, 
	man_doc_erro a 
where	b.nr_sequencia = a.nr_seq_grupo_des 
and	a.nr_sequencia = nr_seq_erro_p;
	 
if (coalesce(nr_seq_gerencia_w,0) in (3,4,7,11,17,21,60)) then 
	begin 
	select	a.nr_sequencia, 
		a.cd_funcao, 
		a.nr_seq_localizacao 
	into STRICT	nr_seq_os_erro_w, 
		cd_funcao_w, 
		nr_seq_localizacao_w 
	from	man_doc_erro b, 
		man_ordem_servico a 
	where	a.nr_sequencia = b.nr_seq_ordem 
	and	b.nr_sequencia = nr_seq_erro_p;
 
	ds_dano_breve_w		:= substr('Análise da OS ' || nr_seq_os_erro_w,1,255);
	ds_dano_w		:= substr('Analisar esta ordem de defeito verificando oportunidades de melhoria do protocolo de teste.' || chr(13) || chr(10) || 
						'Repassar as sugestões para o Analista de Sistemas responsável pela função.',1,4000);
 
	select	count(*) 
	into STRICT	qt_existe_w 
	from	man_ordem_servico 
	where	nr_seq_superior = nr_seq_os_erro_w;
 
	if (qt_existe_w = 0) then		 
		select	nextval('man_ordem_servico_seq') 
		into STRICT	nr_sequencia_w 
		;
 
		select	max(nm_usuario_vv) 
		into STRICT	nm_usuario_exec_w 
		from	funcao_grupo_des 
		where	cd_funcao = cd_funcao_w;
		 
		select	coalesce(max(ie_terceiro),'S') 
		into STRICT	ie_terceiro_w 
		from	man_localizacao 
		where	nr_sequencia = nr_seq_localizacao_w;
		 
		if (ie_terceiro_w = 'S') and (nm_usuario_exec_w IS NOT NULL AND nm_usuario_exec_w::text <> '') then	 
		 
			insert	into man_ordem_servico( 
				cd_pessoa_solicitante, 
				nr_seq_localizacao, 
				nr_seq_equipamento, 
				ds_dano_breve, 
				ds_dano, 
				cd_funcao, 
				dt_atualizacao, 
				dt_ordem_servico, 
				ie_classificacao, 
				ie_classificacao_cliente, 
				ie_origem_os, 
				ie_parado, 
				ie_prioridade, 
				ie_status_ordem, 
				ie_tipo_ordem, 
				nr_grupo_trabalho, 
				nr_grupo_planej, 
				nm_usuario, 
				nr_sequencia, 
				nr_seq_estagio, 
				nr_seq_grupo_sup, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				dt_inicio_desejado, 
				nr_seq_superior, 
				nr_seq_tipo_ordem) 
			values (	coalesce(substr(obter_pf_usuario(nm_usuario_exec_w,'C'),1,10),'7123'), /* Juliana - Qualidade */
 
				1272, /* Wheb Sistemas */
 
				2897, /* Área de Testes */
 
				ds_dano_breve_w, 
				ds_dano_w, 
				cd_funcao_w, 
				clock_timestamp(), 
				clock_timestamp(), 
				'S', 
				'S', 
				'1', 
				'N', 
				'M', 
				'1', 
				1, 
				132, /* Teste de software */
 
				91, /* Testes */
 
				nm_usuario_p, 
				nr_sequencia_w, 
				1061, /* Testes - análise */
 
				31, /* Testes */
 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nr_seq_os_erro_w, 
				12);
 
			select	count(*) 
			into STRICT	qt_existe_w 
			from	man_ordem_servico_exec 
			where	nr_seq_ordem	= nr_sequencia_w 
			and	nm_usuario_exec	= nm_usuario_exec_w;
 
			if (qt_existe_w = 0) then 
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
						nr_sequencia_w, 
						clock_timestamp(), 
						'Tasy', 
						nm_usuario_exec_w, 
						10, 
						clock_timestamp(), 
						null, 
						3);
			end if;
		 
			commit;
		 
			nr_ordem_servico_p := nr_sequencia_w;
		end if;	
	end if;
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_os_testes_analise_erro ( nr_seq_erro_p bigint, nm_usuario_p text, nr_ordem_servico_p INOUT bigint) FROM PUBLIC;

