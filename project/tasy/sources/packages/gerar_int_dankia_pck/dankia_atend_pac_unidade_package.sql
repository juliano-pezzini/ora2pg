-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function gerar_int_dankia_pck.dankia_atend_pac_unidade() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE gerar_int_dankia_pck.dankia_atend_pac_unidade ( nr_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_operacao_p text, cd_unidade_compl_p text, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL gerar_int_dankia_pck.dankia_atend_pac_unidade_atx ( ' || quote_nullable(nr_atendimento_p) || ',' || quote_nullable(cd_setor_atendimento_p) || ',' || quote_nullable(ie_operacao_p) || ',' || quote_nullable(cd_unidade_compl_p) || ',' || quote_nullable(cd_pessoa_fisica_p) || ',' || quote_nullable(cd_estabelecimento_p) || ',' || quote_nullable(nm_usuario_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE gerar_int_dankia_pck.dankia_atend_pac_unidade_atx ( nr_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_operacao_p text, cd_unidade_compl_p text, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

	if (get_ie_int_dankia = 'S') then
		
		PERFORM set_config('gerar_int_dankia_pck.cd_pessoa_fisica_w', cd_pessoa_fisica_p, false);
		
		select	max(cd_local_estoque)
		into STRICT 	current_setting('gerar_int_dankia_pck.cd_local_estoque_w')::local_estoque.cd_local_estoque%type
		from	setor_atendimento
		where 	cd_setor_atendimento = cd_setor_atendimento_p;
		
		select	max(a.dt_alta),
				max(a.ie_tipo_atendimento)
		into STRICT	current_setting('gerar_int_dankia_pck.dt_alta_w')::atendimento_paciente.dt_alta%type,
				ie_tipo_atendimento_w
		from 	atendimento_paciente a
		where 	a.nr_atendimento = nr_atendimento_p;
		
		select	count(1)
		into STRICT	qt_transf_w
		from	dis_regra_movimentacao
		where 	cd_setor_destino = cd_setor_atendimento_p
		and 	cd_estabelecimento = cd_estabelecimento_p;
				
		if (gerar_int_dankia_pck.get_ie_local_dankia(current_setting('gerar_int_dankia_pck.cd_local_estoque_w')::local_estoque.cd_local_estoque%type) = 'S') or (qt_transf_w > 0) then
		
			select 	count(1)
			into STRICT	current_setting('gerar_int_dankia_pck.qt_existe_w')::bigint
			from	dankia_disp_paciente
			where 	cd_pessoa_fisica = current_setting('gerar_int_dankia_pck.cd_pessoa_fisica_w')::atendimento_paciente.cd_pessoa_fisica%type;
				
			if (current_setting('gerar_int_dankia_pck.qt_existe_w')::bigint = 0) then
			
				select 	max(a.nm_pessoa_fisica),
						max(a.ie_sexo),
						max(a.dt_nascimento),
						max(gerar_int_dankia_pck.get_nm_mae_dankia(a.cd_pessoa_fisica))
				into STRICT	nm_paciente_w,
						ie_sexo_w,
						dt_nascimento_w,
						current_setting('gerar_int_dankia_pck.nm_mae_w')::compl_pessoa_fisica.nm_contato%type
				from	pessoa_fisica a
				where	a.cd_pessoa_fisica	= current_setting('gerar_int_dankia_pck.cd_pessoa_fisica_w')::atendimento_paciente.cd_pessoa_fisica%type;
					
				insert into dankia_disp_paciente(
						nr_sequencia,
						cd_estabelecimento,
						dt_atualizacao,
						nm_usuario,
						cd_pessoa_fisica,
						nm_paciente,
						nm_mae,
						ie_sexo,
						dt_nascimento,
						ie_operacao,
						dt_lido_dankia,
						ie_processado,
						ds_processado_observacao,
						ds_stack)
				values (	nextval('dankia_disp_paciente_seq'),
						cd_estabelecimento_p,
						clock_timestamp(),
						nm_usuario_p,
						current_setting('gerar_int_dankia_pck.cd_pessoa_fisica_w')::atendimento_paciente.cd_pessoa_fisica%type,
						nm_paciente_w,
						current_setting('gerar_int_dankia_pck.nm_mae_w')::compl_pessoa_fisica.nm_contato%type,
						ie_sexo_w,
						dt_nascimento_w,
						ie_operacao_p,
						null,
						'N',
						null,
						substr(dbms_utility.format_call_stack,1,2000));
			end if;
				
			insert into dankia_disp_atend_paciente(
					nr_sequencia,
					cd_estabelecimento,
					dt_atualizacao,
					nm_usuario,
					cd_pessoa_fisica,
					nr_atendimento,
					cd_setor_atendimento,
					ie_tipo_atendimento,
					cd_leito,
					ie_alta,
					dt_alta,
					ie_operacao,
					dt_lido_dankia,
					ie_processado,
					ds_processado_observacao,
					ds_stack)
			values (	nextval('dankia_disp_atend_paciente_seq'),
					cd_estabelecimento_p,
					clock_timestamp(),
					nm_usuario_p,
					current_setting('gerar_int_dankia_pck.cd_pessoa_fisica_w')::atendimento_paciente.cd_pessoa_fisica%type,
					nr_atendimento_p,
					cd_setor_atendimento_p,
					ie_tipo_atendimento_w,
					cd_unidade_compl_p,
					CASE WHEN current_setting('gerar_int_dankia_pck.dt_alta_w')::atendimento_paciente.dt_alta%coalesce(type::text, '') = '' THEN 'N'  ELSE 'S' END ,
					current_setting('gerar_int_dankia_pck.dt_alta_w')::atendimento_paciente.dt_alta%type,
					ie_operacao_p,
					null,
					'N',
					null,
					substr(dbms_utility.format_call_stack,1,2000));
		else
			select	max(dt_entrada_unidade)
			into STRICT	dt_entrada_origem_w
			from 	atend_paciente_unidade
			where  	nr_atendimento = nr_atendimento_p;
												
			select	max(cd_setor_atendimento)
			into STRICT	current_setting('gerar_int_dankia_pck.cd_setor_atendimento_w')::dis_regra_setor.cd_setor_atendimento%type
			from 	atend_paciente_unidade
			where	nr_atendimento = nr_atendimento_p
			and 	to_char(dt_entrada_unidade,'dd/mm/yyyy hh24:mi:ss') = to_char(dt_entrada_origem_w,'dd/mm/yyyy hh24:mi:ss');
			
			select	max(cd_local_estoque)
			into STRICT 	current_setting('gerar_int_dankia_pck.cd_local_estoque_w')::local_estoque.cd_local_estoque%type
			from	setor_atendimento
			where 	cd_setor_atendimento = current_setting('gerar_int_dankia_pck.cd_setor_atendimento_w')::dis_regra_setor.cd_setor_atendimento%type;
			
			select	count(1)
			into STRICT	qt_transf_w
			from	dis_regra_movimentacao
			where 	cd_setor_origem = cd_setor_atendimento_p
			and 	cd_estabelecimento = cd_estabelecimento_p;
		
			if (gerar_int_dankia_pck.get_ie_local_dankia(current_setting('gerar_int_dankia_pck.cd_local_estoque_w')::local_estoque.cd_local_estoque%type) = 'S') or (qt_transf_w > 0) then
				insert into dankia_disp_atend_paciente(
						nr_sequencia,
						cd_estabelecimento,
						dt_atualizacao,
						nm_usuario,
						cd_pessoa_fisica,
						nr_atendimento,
						cd_setor_atendimento,
						ie_tipo_atendimento,
						cd_leito,
						ie_alta,
						dt_alta,
						ie_operacao,
						dt_lido_dankia,
						ie_processado,
						ds_processado_observacao,
						ds_stack)
				values (	nextval('dankia_disp_atend_paciente_seq'),
						cd_estabelecimento_p,
						clock_timestamp(),
						nm_usuario_p,
						current_setting('gerar_int_dankia_pck.cd_pessoa_fisica_w')::atendimento_paciente.cd_pessoa_fisica%type,
						nr_atendimento_p,
						current_setting('gerar_int_dankia_pck.cd_setor_atendimento_w')::dis_regra_setor.cd_setor_atendimento%type,
						ie_tipo_atendimento_w,
						cd_unidade_compl_p,
						CASE WHEN current_setting('gerar_int_dankia_pck.dt_alta_w')::atendimento_paciente.dt_alta%coalesce(type::text, '') = '' THEN 'N'  ELSE 'S' END ,
						current_setting('gerar_int_dankia_pck.dt_alta_w')::atendimento_paciente.dt_alta%type,
						'E',
						null,
						'N',
						null,
						substr(dbms_utility.format_call_stack||'william',1,2000));
			end if;
		end if;
	end if;
	commit;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_int_dankia_pck.dankia_atend_pac_unidade ( nr_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_operacao_p text, cd_unidade_compl_p text, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE gerar_int_dankia_pck.dankia_atend_pac_unidade_atx ( nr_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_operacao_p text, cd_unidade_compl_p text, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;