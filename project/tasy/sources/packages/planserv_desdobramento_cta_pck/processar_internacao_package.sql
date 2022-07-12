-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

 
	--Quebra das Contas de Internação 
CREATE OR REPLACE PROCEDURE planserv_desdobramento_cta_pck.processar_internacao ( nr_interno_conta_p conta_paciente.nr_interno_conta%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

 
 
		nr_interno_conta_w			conta_paciente.nr_interno_conta%type;
		ie_tipo_agrup_ant_w			agrup_classif_setor.ie_tipo_agrup%type;
		nr_atendimento_w			atendimento_paciente.nr_atendimento%type;
		cd_convenio_parametro_w			conta_paciente.cd_convenio_parametro%type;
		cd_categoria_parametro_w		conta_paciente.cd_categoria_parametro%type;
		cd_estabelecimento_w			estabelecimento.cd_estabelecimento%type;
		qt_dia_desdob_conta_w			convenio_estabelecimento.qt_dia_desdob_conta%type;
		dt_conta_ant_w				timestamp;		
		qt_conta_pacote_w			bigint;
						
		dt_periodo_inicial_w			timestamp;
		dt_periodo_final_w			timestamp;
		dt_periodo_final_ant_w			timestamp;
		dt_inicio_pacote_w			timestamp;
		dt_final_pacote_w			timestamp;	
 
		 
		cur REFCURSOR;
		ds_comando_w				varchar(4000);

		nr_interno_conta_ww			conta_paciente.nr_interno_conta%type;
		dt_inicial_atual_ww			timestamp;
		dt_final_atual_ww			timestamp;
		qt_contas_periodo_w			double precision;
		dt_conta_periodo_ini_w			timestamp;
		dt_conta_periodo_fin_w			timestamp;
		dt_entrada_w				timestamp;
		dt_alta_w				timestamp;
		qt_dias_conta_w				double precision;
		qt_pendencia_w				bigint;
		
 
		c01 CURSOR FOR 
			SELECT 	b.dt_inicio_pacote, 
				b.dt_final_pacote	 
			from 	conta_paciente c, 
				procedimento_paciente a, 
				atendimento_pacote b 
			where 	a.nr_interno_conta = nr_interno_conta_p 
			and 	a.nr_seq_proc_pacote = a.nr_sequencia 
			and 	a.nr_sequencia = b.nr_seq_procedimento 
			and	a.nr_interno_conta = c.nr_interno_conta 
			and	coalesce(c.ie_tipo_atend_conta,0) <> 3 
			and	coalesce(a.cd_motivo_exc_conta::text, '') = '';
				
		c02 CURSOR(	dt_inicio_pacote_p	timestamp, 
				dt_final_pacote_p	timestamp) FOR 
			SELECT	1 ie_proc_mat, 
				a.nr_sequencia 
			from	procedimento_paciente a 
			where	a.nr_interno_conta = nr_interno_conta_p 
			and	a.dt_conta between dt_inicio_pacote_p and dt_final_pacote_p 
			and	coalesce(a.cd_motivo_exc_conta::text, '') = '' 
			
union all
 
			SELECT	2 ie_proc_mat, 
				a.nr_sequencia 
			from	material_atend_paciente a 
			where	a.nr_interno_conta = nr_interno_conta_p 
			and	a.dt_conta between dt_inicio_pacote_p and dt_final_pacote_p 
			and	coalesce(a.cd_motivo_exc_conta::text, '') = '';
				
		c03 CURSOR FOR 
			SELECT	1 ie_proc_mat, 
				a.nr_sequencia, 
				c.ie_tipo_agrup, 
				a.dt_conta, 
				a.dt_entrada_unidade			 
			FROM procedimento_paciente a, setor_atendimento s
LEFT OUTER JOIN agrup_classif_setor c ON (s.nr_seq_agrup_classif = c.nr_sequencia)
WHERE a.cd_setor_atendimento = s.cd_setor_atendimento  and a.nr_interno_conta = nr_interno_conta_p and coalesce(a.cd_motivo_exc_conta::text, '') = '' and a.dt_conta >= a.dt_entrada_unidade 
			 
union all
 
			SELECT	2 ie_proc_mat, 
				a.nr_sequencia, 
				c.ie_tipo_agrup, 
				a.dt_conta, 
				a.dt_entrada_unidade	 
			FROM material_atend_paciente a, setor_atendimento s
LEFT OUTER JOIN agrup_classif_setor c ON (s.nr_seq_agrup_classif = c.nr_sequencia)
WHERE a.cd_setor_atendimento = s.cd_setor_atendimento  and a.nr_interno_conta = nr_interno_conta_p and coalesce(a.cd_motivo_exc_conta::text, '') = '' and a.dt_conta >= a.dt_entrada_unidade and ((a.qt_material >= 0) or (a.dt_conta > to_date('01032016','ddmmyyyy')))  -- *** 
 order by dt_conta, ie_tipo_agrup;	
			-- O tratamento para trazer somente materias com qtde maior que zero até 01/03/2016 foi criado pois as devoluções até esta data 
			-- foram realizadas com data incorreta devido a problemas de parametrização do Hopsital Português. 
			--A data de devolução deve ser realizada sempre com a mesma dt conta do item original 
		
BEGIN 
 
		delete from log_planserv_desdob;
 
		update	conta_paciente 
		set	nr_seq_ordem  = NULL 
		where	nr_interno_conta = nr_interno_conta_p;
 
		CALL CALL planserv_desdobramento_cta_pck.gravar_log('Inicio desdobramento Planserv' ,nm_usuario_p);
		begin 
			select 	nr_atendimento, 
				cd_convenio_parametro, 
				cd_categoria_parametro, 
				cd_estabelecimento 
			into STRICT	nr_atendimento_w, 
				cd_convenio_parametro_w, 
				cd_categoria_parametro_w, 
				cd_estabelecimento_w 
			from 	conta_paciente 
			where	nr_interno_conta = nr_interno_conta_p;		
		exception 
		when others then 
			nr_atendimento_w :=0;
		end;
 
		begin 
			select	a.dt_alta, 
				a.dt_entrada 
			into STRICT	dt_alta_w, 
				dt_entrada_w 
			from	atendimento_paciente a 
			where	a.nr_atendimento = nr_atendimento_w;	
		exception 
		when others then 
			dt_alta_w := null;
			dt_entrada_w := null;
		end;
 
		CALL CALL planserv_desdobramento_cta_pck.gravar_log('Entrada:	' || to_char(dt_entrada_w,'dd/mm/yyyy hh24:mi:ss') ,nm_usuario_p);
		CALL CALL planserv_desdobramento_cta_pck.gravar_log('Alta: 	' ||to_char(dt_alta_w,'dd/mm/yyyy hh24:mi:ss') ,nm_usuario_p);
 
		select 	coalesce(max(qt_dia_desdob_conta),0) 
		into STRICT	qt_dia_desdob_conta_w 
		from	convenio_estabelecimento 
		where	cd_convenio = cd_convenio_parametro_w 
		and	cd_estabelecimento = cd_estabelecimento_w;
 
		CALL CALL planserv_desdobramento_cta_pck.gravar_log('Qtde Dias Desdobramento: 	'||qt_dia_desdob_conta_w ,nm_usuario_p);
		--Busca todas os pacotes da conta e cria uma conta para cada 
		--Após isso, transfere os itens para estas contas de acordo com o periodo do item 
 
		for r1 in c01 loop 
			 
		   nr_interno_conta_w := planserv_desdobramento_cta_pck.inserir_conta_paciente(	nr_interno_conta_p, r1.dt_inicio_pacote, r1.dt_final_pacote, nm_usuario_p, nr_interno_conta_w);
			CALL CALL planserv_desdobramento_cta_pck.gravar_log('Criada Conta de Pacote: 	'||nr_interno_conta_w ,nm_usuario_p);
			 
			 
			for r2 in c02(r1.dt_inicio_pacote, r1.dt_final_pacote) loop 
				 
				if r2.ie_proc_mat = 1 then 
					update	procedimento_paciente 
					set	nr_interno_conta = nr_interno_conta_w 
					where 	nr_sequencia = r2.nr_sequencia;			
				else 
					update	material_atend_paciente 
					set	nr_interno_conta = nr_interno_conta_w 
					where	nr_sequencia = r2.nr_sequencia;			
				end if;	
			 
			end loop;
 
		end loop;
 
		commit;
 
 
		nr_interno_conta_w:=0;
		dt_conta_ant_w:= null;
		--Busca os itens que não são de pacote para separar em novas contas, de acordo com o tipo de agrupamento do setor 
		for r3 in C03 loop 
			 
			--se o setor do item não tem tipo de agrupamento, utiliza o tipo de agrupamento da unidade anterior 
			if coalesce(r3.ie_tipo_agrup::text, '') = '' then 
				select max(c.ie_tipo_agrup) 
				into STRICT  r3.ie_tipo_agrup 
				from 	atend_paciente_unidade a, 
					setor_atendimento s, 
					agrup_classif_setor c 
				where	a.cd_setor_atendimento = s.cd_setor_atendimento 
				and	c.nr_sequencia = s.nr_seq_agrup_classif 
				and   a.nr_atendimento = nr_atendimento_w 
				and   a.dt_entrada_unidade = (  
								SELECT 	max(x.dt_entrada_unidade)  
								from 	atend_paciente_unidade x, 
									setor_atendimento y,	 
									agrup_classif_setor z					 
								where 	x.nr_Atendimento = a.nr_atendimento 
								and	x.cd_setor_atendimento = y.cd_setor_atendimento 
								and	z.nr_sequencia = y.nr_seq_agrup_classif 
								and	(z.ie_tipo_agrup IS NOT NULL AND z.ie_tipo_agrup::text <> '') 
								and 	x.dt_entrada_unidade < r3.dt_conta 
								);
								 
				-- se não encontrar conta no periodo da data de entrada da unidade, procura pela data conta 
				if coalesce(r3.ie_tipo_agrup::text, '') = '' then 
				 
					select max(c.ie_tipo_agrup) 
					into STRICT  r3.ie_tipo_agrup 
					from 	atend_paciente_unidade a, 
						setor_atendimento s, 
						agrup_classif_setor c 
					where	a.cd_setor_atendimento = s.cd_setor_atendimento 
					and	c.nr_sequencia = s.nr_seq_agrup_classif 
					and   a.nr_atendimento = nr_atendimento_w 
					and   a.dt_entrada_unidade = (  
									SELECT 	max(x.dt_entrada_unidade)  
									from 	atend_paciente_unidade x, 
										setor_atendimento y,	 
										agrup_classif_setor z					 
									where 	x.nr_Atendimento = a.nr_atendimento 
									and	x.cd_setor_atendimento = y.cd_setor_atendimento 
									and	z.nr_sequencia = y.nr_seq_agrup_classif 
									and	(z.ie_tipo_agrup IS NOT NULL AND z.ie_tipo_agrup::text <> '') 
									and 	x.dt_entrada_unidade < r3.dt_entrada_unidade 
									);
				 
				end if;
				 
			end if;
			 
			--Se houver um pacote dentro do período da conta e o lançamento do item atual, seta o periodo final e cria uma nova conta	 
			if (dt_conta_ant_w IS NOT NULL AND dt_conta_ant_w::text <> '') and  
			  ie_tipo_agrup_ant_w = r3.ie_tipo_agrup then		 
			 
				select 	count(1)	 
				into STRICT	qt_conta_pacote_w 
				from 	atendimento_pacote b 
				where 	b.nr_atendimento = nr_atendimento_w 
				and	b.cd_convenio = cd_convenio_parametro_w 
				and	b.dt_inicio_pacote between dt_conta_ant_w and r3.dt_conta 
				and not exists (SELECT 1	 
						from 	conta_paciente c, 
							procedimento_paciente a 
						where 	a.nr_sequencia = b.nr_seq_procedimento 
						and	a.nr_interno_conta = c.nr_interno_conta 
						and	coalesce(c.ie_tipo_atend_conta,0) = 3 
						and	coalesce(a.cd_motivo_exc_conta::text, '') = '');
			 
				if qt_conta_pacote_w > 0 then 
					if nr_interno_conta_w > 0 then 
						 
						update 	conta_paciente 
						set	dt_periodo_final = dt_conta_ant_w 
						where 	nr_interno_conta = nr_interno_conta_w;
					 
						nr_interno_conta_w:=0;
					end if;		
				end if;
			end if;
			 
			if nr_interno_conta_w = 0 then 
				 
				nr_interno_conta_w := planserv_desdobramento_cta_pck.inserir_conta_paciente(	nr_interno_conta_p, r3.dt_conta, r3.dt_conta+30, 	 --Período final provisório 
							nm_usuario_p, nr_interno_conta_w);
							 
				CALL CALL planserv_desdobramento_cta_pck.gravar_log('1 Criada Conta:'||nr_interno_conta_w||' Agrupamento: 	'||r3.ie_tipo_agrup ,nm_usuario_p);
				CALL CALL planserv_desdobramento_cta_pck.gravar_log(' ie_tipo_agrup_ant_w:'||ie_tipo_agrup_ant_w,nm_usuario_p);
				CALL CALL planserv_desdobramento_cta_pck.gravar_log(' dt_conta_ant_w:'||to_char(dt_conta_ant_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);
 
			end if;
			 
			--Se for o mesmo tipo de agrupamento do item anterior, insere na mesma conta 
			--Ser for outro tipo de agrupamento, seta o período final e cria um aconta nova 
			 
			if	ie_tipo_agrup_ant_w = r3.ie_tipo_agrup or	 
				coalesce(ie_tipo_agrup_ant_w::text, '') = '' then 
				if r3.ie_proc_mat = 1 then 
				 
					update	procedimento_paciente 
					set	nr_interno_conta = nr_interno_conta_w 
					where 	nr_sequencia = r3.nr_sequencia;
				 
				else 
				 
					update	material_atend_paciente 
					set	nr_interno_conta = nr_interno_conta_w 
					where 	nr_sequencia = r3.nr_sequencia;
				 
				end if;	
			else		 
				 
				update 	conta_paciente 
				set	dt_periodo_final = dt_conta_ant_w 
				where 	nr_interno_conta = nr_interno_conta_w;
					 
				nr_interno_conta_w := planserv_desdobramento_cta_pck.inserir_conta_paciente(	nr_interno_conta_p, r3.dt_conta, r3.dt_conta+30, 	 --Período final provisório 
							nm_usuario_p, nr_interno_conta_w);
 
				CALL CALL planserv_desdobramento_cta_pck.gravar_log('2 Criada Conta:'||nr_interno_conta_w||' Agrupamento: 	'||r3.ie_tipo_agrup ,nm_usuario_p);
				CALL CALL planserv_desdobramento_cta_pck.gravar_log(' ie_tipo_agrup_ant_w:'||ie_tipo_agrup_ant_w,nm_usuario_p);
				CALL CALL planserv_desdobramento_cta_pck.gravar_log(' Seq Item:'|| r3.nr_sequencia,nm_usuario_p);
				 
				if r3.ie_proc_mat = 1 then 
				 
					update	procedimento_paciente 
					set	nr_interno_conta = nr_interno_conta_w 
					where 	nr_sequencia = r3.nr_sequencia;
				 
				else 
			 
					update	material_atend_paciente 
					set	nr_interno_conta = nr_interno_conta_w 
					where 	nr_sequencia = r3.nr_sequencia;
					 
				end if;
			end if;	
				 
			dt_conta_ant_w:=r3.dt_conta;
			ie_tipo_agrup_ant_w:=r3.ie_tipo_agrup;
			 
		end loop;
 
		update 	conta_paciente 
		set	dt_periodo_final = dt_conta_ant_w 
		where 	nr_interno_conta = nr_interno_conta_w;
 
		CALL CALL planserv_desdobramento_cta_pck.gravar_log('Get_contas_criadas:'|| get_contas_criadas,nm_usuario_p);
		CALL CALL planserv_desdobramento_cta_pck.gravar_log('Início ajuste de datas',nm_usuario_p);
		--Ajuste das datas 
		--Todas as contas que foram criadas, vao ter o período ajustado para que a diferença entra o período final e inicial da proxima seja de 1 segundo 
		if (get_contas_criadas IS NOT NULL AND get_contas_criadas::text <> '') then	 
			open cur for EXECUTE 'select	nr_interno_conta, '|| 
					'	dt_periodo_inicial dt_inicial_atual, '|| 
					'	dt_periodo_final dt_final_atual '|| 
					'from	conta_paciente '|| 
					'where	nr_interno_conta in ('|| get_contas_criadas ||') '|| 
					'order by dt_periodo_inicial ';
			loop 
			fetch cur into 
				nr_interno_conta_ww, 
				dt_inicial_atual_ww, 
				dt_final_atual_ww;
			EXIT WHEN NOT FOUND; /* apply on cur */
				begin 
				 
				dt_inicio_pacote_w:=null;
				dt_final_pacote_w:=null;
				dt_periodo_inicial_w:=null;
				dt_periodo_final_w:=null;
				 
				select	count(1) 
				into STRICT	qt_conta_pacote_w 
				from	atendimento_pacote a, 
					procedimento_paciente b, 
					conta_paciente c 
				where	a.nr_seq_procedimento = b.nr_sequencia 
				and	b.nr_interno_conta = nr_interno_conta_ww 
				and	c.nr_interno_conta = b.nr_interno_conta 
				and	coalesce(c.ie_tipo_atend_conta,0) <> 3;
				 
				CALL CALL planserv_desdobramento_cta_pck.gravar_log('Ajuste conta: '||nr_interno_conta_ww||' Dt Ini: '||to_char(dt_inicial_atual_ww,'dd/mm/yyyy hh24:mi:ss')|| 
										' Dt Fim: '||to_char(dt_final_atual_ww,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);
				 
				if qt_conta_pacote_w = 0 then 
					 
					--ajustar datas 
					select	trunc(min(dt_entrada_unidade),'mi') 
					into STRICT	dt_periodo_inicial_w			 
					from (	SELECT	b.dt_entrada_unidade, 
							coalesce(b.dt_saida_unidade,trunc(a.dt_conta,'mi')+1/24/60) dt_saida_unidade 
						from	procedimento_paciente a, 
							atend_paciente_unidade b, 
							setor_atendimento s, 
							agrup_classif_setor c 
						where	a.nr_seq_atepacu = b.nr_seq_interno 
						and	a.cd_setor_atendimento = s.cd_setor_atendimento 
						and	c.nr_sequencia = s.nr_seq_agrup_classif 
						and	a.nr_interno_conta = nr_interno_conta_ww 
						
union all
 
						SELECT 	b.dt_entrada_unidade, 
							coalesce(b.dt_saida_unidade,trunc(a.dt_conta,'mi')+1/24/60) dt_saida_unidade 
						from	material_atend_paciente a, 
							atend_paciente_unidade b, 
							setor_atendimento s, 
							agrup_classif_setor c 
						where	a.nr_seq_atepacu = b.nr_seq_interno 
						and	a.cd_setor_atendimento = s.cd_setor_atendimento 
						and	c.nr_sequencia = s.nr_seq_agrup_classif				 
						and	a.nr_interno_conta = nr_interno_conta_ww) alias6;
 
					 
					CALL CALL planserv_desdobramento_cta_pck.gravar_log('Dt Min Unidade Item:'|| to_char(dt_periodo_inicial_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);
	 
					select	trunc(max(dt_saida_unidade),'mi') 
					into STRICT	dt_periodo_final_w			 
					from (	SELECT	b.dt_entrada_unidade, 
							coalesce(b.dt_saida_unidade,trunc(a.dt_conta,'mi')+1/24/60) dt_saida_unidade 
						from	procedimento_paciente a, 
							atend_paciente_unidade b 
						where	a.nr_seq_atepacu = b.nr_seq_interno 
						and	a.nr_interno_conta = nr_interno_conta_ww 
						
union all
 
						SELECT 	b.dt_entrada_unidade, 
							coalesce(b.dt_saida_unidade,trunc(a.dt_conta,'mi')+1/24/60) dt_saida_unidade 
						from	material_atend_paciente a, 
							atend_paciente_unidade b 
						where	a.nr_seq_atepacu = b.nr_seq_interno 
						and	a.nr_interno_conta = nr_interno_conta_ww) alias6;
						 
					CALL CALL planserv_desdobramento_cta_pck.gravar_log('Dt Max Unidate Item:'|| to_char(dt_periodo_final_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);	
 
					begin	 
						select 	min(b.dt_inicio_pacote), 
							max(b.dt_final_pacote) 
						into STRICT	dt_inicio_pacote_w, 
							dt_final_pacote_w	 
						from 	atendimento_pacote b 
						where 	b.nr_atendimento = nr_atendimento_w 
						and	b.cd_convenio = cd_convenio_parametro_w 
						and	b.dt_inicio_pacote between dt_periodo_inicial_w and dt_periodo_final_w 
						and not exists (SELECT 1	 
								from 	conta_paciente c, 
									procedimento_paciente a 
								where 	a.nr_sequencia = b.nr_seq_procedimento 
								and	a.nr_interno_conta = c.nr_interno_conta 
								and	coalesce(c.ie_tipo_atend_conta,0) = 3 
								and	coalesce(a.cd_motivo_exc_conta::text, '') = '');
						 
						CALL CALL planserv_desdobramento_cta_pck.gravar_log('Dt Min Pacote:'|| to_char(dt_inicio_pacote_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);	
						CALL CALL planserv_desdobramento_cta_pck.gravar_log('Dt Max Pacote:'|| to_char(dt_final_pacote_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);	
						 
					exception 
					when others then 
						dt_inicio_pacote_w:=null;
						dt_final_pacote_w:=null;
					end;
					 
					CALL CALL planserv_desdobramento_cta_pck.gravar_log('dt_entrada_unidade:'|| to_char(dt_periodo_inicial_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);
					CALL CALL planserv_desdobramento_cta_pck.gravar_log('dt_saida_unidade:'|| to_char(dt_periodo_final_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);
					 
					if coalesce(dt_inicio_pacote_w::text, '') = '' then 
						begin	 
							select 	min(trunc(b.dt_inicio_pacote,'mi')), 
								max(trunc(b.dt_final_pacote,'mi')) 
							into STRICT	dt_inicio_pacote_w, 
								dt_final_pacote_w	 
							from 	atendimento_pacote b 
							where 	b.nr_atendimento = nr_atendimento_w 
							and	b.cd_convenio = cd_convenio_parametro_w 
							and	b.dt_final_pacote between dt_periodo_inicial_w and dt_periodo_final_w 
							and not exists (SELECT 	1	 
									from 	conta_paciente c, 
										procedimento_paciente a 
									where 	a.nr_sequencia = b.nr_seq_procedimento 
									and	a.nr_interno_conta = c.nr_interno_conta 
									and	coalesce(c.ie_tipo_atend_conta,0) = 3 
									and	coalesce(a.cd_motivo_exc_conta::text, '') = '');
						exception 
						when others then 
							dt_inicio_pacote_w:=null;
							dt_final_pacote_w:=null;
						end;
					end if;			
						 
					if (dt_inicio_pacote_w IS NOT NULL AND dt_inicio_pacote_w::text <> '') then 
						 
						if dt_inicio_pacote_w > dt_final_atual_ww then 
							dt_periodo_final_w := dt_inicio_pacote_w - 1/24/60;
							CALL CALL planserv_desdobramento_cta_pck.gravar_log('Data Final = Dt Inicio Pacote '|| to_char(dt_inicio_pacote_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);
						else 
							dt_periodo_inicial_w := dt_final_pacote_w + 1/24/60;
							CALL CALL planserv_desdobramento_cta_pck.gravar_log('Data Inicial = Dt Fim Pacote '|| to_char(dt_final_pacote_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);
							 
						end if;	
						 
					end if;
				 
				 
				else	 
					dt_periodo_inicial_w:=null;
					dt_periodo_final_w:=null;
				end if;	
				 
				if (dt_periodo_final_ant_w IS NOT NULL AND dt_periodo_final_ant_w::text <> '') and (dt_periodo_inicial_w = dt_periodo_final_ant_w) then 
					dt_periodo_inicial_w:= dt_periodo_inicial_w + 1/24/60;
					CALL CALL planserv_desdobramento_cta_pck.gravar_log('Data Inicial + 1min: '|| to_char(dt_periodo_inicial_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);	
				end if;
				 
				if (cur%ROWCOUNT = 1) and (dt_entrada_w IS NOT NULL AND dt_entrada_w::text <> '') then --primeira conta deve ser criada com a data de entrada 
					 
 
					-- se ja existe alguma conta 
					select	max(c.dt_periodo_final) 
					into STRICT	dt_periodo_final_ant_w 
					from	conta_paciente c 
					where	c.nr_atendimento = nr_atendimento_w 
					and	c.cd_convenio_parametro = cd_convenio_parametro_w 
 
					and	c.nr_interno_conta < nr_interno_conta_p;
					 
					if (dt_periodo_final_ant_w IS NOT NULL AND dt_periodo_final_ant_w::text <> '') then 
						CALL CALL planserv_desdobramento_cta_pck.gravar_log('Primeira recebe data final ant + 1min:'|| to_char(dt_entrada_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);
						dt_periodo_inicial_w := dt_periodo_final_ant_w + 1/24/60/60;
					else			 
						CALL CALL planserv_desdobramento_cta_pck.gravar_log('Primeira recebe data de entrada:'|| to_char(dt_entrada_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);		
						dt_periodo_inicial_w := dt_entrada_w;
					end if;
				end if;
				 
				dt_periodo_final_ant_w:=dt_periodo_final_w;
				dt_conta_periodo_ini_w:=dt_periodo_inicial_w;	
				if (dt_periodo_inicial_w IS NOT NULL AND dt_periodo_inicial_w::text <> '') and (dt_periodo_final_w IS NOT NULL AND dt_periodo_final_w::text <> '') then 
								 
					-- A conta não pode ultrapassar a quantidade de dias definido no campo qt_dia_desdob_conta 
					CALL CALL planserv_desdobramento_cta_pck.gravar_log('Dias: '||to_char(trunc(dt_periodo_final_w) - trunc(dt_periodo_inicial_w)),nm_usuario_p);
					 
					if (qt_dia_desdob_conta_w > 0) and (trunc(dt_periodo_final_w) - trunc(dt_periodo_inicial_w) > qt_dia_desdob_conta_w) then 
						 
						qt_contas_periodo_w:=(trunc(dt_periodo_final_w) - trunc(dt_periodo_inicial_w))/qt_dia_desdob_conta_w;				
						 
						CALL CALL planserv_desdobramento_cta_pck.gravar_log('Contas Período: '||qt_contas_periodo_w,nm_usuario_p);
						 
						if qt_contas_periodo_w - trunc(qt_contas_periodo_w) > 0 then 
							qt_contas_periodo_w:= trunc(qt_contas_periodo_w) + 1;
						end if;
						 
						for i in 1..qt_contas_periodo_w loop 
							 
							if (i = qt_contas_periodo_w) or (trunc(dt_periodo_final_w) <= trunc(dt_conta_periodo_ini_w + qt_dia_desdob_conta_w)) then 
								dt_conta_periodo_fin_w:=dt_periodo_final_w;
							else   
								dt_conta_periodo_fin_w:= fim_dia(dt_conta_periodo_ini_w + qt_dia_desdob_conta_w);
							end if;
							 
							nr_interno_conta_w := planserv_desdobramento_cta_pck.inserir_conta_paciente(	nr_interno_conta_ww, dt_conta_periodo_ini_w, dt_conta_periodo_fin_w, nm_usuario_p, nr_interno_conta_w);
							 
							CALL CALL planserv_desdobramento_cta_pck.gravar_log('Criada Conta Período Max: '||nr_interno_conta_w,nm_usuario_p);
						 
							CALL CALL planserv_desdobramento_cta_pck.gravar_log('Transferindo itens de '||to_char(dt_conta_periodo_ini_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);
							CALL CALL planserv_desdobramento_cta_pck.gravar_log('até '||to_char(dt_conta_periodo_fin_w,'dd/mm/yyyy hh24:mi:ss'),nm_usuario_p);
							 
							update	procedimento_paciente 
							set	nr_interno_conta = nr_interno_conta_w 
							where	nr_interno_conta = nr_interno_conta_ww 
							and	dt_conta between dt_conta_periodo_ini_w and dt_conta_periodo_fin_w;
							 
							update	material_atend_paciente 
							set	nr_interno_conta = nr_interno_conta_w 
							where	nr_interno_conta = nr_interno_conta_ww 
							and	dt_conta between dt_conta_periodo_ini_w and dt_conta_periodo_fin_w;
						 
							update	conta_paciente 
							set	nr_seq_ordem = nextval('conta_paciente_ordem_seq') 
							where	nr_interno_conta = nr_interno_conta_w;		
							 
							 
							dt_conta_periodo_ini_w:=dt_conta_periodo_fin_w+ 1/24/60/60;
							 
						end loop;	
						 
					else 
						update	conta_paciente 
						set	nr_seq_ordem = nextval('conta_paciente_ordem_seq'), 
							dt_periodo_inicial = coalesce(dt_periodo_inicial_w,dt_periodo_inicial), 
							dt_periodo_final = coalesce(dt_periodo_final_w,dt_periodo_final) 
						where	nr_interno_conta = nr_interno_conta_ww;
					end if;
					 
				else	 
					update	conta_paciente 
					set	nr_seq_ordem = nextval('conta_paciente_ordem_seq') 
					where	nr_interno_conta = nr_interno_conta_ww;		
				end if;
			 
				 
				end;
			end loop;
			close cur;	
			 
			if (get_contas_criadas IS NOT NULL AND get_contas_criadas::text <> '')then 
				 
				ds_comando_w:= 'select	nvl(min(a.nr_interno_conta),0) '|| 
						'from	conta_paciente a '|| 
						'where	a.nr_interno_conta in ('|| get_contas_criadas ||') '|| 
						'and	a.dt_periodo_inicial = (select min(x.dt_periodo_inicial) from conta_paciente x where x.nr_interno_conta in ('|| get_contas_criadas ||'))';
				 
				EXECUTE ds_comando_w into STRICT nr_interno_conta_w;
				 
				if (nr_interno_conta_w > 0) then 
					select	count(1) 
					into STRICT	qt_pendencia_w 
					from	cta_pendencia 
					where	nr_interno_conta = nr_interno_conta_p;
					 
					if (qt_pendencia_w > 0) then 
					 
						update	cta_pendencia 
						set	nr_interno_conta = nr_interno_conta_w 
						where	nr_interno_conta = nr_interno_conta_p;
					 
						commit;
					end if;
				end if;
			end if;
			 
			--Excluir contas que podem ter ficado vazias 
			CALL Ajustar_Conta_Vazia( nr_atendimento_w, nm_usuario_p );
			 
			--Tratamento para última conta criada 
			if (get_contas_criadas IS NOT NULL AND get_contas_criadas::text <> '')then 
				 
				ds_comando_w:= 'select	nvl(max(a.nr_interno_conta),0) '|| 
						'from	conta_paciente a '|| 
						'where	a.nr_interno_conta in ('|| get_contas_criadas ||') '|| 
						'and	a.dt_periodo_final = (select max(x.dt_periodo_final) from conta_paciente x where x.nr_interno_conta in ('|| get_contas_criadas ||'))';
				 
				EXECUTE ds_comando_w into STRICT nr_interno_conta_w;
				 
				if (nr_interno_conta_w > 0) then 
					 
					if (coalesce(dt_alta_w::text, '') = '') then 
					 
						select	count(1) 
						into STRICT	qt_conta_pacote_w 
						from	atendimento_pacote a, 
							procedimento_paciente b, 
							conta_paciente c 
						where	a.nr_seq_procedimento = b.nr_sequencia 
						and	b.nr_interno_conta = nr_interno_conta_w 
						and	c.nr_interno_conta = b.nr_interno_conta 
						and	coalesce(c.ie_tipo_atend_conta,0) <> 3;
					 
						if qt_conta_pacote_w = 0 then 
							 
							--Quantidade de dias da Conta 
							select	fim_dia(dt_periodo_final) - dt_periodo_inicial 
							into STRICT	qt_dias_conta_w 
							from	conta_paciente 
							where	nr_interno_conta = nr_interno_conta_w;
							 
							qt_dias_conta_w := qt_dia_desdob_conta_w - trunc(qt_dias_conta_w);
							 
							if qt_dias_conta_w - trunc(qt_dias_conta_w) > 0 then 
								qt_dias_conta_w:= trunc(qt_dias_conta_w) + 1;
							end if;
							 
							update	conta_paciente 
							set	dt_periodo_final = fim_dia(dt_periodo_final + qt_dias_conta_w) 
							where	nr_interno_conta = nr_interno_conta_w;
							 
						end if;	
					else 
							update	conta_paciente 
							set	dt_periodo_final = dt_alta_w 
							where	nr_interno_conta = nr_interno_conta_w;
					end if;
				end if;
			end if;
			 
			CALL Recalcular_contas_atend( nr_atendimento_w, nm_usuario_p );
			 
		end if;
			 
		commit;
 
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE planserv_desdobramento_cta_pck.processar_internacao ( nr_interno_conta_p conta_paciente.nr_interno_conta%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
