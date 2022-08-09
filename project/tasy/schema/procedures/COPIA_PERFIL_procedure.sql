-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_perfil ( cd_perfil_destino_p bigint, cd_Perfil_Origem_p bigint, cd_funcao_p bigint, nm_usuario_p text, ie_relatorio_p text, ie_tabela_p text, ie_copia_usuarios_p text, ie_submitted_items_p text default 'N') AS $body$
DECLARE


nr_seq_antiga_w		bigint;
nr_sequencia_w		bigint;	
nr_seq_relatorio_w	bigint;	
qt_copia_w		integer;
ie_logo_w		varchar(1);
ie_configurar_w		varchar(1);
ie_imprimir_w		varchar(1);
ie_outputbin_w		smallint;
ds_impressora_w		varchar(255);
nr_seq_apresent_w	bigint;
IE_VISUALIZAR_w		varchar(03);
ie_gravar_log_w		varchar(1);
ie_apresenta_w		varchar(1);
nm_usuario_refer_w	varchar(15);
nr_seq_item_pepo_w	bigint;
ie_atualizar_w		varchar(1);
ie_somente_template_w	varchar(1);
ie_tipo_item_w		varchar(15);
nm_usuario_lib_w	varchar(15);
nr_seq_perfil_item_w	bigint;
nr_sequencia_item_w	bigint;
nr_seq_template_w	bigint;
nr_seq_antiga_temp_w	bigint;
nr_sequencia_temp_w	bigint;
nr_usuario_lib_item_w   bigint;
nr_seq_per_item_pront_o_w	bigint;
nr_seq_per_item_pront_d_w	bigint;
nr_seq_param_perfil_w	bigint;
nr_seq_item_w		bigint;
cd_estabelecimento_w	smallint;
ie_controle_w		varchar(3);
nr_seq_apresentacao_w	bigint;
ie_atualizar_template_w varchar(1);
nr_seq_item_pasta_w		  bigint;
ds_pasta_instituicao_w    varchar(255);
cd_estab_destino_w		perfil.cd_estabelecimento%type;

C01 CURSOR FOR
SELECT	nr_sequencia,
	nextval('relatorio_perfil_seq'),
	nr_seq_relatorio,
	qt_copia,
	ie_logo,
	ie_configurar,
	ie_imprimir,
	ie_outputbin,
	ds_impressora,
	nr_seq_apresent,
	IE_VISUALIZAR,
	ie_gravar_log,
	ie_apresenta
from	relatorio_perfil a
where	a.cd_perfil = cd_perfil_origem_p
and		ie_relatorio_p = 'S'
and	not exists (	SELECT 1
			from	relatorio_perfil b 
			where 	a.nr_seq_relatorio = b.nr_seq_relatorio
			  and 	b.cd_perfil = cd_perfil_destino_p);
			
			  
C02 CURSOR FOR
SELECT	nr_sequencia,
	nextval('relatorio_perfil_seq'),
	nr_seq_relatorio,
	qt_copia,
	ie_logo,
	ie_configurar,
	ie_imprimir,
	ie_outputbin,
	ds_impressora,
	nr_seq_apresent,
	IE_VISUALIZAR,
	ie_gravar_log,
	ie_apresenta
from	relatorio_perfil a
where	a.cd_perfil = cd_perfil_origem_p
and		ie_relatorio_p = 'S'
and	not exists (	SELECT 1 
			from	relatorio_perfil b 
			where 	a.nr_seq_relatorio = b.nr_seq_relatorio
			  and 	b.cd_perfil = cd_perfil_destino_p)
and	exists (	select	1
			from	relatorio_funcao b
			where	b.nr_seq_relatorio	= a.nr_seq_relatorio
			and	b.cd_funcao		= cd_funcao_p);


C03 CURSOR FOR
	SELECT	a.nm_usuario
	from	usuario_perfil a
	where	a.cd_perfil 	= cd_perfil_origem_p
	and	not exists (	SELECT 1
			from	usuario_perfil b 
			where 	a.nm_usuario = b.nm_usuario
			  and 	b.cd_perfil = cd_perfil_destino_p);	

C04 CURSOR FOR
	SELECT	nr_sequencia,
		nextval('perfil_item_pepo_seq'),
		nr_seq_item_pepo,
		ie_atualizar,
		nr_seq_apresentacao,
		ie_somente_template,
		ie_tipo_item
	from	perfil_item_pepo
	where	cd_perfil	= cd_Perfil_Origem_p
	and	nr_seq_item_pepo not in (SELECT	nr_seq_item_pepo
					 from	perfil_item_pepo
					 where	cd_perfil = cd_perfil_destino_p);
					
					 
C05 CURSOR FOR
	SELECT  nr_sequencia,
		nextval('perfil_item_pepo_usuario_seq'),
		ie_atualizar,
		nm_usuario_liberacao,
		nr_seq_perfil_item
	from    perfil_item_pepo_usuario		
	where   nr_seq_perfil_item = nr_seq_antiga_w;

C06 CURSOR FOR
	SELECT  nr_sequencia,
		nextval('perfil_item_pepo_template_seq'),
		nr_seq_template
	from 	perfil_item_pepo_template
	where   nr_seq_item_perfil = nr_seq_antiga_w;

C07 CURSOR FOR
	SELECT  nr_sequencia
	from	perfil_item_pront
	where	cd_perfil	= cd_Perfil_Origem_p
	and	nr_seq_item_pront not in (	SELECT	nr_seq_item_pront
						from	perfil_item_pront
						where	cd_perfil = cd_perfil_destino_p);
						
C08 CURSOR FOR 						
	SELECT	nr_seq_item,
		ie_atualizar_template,
		nr_seq_apresentacao
	from 	pls_dossie_item_perfil a
	where 	a.cd_perfil = cd_perfil_origem_p
	  and 	not exists (SELECT	1
				from 	pls_dossie_item_perfil b
				where	b.cd_perfil = cd_perfil_destino_p);
C09 CURSOR FOR
	SELECT	nr_seq_item,
		cd_estabelecimento,
		ie_controle
	from 	pls_cad_regra_item_perfil a
	where 	a.cd_perfil = cd_perfil_origem_p
	  and 	not exists (SELECT	1 
				from 	pls_cad_regra_item_perfil b
				where	b.cd_perfil = cd_perfil_destino_p);
				
C10 CURSOR FOR 						
	SELECT	nr_seq_item,
		cd_estabelecimento
	from 	pls_item_relac_cli_perfil a
	where 	a.cd_perfil = cd_perfil_origem_p
	  and 	not exists (SELECT	1
				from 	pls_item_relac_cli_perfil b
				where	b.cd_perfil = cd_perfil_destino_p);
				
C11 CURSOR FOR
	SELECT	nr_seq_item,
		cd_estabelecimento,
		nr_seq_apresentacao
	from 	pls_item_contr_benef_lib a
	where 	a.cd_perfil = cd_perfil_origem_p
	  and 	not exists (SELECT	1
				from 	pls_item_contr_benef_lib b
				where	b.cd_perfil = cd_perfil_destino_p);

C12 CURSOR FOR 						
	SELECT	nr_seq_item,
		cd_estabelecimento
	from 	pls_item_contr_regra_lib a
	where 	a.cd_perfil = cd_perfil_origem_p
	  and 	not exists (SELECT	1
				from 	pls_item_contr_regra_lib b
				where	b.cd_perfil = cd_perfil_destino_p);	

C13 CURSOR FOR
	SELECT	nr_seq_item,
		cd_estabelecimento,
		nr_seq_apresentacao
	from 	pls_item_prod_regra_lib a
	where 	a.cd_perfil = cd_perfil_origem_p
	  and 	not exists (SELECT	1
				from 	pls_item_prod_regra_lib b
				where	b.cd_perfil = cd_perfil_destino_p);	

C14 CURSOR FOR
	SELECT	nr_seq_item_contab,
		cd_estabelecimento
	from 	pls_item_crit_cont_perfil a
	where 	a.cd_perfil = cd_perfil_origem_p
	  and 	not exists (SELECT	1 
				from 	pls_item_crit_cont_perfil b
				where	b.cd_perfil = cd_perfil_destino_p);	

C15 CURSOR FOR
	SELECT	nr_seq_item,
		nr_seq_apresentacao,
		ie_controle
	from 	pls_parametros_item_perfil a
	where 	a.cd_perfil = cd_perfil_origem_p
	  and 	not exists (SELECT	1 
				from 	pls_parametros_item_perfil b
				where	b.cd_perfil = cd_perfil_destino_p);
				
C16 CURSOR FOR
	SELECT	nr_seq_item,		
		ie_controle
	from 	pls_solic_lead_item_perfil a
	where 	a.cd_perfil = cd_perfil_origem_p
	  and 	not exists (SELECT	1 
				from 	pls_solic_lead_item_perfil b
				where	b.cd_perfil = cd_perfil_destino_p);

C17 CURSOR FOR
	SELECT	nr_seq_item,		
		ie_controle
	from 	pls_proposta_item_perfil a
	where 	a.cd_perfil = cd_perfil_origem_p
	  and 	not exists (SELECT	1 
				from 	pls_proposta_item_perfil b
				where	b.cd_perfil = cd_perfil_destino_p);

C18 CURSOR FOR
	SELECT	nr_seq_item,		
		ie_controle
	from 	pls_analise_item_perfil a
	where 	a.cd_perfil = cd_perfil_origem_p
	  and 	not exists (SELECT	1 
				from 	pls_analise_item_perfil b
				where	b.cd_perfil = cd_perfil_destino_p);		

C19 CURSOR FOR
	SELECT	nr_seq_item_pasta,
			ds_pasta_instituicao
	from	perfil_item_pront_pasta
	where	nr_seq_item_perfil = nr_seq_per_item_pront_o_w
	order by coalesce(obter_seq_pasta_superior(nr_seq_item_pasta, 'F'),0),nr_seq_item_pasta;
	
cItemProntEstab CURSOR FOR
	SELECT	*
	from	perfil_item_pront_estab
	where	nr_seq_item_perfil = nr_seq_per_item_pront_o_w;
	
cItemProntUsuario CURSOR FOR
	SELECT	*
	from	perfil_item_pront_usuario
	where	nr_seq_item_perfil = nr_seq_per_item_pront_o_w;
	
cItemProntLib CURSOR FOR
	SELECT	*
	from	perfil_item_pront_lib
	where	nr_seq_item_perfil = nr_seq_per_item_pront_o_w;
	
cItemSoapCli CURSOR FOR
	SELECT	*
	from	prontuario_item_soap_cli
	where	nr_seq_item_prontuario = nr_seq_per_item_pront_o_w;

C20 CURSOR FOR
	SELECT	a.nm_tabela,
		a.nm_atributo,
		a.ie_tabstop,
		a.ie_enable,
		a.ie_visible,
		coalesce(cd_estab_destino_w,a.cd_estabelecimento) cd_estabelecimento,
		a.ie_obrigatorio,
		a.vl_default,
		a.cd_funcao,
		a.nr_seq_regra_funcao,
		a.ie_repetir_valor,
		a.ie_padrao_nulo,
		a.nm_usuario_param,
		a.nr_seq_visao,
		a.vl_minimo,
		a.vl_maximo,
		a.vl_minimo_permitido,
		a.vl_maximo_permitido,
		a.ie_gerar_log,
		a.cd_setor_atendimento,
		a.hr_fim,
		a.hr_inicio,
		a.ie_dia_semana,
		a.ds_observacao,
		a.ie_sensitive,
		a.ie_patient_info
	from	tabela_atrib_regra a
	where	a.cd_perfil = cd_perfil_origem_p
	and	a.cd_funcao = cd_funcao_p
	and not exists (
		SELECT	1
		from	tabela_atrib_regra b
		where	b.nm_tabela = a.nm_tabela
		and	b.nm_atributo = a.nm_atributo
		and	b.cd_perfil = cd_perfil_destino_p);

C21 CURSOR FOR
	SELECT	a.nm_tabela,
		a.nm_atributo,
		a.ie_tabstop,
		a.ie_enable,
		a.ie_visible,
		coalesce(cd_estab_destino_w,a.cd_estabelecimento) cd_estabelecimento,
		a.ie_obrigatorio,
		a.vl_default,
		a.cd_funcao,
		a.nr_seq_regra_funcao,
		a.ie_repetir_valor,
		a.ie_padrao_nulo,
		a.nm_usuario_param,
		a.nr_seq_visao,
		a.vl_minimo,
		a.vl_maximo,
		a.vl_minimo_permitido,
		a.vl_maximo_permitido,
		a.ie_gerar_log,
		a.cd_setor_atendimento,
		a.hr_fim,
		a.hr_inicio,
		a.ie_dia_semana,
		a.ds_observacao,
		a.ie_sensitive,
		a.ie_patient_info
	from	tabela_atrib_regra a
	where	a.cd_perfil = cd_perfil_origem_p
	and not exists (
		SELECT	1
		from	tabela_atrib_regra b
		where	b.nm_tabela = a.nm_tabela
		and	b.nm_atributo = a.nm_atributo
		and	b.cd_perfil = cd_perfil_destino_p);

cPerfilItemOft CURSOR FOR 
	SELECT	*
	from	   perfil_item_oftalmologia
	where	   cd_perfil	= cd_perfil_origem_p
	and	   nr_seq_item not in (	SELECT	nr_seq_item
                                 from	   perfil_item_oftalmologia
                                 where	   cd_perfil = cd_perfil_destino_p);
	
c20_w c20%rowtype;
c21_w c21%rowtype;

BEGIN

select	max(a.cd_estabelecimento)
into STRICT	cd_estab_destino_w
from	perfil	a
where	a.cd_perfil = cd_perfil_destino_p;

if (coalesce(cd_funcao_p,0) > 0) then

	insert into funcao_perfil(
		cd_perfil,
		cd_funcao,
		dt_atualizacao, 
		nm_usuario)
	(SELECT cd_perfil_destino_p,
		cd_funcao, 
		clock_timestamp(),
		nm_usuario_p
	from 	funcao_perfil a
	where 	a.cd_perfil = cd_perfil_origem_p
	  and	a.cd_funcao   = cd_funcao_p
	  and 	not exists (select 1 
					from funcao_perfil b
				where 	a.cd_funcao = b.cd_funcao
	  			  and 	b.cd_perfil = cd_perfil_destino_p));

	insert into funcao_param_perfil(	nr_seq_interno,
			cd_funcao,
			nr_sequencia, 
			cd_perfil, 
			vl_parametro, 
			ds_observacao, 
			dt_atualizacao, 
			nm_usuario,
			cd_estabelecimento)
		(SELECT	nextval('funcao_param_perfil_seq'),
			cd_funcao, 
			nr_sequencia,
			cd_perfil_destino_p,
			vl_parametro, 
			substr(wheb_mensagem_pck.get_texto(672109, 'NM_PERFIL=' || obter_desc_perfil(cd_perfil_origem_p)) || ds_observacao,1,4000), 
			clock_timestamp(),
			nm_usuario_p,
			cd_estabelecimento
		from 	funcao_param_perfil	a 
		where 	a.cd_perfil	= cd_perfil_origem_p
		and	a.cd_funcao	= cd_funcao_p
		and 	not exists (select	1
				from	funcao_param_perfil b 
				where 	a.cd_funcao = b.cd_funcao
				and   a.nr_Sequencia = b.nr_Sequencia 
				and 	b.cd_perfil = cd_perfil_destino_p));

	open C20;
	loop
	fetch C20 into
		c20_w;
	EXIT WHEN NOT FOUND; /* apply on C20 */
		begin
		insert into tabela_atrib_regra(
				nr_sequencia,
				nm_tabela,
				nm_atributo,
				ie_tabstop,
				ie_enable,
				ie_visible,
				dt_atualizacao, 
				nm_usuario,
				cd_estabelecimento,
				cd_perfil,
				ie_obrigatorio,
				vl_default,
				cd_funcao,
				nr_seq_regra_funcao,
				ie_repetir_valor,
				ie_padrao_nulo,
				nm_usuario_param,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_visao,
				vl_minimo,
				vl_maximo,
				vl_minimo_permitido,
				vl_maximo_permitido,
				ie_gerar_log,
				cd_setor_atendimento,
				hr_fim,
				hr_inicio,
				ie_dia_semana,
				ds_observacao,
				ie_sensitive,
				ie_patient_info)
			values (nextval('tabela_atrib_regra_seq'),
				c20_w.nm_tabela,
				c20_w.nm_atributo,
				c20_w.ie_tabstop,
				c20_w.ie_enable,
				c20_w.ie_visible,
				clock_timestamp(), 
				nm_usuario_p,
				c20_w.cd_estabelecimento,
				cd_perfil_destino_p,
				c20_w.ie_obrigatorio,
				c20_w.vl_default,
				c20_w.cd_funcao,
				c20_w.nr_seq_regra_funcao,
				c20_w.ie_repetir_valor,
				c20_w.ie_padrao_nulo,
				c20_w.nm_usuario_param,
				clock_timestamp(),
				nm_usuario_p,
				c20_w.nr_seq_visao,
				c20_w.vl_minimo,
				c20_w.vl_maximo,
				c20_w.vl_minimo_permitido,
				c20_w.vl_maximo_permitido,
				c20_w.ie_gerar_log,
				c20_w.cd_setor_atendimento,
				c20_w.hr_fim,
				c20_w.hr_inicio,
				c20_w.ie_dia_semana,
				c20_w.ds_observacao,
				c20_w.ie_sensitive,
				c20_w.ie_patient_info);
		exception
		when others then
			null;
		end;
	end loop;
	close C20;
	
	open C02;
	loop
	fetch C02 into	
		nr_seq_antiga_w,
		nr_sequencia_w,	
		nr_seq_relatorio_w,
		qt_copia_w,
		ie_logo_w,
		ie_configurar_w,
		ie_imprimir_w,
		ie_outputbin_w,
		ds_impressora_w,
		nr_seq_apresent_w,
		IE_VISUALIZAR_w,
		ie_gravar_log_w,
		ie_apresenta_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		insert into relatorio_perfil(
			nr_sequencia,
			cd_perfil,
			nr_seq_relatorio,
			dt_atualizacao,
			nm_usuario,
			qt_copia,
			ie_logo,
			ie_configurar,
			ie_imprimir,
			ie_outputbin,
			ds_impressora,
			nr_seq_apresent,
			ie_gravar_log,
			IE_VISUALIZAR,
			ie_apresenta)
		values (nr_sequencia_w,
			cd_perfil_destino_p,	
			nr_seq_relatorio_w,
			clock_timestamp(),
			nm_usuario_p,
			qt_copia_w,
			ie_logo_w,
			ie_configurar_w,
			ie_imprimir_w,
			ie_outputbin_w,
			ds_impressora_w,
			nr_seq_apresent_w,
			ie_gravar_log_w,
			IE_VISUALIZAR_w,
			ie_apresenta_w);
		
		insert into relatorio_perfil_param(
			nr_seq_perfil_relat,
			nr_seq_parametro,
			dt_atualizacao,
			nm_usuario,
			ds_valor,
			ds_valor_exec)
		SELECT	nr_sequencia_w,
			nr_seq_parametro,
			clock_timestamp(),
			nm_usuario_p,
			ds_valor,
			ds_valor_exec
		from	relatorio_perfil_param a
		where	a.nr_seq_perfil_relat = nr_seq_antiga_w
		  and 	not exists (	SELECT	1
					from	relatorio_perfil_param b
					where 	a.nr_seq_parametro = b.nr_seq_parametro
					  and 	b.nr_seq_perfil_relat = nr_sequencia_w);
		
		end;
	end loop;
	close C02;	
	
	
	if (ie_copia_usuarios_p = 'S') then
		open C03;
		loop
		fetch C03 into	
			nm_usuario_refer_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			
			insert	into usuario_perfil(NM_USUARIO            ,
				CD_PERFIL              ,
				DT_ATUALIZACAO         ,
				NM_USUARIO_ATUAL       ,
				DS_OBSERVACAO          )
			values (nm_usuario_refer_w,
				cd_perfil_destino_p,
				clock_timestamp(),
				nm_usuario_p,
				null);
			
			end;
		end loop;
		close C03;
	end if;

else

	open C07;
	loop
	fetch C07 into	
		nr_seq_per_item_pront_o_w;
	EXIT WHEN NOT FOUND; /* apply on C07 */
		begin
		
		select	nextval('perfil_item_pront_seq')
		into STRICT	nr_seq_per_item_pront_d_w
		;
		
		insert	into perfil_item_pront(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			cd_perfil,
			nr_seq_item_pront,
			ie_atualizar,
			nr_seq_apres,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_checkup,
			nr_seq_apres_checkup,
			ie_atualizar_alta,
			ie_atualizar_obito,
			qt_min_alta,
			qt_min_obito,
			qt_horas_inativacao,
			ds_item_instituicao,
			qt_tamanho_fonte,
			ds_fonte,
			ds_cor_fonte,
			ie_estabelecimento,
			ie_fim_conta,
			ie_visualiza_inativo,
			ie_liberar_impressao,
			ie_configurar_relatorio,
			ds_alerta_impressao,
			ie_inativar,
			ie_somente_template,
			ie_atualizar_template,
			qt_refresh_tela,
			ie_imprimir_liberar,
			qt_min_impressao_alta,
			qt_dias_filtro,
			ds_pasta_template,
			ie_adep,
			nr_seq_pasta_inicial,
			ie_imp_nao_liberado,
			ie_quest_texto_padrao)
		SELECT	nr_seq_per_item_pront_d_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_perfil_destino_p,
			nr_seq_item_pront,
			ie_atualizar,
			nr_seq_apres,
			clock_timestamp(),
			nm_usuario_p,
			ie_checkup,
			nr_seq_apres_checkup,
			ie_atualizar_alta,
			ie_atualizar_obito,
			qt_min_alta,
			qt_min_obito,
			qt_horas_inativacao,
			ds_item_instituicao,
			qt_tamanho_fonte,
			ds_fonte,
			ds_cor_fonte,
			ie_estabelecimento,
			ie_fim_conta,
			ie_visualiza_inativo,
			ie_liberar_impressao,
			ie_configurar_relatorio,
			ds_alerta_impressao,
			ie_inativar,
			ie_somente_template,
			ie_atualizar_template,
			qt_refresh_tela,
			ie_imprimir_liberar,
			qt_min_impressao_alta,
			qt_dias_filtro,
			ds_pasta_template,
			ie_adep,
			nr_seq_pasta_inicial,
			ie_imp_nao_liberado,
			ie_quest_texto_padrao
		from	perfil_item_pront
		where	nr_sequencia = nr_seq_per_item_pront_o_w;

		insert into perfil_item_pront_template(	
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_item_perfil,
			nr_seq_template,
			ie_digitar_consulta)
		SELECT	nextval('perfil_item_pront_template_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_per_item_pront_d_w,
			nr_seq_template,
			ie_digitar_consulta
		from	perfil_item_pront_template
		where	nr_seq_item_perfil = nr_seq_per_item_pront_o_w;
				
		open C19;
		loop
		fetch C19 into
			nr_seq_item_pasta_w,
			ds_pasta_instituicao_w;
		EXIT WHEN NOT FOUND; /* apply on C19 */
		begin
			
			insert into perfil_item_pront_pasta(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_item_perfil,
				nr_seq_item_pasta,
				ds_pasta_instituicao)
			values (
				nextval('perfil_item_pront_pasta_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_per_item_pront_d_w,
				nr_seq_item_pasta_w,
				ds_pasta_instituicao_w);
				
			commit;
			
		end;
		end loop;
		close C19;
		if (ie_submitted_items_p = 'S') then
			for cItemProntEstab_w in cItemProntEstab loop
			begin
				insert into perfil_item_pront_estab(	
					nr_sequencia,
					cd_estabelecimento,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_item_perfil,
					ie_imprimir_liberar )
				values (	
					nextval('perfil_item_pront_estab_seq'),
					cItemProntEstab_w.cd_estabelecimento,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_per_item_pront_d_w,
					cItemProntEstab_w.ie_imprimir_liberar );		
			end;
			end loop;
			
			for cItemProntUsuario_w in cItemProntUsuario loop
			begin
				insert into perfil_item_pront_usuario(	
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_item_perfil,
					nm_usuario_param,
					ie_inativar )
				values (	
					nextval('perfil_item_pront_usuario_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_per_item_pront_d_w,
					nm_usuario_p,
					cItemProntUsuario_w.ie_inativar );		
			end;
			end loop;
			
			for citemprontlib_w in citemprontlib loop
			begin
				insert into perfil_item_pront_lib(	
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_item_perfil,
					nm_usuario_param )
				values (	
					nextval('perfil_item_pront_lib_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_per_item_pront_d_w,
					citemprontlib_w.nm_usuario_param );		
			end;
			end loop;
			
			for cItemSoapCli_w in cItemSoapCli loop
			begin
				insert into prontuario_item_soap_cli(	
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ie_etapa_soap,
					nr_seq_item_prontuario,
					ie_apresentar_pc,
					ie_apresentar_sc )
				values (	
					nextval('prontuario_item_soap_cli_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cItemSoapCli_w.ie_etapa_soap,
					nr_seq_per_item_pront_d_w,
					cItemSoapCli_w.ie_apresentar_pc,
					cItemSoapCli_w.ie_apresentar_sc );		
			end;
			end loop;
		end if;
		end;
	end loop;
	close C07;

	insert into indicador_gestao_perfil(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		cd_perfil,
		nr_seq_indicador,
		nr_seq_apresent)
	SELECT	nextval('indicador_gestao_perfil_seq'),
		clock_timestamp(),
		nm_usuario_p,
		cd_perfil_destino_p,
		nr_seq_indicador,
		nr_seq_apresent	
	from	indicador_gestao_perfil
	where	cd_perfil	= cd_Perfil_Origem_p;


	insert into funcao_perfil(
		cd_perfil,
		cd_funcao,
		dt_atualizacao, 
		nm_usuario)
	(SELECT cd_perfil_destino_p,
		cd_funcao, 
		clock_timestamp(),
		nm_usuario_p
	from 	funcao_perfil a
	where 	a.cd_perfil = cd_perfil_origem_p
	  and 	not exists (select 1 
				 from	funcao_perfil b
				 where 	a.cd_funcao = b.cd_funcao
	  			 and 	b.cd_perfil = cd_perfil_destino_p));


	insert into funcao_param_perfil(	cd_funcao,
			nr_sequencia, 
			cd_perfil, 
			vl_parametro, 
			ds_observacao, 
			dt_atualizacao, 
			nm_usuario,
			cd_estabelecimento)
		(	SELECT	cd_funcao, 
				nr_sequencia,
				cd_perfil_destino_p,
				vl_parametro, 
				substr(wheb_mensagem_pck.get_texto(672109, 'NM_PERFIL=' || obter_desc_perfil(cd_perfil_origem_p)) || ds_observacao,1,4000), 
				clock_timestamp(),
				nm_usuario_p,
				cd_estabelecimento
			from 	funcao_param_perfil a 
			where 	a.cd_perfil	= cd_perfil_origem_p
			and 	not exists (select	1
						from	funcao_param_perfil b 
						where 	a.cd_funcao	= b.cd_funcao
						and 	b.cd_perfil	= cd_perfil_destino_p));

	insert into tabela_sistema_perfil(
		cd_perfil,
		nm_tabela,
		dt_atualizacao,
		nm_usuario,
		ie_controle)
	SELECT	cd_perfil_destino_p,
		nm_tabela,
		clock_timestamp(),
		nm_usuario_p,
		ie_controle
	from	tabela_sistema_perfil a
	where	a.cd_perfil = cd_perfil_origem_p
	and		ie_tabela_p	= 'S'
	  and 	not exists (	SELECT	1
				from	tabela_sistema_perfil b 
				where 	a.nm_tabela = b.nm_tabela
				  and 	b.cd_perfil = cd_perfil_destino_p);

	open C21;
	loop
	fetch C21 into	
		c21_w;
	EXIT WHEN NOT FOUND; /* apply on C21 */
		begin
		insert into Tabela_Atrib_Regra(
				nr_sequencia,
				nm_tabela,
				nm_atributo,
				ie_tabstop,
				ie_enable,
				ie_visible,
				dt_atualizacao, 
				nm_usuario,
				cd_estabelecimento,
				cd_perfil,
				ie_obrigatorio,
				vl_default,
				cd_funcao,
				nr_seq_regra_funcao,
				ie_repetir_valor,
				ie_padrao_nulo,
				nm_usuario_param,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_visao,
				vl_minimo,
				vl_maximo,
				vl_minimo_permitido,
				vl_maximo_permitido,
				ie_gerar_log,
				cd_setor_atendimento,
				hr_fim,
				hr_inicio,
				ie_dia_semana,
				ds_observacao,
				ie_sensitive,
				ie_patient_info)
			values (nextval('tabela_atrib_regra_seq'),
				c21_w.nm_tabela,
				c21_w.nm_atributo,
				c21_w.ie_tabstop,
				c21_w.ie_enable,
				c21_w.ie_visible,
				clock_timestamp(), 
				nm_usuario_p,
				c21_w.cd_estabelecimento,
				cd_perfil_destino_p,
				c21_w.ie_obrigatorio,
				c21_w.vl_default,
				c21_w.cd_funcao,
				c21_w.nr_seq_regra_funcao,
				c21_w.ie_repetir_valor,
				c21_w.ie_padrao_nulo,
				c21_w.nm_usuario_param,
				clock_timestamp(),
				nm_usuario_p,
				c21_w.nr_seq_visao,
				c21_w.vl_minimo,
				c21_w.vl_maximo,
				c21_w.vl_minimo_permitido,
				c21_w.vl_maximo_permitido,
				c21_w.ie_gerar_log,
				c21_w.cd_setor_atendimento,
				c21_w.hr_fim,
				c21_w.hr_inicio,
				c21_w.ie_dia_semana,
				c21_w.ds_observacao,
				c21_w.ie_sensitive,
				c21_w.ie_patient_info);
		exception
		when others then
			null;
		end;
	end loop;
	close C21;

	open c01;
	loop
	fetch	c01 into
		nr_seq_antiga_w,
		nr_sequencia_w,	
		nr_seq_relatorio_w,
		qt_copia_w,
		ie_logo_w,
		ie_configurar_w,
		ie_imprimir_w,
		ie_outputbin_w,
		ds_impressora_w,
		nr_seq_apresent_w,
		IE_VISUALIZAR_w,
		ie_gravar_log_w,
		ie_apresenta_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		insert into relatorio_perfil(
			nr_sequencia,
			cd_perfil,
			nr_seq_relatorio,
			dt_atualizacao,
			nm_usuario,
			qt_copia,
			ie_logo,
			ie_configurar,
			ie_imprimir,
			ie_outputbin,
			ds_impressora,
			nr_seq_apresent,
			ie_gravar_log,
			IE_VISUALIZAR,
			ie_apresenta)
		values (nr_sequencia_w,
			cd_perfil_destino_p,	
			nr_seq_relatorio_w,
			clock_timestamp(),
			nm_usuario_p,
			qt_copia_w,
			ie_logo_w,
			ie_configurar_w,
			ie_imprimir_w,
			ie_outputbin_w,
			ds_impressora_w,
			nr_seq_apresent_w,
			ie_gravar_log_w,
			IE_VISUALIZAR_w,
			ie_apresenta_w);
		
		insert into relatorio_perfil_param(
			nr_seq_perfil_relat,
			nr_seq_parametro,
			dt_atualizacao,
			nm_usuario,
			ds_valor,
			ds_valor_exec)
		SELECT	nr_sequencia_w,
			nr_seq_parametro,
			clock_timestamp(),
			nm_usuario_p,
			ds_valor,
			ds_valor_exec
		from	relatorio_perfil_param a
		where	a.nr_seq_perfil_relat = nr_seq_antiga_w
		  and 	not exists (	SELECT	1
					from	relatorio_perfil_param b
					where 	a.nr_seq_parametro = b.nr_seq_parametro
					  and 	b.nr_seq_perfil_relat = nr_sequencia_w);
		end;
	end loop;
	close c01;

	if (ie_copia_usuarios_p = 'S') then
		open C03;
		loop
		fetch C03 into	
			nm_usuario_refer_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			
			insert	into usuario_perfil(NM_USUARIO            ,
				CD_PERFIL              ,
				DT_ATUALIZACAO         ,
				NM_USUARIO_ATUAL       ,
				DS_OBSERVACAO          )
			values (nm_usuario_refer_w,
				cd_perfil_destino_p,
				clock_timestamp(),
				nm_usuario_p,
				null);
			
			end;
		end loop;
		close C03;
	end if;

	open C04;
	loop
	fetch C04 into	
		  nr_seq_antiga_w,
		  nr_sequencia_item_w,
		  nr_seq_item_pepo_w,
		  ie_atualizar_w,
		  nr_seq_apresent_w,
		  ie_somente_template_w,
		  ie_tipo_item_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		insert 	into perfil_item_pepo(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			cd_perfil,
			nr_seq_item_pepo,
			ie_atualizar,
			nr_seq_apresentacao,
			ie_somente_template,
			ie_tipo_item)
		values (nr_sequencia_item_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_perfil_destino_p,
			nr_seq_item_pepo_w,
			ie_atualizar_w,
			nr_seq_apresent_w,
			ie_somente_template_w,
			ie_tipo_item_w);
		end;	
		commit;
	
	open C05;
	loop
	fetch C05 into	
		  nr_usuario_lib_item_w,
		  nr_sequencia_w,
		  ie_atualizar_w,
		  nm_usuario_lib_w,
		  nr_seq_perfil_item_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin
		insert into perfil_item_pepo_usuario(
			    nr_sequencia,
			    dt_atualizacao,
			    nm_usuario,
			    nr_seq_perfil_item,
			    nm_usuario_liberacao,
			    ie_atualizar)
		values ( nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_sequencia_item_w,
			nm_usuario_lib_w,
			ie_atualizar_w);		
		end;
		commit;
	end loop;
	close C05;
	
	
	open C06;
	loop
	fetch C06 into
		  nr_seq_antiga_w,
		  nr_sequencia_temp_w,
		  nr_seq_template_w;
	EXIT WHEN NOT FOUND; /* apply on C06 */
		begin
		insert into perfil_item_pepo_template(
			    nr_sequencia,
			    dt_atualizacao,
			    nm_usuario,
			    nr_seq_item_perfil,
			    nr_seq_template)
		values (   nr_sequencia_temp_w,
			    clock_timestamp(),
			    nm_usuario_p,
			    nr_sequencia_item_w,
			    nr_seq_template_w );
		end;
		commit;
	end loop;
	close C06;
		
	end loop;
	close C04;
	
	open C08;
	loop
	fetch C08 into	
		nr_seq_item_w,
		ie_atualizar_template_w,
		nr_seq_apresentacao_w;
	EXIT WHEN NOT FOUND; /* apply on C08 */
		begin
		insert into pls_dossie_item_perfil(
			    nr_sequencia,
			    cd_perfil,
			    nr_seq_item,
			    ie_atualizar_template,
			    nr_seq_apresentacao,			    
			    dt_atualizacao, 
			    nm_usuario)	
		values (   nextval('pls_dossie_item_perfil_seq'),
			    cd_perfil_destino_p,
			    nr_seq_item_w,
			    ie_atualizar_template_w,
			    nr_seq_apresentacao_w,
			    clock_timestamp(),
			    nm_usuario_p);		
		end;
	end loop;
	close C08;
	
	open C09;
	loop
	fetch C09 into	
		nr_seq_item_w,
		cd_estabelecimento_w,
		ie_controle_w;
	EXIT WHEN NOT FOUND; /* apply on C09 */
		begin
		insert into pls_cad_regra_item_perfil(
			    nr_sequencia,
			    cd_perfil,
			    nr_seq_item,
			    cd_estabelecimento,
			    ie_controle,
			    dt_atualizacao, 
			    nm_usuario)	
		values (   nextval('pls_cad_regra_item_perfil_seq'),
			    cd_perfil_destino_p,
			    nr_seq_item_w,
			    cd_estabelecimento_w,
			    ie_controle_w,
			    clock_timestamp(),
			    nm_usuario_p);		
		end;
	end loop;
	close C09;
	
	open C10;
	loop
	fetch C10 into	
		nr_seq_item_w,
		cd_estabelecimento_w;
	EXIT WHEN NOT FOUND; /* apply on C10 */
		begin
		insert into pls_item_relac_cli_perfil(
			    nr_sequencia,
			    cd_perfil,
			    nr_seq_item,
			    cd_estabelecimento,
			    dt_atualizacao, 
			    nm_usuario)	
		values (   nextval('pls_item_relac_cli_perfil_seq'),
			    cd_perfil_destino_p,
			    nr_seq_item_w,
			    cd_estabelecimento_w,
			    clock_timestamp(),
			    nm_usuario_p);		
		end;
	end loop;
	close C10;
	
	open C11;
	loop
	fetch C11 into	
		nr_seq_item_w,
		cd_estabelecimento_w,
		nr_seq_apresentacao_w;
	EXIT WHEN NOT FOUND; /* apply on C11 */
		begin
		insert into pls_item_contr_benef_lib(
			    nr_sequencia,
			    cd_perfil,
			    nr_seq_item,
			    cd_estabelecimento,
			    nr_seq_apresentacao,
			    dt_atualizacao, 
			    nm_usuario)	
		values (   nextval('pls_item_contr_benef_lib_seq'),
			    cd_perfil_destino_p,
			    nr_seq_item_w,
			    cd_estabelecimento_w,
			    nr_seq_apresentacao_w,
			    clock_timestamp(),
			    nm_usuario_p);		
		end;
	end loop;
	close C11;
	
	open C12;
	loop
	fetch  C12 into	
		nr_seq_item_w,
		cd_estabelecimento_w;
	EXIT WHEN NOT FOUND; /* apply on C12 */
		begin
		insert into pls_item_contr_regra_lib(
			    nr_sequencia,
			    cd_perfil,
			    nr_seq_item,
			    cd_estabelecimento,
			    dt_atualizacao, 
			    nm_usuario)	
		values (   nextval('pls_item_contr_regra_lib_seq'),
			    cd_perfil_destino_p,
			    nr_seq_item_w,
			    cd_estabelecimento_w,
			    clock_timestamp(),
			    nm_usuario_p);		
		end;
	end loop;
	close C12;
	
	open C13;
	loop
	fetch C13 into	
		nr_seq_item_w,
		cd_estabelecimento_w,
		nr_seq_apresentacao_w;
	EXIT WHEN NOT FOUND; /* apply on C13 */
		begin
		insert into pls_item_prod_regra_lib(
			    nr_sequencia,
			    cd_perfil,
			    nr_seq_item,
			    cd_estabelecimento,
			    nr_seq_apresentacao,
			    dt_atualizacao, 
			    nm_usuario)	
		values (   nextval('pls_item_prod_regra_lib_seq'),
			    cd_perfil_destino_p,
			    nr_seq_item_w,
			    cd_estabelecimento_w,
			    nr_seq_apresentacao_w,
			    clock_timestamp(),
			    nm_usuario_p);		
		end;
	end loop;
	close C13;	
	
	open C14;
	loop
	fetch  C14 into	
		nr_seq_item_w,
		cd_estabelecimento_w;
	EXIT WHEN NOT FOUND; /* apply on C14 */
		begin
		insert into pls_item_crit_cont_perfil(
			    nr_sequencia,
			    cd_perfil,
			    nr_seq_item_contab,
			    cd_estabelecimento,
			    dt_atualizacao, 
			    nm_usuario)	
		values (   nextval('pls_item_crit_cont_perfil_seq'),
			    cd_perfil_destino_p,
			    nr_seq_item_w,
			    cd_estabelecimento_w,
			    clock_timestamp(),
			    nm_usuario_p);		
		end;
	end loop;
	close C14;
	
	open C15;
	loop
	fetch C15 into	
		nr_seq_item_w,
		nr_seq_apresentacao_w,
		ie_controle_w;
	EXIT WHEN NOT FOUND; /* apply on C15 */
		begin
		insert into pls_parametros_item_perfil(
			    nr_sequencia,
			    cd_perfil,
			    nr_seq_item,
			    nr_seq_apresentacao,
			    ie_controle,
			    dt_atualizacao, 
			    nm_usuario)	
		values (   nextval('pls_parametros_item_perfil_seq'),
			    cd_perfil_destino_p,
			    nr_seq_item_w,
			    nr_seq_apresentacao_w,
			    ie_controle_w,
			    clock_timestamp(),
			    nm_usuario_p);		
		end;
	end loop;
	close C15;
	
	open C16;
	loop
	fetch C16 into	
		nr_seq_item_w,
		ie_controle_w;
	EXIT WHEN NOT FOUND; /* apply on C16 */
		begin
		insert into pls_solic_lead_item_perfil(
			    nr_sequencia,
			    cd_perfil,
			    nr_seq_item,			    
			    ie_controle,
			    dt_atualizacao, 
			    nm_usuario)	
		values (   nextval('pls_solic_lead_item_perfil_seq'),
			    cd_perfil_destino_p,
			    nr_seq_item_w,
			    ie_controle_w,
			    clock_timestamp(),
			    nm_usuario_p);		
		end;
	end loop;
	close C16;	
	
	open C17;
	loop
	fetch C17 into	
		nr_seq_item_w,
		ie_controle_w;
	EXIT WHEN NOT FOUND; /* apply on C17 */
		begin
		insert into pls_proposta_item_perfil(
			    nr_sequencia,
			    cd_perfil,
			    nr_seq_item,			    
			    ie_controle,
			    dt_atualizacao, 
			    nm_usuario)	
		values (   nextval('pls_proposta_item_perfil_seq'),
			    cd_perfil_destino_p,
			    nr_seq_item_w,
			    ie_controle_w,
			    clock_timestamp(),
			    nm_usuario_p);		
		end;
	end loop;
	close C17;	
	
	open C18;
	loop
	fetch C18 into	
		nr_seq_item_w,
		ie_controle_w;
	EXIT WHEN NOT FOUND; /* apply on C18 */
		begin
		insert into pls_analise_item_perfil(
			    nr_sequencia,
			    cd_perfil,
			    nr_seq_item,			    
			    ie_controle,
			    dt_atualizacao, 
			    nm_usuario)	
		values (   nextval('pls_analise_item_perfil_seq'),
			    cd_perfil_destino_p,
			    nr_seq_item_w,
			    ie_controle_w,
			    clock_timestamp(),
			    nm_usuario_p);		
		end;
	end loop;
	close C18;	
end if;

for cPerfilItemOft_w in cPerfilItemOft loop
   begin
   select   nextval('perfil_item_oftalmologia_seq')
   into STRICT     nr_seq_per_item_pront_d_w
;

   nr_seq_per_item_pront_o_w := cPerfilItemOft_w.nr_sequencia;

   insert into perfil_item_oftalmologia(	
      nr_sequencia, 
      dt_atualizacao, 
      nm_usuario, 
      dt_atualizacao_nrec, 
      nm_usuario_nrec, 
      cd_perfil, 
      nr_seq_item, 
      nr_seq_apresentacao, 
      nr_seq_superior, 
      ds_instituicao, 
      ie_visualiza_inativo, 
      ie_quest_texto_padrao, 
      ie_apresenta_visual, 
      ie_apresenta_visual_no_item, 
      ie_visao_paciente, 
      ie_apresentacao, 
      ie_sempre_apresentar, 
      ie_imprimir_liberar, 
      ie_forma_liberar)
   values (	
      nr_seq_per_item_pront_d_w, 
      clock_timestamp(), 
      nm_usuario_p, 
      clock_timestamp(), 
      nm_usuario_p, 
      cd_perfil_destino_p, 
      cPerfilItemOft_w.nr_seq_item, 
      cPerfilItemOft_w.nr_seq_apresentacao, 
      cPerfilItemOft_w.nr_seq_superior, 
      cPerfilItemOft_w.ds_instituicao, 
      coalesce(cPerfilItemOft_w.ie_visualiza_inativo,'S'), 
      coalesce(cPerfilItemOft_w.ie_quest_texto_padrao,'N'),
      coalesce(cPerfilItemOft_w.ie_apresenta_visual,'S'), 
      coalesce(cPerfilItemOft_w.ie_apresenta_visual_no_item,'S'), 
      coalesce(cPerfilItemOft_w.ie_visao_paciente,'N'), 
      cPerfilItemOft_w.ie_apresentacao, 
      coalesce(cPerfilItemOft_w.ie_sempre_apresentar,'N'), 
      coalesce(cPerfilItemOft_w.ie_imprimir_liberar,'N'), 
      coalesce(cPerfilItemOft_w.ie_forma_liberar,'Q'));

      insert into perfil_item_oft_visual(
         nr_sequencia, 
         dt_atualizacao, 
         nm_usuario, 
         dt_atualizacao_nrec, 
         nm_usuario_nrec, 
         nr_seq_item, 
         nr_seq_item_perfil, 
         nr_seq_apresentacao, 
         ds_instituicao)
      SELECT   nextval('perfil_item_oft_visual_seq'), 
               clock_timestamp(), 
               nm_usuario_p, 
               clock_timestamp(), 
               nm_usuario_p, 
               nr_seq_item, 
               nr_seq_per_item_pront_d_w, 
               nr_seq_apresentacao, 
               ds_instituicao
      from     perfil_item_oft_visual a
      where    a.nr_seq_item_perfil = nr_seq_per_item_pront_o_w;
   end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_perfil ( cd_perfil_destino_p bigint, cd_Perfil_Origem_p bigint, cd_funcao_p bigint, nm_usuario_p text, ie_relatorio_p text, ie_tabela_p text, ie_copia_usuarios_p text, ie_submitted_items_p text default 'N') FROM PUBLIC;
