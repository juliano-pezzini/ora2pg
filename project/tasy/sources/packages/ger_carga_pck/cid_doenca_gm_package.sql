-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ger_carga_pck.cid_doenca_gm ( nr_seq_carga_p ger_carga_inicial.nr_sequencia%type, nr_seq_carga_arq_p ger_carga_arq.nr_sequencia%type, nr_sequencia_p bigint) AS $body$
DECLARE

	qt_cid_doenca_w         bigint;
	qt_cid_versao_w         bigint;
	nr_lim_idade_anos_inf_w	cid_doenca_versao.nr_lim_idade_anos_inf%type;
	nr_lim_idade_anos_sup_w	cid_doenca_versao.nr_lim_idade_anos_sup%type;
	nr_lim_idade_dias_inf_w	cid_doenca_versao.nr_lim_idade_dias_inf%type;
	nr_lim_idade_dias_sup_w	cid_doenca_versao.nr_lim_idade_dias_sup%type;


	c_cid_doenca_gm CURSOR FOR
	SELECT  *
	from    cid_doenca_gm
	where   ie_status	= 'V'
	and     nr_seq_carga = nr_seq_carga_p
	and     nr_seq_carga_arq = coalesce(nr_seq_carga_arq_p,nr_seq_carga_arq)
	and     nr_sequencia = coalesce(nr_sequencia_p, nr_sequencia);

	
BEGIN

	for 	row_cid_doenca_gm in c_cid_doenca_gm loop

		nr_lim_idade_anos_inf_w := null;
		nr_lim_idade_anos_sup_w := null;
		nr_lim_idade_dias_inf_w := null;
		nr_lim_idade_dias_sup_w := null;

		reg_proc_w := ger_carga_pck.set_carga_arq(reg_proc_w, row_cid_doenca_gm.nr_seq_carga_arq, row_cid_doenca_gm.nr_linha, row_cid_doenca_gm.nr_sequencia, 'S');
		CALL ger_carga_pck.atualizar_processamento( 'CID_DOENCA_GM', row_cid_doenca_gm.nr_sequencia);
		PERFORM set_config('ger_carga_pck.ie_update_w', null, false);

		begin

		begin
		select	1
		into STRICT   	qt_cid_doenca_w
		from   	cid_doenca
		where  	cd_doenca_cid = row_cid_doenca_gm.cd_cid_doenca  LIMIT 1;
		exception
		when others then
			qt_cid_doenca_w := 0;
		end;

		if (qt_cid_doenca_w = 0) and (ie_tipo_proc_p = 'IMP') then
			begin
			insert into cid_doenca(cd_doenca_cid,
				ds_doenca_cid,
				cd_categoria_cid,
				dt_atualizacao,
				nm_usuario,
				ie_sexo,
				qt_campos_radio,
				ie_estadio,
				ie_repete_radio,
				ie_cad_interno,
				ie_situacao,
				qt_idade_min,
				qt_idade_max,
				ie_exige_lado,
				ds_descricao_original,
				nr_seq_idioma,
				cd_versao,
				cd_doenca,
				ds_informacao_adic,
				ds_mensagem,
				ie_dieta_oral,
				ie_subcategoria,
				ie_exibir_localizador,
				qt_dias_prev_inter,
				ie_obrigar_morfologia,
				dt_atualizacao_nrec,
				nm_usuario_nrec)
			values (row_cid_doenca_gm.cd_cid_doenca, -- cd_doenca_cid
				row_cid_doenca_gm.ds_cid_doenca, -- ds_doenca_cid
				row_cid_doenca_gm.cd_categoria_inicial, -- cd_categoria_cid
				clock_timestamp(), -- dt_atualizacao
				nm_usuario_w, -- nm_usuario
				CASE WHEN row_cid_doenca_gm.ie_sexo='M' THEN  'M' WHEN row_cid_doenca_gm.ie_sexo='W' THEN  'F'  ELSE 'A' END , -- ie_sexo
				null, -- qt_campos_radio
				null, -- ie_estadio
				null, -- ie_repete_radio
				'N', -- ie_cad_interno
				'A', -- ie_situacao
				null, -- qt_idade_min
				null, -- qt_idade_max
				null, -- ie_exige_lado
				row_cid_doenca_gm.ds_cid_doenca, -- ds_descricao_original
				null, -- nr_seq_idioma
				row_cid_doenca_gm.cd_versao,-- cd_versao ** ESTE CAMPO DEVE SER ADICIONADO NO ARQUIVO
				row_cid_doenca_gm.cd_cid_doenca, -- cd_doenca
				null, -- ds_informacao_adic
				null, -- ds_mensagem
				null, -- ie_dieta_oral
				null, -- ie_subcategoria
				null, -- ie_exibir_localizador
				null, -- qt_dias_prev_inter
				null, -- ie_obrigar_morfologia
				clock_timestamp(), -- dt_atualizacao_nrec
				nm_usuario_w); -- nm_usuario_nrec
			end;
		elsif (qt_cid_doenca_w > 0) and (current_setting('ger_carga_pck.ie_atualizar_w')::varchar(1) = 'S') and (ie_tipo_proc_p = 'IMP') then
			begin
			update  cid_doenca
			set     ds_doenca_cid       	= row_cid_doenca_gm.ds_cid_doenca,
				cd_categoria_cid    	= row_cid_doenca_gm.cd_categoria_inicial,
				dt_atualizacao      	= clock_timestamp(),
				nm_usuario          	= nm_usuario_w,
				ie_sexo             	= CASE WHEN row_cid_doenca_gm.ie_sexo='M' THEN  'M' WHEN row_cid_doenca_gm.ie_sexo='W' THEN  'F'  ELSE 'A' END ,
				/*qt_idade_min        	= qt_idade_min_w,
				qt_idade_max        	= qt_idade_max_w,*/
				cd_versao		= row_cid_doenca_gm.cd_versao,
				ie_situacao         	= 'A'
			where   cd_doenca_cid       	= row_cid_doenca_gm.cd_cid_doenca;

			update  cid_doenca_versao
			set     dt_vigencia_final   	= to_date(row_cid_doenca_gm.dt_inicio_vigencia, current_setting('ger_carga_pck.ds_mascara_date_w')::ger_carga_arq.ds_mascara_date%type),
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_w
			where   cd_doenca_cid       	= row_cid_doenca_gm.ds_cid_doenca
			and     coalesce(dt_vigencia_final::text, '') = ''
			and     (dt_vigencia_inicial IS NOT NULL AND dt_vigencia_inicial::text <> '');

			PERFORM set_config('ger_carga_pck.ie_update_w', 'S;', false);

			end;
		end if;

		if (ie_tipo_proc_p = 'IMP')  then

			select  count(*)
			into STRICT    qt_cid_versao_w
			from    cid_doenca_versao
			where   cd_doenca_cid = row_cid_doenca_gm.ds_cid_doenca
			and     trunc(dt_vigencia_inicial) = to_date(row_cid_doenca_gm.dt_inicio_vigencia, current_setting('ger_carga_pck.ds_mascara_date_w')::ger_carga_arq.ds_mascara_date%type)
			and     trunc(dt_vigencia_final) = to_date(row_cid_doenca_gm.dt_final_vigencia, current_setting('ger_carga_pck.ds_mascara_date_w')::ger_carga_arq.ds_mascara_date%type);

			if ( qt_cid_versao_w = 0) then
				begin

				if (row_cid_doenca_gm.nr_menor_idade_limite <> '9999') then --9999    = irrelevant
					if (position('t' in lower(row_cid_doenca_gm.nr_menor_idade_limite)) > 0) then
						nr_lim_idade_dias_inf_w	:= somente_numero(row_cid_doenca_gm.nr_menor_idade_limite);
					elsif (position('j' in lower(row_cid_doenca_gm.nr_menor_idade_limite)) > 0) then
						nr_lim_idade_anos_inf_w	:= somente_numero(row_cid_doenca_gm.nr_menor_idade_limite);
					end if;
				end if;

				if (row_cid_doenca_gm.nr_maior_idade_limite <> '9999') then --9999    = irrelevant
					if (position('t' in lower(row_cid_doenca_gm.nr_maior_idade_limite)) > 0) then
						nr_lim_idade_dias_sup_w	:= somente_numero(row_cid_doenca_gm.nr_maior_idade_limite);
					elsif (position('j' in lower(row_cid_doenca_gm.nr_maior_idade_limite)) > 0) then
						nr_lim_idade_anos_sup_w	:= somente_numero(row_cid_doenca_gm.nr_maior_idade_limite);
					end if;
				end if;

				insert into cid_doenca_versao(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_doenca_cid,
					dt_versao,
					dt_vigencia_inicial,
					dt_vigencia_final,
					cd_versao,
					cd_chave,
					p295,
					p301,
					ie_sexo,
					ie_erro_sexo,
					nr_lim_idade_anos_inf,
					nr_lim_idade_anos_sup,
					nr_lim_idade_dias_inf,
					nr_lim_idade_dias_sup)
				values ( nextval('cid_doenca_versao_seq'),
					clock_timestamp(),
					nm_usuario_w,
					clock_timestamp(),
					nm_usuario_w,
					row_cid_doenca_gm.cd_cid_doenca,
					trunc(to_date(row_cid_doenca_gm.dt_inicio_vigencia, current_setting('ger_carga_pck.ds_mascara_date_w')::ger_carga_arq.ds_mascara_date%type), 'yyyy'),
					to_date(row_cid_doenca_gm.dt_inicio_vigencia, current_setting('ger_carga_pck.ds_mascara_date_w')::ger_carga_arq.ds_mascara_date%type),
					coalesce(to_date(row_cid_doenca_gm.dt_final_vigencia, current_setting('ger_carga_pck.ds_mascara_date_w')::ger_carga_arq.ds_mascara_date%type),null),
					row_cid_doenca_gm.cd_versao,
					row_cid_doenca_gm.cd_chave,
					row_cid_doenca_gm.p295,
					row_cid_doenca_gm.p301,
					row_cid_doenca_gm.ie_sexo,
					row_cid_doenca_gm.cd_erro_sexo,
					nr_lim_idade_anos_inf_w,
					nr_lim_idade_anos_sup_w,
					nr_lim_idade_dias_inf_w,
					nr_lim_idade_dias_sup_w);
				end;
			end if;
		end if;

		if (reg_proc_w.qt_reg_log > 0) then
			begin
			/*'Em caso de qualquer consistencia o sistema efetua rollback, atualiza o status para Erro e registra todos os logs de consistencia'*/

			rollback;
			update	cid_doenca_gm
			set	ie_status 	= 'E',
				dt_fim_proc	= clock_timestamp()
			where	nr_sequencia 	= row_cid_doenca_gm.nr_sequencia;
			end;
		elsif (ie_tipo_proc_p = 'IMP') then
			update	cid_doenca_gm
			set	ie_status 	= 'I',
				ds_chave_tasy	= current_setting('ger_carga_pck.ie_update_w')::varchar(2)||row_cid_doenca_gm.cd_cid_doenca,
				dt_fim_proc	= clock_timestamp()
			where	nr_sequencia 	= row_cid_doenca_gm.nr_sequencia;
		else
			update	cid_doenca_gm
			set	ie_status 	= 'V',
				dt_fim_proc	= clock_timestamp()
			where	nr_sequencia 	= row_cid_doenca_gm.nr_sequencia;
		end if;

		exception
		when others then
			begin
			ds_erro_w := substr(dbms_utility.format_error_backtrace || chr(13) || chr(10) || sqlerrm,1,4000);

			rollback;

			reg_proc_w := ger_carga_pck.incluir_ger_carga_log_import(reg_proc_w, '4', ds_erro_w);

			update	cid_doenca_gm
			set	ie_status 	= 'E',
				dt_fim_proc	= clock_timestamp()
			where	nr_sequencia 	= row_cid_doenca_gm.nr_sequencia;

			end;
		end;

		commit;

	end loop;

	/*if	(ie_tipo_proc_p = 'IMP') then
		update  cid_doenca_versao
		set     dt_vigencia_final   = sysdate
		where   dt_vigencia_final   is null
		and     dt_vigencia_inicial is not null
		and     dt_atualizacao < sysdate
		and     nm_usuario in ('TasyLoad',nm_usuario_w);
	end if;*/
	end;
--==============================================================================
begin

reg_proc_w.ie_tipo_proc	:= ie_tipo_proc_p;

if (coalesce(nr_seq_carga_arq_p,0) > 0) then

	select  max(nr_seq_tipo_arq)
	into STRICT    nr_seq_tipo_arq_w
	from    ger_carga_arq
	where   nr_sequencia = nr_seq_carga_arq_p;

	if (nr_seq_tipo_arq_w = 58) then

		if (ie_tipo_proc_p = 'VAL') then
			update	cid_especialidade_gm
			set	ie_status 		= 'V',
				dt_fim_proc		= clock_timestamp()
			where	nr_seq_carga 		= nr_seq_carga_p
			and	nr_seq_carga_arq	= nr_seq_carga_arq_p;
		else
			CALL ger_carga_pck.importar_cid_especialidade_gm(nr_seq_carga_p, nr_seq_carga_arq_p, nr_sequencia_p);
		end if;

	elsif (nr_seq_tipo_arq_w = 59) then

		if (ie_tipo_proc_p = 'VAL') then
			update	cid_categoria_gm
			set	ie_status 	= 'V',
				dt_fim_proc	= clock_timestamp()
			where	nr_seq_carga 		= nr_seq_carga_p
			and	nr_seq_carga_arq	= nr_seq_carga_arq_p;
		else
			CALL ger_carga_pck.importar_cid_categoria_gm(nr_seq_carga_p, nr_seq_carga_arq_p, nr_sequencia_p);
		end if;

	elsif (nr_seq_tipo_arq_w = 60) then

		if (ie_tipo_proc_p = 'VAL') then
			update	cid_doenca_gm
			set	ie_status 	= 'V',
				dt_fim_proc	= clock_timestamp()
			where	nr_seq_carga 		= nr_seq_carga_p
			and	nr_seq_carga_arq	= nr_seq_carga_arq_p;
		else
			CALL ger_carga_pck.cid_doenca_gm(nr_seq_carga_p, nr_seq_carga_arq_p, nr_sequencia_p);
		end if;
	end if;
else
	if (ie_tipo_proc_p = 'VAL') then

		update	cid_especialidade_gm
		set	ie_status 	= 'V',
			dt_fim_proc	= clock_timestamp()
		where	nr_seq_carga 	= nr_seq_carga_p;

		update	cid_categoria_gm
		set	ie_status 	= 'V',
			dt_fim_proc	= clock_timestamp()
		where	nr_seq_carga 	= nr_seq_carga_p;

		update	cid_doenca_gm
		set	ie_status 	= 'V',
			dt_fim_proc	= clock_timestamp()
		where	nr_seq_carga 	= nr_seq_carga_p;

	else
		CALL ger_carga_pck.importar_cid_especialidade_gm(nr_seq_carga_p, nr_seq_carga_arq_p, nr_sequencia_p);
		CALL ger_carga_pck.importar_cid_categoria_gm(nr_seq_carga_p, nr_seq_carga_arq_p, nr_sequencia_p);
		CALL ger_carga_pck.cid_doenca_gm(nr_seq_carga_p, nr_seq_carga_arq_p, nr_sequencia_p);
	end if;
end if;

commit;

END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ger_carga_pck.cid_doenca_gm ( nr_seq_carga_p ger_carga_inicial.nr_sequencia%type, nr_seq_carga_arq_p ger_carga_arq.nr_sequencia%type, nr_sequencia_p bigint) FROM PUBLIC;