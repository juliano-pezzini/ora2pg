-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eup_atualizar_agenda_pac_js ( nr_seq_agenda_p bigint, ds_lista_agenda_p text, ie_atual_conv_agenda_pac_p text, nr_atendimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_tipo_agenda_p bigint, ie_param_func_ext_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

	
c01 CURSOR FOR	
	SELECT 	b.nr_sequencia,
			b.nr_seq_oftalmo,
			b.cd_medico_exec,
			obter_tipo_agenda(b.cd_agenda)
	from 	table(lista_pck.obter_lista(coalesce(ds_lista_agenda_p, ' '))) a,
			agenda_paciente b
	where	a.nr_registro = b.nr_sequencia
	
union

	SELECT 	b.nr_sequencia,
			b.nr_seq_oftalmo,
			b.cd_medico_exec,
			obter_tipo_agenda(b.cd_agenda)
	from 	agenda_paciente b
	where	b.nr_sequencia = nr_seq_agenda_p;


nr_seq_agenda_int_w	bigint;
ds_lista_w		varchar(1000);
tam_lista_w		bigint;
ie_pos_virgula_w	smallint;
nr_sequencia_w		bigint;
ie_evento_e_w		varchar(1);
ie_evento_ci_w		varchar(1);
ie_gerar_oft_ag_ex_w	varchar(15);
ie_gerar_oft_eup_w	varchar(15);
nr_seq_oftalmo_w		agenda_paciente.nr_seq_oftalmo%type;
cd_medico_exec_w		agenda_paciente.cd_medico_exec%type;	
cd_tipo_agenda_w		agenda.cd_tipo_agenda%type;
nr_seq_agenda_w		agenda_paciente.nr_sequencia%type;

				

BEGIN

ie_gerar_oft_ag_ex_w := obter_param_usuario(820, 369, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_gerar_oft_ag_ex_w);
ie_gerar_oft_eup_w := obter_param_usuario(916, 1091, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_gerar_oft_eup_w);


ie_evento_e_w	:= obter_se_existe_evento_agenda(cd_estabelecimento_p,'GA','E');
ie_evento_ci_w	:= obter_se_existe_evento_agenda(cd_estabelecimento_p,'GA','CI');


if (nr_seq_agenda_p <> 0) then
	if (coalesce(ds_lista_agenda_p::text, '') = '') then
		if (ie_atual_conv_agenda_pac_p = 'S') then
			
			update 	agenda_paciente
			set 	nr_atendimento 	= nr_atendimento_p,
					cd_convenio    	= cd_convenio_p,
					cd_categoria   	= cd_categoria_p,
					cd_plano       	= cd_plano_p,
					nm_usuario     	= nm_usuario_p
			where 	nr_sequencia 	= nr_seq_agenda_p;
			
			update 	gestao_vaga
			set		cd_convenio    		= cd_convenio_p,
					cd_categoria   		= cd_categoria_p,
					cd_plano_convenio	= cd_plano_p,
					nm_usuario     		= nm_usuario_p
			where 	nr_seq_agenda 		= nr_seq_agenda_p;
			
		else
			update 	agenda_paciente
			set 	nr_atendimento = nr_atendimento_p
			where 	nr_sequencia 	= nr_seq_agenda_p;
		end if;
		
		if	(cd_tipo_agenda_p = 2 AND ie_evento_e_w = 'N') or
			 (cd_tipo_agenda_p = 1 AND ie_evento_ci_w = 'N') then
		
			if (ie_param_func_ext_p = 'S')then
			
				update 	agenda_paciente
				set 	ie_status_agenda = 'E'
				where 	nr_sequencia = nr_seq_agenda_p;
			end if;
		end if;
		
		update 	autorizacao_convenio
		set   	nr_atendimento  = nr_atendimento_p
		where 	nr_seq_agenda 	= nr_seq_agenda_p
		and   	coalesce(nr_atendimento::text, '') = '';
		
	else
	
		ds_lista_w := ds_lista_agenda_p;	

		if (substr(ds_lista_w,length(ds_lista_w) - 1, length(ds_lista_w))	<> ',') then
			ds_lista_w	:= ds_lista_w ||',';
		end if;
		
		while(ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') loop
			begin
			
			tam_lista_w		:= length(ds_lista_w);
			ie_pos_virgula_w	:= position(',' in ds_lista_w);
			
			if (ie_pos_virgula_w <> 0) then
				nr_sequencia_w		:= (substr(ds_lista_w,1,(ie_pos_virgula_w - 1)))::numeric;
				ds_lista_w		:= substr(ds_lista_w,(ie_pos_virgula_w + 1),tam_lista_w);
			end if;
			if (coalesce(nr_sequencia_w,0) > 0) then
			
				if (ie_atual_conv_agenda_pac_p = 'S') then
				
					update 	agenda_paciente
					set 	nr_atendimento 	= nr_atendimento_p,
						cd_convenio    	= cd_convenio_p,
						cd_categoria   	= cd_categoria_p,
						cd_plano       	= cd_plano_p,
						nm_usuario     	= nm_usuario_p
					where 	nr_sequencia 	= nr_sequencia_w;
				else
					update 	agenda_paciente
					set 	nr_atendimento = nr_atendimento_p
					where 	nr_sequencia 	= nr_sequencia_w;
				end if;
				
				if	(cd_tipo_agenda_p = 2 AND ie_evento_e_w = 'N') or
					(cd_tipo_agenda_p = 1 AND ie_evento_ci_w = 'N') then
					
					if (ie_param_func_ext_p = 'S')then
					
						update 	agenda_paciente
						set 	ie_status_agenda = 'E'
						where 	nr_sequencia 	= nr_sequencia_w;
					end if;
				end if;
				
				update 	autorizacao_convenio
				set   	nr_atendimento  = nr_atendimento_p
				where 	nr_seq_agenda 	= nr_sequencia_w
				and   	coalesce(nr_atendimento::text, '') = '';
				
			end if;
			end;
		end loop;
		
	end if;
end if;

if (ie_gerar_oft_eup_w = 'N') and (ie_gerar_oft_ag_ex_w = 'A') then
	open C01;
	loop
	fetch C01 into	
		nr_seq_agenda_w,
		nr_seq_oftalmo_w,
		cd_medico_exec_w,
		cd_tipo_agenda_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (cd_tipo_agenda_w = 2) and (coalesce(nr_atendimento_p,0) > 0) and (coalesce(nr_seq_oftalmo_w::text, '') = '') and (cd_medico_exec_w IS NOT NULL AND cd_medico_exec_w::text <> '') then
			CALL gerar_consulta_oft_agenda(null,nr_seq_agenda_w,nm_usuario_p,wheb_usuario_pck.get_cd_estabelecimento);
		end if;	
		end;
	end loop;
	close C01;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eup_atualizar_agenda_pac_js ( nr_seq_agenda_p bigint, ds_lista_agenda_p text, ie_atual_conv_agenda_pac_p text, nr_atendimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_tipo_agenda_p bigint, ie_param_func_ext_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
