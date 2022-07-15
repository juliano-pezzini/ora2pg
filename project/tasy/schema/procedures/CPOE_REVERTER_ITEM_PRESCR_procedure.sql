-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_reverter_item_prescr (lista_itens_p text, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_prescricao_max_w    	prescr_medica.nr_prescricao%type;							

nr_seq_reg_item_w		cpoe_dieta.nr_sequencia%type;	
ie_tipo_dieta_w      	cpoe_dieta.ie_tipo_dieta%type;

ie_controle_tempo_w  	cpoe_material.ie_controle_tempo%type;
ie_material_w			cpoe_material.ie_material%type;

dt_alta_w				timestamp;
ie_possui_dialise_w		char(1);
ie_sol_dialise_w		char(1);
ie_opcao_prescr_ww		varchar(2000);
ie_opcao_prescr_w		varchar(255);
item_w					varchar(255);
nr_sequencia_hor		bigint;


c01 REFCURSOR;


BEGIN

ie_opcao_prescr_ww := lista_itens_p;

while(ie_opcao_prescr_ww IS NOT NULL AND ie_opcao_prescr_ww::text <> '') loop
	begin
	-- R,12;M,12345;D,1233;M,2312;
	
	if	((position(';' in ie_opcao_prescr_ww) = 0) and (ie_opcao_prescr_ww IS NOT NULL AND ie_opcao_prescr_ww::text <> '')) then
		
		ie_opcao_prescr_ww	:= ie_opcao_prescr_ww ||';';	
	end if;	
	
	item_w := substr(ie_opcao_prescr_ww, 1, position(';' in ie_opcao_prescr_ww) - 1);
	ie_opcao_prescr_w := substr(item_w, 1, position(',' in item_w) - 1);	
	nr_seq_reg_item_w := (substr(item_w, position(',' in item_w) + 1, length(item_w)))::numeric;
	ie_opcao_prescr_ww := substr(ie_opcao_prescr_ww, position(';' in ie_opcao_prescr_ww) + 1, length(ie_opcao_prescr_ww));

	if (ie_opcao_prescr_w IS NOT NULL AND ie_opcao_prescr_w::text <> '') then		
		
			if (ie_opcao_prescr_w = 'N') then
				
				select	max(ie_tipo_dieta)
				into STRICT	ie_tipo_dieta_w
				from	cpoe_dieta
				where	nr_sequencia = nr_seq_reg_item_w;
			
				--Oral
				if (ie_tipo_dieta_w = 'O') then
				
					select	max(a.nr_prescricao)
					into STRICT	nr_prescricao_max_w
					from	prescr_medica a,
						prescr_dieta c
					where	a.nr_prescricao = c.nr_prescricao
					and	a.nr_atendimento = nr_atendimento_p
					and	c.nr_seq_dieta_cpoe = nr_seq_reg_item_w;
				
				-- Enteral and Supplement
				elsif (ie_tipo_dieta_w in ('E','S')) then	
				
					select	max(a.nr_prescricao)
					into STRICT	nr_prescricao_max_w
					from	prescr_medica a,
						prescr_material c
					where	a.nr_prescricao = c.nr_prescricao
					and	a.nr_atendimento = nr_atendimento_p
					and	c.nr_seq_dieta_cpoe = nr_seq_reg_item_w;					
				
				-- Fasting
				elsif (ie_tipo_dieta_w = 'J') then
				
					select	max(a.nr_prescricao)
					into STRICT	nr_prescricao_max_w
					from	prescr_medica a,
						rep_jejum c
					where	a.nr_prescricao = c.nr_prescricao
					and	a.nr_atendimento = nr_atendimento_p
					and	c.nr_seq_dieta_cpoe = nr_seq_reg_item_w;
					
				-- Milk and infant formulas
				elsif (ie_tipo_dieta_w = 'L') then					

					select	max(a.nr_prescricao)
					into STRICT	nr_prescricao_max_w
					from   	prescr_medica a,
						prescr_material c
					where   a.nr_prescricao = c.nr_prescricao
					and	a.nr_atendimento = nr_atendimento_p
					and c.nr_seq_dieta_cpoe = nr_seq_reg_item_w;
				
				end if;				
				
				if (coalesce(nr_prescricao_max_w,0) > 0) then
					
					if (ie_tipo_dieta_w = 'O') then					
						
						open C01 for
							SELECT	b.nr_sequencia,
									a.nr_prescricao
							from	prescr_medica a,
									prescr_dieta_hor b,
									prescr_dieta c
							where	a.nr_prescricao = b.nr_prescricao
							and		a.nr_prescricao = c.nr_prescricao
							and		b.nr_seq_dieta = c.nr_sequencia
							and		a.nr_prescricao = nr_prescricao_max_w
							and		c.nr_seq_dieta_cpoe = nr_seq_reg_item_w
							and	    (b.dt_suspensao IS NOT NULL AND b.dt_suspensao::text <> '');		
					
					elsif (ie_tipo_dieta_w = 'J') then
						
						open C01 for
							SELECT	max(a.nr_sequencia),
									a.nr_prescricao
							from	rep_jejum a
							where	nr_prescricao = nr_prescricao_max_w
							and		nr_seq_dieta_cpoe = nr_seq_reg_item_w
							and	    coalesce(ie_suspenso,'N') = 'S';
					
					else 		
						
						open C01 for
							SELECT	b.nr_sequencia,
									a.nr_prescricao
							from	prescr_medica a,
									prescr_mat_hor b,
									prescr_material c
							where	a.nr_prescricao = b.nr_prescricao
							and		a.nr_prescricao = c.nr_prescricao
							and		b.nr_seq_material = c.nr_sequencia
							and		a.nr_prescricao = nr_prescricao_max_w
							and		c.nr_seq_dieta_cpoe = nr_seq_reg_item_w
							and		coalesce(b.ie_suspenso_adep,'N') = 'N'
							and	    (b.dt_suspensao IS NOT NULL AND b.dt_suspensao::text <> '');
					end if;
					
				end if;
				
				
			-- Medicine and Solution - MAterials
			elsif (ie_opcao_prescr_w = 'M') then
				
				select 	coalesce(max(ie_controle_tempo),'N'),
					coalesce(max(ie_material),'N')
				into STRICT   ie_controle_tempo_w,
					ie_material_w
				from   cpoe_material
				where  nr_Sequencia = nr_seq_reg_item_w;

				if (coalesce(ie_material_w,'N') = 'S') then
					ie_opcao_prescr_w := 'MA';
				elsif (coalesce(ie_controle_tempo_w,'N') = 'S') then
					ie_opcao_prescr_w := 'S';
				end if;				
				
				select	max(a.nr_prescricao)
				into STRICT	nr_prescricao_max_w
				from	prescr_medica a,
					prescr_material c
				where	a.nr_prescricao = c.nr_prescricao
				and	a.nr_atendimento = nr_atendimento_p
				and	c.nr_seq_mat_cpoe = nr_seq_reg_item_w;

				if (coalesce(nr_prescricao_max_w,0) > 0) then
					
					open C01 for
						SELECT	b.nr_sequencia,
								b.nr_prescricao
						from	prescr_medica a,
								prescr_mat_hor b,
								prescr_material c
						where	a.nr_prescricao = b.nr_prescricao
						and		a.nr_prescricao = c.nr_prescricao
						and		b.nr_seq_material = c.nr_sequencia
						--and		a.nr_prescricao = nr_prescricao_max_w
						and		c.nr_seq_mat_cpoe = nr_seq_reg_item_w
						and		coalesce(b.ie_suspenso_adep,'N') = 'N'
						and 	b.dt_horario > clock_timestamp()
						and	    (b.dt_suspensao IS NOT NULL AND b.dt_suspensao::text <> '');
				end if;
				
				
			-- Recommendation
			elsif (ie_opcao_prescr_w = 'R') then

				select	max(a.nr_prescricao)
				into STRICT	nr_prescricao_max_w
				from	prescr_medica a,
					prescr_recomendacao c
				where	a.nr_prescricao = c.nr_prescricao
				and	a.nr_atendimento = nr_atendimento_p
				and	c.nr_seq_rec_cpoe = nr_seq_reg_item_w;			
			
			if (coalesce(nr_prescricao_max_w,0) > 0) then
				
				open C01 for
					SELECT 	b.nr_sequencia,
							a.nr_prescricao
					from	prescr_medica a,
							prescr_rec_hor b,
							prescr_recomendacao c
					where	a.nr_prescricao = b.nr_prescricao
					and		b.nr_prescricao = c.nr_prescricao
					and		b.nr_seq_recomendacao = c.nr_sequencia
					and		a.nr_prescricao = nr_prescricao_max_w
					and		c.nr_seq_rec_cpoe = nr_seq_reg_item_w
					and	    (b.dt_suspensao IS NOT NULL AND b.dt_suspensao::text <> '');		
			
			end if;

			-- Procedure
			elsif (ie_opcao_prescr_w = 'P') then
			
				select	max(a.nr_prescricao)
				into STRICT	nr_prescricao_max_w
				from	prescr_medica a,
					prescr_procedimento c
				where	a.nr_prescricao = c.nr_prescricao
				and	a.nr_atendimento = nr_atendimento_p
				and	c.nr_seq_proc_cpoe = nr_seq_reg_item_w;
								
				if (coalesce(nr_prescricao_max_w,0) > 0) then
					
					open C01 for
						SELECT	b.nr_sequencia,
								a.nr_prescricao
						from	prescr_medica a,
								prescr_proc_hor b,
								prescr_procedimento c
						where	a.nr_prescricao = b.nr_prescricao
						and		a.nr_prescricao = c.nr_prescricao
						and		b.nr_seq_procedimento = c.nr_sequencia
						and		a.nr_prescricao = nr_prescricao_max_w
						and		c.nr_seq_proc_cpoe = nr_seq_reg_item_w
						and	    (b.dt_suspensao IS NOT NULL AND b.dt_suspensao::text <> '');			
				
				end if;
			
			-- Gastherapy
			elsif (ie_opcao_prescr_w = 'G') then

				select	max(a.nr_prescricao)
				into STRICT	nr_prescricao_max_w
				from    	prescr_medica a,
					prescr_gasoterapia c
				where	a.nr_prescricao	= c.nr_prescricao
				and	a.nr_atendimento	= nr_atendimento_p
				and	c.nr_seq_gas_cpoe	= nr_seq_reg_item_w;			
			
				if (coalesce(nr_prescricao_max_w,0) > 0) then
			
					open C01 for				
						SELECT  b.nr_sequencia,
								a.nr_prescricao
						from    prescr_medica a,
								prescr_gasoterapia_hor b,
								prescr_gasoterapia c
						where   a.nr_prescricao = b.nr_prescricao
						and     a.nr_prescricao = c.nr_prescricao
						and	    a.nr_prescricao = nr_prescricao_max_w
						and		c.nr_seq_gas_cpoe = nr_seq_reg_item_w
						and     b.nr_seq_gasoterapia = c.nr_sequencia
						and	    (b.dt_suspensao IS NOT NULL AND b.dt_suspensao::text <> '');
				end if;
			
			--Hemotherapy
			elsif (ie_opcao_prescr_w = 'H') THEN
			
				select	max(a.nr_prescricao)
				into STRICT	nr_prescricao_max_w
				from    	prescr_medica a,
					prescr_solic_bco_sangue c
				where	a.nr_prescricao	= c.nr_prescricao
				and	a.nr_atendimento	= nr_atendimento_p
				and	c.nr_seq_hemo_cpoe	= nr_seq_reg_item_w;

				
				if (coalesce(nr_prescricao_max_w,0) > 0) then
				
					open C01 for
						SELECT	b.nr_sequencia,
								a.nr_prescricao
						from	prescr_medica a,
								prescr_proc_hor b,
								prescr_procedimento c
						where	a.nr_prescricao = b.nr_prescricao
						and		a.nr_prescricao = c.nr_prescricao
						and		b.nr_seq_procedimento = c.nr_sequencia
						and		a.nr_prescricao = nr_prescricao_max_w
						and		c.nr_seq_proc_cpoe = nr_seq_reg_item_w
						and	    (b.dt_suspensao IS NOT NULL AND b.dt_suspensao::text <> '');	
				
				end if;
			
			-- Dialise
			elsif (ie_opcao_prescr_w = 'D') then

				select	max(a.nr_prescricao)
				into STRICT	nr_prescricao_max_w
				from	prescr_medica a,
					prescr_solucao c
				where	a.nr_prescricao = c.nr_prescricao
				and	a.nr_atendimento = nr_atendimento_p
				and	c.nr_seq_dialise_cpoe = nr_seq_reg_item_w
				and coalesce(ie_status,'N') = 'S'
				and	(c.dt_suspensao IS NOT NULL AND c.dt_suspensao::text <> '');
				
				if (coalesce(nr_prescricao_max_w,0) > 0) then

					ie_possui_dialise_w := 'S';
				
					open C01 for
						SELECT 	b.nr_seq_solucao,
								a.nr_prescricao
						from    prescr_medica a,
							hd_prescricao c,
							prescr_solucao b
						where	a.nr_prescricao	= c.nr_prescricao
						and c.nr_sequencia = b.nr_seq_dialise
						and	a.nr_atendimento	= nr_atendimento_p
						and	a.nr_prescricao	= nr_prescricao_max_w
						and	c.nr_seq_dialise_cpoe	= nr_seq_reg_item_w;				
				
					ie_opcao_prescr_w := null;
				
				end if;		
			else
				ie_opcao_prescr_w := null;
			end if;
			
			if	((coalesce(nr_prescricao_max_w,0) > 0) and ((ie_opcao_prescr_w IS NOT NULL AND ie_opcao_prescr_w::text <> '') or ie_possui_dialise_w = 'S')) then
				loop
				fetch c01 into
					nr_sequencia_hor,
					nr_prescricao_max_w;
				EXIT WHEN NOT FOUND; /* apply on c01 */
					if (coalesce(ie_possui_dialise_w,'N') = 'S') then
						
						select	coalesce(max('S'),'N')
						into STRICT	ie_sol_dialise_w
						from	prescr_solucao
						where	nr_prescricao	= nr_prescricao_max_w
						and		nr_seq_solucao	= nr_sequencia_hor
						and		(nr_seq_dialise IS NOT NULL AND nr_seq_dialise::text <> '');
						
						if (coalesce(ie_sol_dialise_w,'N') = 'S') then
								ie_opcao_prescr_w := 'D';
						end if;							
						
					end if;				
					
					
					CALL cpoe_reverter_hor_item_prescr(nr_prescricao_max_w, nr_sequencia_hor, ie_opcao_prescr_w, nr_atendimento_p, nm_usuario_p);				
					ie_possui_dialise_w := 'N';
				end loop;
				close c01;				
				
			end if;
		
			ie_tipo_dieta_w := '';		
			
	end if;	
	
	end;
end loop;	

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_reverter_item_prescr (lista_itens_p text, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

