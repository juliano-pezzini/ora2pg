-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rp_consistir_falta_agend (nr_seq_rp_mod_item_p text, nr_seq_rp_item_ind_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_agenda_p bigint default 0) AS $body$
DECLARE


qt_faltas_perm_w	integer;
pr_permitido_falta_w	double precision;
ie_status_bloq_w	bigint;
nr_seq_pac_reab_w	bigint;
dt_periodo_inicial_w	timestamp;
dt_periodo_final_w	timestamp;
cd_pessoa_fisica_w	varchar(10);
nr_dias_w		bigint := 0;
dt_agenda_w		timestamp;
dt_agenda_ant_w		timestamp;
ie_falta_w		varchar(1);
ie_bloqueia_w		varchar(1);
qt_agendamentos_w	bigint;
qt_agend_falta_w	bigint;
pr_falta_w		double precision;
ie_status_agenda_susp_w	varchar(3);
ie_falta_consecutiva_w	varchar(1);
qt_faltas_w		bigint;
cd_pessoa_fisica_falta_w	varchar(10);
qt_valida_falta_w	bigint;
ie_continua_w		varchar(1);
dt_vigencia_regra_falta_w timestamp;
dt_desbloqueio_w	timestamp;
ie_possui_equipe_w	varchar(1) := 'N';
ie_utiliza_equipe_w	varchar(1);
nr_seq_classif_w	bigint;
qt_perm_falta_classif_w	integer;
qt_permitida_falta_just_w integer;
ie_falta_consecutiva_classif_w varchar(1);
ie_falta_just_cons_classif_w	varchar(1);
ds_log_w		varchar(2000);
ie_susp_treinamento_w	varchar(1);
nr_seq_inscrito_w		bigint;
nr_seq_hora_w		agenda_consulta.nr_seq_hora%TYPE;
nr_sequencia_w		agenda_consulta.nr_sequencia%TYPE;
cd_agenda_w		agenda_consulta.cd_agenda%TYPE;
dt_agenda_2_w		agenda_consulta.dt_agenda%TYPE;

C01 CURSOR FOR
	SELECT	distinct trunc(a.dt_agenda),
		a.cd_pessoa_fisica
	from   	agenda_consulta a,
		agenda b
	where  	a.cd_agenda = b.cd_agenda
	and	b.cd_estabelecimento = cd_estabelecimento_p
	and	a.cd_pessoa_fisica = cd_pessoa_fisica_w
	and	((a.nr_seq_rp_mod_item IS NOT NULL AND a.nr_seq_rp_mod_item::text <> '') or (a.nr_seq_rp_item_ind IS NOT NULL AND a.nr_seq_rp_item_ind::text <> ''))	
	and	((a.dt_agenda > dt_vigencia_regra_falta_w) or (coalesce(dt_vigencia_regra_falta_w::text, '') = ''))
	and	((a.dt_agenda > dt_desbloqueio_w) or (coalesce(dt_desbloqueio_w::text, '') = ''))
	order by 1;
	
C02 CURSOR FOR
	SELECT	distinct b.nr_sequencia
	from	tre_evento a,
		tre_inscrito b
	where	a.nr_sequencia = b.nr_seq_evento
	and	b.cd_pessoa_fisica = cd_pessoa_fisica_w
	and	coalesce(a.dt_fim_real,a.dt_fim) >= clock_timestamp()
	and	not exists (	SELECT	1
				from	tre_agenda c
				where	c.nr_sequencia = a.nr_seq_agenda
				and	(c.dt_cancelamento IS NOT NULL AND c.dt_cancelamento::text <> ''))
	and	not exists (	select	1
				from	tre_inscrito_bloqueio d
				where	d.nr_seq_inscrito = b.nr_sequencia
				and	coalesce(dt_fim_bloqueio::text, '') = '');
				
C03 CURSOR FOR
	SELECT  a.nr_sequencia,		
		a.cd_agenda,
		a.dt_agenda
	from	agenda_consulta a,
		agenda b
	where	a.cd_agenda 		= b.cd_agenda
	and	b.cd_estabelecimento	= cd_estabelecimento_p
	and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w			
	and	((a.nr_seq_rp_item_ind IS NOT NULL AND a.nr_seq_rp_item_ind::text <> '') or (a.nr_seq_rp_mod_item IS NOT NULL AND a.nr_seq_rp_mod_item::text <> ''))
	and	a.ie_status_agenda	not in ('E','C','AD')
	and	a.nr_sequencia		<> nr_seq_agenda_p
	and	a.dt_agenda		between trunc(clock_timestamp()) and fim_dia(clock_timestamp())+999
	order by a.dt_agenda, a.nr_seq_hora;
			

BEGIN

ie_utiliza_equipe_w := obter_param_usuario(9091, 40, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_utiliza_equipe_w);

select	max(qt_permitida_falta),
	max(nr_seq_pac_reab_bloqueio),
	max(coalesce(pr_permitido_falta,0)),
	max(ie_status_agenda_susp),
	max(coalesce(ie_falta_consecutiva,'S')),
	max(dt_vigencia_regra_falta)
into STRICT	qt_faltas_perm_w,
	ie_status_bloq_w,
	pr_permitido_falta_w,
	ie_status_agenda_susp_w,
	ie_falta_consecutiva_w,
	dt_vigencia_regra_falta_w
from	rp_parametros
where	cd_estabelecimento = cd_estabelecimento_p;

if (nr_seq_rp_mod_item_p IS NOT NULL AND nr_seq_rp_mod_item_p::text <> '') then -- agenda_consulta -> nr_seq_rp_mod_item -- FK -- rp_pac_modelo_agend_item -> nr_sequencia  ** nr_seq_modelo_pac -- FK -- rp_pac_modelo_agendamento -> nr_sequencia
	
	select	max(nr_seq_pac_reab)
	into STRICT	nr_seq_pac_reab_w
	from	rp_pac_modelo_agend_item a,
		rp_pac_modelo_agendamento b
	where	b.nr_sequencia = a.nr_seq_modelo_pac
	and	a.nr_sequencia = nr_seq_rp_mod_item_p;
	
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END 
	into STRICT	ie_possui_equipe_w
	from	rp_pac_modelo_agend_item a,
		rp_pac_modelo_agendamento b,
		rp_modelo_agendamento c
	where	b.nr_sequencia = a.nr_seq_modelo_pac
	and	a.nr_sequencia = nr_seq_rp_mod_item_p
	and	b.nr_seq_modelo_agendamento = c.nr_sequencia
	and	(c.nr_seq_equipe IS NOT NULL AND c.nr_seq_equipe::text <> '');

elsif (nr_seq_rp_item_ind_p IS NOT NULL AND nr_seq_rp_item_ind_p::text <> '') then -- agenda_consulta -> nr_seq_rp_item_ind -- FK -- rp_pac_agend_individual - > nr_sequencia  **  nr_seq_pac_reab -- FK -- rp_paciente_reabilitacao - > nr_sequencia
		
	select	max(nr_seq_pac_reab)
	into STRICT	nr_seq_pac_reab_w
	from	rp_pac_agend_individual
	where	nr_sequencia = nr_seq_rp_item_ind_p;
end if;

select	max(cd_pessoa_fisica),
	max(dt_desbloqueio),
	max(nr_seq_classif)
into STRICT	cd_pessoa_fisica_w,	
	dt_desbloqueio_w,	
	nr_seq_classif_w	
from	rp_paciente_reabilitacao
where	nr_sequencia = nr_seq_pac_reab_w;

select	max(qt_permitida_falta),
	max(qt_permitida_falta_just),
	coalesce(max(ie_falta_consecutiva),'N'),
	coalesce(max(ie_falta_just_cons),'N'),
	coalesce(max(ie_susp_treinamento),'N')
into STRICT	qt_perm_falta_classif_w,	
	qt_permitida_falta_just_w,	
	ie_falta_consecutiva_classif_w,
	ie_falta_just_cons_classif_w,
	ie_susp_treinamento_w
from	rp_classif_paciente 	
where	nr_sequencia = nr_seq_classif_w
and cd_estabelecimento = cd_estabelecimento_p;

if (qt_perm_falta_classif_w IS NOT NULL AND qt_perm_falta_classif_w::text <> '') then
	qt_faltas_perm_w 	:= qt_perm_falta_classif_w;
	ie_falta_consecutiva_w  := ie_falta_consecutiva_classif_w;
end if;

if 	((ie_possui_equipe_w = 'S') or (coalesce(nr_seq_rp_item_ind_p,0) > 0) or (ie_utiliza_equipe_w = 'N')) then
	if (qt_faltas_perm_w IS NOT NULL AND qt_faltas_perm_w::text <> '') and (ie_status_bloq_w IS NOT NULL AND ie_status_bloq_w::text <> '') then

		if (ie_falta_consecutiva_w = 'S') then
			ie_continua_w := 'S';
			open C01;
			loop
			fetch C01 into	
				dt_agenda_w,
				cd_pessoa_fisica_falta_w;
			EXIT WHEN NOT FOUND or ie_continua_w = 'N';  /* apply on C01 */
				begin
				
				if (coalesce(nr_dias_w::text, '') = '') then
					nr_dias_w := 0;
				end if;	
				
				select	count(*)
				into STRICT	qt_valida_falta_w
				from	agenda_consulta a,
					agenda b
				where	a.cd_agenda = b.cd_agenda
				and	b.cd_estabelecimento = cd_estabelecimento_p
				and	a.cd_pessoa_fisica = cd_pessoa_fisica_falta_w
				and	a.dt_agenda between dt_agenda_w and fim_dia(dt_agenda_w)
				and	((a.nr_seq_rp_mod_item IS NOT NULL AND a.nr_seq_rp_mod_item::text <> '') or (a.nr_seq_rp_item_ind IS NOT NULL AND a.nr_seq_rp_item_ind::text <> ''))
				and	a.ie_status_agenda <> 'C'
				and	a.ie_status_agenda <> 'I';				
					
				if (qt_valida_falta_w > 0) then
					nr_dias_w     := 0;
				else
				
					select	count(*)
					into STRICT	qt_valida_falta_w
					from	agenda_consulta a,
						agenda b
					where	a.cd_agenda = b.cd_agenda
					and	b.cd_estabelecimento = cd_estabelecimento_p
					and	a.cd_pessoa_fisica = cd_pessoa_fisica_falta_w
					and	a.dt_agenda between dt_agenda_w and fim_dia(dt_agenda_w)
					and	((a.nr_seq_rp_mod_item IS NOT NULL AND a.nr_seq_rp_mod_item::text <> '') or (a.nr_seq_rp_item_ind IS NOT NULL AND a.nr_seq_rp_item_ind::text <> ''))
					and	a.ie_status_agenda = 'I';
					
					if (qt_valida_falta_w > 0) then
						nr_dias_w := nr_dias_w + 1;
					end if;	
				
				end if;																		
										
				if (nr_dias_w > qt_faltas_perm_w) then
					ie_continua_w := 'N';
				else	
					ie_continua_w := 'S';
				end if;		
					
				ds_log_w := 	substr(	'1 - cd_pessoa_fisica_w= '||cd_pessoa_fisica_w||
						' nr_seq_pac_reab_w= '||nr_seq_pac_reab_w||
						' dt_agenda_w= '||to_char(dt_agenda_w,'dd/mm/yyyy hh24:mi:ss')||
						' qt_faltas_perm_w= '||qt_faltas_perm_w||
						' nr_dias_w= '||nr_dias_w||
						' nr_seq_agenda_p= '||nr_seq_agenda_p||
						' ie_status_agenda_susp_w= '||ie_status_agenda_susp_w||
						' qt_permitida_falta_just_w= '||qt_permitida_falta_just_w||
						' nr_seq_classif_w= '||nr_seq_classif_w||
						' ie_falta_consecutiva_w= '||ie_falta_consecutiva_w||
						' ie_status_bloq_w= '||ie_status_bloq_w||
						' ie_falta_just_cons_classif_w= '||ie_falta_just_cons_classif_w||
						' nr_seq_rp_item_ind_p= '||nr_seq_rp_item_ind_p||
						' nr_seq_rp_mod_item_p= '||nr_seq_rp_mod_item_p||
						' qt_valida_falta_w= '||qt_valida_falta_w,1,1500);
				
					
				end;			
			end loop;
			close C01;

			ds_log_w := 	substr(	'2 - cd_pessoa_fisica_w= '||cd_pessoa_fisica_w||
						' nr_seq_pac_reab_w= '||nr_seq_pac_reab_w||
						' dt_agenda_w= '||dt_agenda_w||
						' qt_faltas_perm_w= '||qt_faltas_perm_w||
						' nr_dias_w= '||nr_dias_w||
						' nr_seq_agenda_p= '||nr_seq_agenda_p||
						' ie_status_agenda_susp_w= '||ie_status_agenda_susp_w||
						' qt_permitida_falta_just_w= '||qt_permitida_falta_just_w||
						' nr_seq_classif_w= '||nr_seq_classif_w||
						' ie_falta_consecutiva_w= '||ie_falta_consecutiva_w||
						' ie_status_bloq_w= '||ie_status_bloq_w||
						' ie_falta_just_cons_classif_w= '||ie_falta_just_cons_classif_w||
						' nr_seq_rp_item_ind_p= '||nr_seq_rp_item_ind_p||
						' nr_seq_rp_mod_item_p= '||nr_seq_rp_mod_item_p,1,1500);
								
			
			if (nr_dias_w > qt_faltas_perm_w) then
			
				update	rp_paciente_reabilitacao
				set	nr_seq_status	= ie_status_bloq_w,
					dt_atualizacao	= clock_timestamp(),
					nm_usuario	= 'BLOQ.AUTO'
				where	nr_sequencia 	= nr_seq_pac_reab_w;
				
				update	rp_tratamento
				set	nr_seq_status	= ie_status_bloq_w,
					dt_atualizacao	= clock_timestamp(),
					nm_usuario	= 'BLOQ.AUTO'
				where	nr_seq_pac_reav = nr_seq_pac_reab_w
				and	coalesce(dt_fim_tratamento::text, '') = '';

				if (ie_status_agenda_susp_w IS NOT NULL AND ie_status_agenda_susp_w::text <> '') then
				
					open C03;
					loop
					fetch C03 into	
						nr_sequencia_w,
						cd_agenda_w,
						dt_agenda_2_w;
					EXIT WHEN NOT FOUND; /* apply on C03 */
					begin
					
					select	coalesce(max(nr_seq_hora),0) + 1
					into STRICT	nr_seq_hora_w
					from	agenda_consulta
					where	cd_agenda = cd_agenda_w
					and	dt_agenda = dt_agenda_2_w;
				
					update	agenda_consulta
					set	ie_status_agenda 	= ie_status_agenda_susp_w,
						nr_seq_hora		= nr_seq_hora_w
					where	nr_sequencia		= nr_sequencia_w
                    and dt_agenda > clock_timestamp();
					
					end;
					end loop;
					close C03;
					
					if (ie_susp_treinamento_w = 'S') then						
						open C02;
						loop
						fetch C02 into	
							nr_seq_inscrito_w;
						EXIT WHEN NOT FOUND; /* apply on C02 */
							begin
							CALL tre_altera_bloqueio_inscrito(nr_seq_inscrito_w,clock_timestamp(),'B',nm_usuario_p,'N');
							end;
						end loop;
						close C02;						
					end if;
				end if;

			end if;
		
		else
			select	count(distinct trunc(a.dt_agenda))
			into STRICT	qt_faltas_w
			from	agenda_consulta a,
				agenda b
			where	a.cd_agenda = b.cd_agenda
			and	b.cd_estabelecimento = cd_estabelecimento_p
			and	a.cd_pessoa_fisica = cd_pessoa_fisica_w
			and	((a.nr_seq_rp_item_ind = nr_seq_rp_item_ind_p) or (a.nr_seq_rp_mod_item = nr_seq_rp_mod_item_p))
			and	((a.dt_agenda > dt_vigencia_regra_falta_w) or (coalesce(dt_vigencia_regra_falta_w::text, '') = ''))
			and	((a.dt_agenda > dt_desbloqueio_w) or (coalesce(dt_desbloqueio_w::text, '') = ''))
			and	a.ie_status_agenda = 'I';

			ds_log_w := 	substr(	'3 - cd_pessoa_fisica_w= '||cd_pessoa_fisica_w||
						' nr_seq_pac_reab_w= '||nr_seq_pac_reab_w||
						' dt_agenda_w= '||dt_agenda_w||
						' qt_faltas_perm_w= '||qt_faltas_perm_w||
						' qt_faltas_w= '||qt_faltas_w||
						' nr_seq_agenda_p= '||nr_seq_agenda_p||
						' ie_status_agenda_susp_w= '||ie_status_agenda_susp_w||
						' qt_permitida_falta_just_w= '||qt_permitida_falta_just_w||
						' nr_seq_classif_w= '||nr_seq_classif_w||
						' ie_falta_consecutiva_w= '||ie_falta_consecutiva_w||
						' ie_status_bloq_w= '||ie_status_bloq_w||
						' ie_falta_just_cons_classif_w= '||ie_falta_just_cons_classif_w||
						' nr_seq_rp_item_ind_p= '||nr_seq_rp_item_ind_p||
						' nr_seq_rp_mod_item_p= '||nr_seq_rp_mod_item_p,1,1500);
								
			
			if (qt_faltas_w > qt_faltas_perm_w) then
			
				update	rp_paciente_reabilitacao
				set	nr_seq_status	= ie_status_bloq_w,
					dt_atualizacao	= clock_timestamp(),
					nm_usuario	= 'BLOQ.AUTO'
				where	nr_sequencia 	= nr_seq_pac_reab_w;
				
				update	rp_tratamento
				set	nr_seq_status	= ie_status_bloq_w,
					dt_atualizacao	= clock_timestamp(),
					nm_usuario	= 'BLOQ.AUTO'
				where	nr_seq_pac_reav = nr_seq_pac_reab_w
				and	coalesce(dt_fim_tratamento::text, '') = '';
			
				if (ie_status_agenda_susp_w IS NOT NULL AND ie_status_agenda_susp_w::text <> '') then

					open C03;
					loop
					fetch C03 into	
						nr_sequencia_w,
						cd_agenda_w,
						dt_agenda_2_w;
					EXIT WHEN NOT FOUND; /* apply on C03 */
					begin
					
					select	coalesce(max(nr_seq_hora),0) + 1
					into STRICT	nr_seq_hora_w
					from	agenda_consulta
					where	cd_agenda = cd_agenda_w
					and	dt_agenda = dt_agenda_2_w;
				
					update	agenda_consulta
					set	ie_status_agenda 	= ie_status_agenda_susp_w,
						nr_seq_hora		= nr_seq_hora_w
					where	nr_sequencia		= nr_sequencia_w
                    and dt_agenda > clock_timestamp();
					
					end;
					end loop;
					close C03;
					
					if (ie_susp_treinamento_w = 'S') then						
						open C02;
						loop
						fetch C02 into	
							nr_seq_inscrito_w;
						EXIT WHEN NOT FOUND; /* apply on C02 */
							begin
							CALL tre_altera_bloqueio_inscrito(nr_seq_inscrito_w,clock_timestamp(),'B',nm_usuario_p,'N');
							end;
						end loop;
						close C02;						
					end if;
				end if;
			
			end if;
		
		end if;
		
	end if;
	
	ds_log_w := 	substr(	'4 - cd_pessoa_fisica_w= '||cd_pessoa_fisica_w||
				' nr_seq_pac_reab_w= '||nr_seq_pac_reab_w||
				' dt_agenda_w= '||dt_agenda_w||
				' qt_faltas_perm_w= '||qt_faltas_perm_w||
				' qt_faltas_w= '||qt_faltas_w||
				' nr_seq_agenda_p= '||nr_seq_agenda_p||
				' ie_status_agenda_susp_w= '||ie_status_agenda_susp_w||
				' qt_permitida_falta_just_w= '||qt_permitida_falta_just_w||
				' nr_seq_classif_w= '||nr_seq_classif_w||
				' ie_falta_consecutiva_w= '||ie_falta_consecutiva_w||
				' ie_status_bloq_w= '||ie_status_bloq_w||
				' ie_falta_just_cons_classif_w= '||ie_falta_just_cons_classif_w||
				' nr_seq_rp_item_ind_p= '||nr_seq_rp_item_ind_p||
				' nr_seq_rp_mod_item_p= '||nr_seq_rp_mod_item_p,1,1500);
					
	
	if (qt_permitida_falta_just_w IS NOT NULL AND qt_permitida_falta_just_w::text <> '') and (ie_status_bloq_w IS NOT NULL AND ie_status_bloq_w::text <> '') then
		if (ie_falta_just_cons_classif_w = 'S') then
			ie_continua_w := 'S';
			nr_dias_w := 0;
			open C01;
			loop
			fetch C01 into	
				dt_agenda_w,
				cd_pessoa_fisica_falta_w;
			EXIT WHEN NOT FOUND or ie_continua_w = 'N';  /* apply on C01 */
				begin

				if (coalesce(nr_dias_w::text, '') = '') then
					nr_dias_w := 0;
				end if;	
				
				select	count(*)
				into STRICT	qt_valida_falta_w
				from	agenda_consulta a,
					agenda b
				where	a.cd_agenda = b.cd_agenda
				and	b.cd_estabelecimento = cd_estabelecimento_p
				and	a.cd_pessoa_fisica = cd_pessoa_fisica_falta_w
				and	a.dt_agenda between dt_agenda_w and fim_dia(dt_agenda_w)
				and	((a.nr_seq_rp_mod_item IS NOT NULL AND a.nr_seq_rp_mod_item::text <> '') or (a.nr_seq_rp_item_ind IS NOT NULL AND a.nr_seq_rp_item_ind::text <> ''))
				and	a.ie_status_agenda <> 'C'
				and	a.ie_status_agenda <> 'F';
					
				if (qt_valida_falta_w > 0) then
					nr_dias_w     := 0;
				else
				
					select	count(*)
					into STRICT	qt_valida_falta_w
					from	agenda_consulta a,
						agenda b
					where	a.cd_agenda = b.cd_agenda
					and	b.cd_estabelecimento = cd_estabelecimento_p
					and	a.cd_pessoa_fisica = cd_pessoa_fisica_falta_w
					and	a.dt_agenda between dt_agenda_w and fim_dia(dt_agenda_w)
					and	((a.nr_seq_rp_mod_item IS NOT NULL AND a.nr_seq_rp_mod_item::text <> '') or (a.nr_seq_rp_item_ind IS NOT NULL AND a.nr_seq_rp_item_ind::text <> ''))
					and	a.ie_status_agenda = 'F';
					
					if (qt_valida_falta_w > 0) then
						nr_dias_w := nr_dias_w + 1;
					end if;	
				
				end if;																		
										
				if (nr_dias_w > qt_permitida_falta_just_w) then
					ie_continua_w := 'N';
				else	
					ie_continua_w := 'S';
				end if;		
							
				end;			
			end loop;
			close C01;

			ds_log_w := 	substr(	'5 - cd_pessoa_fisica_w= '||cd_pessoa_fisica_w||
						' nr_seq_pac_reab_w= '||nr_seq_pac_reab_w||
						' dt_agenda_w= '||dt_agenda_w||
						' qt_faltas_perm_w= '||qt_faltas_perm_w||
						' nr_dias_w= '||nr_dias_w||
						' nr_seq_agenda_p= '||nr_seq_agenda_p||
						' ie_status_agenda_susp_w= '||ie_status_agenda_susp_w||
						' qt_permitida_falta_just_w= '||qt_permitida_falta_just_w||
						' nr_seq_classif_w= '||nr_seq_classif_w||
						' ie_falta_consecutiva_w= '||ie_falta_consecutiva_w||
						' ie_status_bloq_w= '||ie_status_bloq_w||
						' ie_falta_just_cons_classif_w= '||ie_falta_just_cons_classif_w||
						' nr_seq_rp_item_ind_p= '||nr_seq_rp_item_ind_p||
						' nr_seq_rp_mod_item_p= '||nr_seq_rp_mod_item_p,1,1500);
					
			
			if (nr_dias_w > qt_permitida_falta_just_w) then

				update	rp_paciente_reabilitacao
				set	nr_seq_status	= ie_status_bloq_w,
					dt_atualizacao	= clock_timestamp(),
					nm_usuario	= 'BLOQ.AUTO'
				where	nr_sequencia 	= nr_seq_pac_reab_w;
				
				update	rp_tratamento
				set	nr_seq_status	= ie_status_bloq_w,
					dt_atualizacao	= clock_timestamp(),
					nm_usuario	= 'BLOQ.AUTO'
				where	nr_seq_pac_reav = nr_seq_pac_reab_w
				and	coalesce(dt_fim_tratamento::text, '') = '';

				if (ie_status_agenda_susp_w IS NOT NULL AND ie_status_agenda_susp_w::text <> '') then
				
					open C03;
					loop
					fetch C03 into	
						nr_sequencia_w,
						cd_agenda_w,
						dt_agenda_2_w;
					EXIT WHEN NOT FOUND; /* apply on C03 */
					begin
					
					select	coalesce(max(nr_seq_hora),0) + 1
					into STRICT	nr_seq_hora_w
					from	agenda_consulta
					where	cd_agenda = cd_agenda_w
					and	dt_agenda = dt_agenda_2_w;
				
					update	agenda_consulta
					set	ie_status_agenda 	= ie_status_agenda_susp_w,
						nr_seq_hora		= nr_seq_hora_w
					where	nr_sequencia		= nr_sequencia_w
                    and dt_agenda > clock_timestamp();
					
					end;
					end loop;
					close C03;
					
					
					if (ie_susp_treinamento_w = 'S') then						
						open C02;
						loop
						fetch C02 into	
							nr_seq_inscrito_w;
						EXIT WHEN NOT FOUND; /* apply on C02 */
							begin
							CALL tre_altera_bloqueio_inscrito(nr_seq_inscrito_w,clock_timestamp(),'B',nm_usuario_p,'N');
							end;
						end loop;
						close C02;						
					end if;
		
				end if;

			end if;
		else
			select	count(distinct trunc(a.dt_agenda))
			into STRICT	nr_dias_w
			from	agenda_consulta a,
				agenda b
			where	a.cd_agenda = b.cd_agenda
			and	b.cd_estabelecimento = cd_estabelecimento_p
			and	a.cd_pessoa_fisica = cd_pessoa_fisica_w
			and	((a.nr_seq_rp_mod_item IS NOT NULL AND a.nr_seq_rp_mod_item::text <> '') or (a.nr_seq_rp_item_ind IS NOT NULL AND a.nr_seq_rp_item_ind::text <> ''))	
			and	a.ie_status_agenda = 'F'
			and	((a.dt_agenda > dt_vigencia_regra_falta_w) or (coalesce(dt_vigencia_regra_falta_w::text, '') = ''))
			and	((a.dt_agenda > dt_desbloqueio_w) or (coalesce(dt_desbloqueio_w::text, '') = ''));
			
			ds_log_w := 	substr(	'6 - cd_pessoa_fisica_w= '||cd_pessoa_fisica_w||
						' nr_seq_pac_reab_w= '||nr_seq_pac_reab_w||
						' dt_agenda_w= '||dt_agenda_w||
						' qt_faltas_perm_w= '||qt_faltas_perm_w||
						' nr_dias_w= '||nr_dias_w||
						' nr_seq_agenda_p= '||nr_seq_agenda_p||
						' ie_status_agenda_susp_w= '||ie_status_agenda_susp_w||
						' qt_permitida_falta_just_w= '||qt_permitida_falta_just_w||
						' nr_seq_classif_w= '||nr_seq_classif_w||
						' ie_falta_consecutiva_w= '||ie_falta_consecutiva_w||
						' ie_status_bloq_w= '||ie_status_bloq_w||
						' ie_falta_just_cons_classif_w= '||ie_falta_just_cons_classif_w||
						' nr_seq_rp_item_ind_p= '||nr_seq_rp_item_ind_p||
						' nr_seq_rp_mod_item_p= '||nr_seq_rp_mod_item_p,1,1500);
					
			
			if (nr_dias_w > qt_permitida_falta_just_w) then

				update	rp_paciente_reabilitacao
				set	nr_seq_status	= ie_status_bloq_w,
					dt_atualizacao	= clock_timestamp(),
					nm_usuario	= 'BLOQ.AUTO'
				where	nr_sequencia 	= nr_seq_pac_reab_w;
				
				update	rp_tratamento
				set	nr_seq_status	= ie_status_bloq_w,
					dt_atualizacao	= clock_timestamp(),
					nm_usuario	= 'BLOQ.AUTO'
				where	nr_seq_pac_reav = nr_seq_pac_reab_w
				and	coalesce(dt_fim_tratamento::text, '') = '';

				if (ie_status_agenda_susp_w IS NOT NULL AND ie_status_agenda_susp_w::text <> '') then
				
					open C03;
					loop
					fetch C03 into	
						nr_sequencia_w,
						cd_agenda_w,
						dt_agenda_2_w;
					EXIT WHEN NOT FOUND; /* apply on C03 */
					begin
					
					select	coalesce(max(nr_seq_hora),0) + 1
					into STRICT	nr_seq_hora_w
					from	agenda_consulta
					where	cd_agenda = cd_agenda_w
					and	dt_agenda = dt_agenda_2_w;
				
					update	agenda_consulta
					set	ie_status_agenda 	= ie_status_agenda_susp_w,
						nr_seq_hora		= nr_seq_hora_w
					where	nr_sequencia		= nr_sequencia_w
                    and dt_agenda > clock_timestamp();
					
					end;
					end loop;
					close C03;
					
					if (ie_susp_treinamento_w = 'S') then						
						open C02;
						loop
						fetch C02 into	
							nr_seq_inscrito_w;
						EXIT WHEN NOT FOUND; /* apply on C02 */
							begin
							CALL tre_altera_bloqueio_inscrito(nr_seq_inscrito_w,clock_timestamp(),'B',nm_usuario_p,'N');
							end;
						end loop;
						close C02;						
					end if;
		
				end if;

			end if;
		end if;
		
		
	end if;	
	
	ds_log_w := 	substr(	'7 - cd_pessoa_fisica_w= '||cd_pessoa_fisica_w||
				' nr_seq_pac_reab_w= '||nr_seq_pac_reab_w||
				' dt_agenda_w= '||dt_agenda_w||
				' qt_faltas_perm_w= '||qt_faltas_perm_w||
				' pr_falta_w= '||pr_falta_w||
				' nr_seq_agenda_p= '||nr_seq_agenda_p||
				' ie_status_agenda_susp_w= '||ie_status_agenda_susp_w||
				' qt_permitida_falta_just_w= '||qt_permitida_falta_just_w||
				' nr_seq_classif_w= '||nr_seq_classif_w||
				' ie_falta_consecutiva_w= '||ie_falta_consecutiva_w||
				' ie_status_bloq_w= '||ie_status_bloq_w||
				' ie_falta_just_cons_classif_w= '||ie_falta_just_cons_classif_w||
				' nr_seq_rp_item_ind_p= '||nr_seq_rp_item_ind_p||
				' nr_seq_rp_mod_item_p= '||nr_seq_rp_mod_item_p||
				' pr_permitido_falta_w= '||pr_permitido_falta_w,1,1500);
			

	if (pr_permitido_falta_w > 0) and (ie_status_bloq_w IS NOT NULL AND ie_status_bloq_w::text <> '') then
		
		select	count(*)
		into STRICT	qt_agendamentos_w
		from	agenda_consulta a,
			agenda b
		where	a.cd_agenda = b.cd_agenda
		and	b.cd_estabelecimento = cd_estabelecimento_p
		and	a.cd_pessoa_fisica = cd_pessoa_fisica_w
		and	((a.nr_seq_rp_mod_item IS NOT NULL AND a.nr_seq_rp_mod_item::text <> '') or (a.nr_seq_rp_item_ind IS NOT NULL AND a.nr_seq_rp_item_ind::text <> ''));
		
		select	count(*)
		into STRICT	qt_agend_falta_w
		from	agenda_consulta a,
			agenda b
		where	a.cd_agenda = b.cd_agenda
		and	b.cd_estabelecimento = cd_estabelecimento_p
		and	a.cd_pessoa_fisica = cd_pessoa_fisica_w
		and	((a.nr_seq_rp_mod_item IS NOT NULL AND a.nr_seq_rp_mod_item::text <> '') or (a.nr_seq_rp_item_ind IS NOT NULL AND a.nr_seq_rp_item_ind::text <> ''))
		and	a.ie_status_agenda = 'I';
			
		pr_falta_w	:= round((dividir(qt_agend_falta_w,qt_agendamentos_w) * 100),2);
			
		ds_log_w := 	substr(	'8 - cd_pessoa_fisica_w= '||cd_pessoa_fisica_w||
					' nr_seq_pac_reab_w= '||nr_seq_pac_reab_w||
					' dt_agenda_w= '||dt_agenda_w||
					' qt_faltas_perm_w= '||qt_faltas_perm_w||
					' pr_falta_w= '||pr_falta_w||
					' nr_seq_agenda_p= '||nr_seq_agenda_p||
					' ie_status_agenda_susp_w= '||ie_status_agenda_susp_w||
					' qt_permitida_falta_just_w= '||qt_permitida_falta_just_w||
					' nr_seq_classif_w= '||nr_seq_classif_w||
					' ie_falta_consecutiva_w= '||ie_falta_consecutiva_w||
					' ie_status_bloq_w= '||ie_status_bloq_w||
					' ie_falta_just_cons_classif_w= '||ie_falta_just_cons_classif_w||
					' nr_seq_rp_item_ind_p= '||nr_seq_rp_item_ind_p||
					' nr_seq_rp_mod_item_p= '||nr_seq_rp_mod_item_p||
					' pr_permitido_falta_w= '||pr_permitido_falta_w,1,1500);
		
		
		if (pr_falta_w > pr_permitido_falta_w) then

			update	rp_paciente_reabilitacao
			set	nr_seq_status	= ie_status_bloq_w,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= 'BLOQ.AUTO'
			where	nr_sequencia 	= nr_seq_pac_reab_w;
			
			update	rp_tratamento
			set	nr_seq_status	= ie_status_bloq_w,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= 'BLOQ.AUTO'
			where	nr_seq_pac_reav = nr_seq_pac_reab_w
			and	coalesce(dt_fim_tratamento::text, '') = '';       		

			if (ie_status_agenda_susp_w IS NOT NULL AND ie_status_agenda_susp_w::text <> '') then						
				
				open C03;
				loop
				fetch C03 into	
					nr_sequencia_w,
					cd_agenda_w,
					dt_agenda_2_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */
				begin
					
				select	coalesce(max(nr_seq_hora),0) + 1
				into STRICT	nr_seq_hora_w
				from	agenda_consulta
				where	cd_agenda = cd_agenda_w
				and	dt_agenda = dt_agenda_2_w;
				
				update	agenda_consulta
				set	ie_status_agenda 	= ie_status_agenda_susp_w,
					nr_seq_hora		= nr_seq_hora_w
				where	nr_sequencia		= nr_sequencia_w
                and dt_agenda > clock_timestamp();
					
				end;
				end loop;
				close C03;
				
				if (ie_susp_treinamento_w = 'S') then						
					open C02;
					loop
					fetch C02 into	
						nr_seq_inscrito_w;
					EXIT WHEN NOT FOUND; /* apply on C02 */
						begin
						CALL tre_altera_bloqueio_inscrito(nr_seq_inscrito_w,clock_timestamp(),'B',nm_usuario_p,'N');
						end;
					end loop;
					close C02;						
				end if;
	
			end if;
			
		end if;

	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rp_consistir_falta_agend (nr_seq_rp_mod_item_p text, nr_seq_rp_item_ind_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_agenda_p bigint default 0) FROM PUBLIC;
