-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_prox_adm_grid_ang ( nr_seq_item_cpoe_p bigint, ie_tipo_item_p text, nm_usuario_p text default null, nr_atendimento_p bigint default null, ie_administracao_p text default null, cd_intervalo_p text default null, dt_inicio_base_p timestamp default null, dt_inicio_p timestamp default null, dt_fim_p timestamp default null, nm_rep_tabela_cpoe_p text default null, nm_rep_chave_cpoe_p text default null, nm_hor_tabela_rep_p text default null, nm_hor_chave_rep_p text default null, nr_prescricao_p bigint default null, dt_fim_grid_p timestamp default null, cd_funcao_p bigint default 2314, ie_revalidacao_p text default 'N') RETURNS varchar AS $body$
DECLARE


nr_prescricao_w			prescr_medica.nr_prescricao%type;	
nr_seq_item_w			prescr_material.nr_sequencia%type;

ie_operacao_w			intervalo_prescricao.ie_operacao%type;
dt_prox_adm_w			timestamp;
dt_fim_w				timestamp;
qt_controle_w			double precision;
ds_idioma_w   varchar(20);


	procedure Localizar_inicio_item is
		ds_sql_w	varchar(4000);
	
BEGIN
		if (dt_inicio_p IS NOT NULL AND dt_inicio_p::text <> '') then
			dt_prox_adm_w	:= dt_inicio_p;
		else
			dt_prox_adm_w	:= dt_inicio_base_p;
		end if;
		
		-- Localizar ultima prescricao gerada pela CPOE, nao pode ser a prescricao que e sendo gerada
		ds_sql_w	:=
				' select	max(b.nr_prescricao) ' ||
				' from		prescr_medica a, ' ||
				' 			' || nm_rep_tabela_cpoe_p || ' b ' ||
				' where		a.nr_prescricao = b.nr_prescricao ' ||
				' and		a.nr_atendimento = :nr_atendimento ' ||
				' and		a.dt_inicio_prescr > :dt_inicio_busca ' ||
				' and		b.' || nm_rep_chave_cpoe_p || ' = :nr_seq_item_cpoe ';
				
		if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
			ds_sql_w	:= ds_sql_w || ' and		a.nr_prescricao < ' || nr_prescricao_p || ' ';
		end if;
		
		EXECUTE
				ds_sql_w
		into STRICT	nr_prescricao_w
		using	nr_atendimento_p,
				dt_inicio_base_p-30,
				nr_seq_item_cpoe_p;
		
		-- Localizar o item principal da ultima prescricao gerada pela CPOE
		EXECUTE
				' select	min(b.nr_sequencia) ' ||
				' from		' || nm_rep_tabela_cpoe_p || ' b ' ||
				' where		b.nr_prescricao = :nr_prescricao ' ||
				' and		b.' || nm_rep_chave_cpoe_p || ' = :nr_seq_item_cpoe '
		into STRICT	nr_seq_item_w
		using	nr_prescricao_w,
				nr_seq_item_cpoe_p;
				
		if (coalesce(nr_seq_item_w::text, '') = '' and coalesce(nr_prescricao_w::text, '') = '')then
			dt_prox_adm_w := null;
		end if;
		
		
		EXECUTE
				' select	nvl(max(c.dt_horario), :dt_inicio) ' ||
				' from		' || nm_hor_tabela_rep_p || ' c ' ||
				' where		c.nr_prescricao = :nr_prescricao ' ||
				' and		c.' || nm_hor_chave_rep_p || ' = :nr_seq_item '
		into STRICT	dt_prox_adm_w
		using	dt_prox_adm_w,
				nr_prescricao_w,
				nr_seq_item_w;				
	end;
	
	function obter_hor_anterior return varchar2 is
	ds_sql_w	 varchar2(4000);
	ie_hor_ant_w varchar2(1):='N';
	begin
	
		-- Localizar ultima prescricao gerada pela CPOE, nao pode ser a prescricao que esta sendo gerada
		ds_sql_w	:=
				' select	max(b.nr_prescricao) ' ||
				' from		prescr_medica a, ' ||
				' 			' || nm_rep_tabela_cpoe_p || ' b ' ||
				' where		a.nr_prescricao = b.nr_prescricao ' ||
				' and		a.nr_atendimento = :nr_atendimento ' ||
				' and		a.dt_inicio_prescr > :dt_inicio_busca ' ||
				' and		b.' || nm_rep_chave_cpoe_p || ' = :nr_seq_item_cpoe ';
				
		if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
			ds_sql_w	:= ds_sql_w || ' and		a.nr_prescricao < ' || nr_prescricao_p || ' ';
		end if;
				
		EXECUTE
				ds_sql_w
		into STRICT	nr_prescricao_w
		using	nr_atendimento_p,
				dt_inicio_base_p-30,
				nr_seq_item_cpoe_p;
		
		-- Localizar o item principal da ultima prescricao gerada pela CPOE
		EXECUTE
				' select	min(b.nr_sequencia) ' ||
				' from		' || nm_rep_tabela_cpoe_p || ' b ' ||
				' where		b.nr_prescricao = :nr_prescricao ' ||
				' and		b.' || nm_rep_chave_cpoe_p || ' = :nr_seq_item_cpoe '
		into STRICT	nr_seq_item_w
		using	nr_prescricao_w,
				nr_seq_item_cpoe_p;
				

		EXECUTE
				' select	max(nvl(''S'',''N'')) ' ||
				' from		' || nm_hor_tabela_rep_p || ' c ' ||
				' where		c.nr_prescricao = :nr_prescricao ' ||
				' and		c.' || nm_hor_chave_rep_p || ' = :nr_seq_item ' ||
				' and 		c.dt_horario < :dt_prox_adm_w'
		into STRICT	ie_hor_ant_w
		using	nr_prescricao_w,
				nr_seq_item_w,
				dt_prox_adm_w;
		
		return coalesce(ie_hor_ant_w,'N');
	end;
	
	procedure Gera_prox_adm_por_dias_espec is
		ds_dias_utilizacao_w	varchar2(30);
	begin
		-- Verificar o tipo e quantidade de operacao ou dias especificos para o intervalo
		select	CASE WHEN max(ie_domingo)='S' THEN '1,' END  ||
				CASE WHEN max(ie_segunda)='S' THEN '2,' END  || 
				CASE WHEN max(ie_terca)='S' THEN '3,' END  || 
				CASE WHEN max(ie_quarta)='S' THEN '4,' END  || 
				CASE WHEN max(ie_quinta)='S' THEN '5,' END  || 
				CASE WHEN max(ie_sexta)='S' THEN '6,' END  || 
				CASE WHEN max(ie_sabado)='S' THEN '7,' END 
		into STRICT	ds_dias_utilizacao_w
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_p;
	
		-- Caso estes tenham sido definidos, verificar qual e o proximo dia
		if (ds_dias_utilizacao_w IS NOT NULL AND ds_dias_utilizacao_w::text <> '') then	

			if (dt_inicio_p > clock_timestamp()) then
				dt_prox_adm_w := dt_inicio_p;
			else
				Localizar_inicio_item;
				
				-- CUIDADO: Esta repeticao pode travar a CPOE, se manipulada sem atencao

				--  Enquanto o inicio for menor que 
				loop	
					begin
					dt_prox_adm_w		:= dt_prox_adm_w + 1;
					qt_controle_w		:= qt_controle_w + 24;

					if (qt_controle_w > 5000) then
						return;
					end if;
					end;
				exit when(dt_prox_adm_w > dt_inicio_base_p) and (obter_se_valor_contido(pkg_date_utils.get_WeekDay(dt_prox_adm_w),ds_dias_utilizacao_w) = 'S');
				end loop;
			end if;
		end if;
		
	end;
	
	procedure Gerar_prox_adm_por_horas is
		qt_horas_adic_w		number(18,6);
	begin
		qt_horas_adic_w		:= Obter_ocorrencia_intervalo(cd_intervalo_p, 24, 'H');

		if (qt_horas_adic_w > 24) then
			
			if (dt_inicio_p > clock_timestamp()) then
				dt_prox_adm_w := dt_inicio_p;
			else			
				Localizar_inicio_item;
				
				-- CUIDADO: Esta repeticao pode travar a CPOE, se manipulada sem atencao

				--  Enquanto o inicio for menor que 
				loop	
					begin
					dt_prox_adm_w	:= dt_prox_adm_w + dividir(qt_horas_adic_w, 24);
					qt_controle_w	:= qt_controle_w + qt_horas_adic_w;

					if (qt_controle_w > 5000) then
						return;
					end if;

					end;
				exit when(dt_prox_adm_w > dt_inicio_base_p);
				end loop;
			end if;
		end if;		
	end;
	
begin
-- Itens ACM e SN nao devem definir proxima geracao
if (ie_administracao_p not in ('C', 'N')) and (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then

	-- Verificar o tipo de operacao para o intervalo
	select	coalesce(max(ie_operacao),'X')
	into STRICT	ie_operacao_w
	from	intervalo_prescricao
	where	cd_intervalo = cd_intervalo_p;

	if (dt_inicio_p > dt_fim_grid_p) and (Obter_ocorrencia_intervalo(cd_intervalo_p, 24, 'H') <= 24) then		
		dt_prox_adm_w := dt_inicio_p;
	else				
		if (ie_operacao_w = 'D') then
			Gera_prox_adm_por_dias_espec;
		else
			Gerar_prox_adm_por_horas;
		end if;
	end if;
	
	-- Se a data de proxima administracao foi gerada, retornar
	if (dt_prox_adm_w IS NOT NULL AND dt_prox_adm_w::text <> '') then
		dt_fim_w	:= coalesce(dt_fim_p, dt_prox_adm_w+1);
		
		if (dt_prox_adm_w < dt_fim_w) then			
			--Verificar se tem	 alguma data anterior esta dt_prox_adm_w
			
			select coalesce(DS_LANGUAGE_TAG,'pt_BR')
			into STRICT ds_idioma_w
			from tasy_idioma
			where NR_SEQUENCIA = wheb_usuario_pck.get_nr_seq_idioma;

			if (cd_funcao_p <> 252) then
				if (coalesce(obter_hor_anterior,'N') = 'S' and coalesce(ie_revalidacao_p,'N') = 'N') then
					return obter_desc_expressao(327473, '') || '<br>' 
                          	|| pkg_date_formaters.to_varchar(dt_prox_adm_w, 'shortDayMonth', ds_idioma_w, null) || '   ' 
                          	|| pkg_date_formaters.to_varchar(dt_prox_adm_w, 'shortTime', ds_idioma_w, null) || ' >>@' 
                          	|| to_char(dt_prox_adm_w,'dd/MM/yyyy');--pkg_date_formaters.to_varchar(dt_prox_adm_w, 'dd/MM/yyyy', nvl(wheb_usuario_pck.get_cd_estabelecimento, 1), nm_usuario_p);
				end if;

				if (dt_prox_adm_w > dt_fim_grid_p)  then
					if (coalesce(ie_revalidacao_p,'N') = 'N') then
						return obter_desc_expressao(736613, '') || '<br>'
                        	|| pkg_date_formaters.to_varchar(dt_prox_adm_w, 'shortDayMonth', ds_idioma_w, null) || '   '
                          	|| pkg_date_formaters.to_varchar(dt_prox_adm_w, 'shortTime', ds_idioma_w, null) 
                          	|| ' >>@'||to_char(dt_prox_adm_w,'dd/MM/yyyy');--pkg_date_formaters.to_varchar(dt_prox_adm_w, 'dd/MM/yyyy', nvl(wheb_usuario_pck.get_cd_estabelecimento, 1), nm_usuario_p);
					else
						return obter_desc_expressao(736613, '') || ' '
                        	|| pkg_date_formaters.to_varchar(dt_prox_adm_w, 'shortDayMonth', ds_idioma_w, null) || '   '
                          	|| pkg_date_formaters.to_varchar(dt_prox_adm_w, 'shortTime', ds_idioma_w, null);                          	
					end if;
				end if;				
			else
				if (coalesce(ie_revalidacao_p,'N') = 'N') then
					return pkg_date_formaters.to_varchar(dt_prox_adm_w, 'shortDayMonth', ds_idioma_w, null) || '   '
                        || pkg_date_formaters.to_varchar(dt_prox_adm_w, 'shortTime',ds_idioma_w, null);
				end if;
			end if;
			
		end if;
	end if;
end if;
	
return null;
end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_prox_adm_grid_ang ( nr_seq_item_cpoe_p bigint, ie_tipo_item_p text, nm_usuario_p text default null, nr_atendimento_p bigint default null, ie_administracao_p text default null, cd_intervalo_p text default null, dt_inicio_base_p timestamp default null, dt_inicio_p timestamp default null, dt_fim_p timestamp default null, nm_rep_tabela_cpoe_p text default null, nm_rep_chave_cpoe_p text default null, nm_hor_tabela_rep_p text default null, nm_hor_chave_rep_p text default null, nr_prescricao_p bigint default null, dt_fim_grid_p timestamp default null, cd_funcao_p bigint default 2314, ie_revalidacao_p text default 'N') FROM PUBLIC;
