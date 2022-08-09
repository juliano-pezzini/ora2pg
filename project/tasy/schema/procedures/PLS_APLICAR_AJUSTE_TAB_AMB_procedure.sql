-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_aplicar_ajuste_tab_amb ( cd_edicao_amb_p edicao_amb.cd_edicao_amb%type, ie_aplicacao_regra_p text, pr_ajuste_filme_p bigint, pr_ajuste_qt_filme_p bigint, pr_ajuste_co_p bigint, pr_ajuste_medico_p bigint, pr_ajuste_vl_proced_p bigint, dt_inicio_vigencia_p timestamp, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

 
/* 
	ie_aplicacao_regra_p = 0 então é inflator do preço. 
	ie_aplicacao_regra_p = 1 então é deflator do preço. 
*/
 
dt_inicio_vigencia_w	timestamp;
ie_primeira_vez_w	boolean;
nr_contador_w		integer;
t_seq_registros_w	pls_util_cta_pck.t_number_table;

vl_procedimento_w	preco_amb.vl_procedimento%type;
vl_custo_operacional_w preco_amb.vl_custo_operacional%type;
vl_medico_w	    preco_amb.vl_medico%type;
vl_filme_w	    preco_amb.vl_filme%type;
qt_filme_w	    preco_amb.qt_filme%type;
vl_anestesista_w	preco_amb.vl_anestesista%type;
vl_auxiliares_w		preco_amb.vl_auxiliares%type;
nr_index_w		integer := 0;

--Pega todos os preços da tabela cujo final vigência estiver nulo 
--Como tem uma unique pelos campos do agrupamento abaixo, 
--somente irei gerar um registro para cada procedimento distinto(entre os que não tem fim vigência) 
C00 CURSOR(	cd_edicao_amb_pc	preco_amb.cd_edicao_amb%type) FOR 
	SELECT 	a.cd_procedimento, 
		a.ie_origem_proced, 
		a.cd_edicao_amb, 
		max(a.dt_inicio_vigencia) dt_inicio_vigencia_maior 
	from	preco_amb a 
	where	a.cd_edicao_amb = cd_edicao_amb_pc 
	and 	coalesce(a.dt_final_vigencia::text, '') = '' 
	group by a.cd_procedimento, 
		a.ie_origem_proced, 
		a.cd_edicao_amb 
	order by dt_inicio_vigencia_maior desc;

-- a regra de negócio no momento da criação desta rotina era que só iríamos alterar nas regras que não 
-- tem o fim de vigência informado 
C01 CURSOR(	cd_procedimento_pc	preco_amb.cd_procedimento%type, 
		ie_origem_proced_pc	preco_amb.ie_origem_proced%type, 
		cd_edicao_amb_pc	preco_amb.cd_edicao_amb%type) FOR 
	SELECT 	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced, 
		vl_procedimento, 
		coalesce(vl_custo_operacional, 0) vl_custo_operacional, 
		coalesce(vl_medico, 0) vl_medico, 
		coalesce(vl_filme, 0) vl_filme, 
		coalesce(qt_filme, 0) qt_filme, 
		cd_moeda, 
		vl_anestesista, 
		nr_auxiliares, 
		nr_incidencia, 
		qt_porte_anestesico, 
		vl_auxiliares 
	from 	preco_amb 
	where 	cd_edicao_amb = cd_edicao_amb_pc 
	and	ie_origem_proced = ie_origem_proced_pc 
	and	cd_procedimento	 = cd_procedimento_pc 
	and 	coalesce(dt_final_vigencia::text, '') = '' 
	order by dt_inicio_vigencia desc;

-- criada apenas para gravar os registros no banco 
procedure p_atualiza_registro(	t_seq_registros_p	in out pls_util_cta_pck.t_number_table, 
				dt_inicio_vigencia_p	in timestamp) is 
;
BEGIN
if (t_seq_registros_p.count > 0) then 
	forall i in t_seq_registros_p.first..t_seq_registros_p.last 
		update	preco_amb 
		set	dt_final_vigencia = (dt_inicio_vigencia_p - 1) 
		where	nr_sequencia = t_seq_registros_p(i) 
		and	coalesce(dt_final_vigencia::text, '') = '';
	commit;
end if;
 
t_seq_registros_p.delete;
 
end;
 
begin 
-- se não foi informado a vigência coloca a atual 
dt_inicio_vigencia_w := coalesce(dt_inicio_vigencia_p, trunc(clock_timestamp()));
nr_contador_w := 0;
 
for	r_C00_w	in C00(cd_edicao_amb_p) loop 
 
	-- só executa para regras cuja maior data de vigência atual seja menor que a data de vigência passada de parâmetro 
	-- isso para não criar regras no passado 
	-- se existir uma data de início de vigência maior na tabela do que a que está sendo passada de parâmetro aborta a execução 
	-- isso é possível através da aplicação do order by no cursor C00 
	if (r_C00_w.dt_inicio_vigencia_maior < dt_inicio_vigencia_w and (r_C00_w.dt_inicio_vigencia_maior IS NOT NULL AND r_C00_w.dt_inicio_vigencia_maior::text <> '')) then 
 
		ie_primeira_vez_w := true;
		for r_c01_w in C01(r_C00_w.cd_procedimento, r_C00_w.ie_origem_proced, cd_edicao_amb_p) loop 
 
			-- só entra e calcula no primeiro registro que é a maior data de vigência 
			if (ie_primeira_vez_w) then 
			 
				ie_primeira_vez_w := false;
				vl_procedimento_w	:= 0;
				vl_custo_operacional_w := 0;
				vl_medico_w	    := 0;
				vl_filme_w	    := 0;
				vl_anestesista_w := r_c01_w.vl_anestesista;
				vl_auxiliares_w := r_c01_w.vl_auxiliares;
				 
				-- se for informado o percentual do procedimento o mesmo é aplicado a todos os campos 
				if (coalesce(pr_ajuste_vl_proced_p, 0) > 0 ) then 
					-- 0 inflator, senão é deflator 
					if (ie_aplicacao_regra_p = 0) then 
 
						vl_filme_w := r_c01_w.vl_filme + dividir(r_c01_w.vl_filme * pr_ajuste_vl_proced_p, 100);
						qt_filme_w := r_c01_w.qt_filme + dividir(r_c01_w.qt_filme * pr_ajuste_vl_proced_p, 100 );
						vl_medico_w := r_c01_w.vl_medico + dividir( r_c01_w.vl_medico * pr_ajuste_vl_proced_p, 100);
						vl_custo_operacional_w := r_c01_w.vl_custo_operacional + dividir( r_c01_w.vl_custo_operacional * pr_ajuste_vl_proced_p,100);
						vl_anestesista_w := r_c01_w.vl_anestesista + dividir( r_c01_w.vl_anestesista * pr_ajuste_vl_proced_p,100);
						vl_auxiliares_w := r_c01_w.vl_auxiliares + dividir( r_c01_w.vl_auxiliares * pr_ajuste_vl_proced_p,100);
					else 
					 
						vl_filme_w := r_c01_w.vl_filme - dividir(r_c01_w.vl_filme * pr_ajuste_vl_proced_p, 100);
						qt_filme_w := r_c01_w.qt_filme - dividir(r_c01_w.qt_filme * pr_ajuste_vl_proced_p, 100 );
						vl_medico_w := r_c01_w.vl_medico - dividir( r_c01_w.vl_medico * pr_ajuste_vl_proced_p, 100);
						vl_custo_operacional_w := r_c01_w.vl_custo_operacional - dividir( r_c01_w.vl_custo_operacional * pr_ajuste_vl_proced_p,100);
						vl_anestesista_w := r_c01_w.vl_anestesista - dividir( r_c01_w.vl_anestesista * pr_ajuste_vl_proced_p,100);
						vl_auxiliares_w := r_c01_w.vl_auxiliares - dividir( r_c01_w.vl_auxiliares * pr_ajuste_vl_proced_p,100);
					end if;
				else 
					if ( (pr_ajuste_filme_p IS NOT NULL AND pr_ajuste_filme_p::text <> '') and pr_ajuste_filme_p > 0) then 
						if (ie_aplicacao_regra_p = 0) then 
							vl_filme_w := r_c01_w.vl_filme + dividir(r_c01_w.vl_filme * pr_ajuste_filme_p, 100);
						else 
							vl_filme_w := r_c01_w.vl_filme - dividir(r_c01_w.vl_filme * pr_ajuste_filme_p, 100);
						end if;
					else 
						vl_filme_w := r_c01_w.vl_filme;
					end if;
					if ( (pr_ajuste_qt_filme_p IS NOT NULL AND pr_ajuste_qt_filme_p::text <> '') and pr_ajuste_qt_filme_p > 0) then 
						if (ie_aplicacao_regra_p = 0) then 
							qt_filme_w := r_c01_w.qt_filme + dividir(r_c01_w.qt_filme * pr_ajuste_qt_filme_p, 100 );
						else 
							qt_filme_w := r_c01_w.qt_filme - dividir(r_c01_w.qt_filme * pr_ajuste_qt_filme_p, 100 );
						end if;
					else 
						qt_filme_w := r_c01_w.qt_filme;
					end if;
					if ( (pr_ajuste_co_p IS NOT NULL AND pr_ajuste_co_p::text <> '') and pr_ajuste_co_p > 0) then 
						if (ie_aplicacao_regra_p = 0) then 
							vl_custo_operacional_w := r_c01_w.vl_custo_operacional + dividir( r_c01_w.vl_custo_operacional * pr_ajuste_co_p,100);
						else 
							vl_custo_operacional_w := r_c01_w.vl_custo_operacional - dividir( r_c01_w.vl_custo_operacional * pr_ajuste_co_p,100);
						end if;
					else 
						vl_custo_operacional_w := r_c01_w.vl_custo_operacional;
					end if;
					if ( (pr_ajuste_medico_p IS NOT NULL AND pr_ajuste_medico_p::text <> '') and pr_ajuste_medico_p > 0) then 
						if (ie_aplicacao_regra_p = 0) then 
							vl_medico_w := r_c01_w.vl_medico + dividir( r_c01_w.vl_medico * pr_ajuste_medico_p, 100);
						else 
							vl_medico_w := r_c01_w.vl_medico - dividir( r_c01_w.vl_medico * pr_ajuste_medico_p, 100);
						end if;
					else 
						vl_medico_w := r_c01_w.vl_medico;
					end if;
				end if;
				 
				--Se valor do procedimento não estiver nulo, então atualiza o valor de acordo com os ajustes 
				if (r_c01_w.vl_procedimento IS NOT NULL AND r_c01_w.vl_procedimento::text <> '') then 
					vl_procedimento_w := vl_filme_w + vl_custo_operacional_w + vl_medico_w;
				else 
					vl_procedimento_w := 0;
				end if;
 
				insert into preco_amb(	 
					cd_edicao_amb, 
					cd_procedimento, 
					vl_procedimento, 
					cd_moeda, 
					dt_atualizacao, 
					nm_usuario, 
					vl_custo_operacional, 
					vl_anestesista, 
					vl_medico, 
					vl_filme, 
					qt_filme, 
					nr_auxiliares, 
					nr_incidencia, 
					qt_porte_anestesico, 
					ie_origem_proced, 
					vl_auxiliares, 
					dt_inicio_vigencia, 
					nr_sequencia 
				) values (	 
					cd_edicao_amb_p, 
					r_c01_w.cd_procedimento, 
					vl_procedimento_w, 
					r_c01_w.cd_moeda, 
					clock_timestamp(), 
					nm_usuario_p, 
					vl_custo_operacional_w, 
					vl_anestesista_w, 
					vl_medico_w, 
					vl_filme_w, 
					qt_filme_w, 
					r_c01_w.nr_auxiliares, 
					r_c01_w.nr_incidencia, 
					r_c01_w.qt_porte_anestesico, 
					r_c01_w.ie_origem_proced, 
					vl_auxiliares_w, 
					dt_inicio_vigencia_w, 
					nextval('preco_amb_seq') 
				);
			end if;
			 
			-- só armazena para futuramente dar update 
			t_seq_registros_w(nr_contador_w) := r_c01_w.nr_sequencia;
			 
			if (nr_contador_w >= pls_util_pck.qt_registro_transacao_w) then 
				p_atualiza_registro(t_seq_registros_w, dt_inicio_vigencia_w);
				nr_contador_w := 0;
			else 
				nr_contador_w := nr_contador_w + 1;
			end if;
		end loop;
	else	 
		-- exibe mensagem de erro 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(388899, 'DT_VIG_TABELA=' || to_char(r_C00_w.dt_inicio_vigencia_maior, 'DD/MM/YYYY') || 
								';CD_PROCEDIMENTO=' || to_char(r_C00_w.cd_procedimento) || 
								';DT_VIG_INFORMADA=' || to_char(dt_inicio_vigencia_w, 'DD/MM/YYYY') );
	end if;
end loop;
-- se sobrar algo manda bala 
p_atualiza_registro(t_seq_registros_w, dt_inicio_vigencia_w);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_aplicar_ajuste_tab_amb ( cd_edicao_amb_p edicao_amb.cd_edicao_amb%type, ie_aplicacao_regra_p text, pr_ajuste_filme_p bigint, pr_ajuste_qt_filme_p bigint, pr_ajuste_co_p bigint, pr_ajuste_medico_p bigint, pr_ajuste_vl_proced_p bigint, dt_inicio_vigencia_p timestamp, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
