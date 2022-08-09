-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pcs_gerar_dados_agenda ( nr_seq_regra_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_empresa_w		 smallint;
cd_estabelecimento_w	 smallint;
cd_estabelecimento_ww	 smallint;
ds_atividade_w		 varchar(4000);
dt_inicio_vigencia_w	 timestamp;
dt_fim_vigencia_w	 	timestamp;
ie_estagio_padrao_w	 varchar(15);
ie_situacao_w		 varchar(1);
nr_grupo_planej_w	 	bigint;
nr_grupo_trabalho_w	 bigint;
nr_seq_atividade_w	 	bigint;
nr_seq_grupamento_w	 bigint;
nr_seq_grupamento_ww	 bigint;
nr_seq_regional_w	 	bigint;
nr_seq_tipo_lista_w	 	bigint;
qt_dias_antecipacao_w	 integer;
hr_inicio_w		 timestamp;
ie_dia_semana_w		 varchar(15);
ie_feriado_w		 varchar(15);
ie_semana_w		varchar(15);
nr_seq_regra_ativ_w	bigint;
qt_minutos_prev_w	 	integer;
nr_seq_regra_ativ_dias_w 	bigint;
nr_seq_agenda_ativ_w	 bigint;
dt_hora_inicio_w	 	timestamp;
dt_hora_final_w		 timestamp;
nr_dia_inicial_semana_w	integer;
nr_dia_final_semana_w	integer;
qt_dias_mes_w		integer;
nm_usuario_param_w	varchar(15);
nr_seq_grupo_trabalho_w	bigint;
nr_seq_ativ_exec_w	bigint;
ie_continua_w		varchar(1);
dt_hora_vigencia_w	timestamp;
dt_ativ_com_os_w		timestamp;
cd_responsavel_w		varchar(10);
ie_forma_geracao_w	varchar(1);
ie_possui_grupamento_w	varchar(1);
ie_responsavel_w		varchar(15);
nr_seq_relatorio_w		pcs_segmento_compras_rel.nr_sequencia%type;
ie_dia_util_w		varchar(1);

C01 CURSOR FOR 
	SELECT 	cd_empresa, 
		cd_estabelecimento, 
		ds_atividade, 
		dt_inicio_vigencia, 
		dt_fim_vigencia, 
		ie_estagio_padrao, 
		ie_situacao, 
		nr_grupo_planej, 
		nr_grupo_trabalho, 
		nr_seq_atividade, 
		nr_seq_grupamento, 
		nr_seq_regional, 
		nr_seq_tipo_lista, 
		nr_sequencia, 
		qt_dias_antecipacao, 
		ie_responsavel 
	from	pcs_regra_atividades 
	where	ie_selecionado = 'S' 
	and	ie_situacao = 'A' 
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

C02 CURSOR FOR 
	SELECT	hr_inicio, 
		ie_dia_semana, 
		ie_feriado, 
		coalesce(ie_semana,'T'), 
		nr_sequencia, 
		qt_minutos_prev 
	from	pcs_regra_atividades_dias 
	where	nr_seq_regra = nr_seq_regra_ativ_w;

C03 CURSOR FOR 
	SELECT	a.nm_usuario_param 
	from	man_grupo_trab_usuario a, 
		usuario b 
	where	a.nm_usuario_param = b.nm_usuario 
	and	a.nr_seq_grupo_trab = nr_grupo_trabalho_w 
	and	(a.nm_usuario_param IS NOT NULL AND a.nm_usuario_param::text <> '') 
	and	b.ie_situacao = 'A';
	
C04 CURSOR FOR 
	 
	SELECT distinct x.cd_responsavel	 
	from (SELECT	b.cd_responsavel 
		from	pcs_regra_atividades a, 
			pcs_regra_atividades_resp b 
		where	a.nr_sequencia = b.nr_seq_regra 
		and	b.nr_seq_regra = nr_seq_regra_ativ_w 
		and	ie_responsavel_w = 'I' --Informado na regra 
		and	(obter_usuario_ativo_pf(b.cd_responsavel) IS NOT NULL AND (obter_usuario_ativo_pf(b.cd_responsavel))::text <> '') 
		
union all
 
		select	a.cd_responsavel 		--Quando não tiver política 
		from		pcs_grupamentos a,	 
				pcs_segmento b, 
				pcs_estrutura_segmento c 
		where	a.nr_sequencia = b.nr_seq_grupamento 
		and	 	a.nr_sequencia = c.nr_seq_grupamento 
		and	 	b.nr_sequencia = c.nr_seq_segmento 
		and		a.cd_empresa = coalesce(cd_empresa_w,a.cd_empresa)		 
		/*and		(((obter_dias_estoque_material(c.cd_estabelecimento,c.cd_material,nm_usuario_p) <= nvl(a.qt_dias_corte_mlc,0)) and (pcs_obter_tipo_lista(nr_seq_tipo_lista_w) = 'MLC')) 
		or		((obter_dias_estoque_material(c.cd_estabelecimento,c.cd_material,nm_usuario_p) <= nvl(a.qt_dias_corte_lc,0)) and (pcs_obter_tipo_lista(nr_seq_tipo_lista_w) = 'LC')))*/
 
		and	pcs_obter_tipo_lista(nr_seq_tipo_lista_w) in ('MLC','LC','PV')	 
		and		ie_responsavel_w in ('C','P') --Lista crtica ou Manuteno da lista crtica ou previsão vencida 
		and	(obter_usuario_ativo_pf(a.cd_responsavel) IS NOT NULL AND (obter_usuario_ativo_pf(a.cd_responsavel))::text <> '')	 
		and	pcs_obter_se_possui_politica(a.nr_sequencia) = 'N' 
		
union all
 
		select	pcs_obter_responsavel_politica(d.nr_seq_grupamento,cd_estabelecimento_ww,cd_empresa_w,nm_usuario_p)--Quando tiver política		 
		from		pcs_grupamentos a,	 
				pcs_segmento b, 
				pcs_estrutura_segmento c, 
				pcs_politicas_grupamento d 
		where	a.nr_sequencia = b.nr_seq_grupamento 
		and	a.nr_sequencia = c.nr_seq_grupamento 
		and	b.nr_sequencia = c.nr_seq_segmento 
		and	a.nr_sequencia = d.nr_seq_grupamento 
		and	pcs_obter_tipo_lista(nr_seq_tipo_lista_w) in ('MLC','LC','PV') 
		/*and	(((obter_dias_estoque_material(c.cd_estabelecimento,c.cd_material,nm_usuario_p) <= nvl(d.qt_dias_corte_mlc,0)) and (pcs_obter_tipo_lista(nr_seq_tipo_lista_w) = 'MLC')) 
		or	((obter_dias_estoque_material(c.cd_estabelecimento,c.cd_material,nm_usuario_p) <= nvl(d.qt_dias_corte_lc,0)) and (pcs_obter_tipo_lista(nr_seq_tipo_lista_w) = 'LC')))*/
 
		and	ie_responsavel_w in ('C','P') --Lista crtica ou Manuteno da lista crtica ou previsão vencida 
		and	pcs_obter_se_possui_politica(a.nr_sequencia) = 'S' 
		/*union all 
		select	b.cd_pessoa_resp_lc cd_responsavel 
		from	pcs_segmento_compras_rel a, 
			pcs_seg_compras_rel_item b 
		where	a.nr_sequencia = b.nr_seq_relatorio 
		and	b.nr_seq_relatorio = nr_seq_relatorio_w 
		and	ie_responsavel_w = 'P' 
		and	pcs_obter_tipo_lista(nr_seq_tipo_lista_w) = 'PV' 
		and	(to_date(to_char(nvl(b.dt_entrega_prevista_oc,sysdate),'dd/mm/yyyy') || ' 00:00:00', 'dd/mm/yyyy hh24:mi:ss')	<= nvl(dt_geracao,sysdate))*/
 
		
union all
 
		select	a.cd_responsavel 
		from		pcs_grupamentos a 
		where	a.nr_sequencia = nr_seq_grupamento_w 
		and	ie_responsavel_w = 'G' --Grupamento informado 
		and	(nr_seq_grupamento_w IS NOT NULL AND nr_seq_grupamento_w::text <> '') 
		and	(obter_usuario_ativo_pf(a.cd_responsavel) IS NOT NULL AND (obter_usuario_ativo_pf(a.cd_responsavel))::text <> '')	 
		and	a.cd_empresa = coalesce(cd_empresa_w,a.cd_empresa)	 
		and	pcs_obter_se_possui_politica(a.nr_sequencia) = 'N' 
		
union all
 
		select	pcs_obter_responsavel_politica(d.nr_seq_grupamento,cd_estabelecimento_ww,cd_empresa_w,nm_usuario_p)--Quando tiver política		 
		from	pcs_grupamentos a,	 
			pcs_politicas_grupamento d 
		where	a.nr_sequencia = d.nr_seq_grupamento 
		and	a.nr_sequencia = nr_seq_grupamento_w 
		and	ie_responsavel_w = 'G' --Grupamento informado			 
		and	obter_empresa_estab(cd_estabelecimento_ww) = a.cd_empresa 
		and	pcs_obter_se_possui_politica(a.nr_sequencia) = 'S'			 
		
union all
	 
		select	obter_pf_usuario(nm_usuario_param,'C') cd_responsavel 
		from	man_grupo_trab_usuario 
		where	nr_seq_grupo_trab = nr_grupo_trabalho_w	 
		and	ie_responsavel_w = 'T' --Grupo de trabalho 
		and	(nr_grupo_trabalho_w IS NOT NULL AND nr_grupo_trabalho_w::text <> '') 
		and	obter_usuario_ativo_pf(obter_pf_usuario(nm_usuario_param,'C')) is not null) x	 
	order by cd_responsavel;	
 
 
C05 CURSOR FOR 
	SELECT cd_estabelecimento_ww 
	 
	where ie_forma_geracao_w = 'E'	 
	
union all
 
	SELECT cd_estabelecimento 
	from estabelecimento 
	where cd_empresa = cd_empresa_w 
	and ie_forma_geracao_w = 'M'	 
	
union all
 
	select	cd_estab_vinculado 
	from	pcs_estab_regionais 
	where	nr_seq_regional = nr_seq_regional_w 
	and	ie_forma_geracao_w = 'R';

 
	 
BEGIN 
 
nr_seq_regra_ativ_w := null;
 
select 	max(a.nr_sequencia) 
into STRICT	nr_seq_relatorio_w 
from	pcs_segmento_compras_rel a, 
	pcs_seg_compras_rel_item b 
where	a.nr_sequencia = b.nr_seq_relatorio 
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '');
 
open C01;
loop 
fetch C01 into 
	cd_empresa_w, 
	cd_estabelecimento_ww, 
	ds_atividade_w, 
	dt_inicio_vigencia_w, 
	dt_fim_vigencia_w, 
	ie_estagio_padrao_w, 
	ie_situacao_w, 
	nr_grupo_planej_w, 
	nr_grupo_trabalho_w, 
	nr_seq_atividade_w, 
	nr_seq_grupamento_w, 
	nr_seq_regional_w, 
	nr_seq_tipo_lista_w, 
	nr_seq_regra_ativ_w, 
	qt_dias_antecipacao_w, 
	ie_responsavel_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	delete	from pcs_agenda_atividades 
	where	coalesce(nr_ordem_Servico::text, '') = '' 
	and	nr_seq_regra = nr_seq_regra_ativ_w;
	 
	commit;
	 
	select	max(dt_inicio)   --Para buscar a data de inicio na agenda mais recente, para caso for alterada algo na regra gerar novamente a partir desta data. 
	into STRICT	dt_ativ_com_os_w 
	from 	pcs_agenda_atividades 
	where	(nr_ordem_Servico IS NOT NULL AND nr_ordem_Servico::text <> '') 
	and		nr_seq_regra = nr_seq_regra_ativ_w;	
	 
	 
	if (cd_estabelecimento_ww IS NOT NULL AND cd_estabelecimento_ww::text <> '') then 
	ie_forma_geracao_w := 'E';
	elsif (nr_seq_regional_w IS NOT NULL AND nr_seq_regional_w::text <> '') then 
	ie_forma_geracao_w := 'R';
	elsif (cd_empresa_w IS NOT NULL AND cd_empresa_w::text <> '') then 
	ie_forma_geracao_w := 'M';
	end if;			
 
	open C02;
	loop 
	fetch C02 into 
		hr_inicio_w, 
		ie_dia_semana_w, 
		ie_feriado_w, 
		ie_semana_w, 
		nr_seq_regra_ativ_dias_w, 
		qt_minutos_prev_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		nr_dia_inicial_semana_w := 0;
 
		--O cursor para cada estabelecimento 
		 
		select	to_char(dt_inicio_vigencia_w,'dd') --Pega o Dia ex: 10 
		into STRICT	nr_dia_inicial_semana_w 
		;
 
		select	(to_char(pkg_date_utils.end_of(dt_inicio_vigencia_w, 'MONTH', 0), 'dd'))::numeric  --Quantidade de dias no ms. Ex:30 
		into STRICT	qt_dias_mes_w 
		;
 
		nr_dia_final_semana_w := 0;
		 
		select	round(dt_fim_vigencia_w - dt_inicio_vigencia_w)  --Quantidade de dias do perodo de vigncia 
		into STRICT	nr_dia_final_semana_w 
		;
		 
		if (ie_semana_w <> 'T') then --Se for diferente da opo 'Todas as semanas'. Vai ser considerada a semana informada(ie_semana_w) ex: 1semana, 2 semana 
 
			for i in nr_dia_inicial_semana_w..nr_dia_final_semana_w loop 
				begin	 
 
 
 
				dt_inicio_vigencia_w := trunc(dt_inicio_vigencia_w,'mm');
				 
				select	to_date(max(dt_inicio_vigencia_w + i)) 
				into STRICT	dt_hora_inicio_w 
				 
				where	pkg_date_utils.get_WeekDay(dt_inicio_vigencia_w + i) = ie_dia_semana_w 
				and		obter_semana_dia(to_date(dt_inicio_vigencia_w + i)) = ie_semana_w;
														 
				if (dt_hora_inicio_w IS NOT NULL AND dt_hora_inicio_w::text <> '') and  --Caso alguma vez foi gerado OS para a regra, ser verificado a atividade mais recente que tenha OS. Dai ser gerado novamente a partir da mais recente.; 
					((dt_ativ_com_os_w IS NOT NULL AND dt_ativ_com_os_w::text <> '' AND dt_hora_inicio_w > dt_ativ_com_os_w) or (coalesce(dt_ativ_com_os_w::text, '') = '')) then 
					 
					dt_hora_inicio_w	:= to_date(to_char(dt_hora_inicio_w,'dd/mm/yyyy') || '' || to_char(hr_inicio_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
 
 
					open C05;
					loop 
					fetch C05 into	 
						cd_estabelecimento_w;
					EXIT WHEN NOT FOUND; /* apply on C05 */
						begin								 
					 
						select	Obter_Se_Dia_Util(trunc(dt_hora_inicio_w,'dd'),cd_estabelecimento_w) 
						into STRICT	ie_dia_util_w 
						;
						 
						if (ie_dia_util_w = 'N') then 
							if (ie_feriado_w = 'A') then 
								select	obter_dia_util_anterior(cd_estabelecimento_w,dt_hora_inicio_w) 
								into STRICT	dt_hora_inicio_w	 
								;
							elsif (ie_feriado_w = 'P') then 
								select	obter_proximo_dia_util(cd_estabelecimento_w,dt_hora_inicio_w) 
								into STRICT	dt_hora_inicio_w	 
								;												
							end if;
						end if;						
						dt_hora_final_w		:= dt_hora_inicio_w + qt_minutos_prev_w/1440;										
					 
						open C04;
						loop 
						fetch C04 into	 
							cd_responsavel_w;
						EXIT WHEN NOT FOUND; /* apply on C04 */
							begin 
							 
							select	nextval('pcs_agenda_atividades_seq') 
							into STRICT	nr_seq_agenda_ativ_w 
							;
			 
							insert into pcs_agenda_atividades( 
									nr_sequencia, 
									cd_estabelecimento, 
									dt_atualizacao, 
									nm_usuario, 
									dt_atualizacao_nrec, 
									nm_usuario_nrec, 
									nr_seq_regra, 
									nr_seq_atividade, 
									dt_inicio, 
									dt_fim, 
									qt_minutos, 
									nr_ordem_servico, 
									ie_status, 
									nr_seq_regional, 
									nr_seq_grupamento, 
									cd_responsavel, 
									ie_situacao) 
							values (	nr_seq_agenda_ativ_w, 
									cd_estabelecimento_w, 
									clock_timestamp(), 
									nm_usuario_p, 
									clock_timestamp(), 
									nm_usuario_p, 
									nr_seq_regra_ativ_w, 
									nr_seq_atividade_w, 
									dt_hora_inicio_w, 
									dt_hora_final_w, 
									qt_minutos_prev_w, 
									null, 
									'B', 
									nr_seq_regional_w, 
									nr_seq_grupamento_w, 
									cd_responsavel_w, 
									'A');
		 
							 
								open C03;
								loop 
								fetch C03 into	 
									nm_usuario_param_w;
								EXIT WHEN NOT FOUND; /* apply on C03 */
									begin 
									 
									select	nextval('pcs_agenda_atividades_exec_seq') 
									into STRICT	nr_seq_ativ_exec_w 
									;
									 
									insert into pcs_agenda_atividades_exec(	 
											nr_sequencia, 
											dt_atualizacao, 
											nm_usuario, 
											dt_atualizacao_nrec, 
											nm_usuario_nrec, 
											nr_seq_agenda, 
											nm_usuario_exec) 
									values (	nr_seq_ativ_exec_w, 
											clock_timestamp(), 
											nm_usuario_p, 
											clock_timestamp(), 
											nm_usuario_p, 
											nr_seq_agenda_ativ_w, 
											nm_usuario_param_w 
									);
									 
									end;
								end loop;
								close C03;						
							end;
						end loop;
						close C04;	
	 
						 
						end;
					end loop;
					close C05;
 
				end if;
				end;
			end loop;
		elsif	(ie_semana_w = 'T') then --Se a opo for igual a 'Todas as semanas'. Vai ser considerada todas as semanas pegando o dia da semana(ie_dia_semana_w) do periodo de vigencia. 
			for i in 1..nr_dia_final_semana_w loop 
				begin 
 
				select	to_date(max(dt_inicio_vigencia_w + i)) 
				into STRICT	dt_hora_inicio_w 
				 
				where	pkg_date_utils.get_WeekDay(dt_inicio_vigencia_w + i) = ie_dia_semana_w;
												 
				if (dt_hora_inicio_w IS NOT NULL AND dt_hora_inicio_w::text <> '') and 
					((dt_ativ_com_os_w IS NOT NULL AND dt_ativ_com_os_w::text <> '' AND dt_hora_inicio_w > dt_ativ_com_os_w) or (coalesce(dt_ativ_com_os_w::text, '') = '')) then 
							 
					dt_hora_inicio_w := to_date(to_char(dt_hora_inicio_w,'dd/mm/yyyy') || '' || to_char(hr_inicio_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
					 
					open C05;
					loop 
					fetch C05 into	 
						cd_estabelecimento_w;
					EXIT WHEN NOT FOUND; /* apply on C05 */
						begin 
					 
						select	Obter_Se_Dia_Util(trunc(dt_hora_inicio_w,'dd'),cd_estabelecimento_w) 
						into STRICT	ie_dia_util_w 
						;
						 
						if (ie_dia_util_w = 'N') then 
							if (ie_feriado_w = 'A') then 
								select	obter_dia_util_anterior(cd_estabelecimento_w,dt_hora_inicio_w) 
								into STRICT	dt_hora_inicio_w	 
								;
							elsif (ie_feriado_w = 'P') then 
								select	obter_proximo_dia_util(cd_estabelecimento_w,dt_hora_inicio_w) 
								into STRICT	dt_hora_inicio_w	 
								;												
							end if;
						end if;						
						dt_hora_final_w		:= dt_hora_inicio_w + qt_minutos_prev_w/1440;	
						 
						open C04;
						loop 
						fetch C04 into	 
							cd_responsavel_w;
						EXIT WHEN NOT FOUND; /* apply on C04 */
							begin				 
	 
							select	nextval('pcs_agenda_atividades_seq') 
							into STRICT	nr_seq_agenda_ativ_w 
							;									
		 
							insert into pcs_agenda_atividades( 
									nr_sequencia, 
									cd_estabelecimento, 
									dt_atualizacao, 
									nm_usuario, 
									dt_atualizacao_nrec, 
									nm_usuario_nrec, 
									nr_seq_regra, 
									nr_seq_atividade, 
									dt_inicio, 
									dt_fim, 
									qt_minutos, 
									nr_ordem_servico, 
									ie_status, 
									nr_seq_regional, 
									nr_seq_grupamento, 
									cd_responsavel, 
									ie_situacao) 
							values (	nr_seq_agenda_ativ_w, 
									cd_estabelecimento_w, 
									clock_timestamp(), 
									nm_usuario_p, 
									clock_timestamp(), 
									nm_usuario_p, 
									nr_seq_regra_ativ_w, 
									nr_seq_atividade_w, 
									dt_hora_inicio_w, 
									dt_hora_final_w, 
									qt_minutos_prev_w, 
									null, 
									'B', 
									nr_seq_regional_w, 
									nr_seq_grupamento_w, 
									cd_responsavel_w, 
									'A');
	 
							open C03;
							loop 
							fetch C03 into	 
								nm_usuario_param_w;
							EXIT WHEN NOT FOUND; /* apply on C03 */
								begin 
								 
								select	nextval('pcs_agenda_atividades_exec_seq') 
								into STRICT	nr_seq_ativ_exec_w 
								;
			 
								insert into pcs_agenda_atividades_exec(	 
										nr_sequencia, 
										dt_atualizacao, 
										nm_usuario, 
										dt_atualizacao_nrec, 
										nm_usuario_nrec, 
										nr_seq_agenda, 
										nm_usuario_exec) 
								values (		nr_seq_ativ_exec_w, 
										clock_timestamp(), 
										nm_usuario_p, 
										clock_timestamp(), 
										nm_usuario_p, 
										nr_seq_agenda_ativ_w, 
										nm_usuario_param_w);
								 
								end;
							end loop;
							close C03;		
	 
							end;
						end loop;
						close C04;		
						 
						end;
					end loop;
					close C05;
					 
				end if;						
				end;
			end loop;
		end if;
		 
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;	
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pcs_gerar_dados_agenda ( nr_seq_regra_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
