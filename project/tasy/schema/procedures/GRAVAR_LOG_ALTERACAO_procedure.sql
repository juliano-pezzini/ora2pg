-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_alteracao ( ds_valor_old_p text, ds_valor_new_p text, nm_usuario_p text, nr_seq_log_atual_p INOUT bigint, nm_campo_p text, ie_log_p INOUT text, ds_descricao_p text, nm_tabela_p text, ds_chave_simples_p text, ds_chave_composta_p text) AS $body$
DECLARE

nr_sequencia_w    bigint;
nr_seq_just_w    bigint;
ds_just_w    varchar(255);
ie_callstack_w    varchar(1) := '';
ds_callstack_w    varchar(500) := '';
nr_ordem_servico_w bigint := 0;
ie_exige_ccb_w bigint := 0;
  nm_maquina_w         varchar(250);
  cd_maquina_ip_w      varchar(250);
  nr_seq_equipamento_w bigint;
  nr_seq_terminal_w    bigint;
  ds_valor_old_w tasy_log_alt_campo.ds_valor_old%type;
  ds_valor_new_w tasy_log_alt_campo.ds_valor_new%type;

BEGIN
    if    ((coalesce(ds_valor_old_p::text, '') = '') and (ds_valor_new_p IS NOT NULL AND ds_valor_new_p::text <> '')) or
        ((coalesce(ds_valor_new_p::text, '') = '') and (ds_valor_old_p IS NOT NULL AND ds_valor_old_p::text <> '')) or (ds_valor_old_p <> ds_valor_new_p) then
            if (coalesce(ie_log_p::text, '') = '') then
                ie_log_p := 'S';
                select    nextval('tasy_log_alteracao_seq')
                into STRICT    nr_seq_log_atual_p
;

                nr_seq_just_w := obter_valor_dinamico('select wheb_log_pck.get_nr_seq_log_tasy from dual', nr_seq_just_w);
                if (nr_seq_just_w = 0) then
                    nr_seq_just_w := null;
                end if;
                ds_just_w := obter_valor_dinamico_char_bv('select substr(wheb_log_pck.get_ds_log_tasy,1,255) from dual', null, ds_just_w);
                CALL exec_sql_dinamico('Almir', 'begin wheb_log_pck.set_log_tasy(null,null); end; ');

                ie_callstack_w := obter_valor_dinamico_char_bv('select substr(wheb_log_pck.get_ie_gerar_callstack(:nm_tabela_p),1,500) from dual', 'nm_tabela_p='||nm_tabela_p||';', ie_callstack_w);
                                    
                if (ie_callstack_w = 'S') then
                    begin
                    ds_callstack_w := 'CS - ' || substr(dbms_utility.format_call_stack,30,530);
                    end;
                end if;

                if OBTER_SE_BASE_WHEB = 'S' then                    	
			begin
				ie_exige_ccb_w
					 := obter_valor_dinamico_bv(
					'SELECT COUNT(0) FROM TABELA_SISTEMA_CCB WHERE NM_TABELA = UPPER(:nm_tabela_p)', 'nm_tabela_p='|| nm_tabela_p, ie_exige_ccb_w);					
							
				nr_ordem_servico_w
					 := obter_valor_dinamico_bv(
					'SELECT REG_OBJECT_LOG_PCK.load_so_activity_corp(:nm_usuario_p) FROM DUAL', 'nm_usuario_p=' || nm_usuario_p, nr_ordem_servico_w);
										
				if (ie_exige_ccb_w > 0
					or (nm_tabela_p in ('DIC_EXPRESSAO', 'DIC_EXPRESSAO_IDIOMA') and nr_ordem_servico_w > 0)) then
					begin
						if (ds_just_w IS NOT NULL AND ds_just_w::text <> '') and length(ds_just_w) > 0 then
							ds_just_w := ds_just_w || ' - OS '|| nr_ordem_servico_w;
						else
							ds_just_w := 'OS '|| nr_ordem_servico_w;
						end if;
					end;
                    		end if;		
			end;
                end if;

                nm_maquina_w    := wheb_usuario_pck.get_nm_maquina();
                cd_maquina_ip_w := wheb_usuario_pck.get_cd_maquina_ip();
                IF (nm_maquina_w IS NOT NULL AND nm_maquina_w::text <> '') OR
				    (cd_maquina_ip_w IS NOT NULL AND cd_maquina_ip_w::text <> '') THEN
					BEGIN
					  SELECT met.nr_sequencia,
							 met.nr_seq_equipamento
						INTO STRICT nr_seq_terminal_w,
							 nr_seq_equipamento_w
						FROM man_equipamento_terminal met
					   WHERE (met.ds_hostname = nm_maquina_w OR met.ds_ipv4 = cd_maquina_ip_w)  LIMIT 1;
					EXCEPTION
					  WHEN no_data_found THEN
						nr_seq_terminal_w    := NULL;
						nr_seq_equipamento_w := NULL;
					END;
					IF (nr_seq_terminal_w IS NOT NULL AND nr_seq_terminal_w::text <> '') THEN
					  ds_callstack_w := 'MC - ' ||
										' Equipamento : ' || nr_seq_equipamento_w || 
										' Terminal : ' || nr_seq_terminal_w || 
										' IP : ' || cd_maquina_ip_w || 
										' Host : ' || nm_maquina_w ||
										 ds_callstack_w;
					END IF;
			    END IF;
                    
                insert into tasy_log_alteracao(
                    nr_sequencia,
                    nm_tabela,
                    ds_chave_simples,
                    ds_chave_composta,
                    dt_atualizacao,
                    nm_usuario,
                    ds_descricao,
                    nr_seq_justificativa,
                    ds_justificativa)
                values (nr_seq_log_atual_p,
                    upper(nm_tabela_p),
                    upper(ds_chave_simples_p),
                    upper(ds_chave_composta_p),
                    clock_timestamp(),
                    nm_usuario_p,
                    substr(ds_descricao_p || ds_callstack_w,1,500),
                    nr_seq_just_w,
                    ds_just_w);
                                                                        
             end if;

            select    nextval('tasy_log_alt_campo_seq')
            into STRICT    nr_sequencia_w
;

            case when   nm_campo_p = 'NR_SEQ_FORMA_TRAT' then
                select  max(ds_forma_tratamento)
                into STRICT    ds_valor_old_w
                from    pf_forma_tratamento
                where   ds_sigla = ds_valor_old_p;
                select  max(ds_forma_tratamento)
                into STRICT    ds_valor_new_w
                from    pf_forma_tratamento
                where   ds_sigla = ds_valor_new_p;
            when    nm_campo_p = 'IE_SEXO' then
                select  max(ds_genero)
                into STRICT    ds_valor_old_w
                from    genero
                where   cd_intercambio = ds_valor_old_p;
                select  max(ds_genero)
                into STRICT    ds_valor_new_w
                from    genero
                where   cd_intercambio = ds_valor_new_p;
            when    nm_campo_p = 'IE_ESTADO_CIVIL' then
                ds_valor_old_w := obter_valor_dominio(5, ds_valor_old_p);
                ds_valor_new_w := obter_valor_dominio(5, ds_valor_new_p);
            when    nm_campo_p = 'IE_FLUENCIA_PORTUGUES' then
                ds_valor_old_w := obter_valor_dominio(1343, ds_valor_old_p);
                ds_valor_new_w := obter_valor_dominio(1343, ds_valor_new_p);
            when    nm_campo_p = 'IE_TIPO_SANGUE' then
                ds_valor_old_w := obter_valor_dominio(1173, ds_valor_old_p);
                ds_valor_new_w := obter_valor_dominio(1173, ds_valor_new_p);
            when    nm_campo_p = 'IE_FATOR_RH' then
                ds_valor_old_w := obter_valor_dominio(1174, ds_valor_old_p);
                ds_valor_new_w := obter_valor_dominio(1174, ds_valor_new_p);
            when    nm_campo_p = 'NR_SEQ_ETNIA' then
                select  max(ds_etnia)
                into STRICT    ds_valor_old_w
                from    origem_etnica
                where   cd_etnia = ds_valor_old_p;
                select  max(ds_etnia)
                into STRICT    ds_valor_new_w
                from    origem_etnica
                where   cd_etnia = ds_valor_new_p;
            when    nm_campo_p = 'IE_DOADOR' then
                ds_valor_old_w := obter_valor_dominio(3569, ds_valor_old_p);
                ds_valor_new_w := obter_valor_dominio(3569, ds_valor_new_p);
            when    nm_campo_p = 'NR_SEQ_PERFIL' then
                select  max(ds_perfil)
                into STRICT    ds_valor_old_w
                from    pep_perfil_paciente
                where   nr_sequencia = ds_valor_old_p;
                select  max(ds_perfil)
                into STRICT    ds_valor_new_w
                from    pep_perfil_paciente
                where   nr_sequencia = ds_valor_new_p;
            when    nm_campo_p = 'CD_CARGO' then
                select  max(ds_cargo)
                into STRICT    ds_valor_old_w
                from    cargo
                where   cd_cargo = ds_valor_old_p;
                select  max(ds_cargo)
                into STRICT    ds_valor_new_w
                from    cargo
                where   cd_cargo = ds_valor_new_p;
            when    nm_campo_p = 'CD_NACIONALIDADE' then
                select  max(ds_nacionalidade)
                into STRICT    ds_valor_old_w
                from    nacionalidade
                where   cd_nacionalidade = ds_valor_old_p;
                select  max(ds_nacionalidade)
                into STRICT    ds_valor_new_w
                from    nacionalidade
                where   cd_nacionalidade = ds_valor_new_p;
            when    nm_campo_p = 'CD_RELIGIAO' then
                select  max(ds_religiao)
                into STRICT    ds_valor_old_w
                from    religiao
                where   cd_religiao = ds_valor_old_p;
                select  max(ds_religiao)
                into STRICT    ds_valor_new_w
                from    religiao
                where   cd_religiao = ds_valor_new_p;
            else
                ds_valor_old_w := ds_valor_old_p;
                ds_valor_new_w := ds_valor_new_p;
            end case;

            insert into tasy_log_alt_campo(
                nr_sequencia,
                ds_valor_old,
                ds_valor_new,
                dt_atualizacao,
                nm_usuario,
                nr_seq_log_alteracao,
                nm_atributo)
            values (
                nr_sequencia_w,
                ds_valor_old_w,
                ds_valor_new_w,
                clock_timestamp(),
                nm_usuario_p,
                nr_seq_log_atual_p,
                nm_campo_p);
    end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_alteracao ( ds_valor_old_p text, ds_valor_new_p text, nm_usuario_p text, nr_seq_log_atual_p INOUT bigint, nm_campo_p text, ie_log_p INOUT text, ds_descricao_p text, nm_tabela_p text, ds_chave_simples_p text, ds_chave_composta_p text) FROM PUBLIC;

