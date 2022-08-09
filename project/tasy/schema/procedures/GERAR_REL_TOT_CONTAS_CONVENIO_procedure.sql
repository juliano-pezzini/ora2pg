-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_rel_tot_contas_convenio ( dt_mesano_refer_p timestamp, dt_mesano_ate_p timestamp, dt_alta_ini_p timestamp, dt_alta_fim_p timestamp, nivel_de_lcb_p bigint, nivel_ate_lcb_p bigint, dt_entrada_ini_p timestamp, dt_entrada_fim_p timestamp, dt_alta_p timestamp, dt_alta_ate_p timestamp, tot_prot_p bigint, ie_maior_zero_p bigint, ie_imprimirch_p bigint, quebra_tipo_atend_p bigint, ie_alta_tiss_p bigint, ie_somente_conta_titulo_p bigint, ie_cancelamento_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_atendimento_w	conta_paciente_status_v.nr_atendimento%type;
nr_interno_conta_w	conta_paciente_status_v.nr_interno_conta%type;		
nr_seq_protocolo_w	conta_paciente_status_v.nr_seq_protocolo%type;
dt_entrada_w		conta_paciente_status_v.dt_entrada%type;
dt_alta_w		conta_paciente_status_v.dt_alta%type;
dt_alta_tiss_w		conta_paciente_status_v.dt_alta%type;
cd_convenio_w		conta_paciente_status_v.cd_convenio%type;
ds_convenio_w		conta_paciente_status_v.ds_convenio%type;
nm_paciente_w		conta_paciente_status_v.nm_paciente%type;
ds_tipo_atendimento_w	w_rel_tot_contas_convenio.ds_tipo_atendimento%type;
vl_fora_conta_w		w_rel_tot_contas_convenio.vl_fora_conta%type;
vl_medico_w		w_rel_tot_contas_convenio.vl_medico%type;
vl_repasse_w		w_rel_tot_contas_convenio.vl_repasse%type;
vl_hospital_w		w_rel_tot_contas_convenio.vl_hospital%type;
vl_material_w		w_rel_tot_contas_convenio.vl_material%type;
vl_medicamento_w	w_rel_tot_contas_convenio.vl_medicamento%type;
vl_proced_hosp_w	w_rel_tot_contas_convenio.vl_proced_hosp%type;
vl_servico_w		w_rel_tot_contas_convenio.vl_servico%type;
vl_diaria_w		w_rel_tot_contas_convenio.vl_diaria%type;
vl_total_receita_w	w_rel_tot_contas_convenio.vl_total_receita%type;
vl_diferenca_w		w_rel_tot_contas_convenio.vl_diferenca%type;
cd_categoria_w		conta_paciente_status_v.cd_categoria%type;	
cd_etapa_conta_w	w_rel_tot_contas_convenio.cd_etapa_conta%type;
cd_setor_atendimento_w	conta_paciente_status_v.cd_setor_atendimento%type;
nr_seq_classificacao_w	conta_paciente_status_v.nr_seq_classificacao%type;
ie_clinica_w		conta_paciente_status_v.ie_clinica%type;
ie_tipo_atendimento_w	conta_paciente_status_v.ie_tipo_atendimento%type;

retorno_w		bigint;

ds_comando_select_w	varchar(4000);

dt_mesano_ate_w		timestamp;
dt_alta_ate_w		timestamp;
dt_alta_fim_w		timestamp;

cur_id			bigint;

C02 REFCURSOR;


BEGIN
ds_comando_select_w := 'select 	x.nr_atendimento, x.nr_interno_conta, x.nr_seq_protocolo, x.dt_entrada, x.cd_convenio, x.ds_convenio, x.nm_paciente, sum(x.vl_medico_fora_conta + x.vl_sadt_fora_conta) vl_fora_conta, 
				obter_valor_terceiro_conta(x.nr_interno_conta,' ||  chr(39) || 'R' || chr(39) || ') vl_repasse, sum(x.vl_hospital) vl_hospital, sum(x.vl_material) vl_material, sum(x.vl_medicamento) vl_medicamento, 
				sum(x.vl_proced_hosp) vl_proced_hosp, sum(x.vl_servico) vl_servico, sum(x.vl_diaria) vl_diaria, sum(x.vl_total_receita) vl_total_receita, 
				sum(x.vl_medicos + x.vl_servico + x.vl_diaria + x.vl_proced_hosp + x.vl_material + x.vl_medicamento + x.vl_medico_fora_conta + x.vl_sadt_fora_conta) - sum(x.vl_total_receita) vl_diferenca, ';
				
				if (ie_alta_tiss_p = 1) then
					ds_comando_select_w := ds_comando_select_w || 'nvl(x.dt_alta_tiss, x.dt_alta)' || ' dt_alta, ';
				else
					ds_comando_select_w := ds_comando_select_w || 'x.dt_alta' || ' dt_alta, ';
				end if;

				if (quebra_tipo_atend_p = 1) then
					ds_comando_select_w := ds_comando_select_w || 'substr(obter_valor_dominio(12, x.ie_tipo_atendimento),1,254) ds_tipo_atendimento, ';
				end if;	
				
				if (ie_imprimirch_p = 1) then
					ds_comando_select_w := ds_comando_select_w || 'sum(obter_preco_procedimento(x.cd_estabelecimento,x.cd_convenio,x.cd_categoria,x.dt_item,x.cd_procedimento, 
														    x.ie_origem_proced,null,x.ie_tipo_atendimento, x.cd_setor_atendimento,null,
														    x.cd_especialidade,null,null,null,null,' || chr(39) || 'PM' || chr(39) || ') * x.qt_resumo) vl_medico ';
				else
					ds_comando_select_w := ds_comando_select_w || 'sum(x.vl_medicos) vl_medico ';
				end if;										
				
				ds_comando_select_w := ds_comando_select_w || '	from conta_paciente_status_v x where 1 = 1 and exists (select 1 from dual where x.cd_estab_conta = ' || cd_estabelecimento_p || ') 
										and ((' || ie_somente_conta_titulo_p || ' = 0) or (substr(obter_titulo_conta_protocolo(x.nr_seq_protocolo,0),1,254) is not null)) 
										and ((' || nivel_de_lcb_p || ' = 0) or (x.ie_status >= ' || nivel_de_lcb_p || ')) and ((' || nivel_ate_lcb_p || '= 0) or (x.ie_status <= ' || nivel_ate_lcb_p || ')) ';
		
				dt_mesano_ate_w := dt_mesano_ate_p + (obter_ultimo_dia_mes(dt_mesano_ate_p)-1);
				
				ds_comando_select_w := ds_comando_select_w || ' and (trunc(x.dt_mesano_referencia) between ' || chr(39) || dt_mesano_refer_p || chr(39) || ' and ' || chr(39) || dt_mesano_ate_w || chr(39) || ' )';			
							
			if (dt_entrada_ini_p IS NOT NULL AND dt_entrada_ini_p::text <> '') and (dt_entrada_fim_p IS NOT NULL AND dt_entrada_fim_p::text <> '') then
				ds_comando_select_w := ds_comando_select_w || ' and (x.dt_entrada between ' || chr(39) || dt_entrada_ini_p || chr(39) || ' and ' || chr(39) || dt_entrada_fim_p || chr(39) || ' )';
			end if;

			if (dt_alta_ini_p IS NOT NULL AND dt_alta_ini_p::text <> '') then
				dt_alta_fim_w := dt_alta_ini_p + (obter_ultimo_dia_mes(dt_alta_ini_p)-1);
				if (dt_alta_fim_p IS NOT NULL AND dt_alta_fim_p::text <> '') and (dt_alta_ini_p <> dt_alta_fim_p) then
					dt_alta_fim_w := dt_alta_fim_p + (obter_ultimo_dia_mes(dt_alta_fim_p)-1);
				end if;
				if (ie_alta_tiss_p = 1) then
					ds_comando_select_w := ds_comando_select_w || ' and (trunc(nvl(x.dt_alta_tiss, x.dt_alta)) between ' || chr(39) || dt_alta_ini_p || chr(39) || ' and ' || chr(39) || dt_alta_fim_w || chr(39) || ' )';
				else
					ds_comando_select_w := ds_comando_select_w || ' and (trunc(x.dt_alta) between ' || chr(39) || dt_alta_ini_p || chr(39) || ' and ' || chr(39) || dt_alta_fim_w || chr(39) || ' )';
				end if;
			end if;
			
			if (dt_alta_p IS NOT NULL AND dt_alta_p::text <> '') then
				dt_alta_ate_w := dt_alta_ate_p;
				if (dt_alta_ate_p IS NOT NULL AND dt_alta_ate_p::text <> '') and (dt_alta_ate_p <> dt_alta_p) then
					if (ie_alta_tiss_p = 1) then
						ds_comando_select_w := ds_comando_select_w || ' and (nvl(x.dt_alta_tiss, x.dt_alta) between ' || chr(39) || dt_alta_p || chr(39) || ' and ' || chr(39) || dt_alta_ate_w || chr(39) || ' )';
					end if;	
				else
					ds_comando_select_w := ds_comando_select_w || ' and (x.dt_alta between ' || chr(39) || dt_alta_p || chr(39) || ' and ' || chr(39) || dt_alta_ate_w || chr(39) || ' )';
				end if;
			end if;
			
			if (ie_maior_zero_p = 1) then
				ds_comando_select_w := ds_comando_select_w || ' and (x.vl_total_receita > 0) ';
			end if;	

			if (ie_cancelamento_p = 'N') then
				ds_comando_select_w := ds_comando_select_w || ' and x.ie_cancelamento is null ';
			elsif (ie_cancelamento_p = 'C') then
				ds_comando_select_w := ds_comando_select_w || ' and x.ie_cancelamento is not null ';
			end if;

			ds_comando_select_w := ds_comando_select_w || 'group by x.nr_atendimento, x.nr_interno_conta, x.nr_seq_protocolo, x.dt_entrada, ';
			
			if (ie_alta_tiss_p = 1) then
				ds_comando_select_w := ds_comando_select_w || '	nvl(x.dt_alta_tiss, x.dt_alta) ';
			else
				ds_comando_select_w := ds_comando_select_w || '	x.dt_alta ';
			end if;
			
			ds_comando_select_w := ds_comando_select_w || ', x.cd_convenio, x.ds_convenio, x.nm_paciente ';

			if (quebra_tipo_atend_p = 1) then
				ds_comando_select_w := ds_comando_select_w || ',x.ie_tipo_atendimento order by ds_tipo_atendimento, ds_convenio, ';
			else
				ds_comando_select_w := ds_comando_select_w ||'	order by ds_convenio, ';
			end if;
			
			if (tot_prot_p = 1) then
				ds_comando_select_w := ds_comando_select_w || '	nr_seq_protocolo, ';
			end if;
							
			ds_comando_select_w := ds_comando_select_w || 'nm_paciente ';
			
begin

	delete from w_rel_tot_contas_convenio where nm_usuario = nm_usuario_p;
	commit;
	
	cur_id := dbms_sql.open_cursor;
	dbms_sql.parse(cur_id, ds_comando_select_w, dbms_sql.native);
	dbms_sql.define_column(cur_id, 1, nr_atendimento_w);
	dbms_sql.define_column(cur_id, 2, nr_interno_conta_w);
	dbms_sql.define_column(cur_id, 3, nr_seq_protocolo_w);
	dbms_sql.define_column(cur_id, 4, dt_entrada_w);	
	dbms_sql.define_column(cur_id, 5, cd_convenio_w);
	dbms_sql.define_column(cur_id, 6, ds_convenio_w, 255);
	dbms_sql.define_column(cur_id, 7, nm_paciente_w, 40);	
	dbms_sql.define_column(cur_id, 8, vl_fora_conta_w);
	dbms_sql.define_column(cur_id, 9, vl_repasse_w);
	dbms_sql.define_column(cur_id, 10, vl_hospital_w);
	dbms_sql.define_column(cur_id, 11, vl_material_w);
	dbms_sql.define_column(cur_id, 12, vl_medicamento_w);
	dbms_sql.define_column(cur_id, 13, vl_proced_hosp_w);
	dbms_sql.define_column(cur_id, 14, vl_servico_w);
	dbms_sql.define_column(cur_id, 15, vl_diaria_w);
	dbms_sql.define_column(cur_id, 16, vl_total_receita_w);
	dbms_sql.define_column(cur_id, 17, vl_diferenca_w);
	dbms_sql.define_column(cur_id, 18, dt_alta_w);	
	if (quebra_tipo_atend_p = 1) then
		dbms_sql.define_column(cur_id, 19, ds_tipo_atendimento_w, 255);
		dbms_sql.define_column(cur_id, 20, vl_medico_w);
	else
		dbms_sql.define_column(cur_id, 19, vl_medico_w);
	end if;		
		
	retorno_w := dbms_sql.execute(cur_id);

	while dbms_sql.fetch_rows(cur_id) > 0 loop
		
		dbms_sql.column_value(cur_id, 1, nr_atendimento_w);
		dbms_sql.column_value(cur_id, 2, nr_interno_conta_w);
		dbms_sql.column_value(cur_id, 3, nr_seq_protocolo_w);
		dbms_sql.column_value(cur_id, 4, dt_entrada_w);	
		dbms_sql.column_value(cur_id, 5, cd_convenio_w);
		dbms_sql.column_value(cur_id, 6, ds_convenio_w);
		dbms_sql.column_value(cur_id, 7, nm_paciente_w);	
		dbms_sql.column_value(cur_id, 8, vl_fora_conta_w);
		dbms_sql.column_value(cur_id, 9, vl_repasse_w);
		dbms_sql.column_value(cur_id, 10, vl_hospital_w);
		dbms_sql.column_value(cur_id, 11, vl_material_w);
		dbms_sql.column_value(cur_id, 12, vl_medicamento_w);
		dbms_sql.column_value(cur_id, 13, vl_proced_hosp_w);
		dbms_sql.column_value(cur_id, 14, vl_servico_w);
		dbms_sql.column_value(cur_id, 15, vl_diaria_w);
		dbms_sql.column_value(cur_id, 16, vl_total_receita_w);
		dbms_sql.column_value(cur_id, 17, vl_diferenca_w);
		dbms_sql.column_value(cur_id, 18, dt_alta_w);	
		if (quebra_tipo_atend_p = 1) then
			dbms_sql.column_value(cur_id, 19, ds_tipo_atendimento_w);
			dbms_sql.column_value(cur_id, 20, vl_medico_w);		
		else
			dbms_sql.column_value(cur_id, 19, vl_medico_w);		
		end if;	
		
		select	obter_conta_paciente_etapa(nr_interno_conta_w, 'C')
		into STRICT	cd_etapa_conta_w
		;

		select 	max(cd_categoria),
			max(cd_setor_atendimento),
			max(nr_seq_classificacao),
			max(ie_clinica),
			max(ie_tipo_atendimento)
		into STRICT	cd_categoria_w,
			cd_setor_atendimento_w,
			nr_seq_classificacao_w,
			ie_clinica_w,
			ie_tipo_atendimento_w
		from    conta_paciente_status_v
		where	nr_atendimento = nr_atendimento_w
		and	nr_interno_conta = nr_interno_conta_w;
		
		
		insert into w_rel_tot_contas_convenio(
				nr_atendimento,
				nr_interno_conta, 
				nr_seq_protocolo, 
				dt_entrada,
				dt_alta,
				cd_convenio, 
				ds_convenio, 
				nm_paciente, 
				ds_tipo_atendimento,
				vl_fora_conta,
				vl_medico, 
				vl_repasse, 
				vl_hospital, 
				vl_material, 
				vl_medicamento, 
				vl_proced_hosp, 
				vl_servico, 
				vl_diaria, 
				vl_total_receita, 
				vl_diferenca,
				cd_categoria,
				cd_etapa_conta,
				cd_setor_atendimento,
				nr_seq_classificacao,
				ie_clinica,
				ie_tipo_atendimento,
				nm_usuario)
		values (	nr_atendimento_w, 
				nr_interno_conta_w, 
				nr_seq_protocolo_w, 
				dt_entrada_w,
				dt_alta_w,
				cd_convenio_w, 
				ds_convenio_w, 
				nm_paciente_w, 
				ds_tipo_atendimento_w,
				vl_fora_conta_w,
				vl_medico_w, 
				vl_repasse_w, 
				vl_hospital_w, 
				vl_material_w, 
				vl_medicamento_w, 
				vl_proced_hosp_w, 
				vl_servico_w, 
				vl_diaria_w, 
				vl_total_receita_w, 
				vl_diferenca_w,
				cd_categoria_w,
				cd_etapa_conta_w,
				cd_setor_atendimento_w,
				nr_seq_classificacao_w,
				ie_clinica_w,
				ie_tipo_atendimento_w,
				nm_usuario_p	);				

	end loop;
	dbms_sql.close_cursor(cur_id);
end;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_rel_tot_contas_convenio ( dt_mesano_refer_p timestamp, dt_mesano_ate_p timestamp, dt_alta_ini_p timestamp, dt_alta_fim_p timestamp, nivel_de_lcb_p bigint, nivel_ate_lcb_p bigint, dt_entrada_ini_p timestamp, dt_entrada_fim_p timestamp, dt_alta_p timestamp, dt_alta_ate_p timestamp, tot_prot_p bigint, ie_maior_zero_p bigint, ie_imprimirch_p bigint, quebra_tipo_atend_p bigint, ie_alta_tiss_p bigint, ie_somente_conta_titulo_p bigint, ie_cancelamento_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
