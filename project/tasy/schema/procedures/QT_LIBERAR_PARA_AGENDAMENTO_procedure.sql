-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_liberar_para_agendamento ( nr_seq_atendimento_p bigint, ie_opcao_p text, ie_lib_desf_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/*
ie_opcao_p

P - Protocolo
C - Ciclo
D - Dia

ie_lib_desf_p

L - Liberar
D - Desfazer liberacao

Protocolo - NR_SEQ_PACIENTE
Ciclo - NR_CICLO
Dia - NR_SEQ_ATENDIMENTO

*/
nr_seq_paciente_w	bigint;
nr_ciclo_w		smallint;
nr_ciclo_ww		smallint;
nr_seq_pend_agenda_w	bigint;
nr_seq_atendimento_w	bigint;
cd_pessoa_fisica_w	varchar(10);
nr_seq_pac_sim_w	bigint;
dt_prev_sim_w		timestamp;
nr_seq_atend_sim_w	bigint;
dt_prevista_w		timestamp;
nr_seq_atend_w		bigint;
ie_liberar_todos_ciclos_w	varchar(1);
ie_adm_hospital_w	varchar(1);
ie_mesma_pend_trat_w	varchar(1);
ie_liberar_agendamento_w	varchar(5);
ie_profissional_w			varchar(15);
nr_seq_ageint_quimio_w		varchar(10);
cd_prof_w					varchar(10);
nr_seq_status_w				varchar(10);
dt_agenda_w					varchar(50);
ie_edicao_w					varchar(1);
dt_agenda_html_w			timestamp;

C01 CURSOR FOR
SELECT	nr_seq_atendimento
from	paciente_atendimento
where	nr_seq_paciente		=	nr_seq_paciente_w
and	nr_ciclo		=	nr_ciclo_w;

C02 CURSOR FOR
	SELECT	distinct nr_ciclo
	from	paciente_atendimento
	where	nr_seq_paciente	=	nr_seq_paciente_w;
					

BEGIN

ie_liberar_todos_ciclos_w := Obter_Param_Usuario(281, 1004, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_liberar_todos_ciclos_w);
ie_mesma_pend_trat_w := Obter_Param_Usuario(281, 1177, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_mesma_pend_trat_w);
ie_liberar_agendamento_w := Obter_Param_Usuario(281, 753, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_liberar_agendamento_w);
ie_adm_hospital_w := Obter_Param_Usuario(865, 75, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_adm_hospital_w);

if (nr_seq_atendimento_p > 0) then
	select	max(b.nr_seq_paciente),
		max(nr_ciclo),
		coalesce(max(nr_seq_pend_agenda),0),
		max(a.cd_pessoa_fisica)
	into STRICT	nr_seq_paciente_w,
		nr_ciclo_w,
		nr_seq_pend_agenda_w,
		cd_pessoa_fisica_w
	from	paciente_setor a,
		paciente_atendimento b
	where	b.nr_seq_atendimento	= nr_seq_atendimento_p
	and	a.nr_seq_paciente	= b.nr_seq_paciente;	
	
	if (nr_seq_pend_agenda_w	= 0) and (ie_mesma_pend_trat_w	= 'S') then
		select	coalesce(max(nr_seq_pend_agenda),0)
		into STRICT	nr_seq_pend_agenda_w
		from	paciente_atendimento
		where	nr_seq_paciente	= nr_seq_paciente_w;
	end if;
	
	if (nr_seq_pend_agenda_w	= 0) then
	
		select	nextval('qt_pendencia_agenda_seq')
		into STRICT	nr_seq_pend_agenda_w
		;
		insert into qt_pendencia_agenda(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_tipo_pendencia,
				cd_estabelecimento)
			values (nr_seq_pend_agenda_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				'Q',
				cd_estabelecimento_p);
	end if;
	
	if (ie_lib_desf_p = 'L') then
	
		if (ie_opcao_p = 'P') then
			if (ie_adm_hospital_w = 'N') then
				update	paciente_atendimento a
                   set	dt_liberacao_atend     	=	clock_timestamp(),
					    nm_usuario_lib_atend	=	nm_usuario_p,
					    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                   where	nr_seq_paciente		=	nr_seq_paciente_w
                   and 	    a.nr_seq_atendimento = (SELECT max(x.nr_seq_atendimento)
								                    from	paciente_atend_medic x
								                    where	x.nr_seq_atendimento = a.nr_seq_atendimento
                                                    and	coalesce(x.ie_local_adm,'C') in ('H','D'));

                   update	paciente_atendimento a
                   set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                   where	nr_seq_paciente		=	nr_seq_paciente_w                  
                   and 	    a.nr_seq_atendimento = (SELECT max(s.nr_seq_atendimento)
								                    from	PACIENTE_ATEND_SOLUC s
								                    where	s.nr_seq_atendimento = a.nr_seq_atendimento
								                    and	coalesce(s.ie_local_adm,'C') in ('H','D'));

                  update	paciente_atendimento a
                  set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                  where	    nr_seq_paciente		=	nr_seq_paciente_w                 
                  and 	a.nr_seq_atendimento = (SELECT max(p.nr_seq_atendimento)
								                from	PACIENTE_ATEND_PROC p
								                where	p.nr_seq_atendimento = a.nr_seq_atendimento
                                                and	coalesce(p.ie_local_adm,'C') in ('H','D'));

                 update	   paciente_atendimento a
                 set	   dt_liberacao_atend     	=	clock_timestamp(),
		                   nm_usuario_lib_atend	=	nm_usuario_p,
		                   nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                 where	nr_seq_paciente		=	nr_seq_paciente_w                 
                 and 	a.nr_seq_atendimento = (SELECT max(r.nr_seq_atendimento)
								                from	PACIENTE_ATEND_REC r
								                where	r.nr_seq_atendimento = a.nr_seq_atendimento
								                and	coalesce(r.ie_local_adm,'C') in ('H','D'));
			else
				    update	paciente_atendimento a
                    set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                    where	nr_seq_paciente		=	nr_seq_paciente_w
                    and 	a.nr_seq_atendimento = (SELECT max(x.nr_seq_atendimento)
								                    from	paciente_atend_medic x
								                    where	x.nr_seq_atendimento = a.nr_seq_atendimento
                                                    and	coalesce(x.ie_local_adm,'C') in ('H','D'));

                   update	paciente_atendimento a
                   set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                   where	nr_seq_paciente		=	nr_seq_paciente_w                  
                   and 	    a.nr_seq_atendimento = (SELECT max(s.nr_seq_atendimento)
								                    from	PACIENTE_ATEND_SOLUC s
								                    where	s.nr_seq_atendimento = a.nr_seq_atendimento
								                    and	coalesce(s.ie_local_adm,'C') in ('H','D'));

                  update	paciente_atendimento a
                  set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                  where	    nr_seq_paciente		=	nr_seq_paciente_w                 
                  and 	    a.nr_seq_atendimento = (SELECT max(p.nr_seq_atendimento)
								                from	PACIENTE_ATEND_PROC p
								                where	p.nr_seq_atendimento = a.nr_seq_atendimento
                                                and	coalesce(p.ie_local_adm,'C') in ('H','D'));

                 update	   paciente_atendimento a
                 set	   dt_liberacao_atend     	=	clock_timestamp(),
		                   nm_usuario_lib_atend	=	nm_usuario_p,
		                   nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                 where	nr_seq_paciente		=	nr_seq_paciente_w                 
                 and 	a.nr_seq_atendimento = (SELECT max(r.nr_seq_atendimento)
								                from	PACIENTE_ATEND_REC r
								                where	r.nr_seq_atendimento = a.nr_seq_atendimento
								                and	coalesce(r.ie_local_adm,'C') in ('H','D'));
			end if;
		elsif (ie_opcao_p = 'C') then
			if (ie_liberar_todos_ciclos_w = 'N') then
				if (ie_adm_hospital_w = 'N') then

					update	paciente_atendimento a
                    set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                    where	nr_seq_paciente		=	nr_seq_paciente_w
                    and		nr_ciclo		=	nr_ciclo_w
                    and 	    a.nr_seq_atendimento = (SELECT max(x.nr_seq_atendimento)
								                    from	paciente_atend_medic x
								                    where	x.nr_seq_atendimento = a.nr_seq_atendimento
                                                    and	coalesce(x.ie_local_adm,'C') in ('H','D'));

                   update	paciente_atendimento a
                   set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                   where	nr_seq_paciente		=	nr_seq_paciente_w
                   and		nr_ciclo		=	nr_ciclo_w
                   and 	    a.nr_seq_atendimento = (SELECT max(s.nr_seq_atendimento)
								                    from	PACIENTE_ATEND_SOLUC s
								                    where	s.nr_seq_atendimento = a.nr_seq_atendimento
								                    and	coalesce(s.ie_local_adm,'C') in ('H','D'));

                  update	paciente_atendimento a
                  set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                  where	   nr_seq_paciente		=	nr_seq_paciente_w
                  and		nr_ciclo		=	nr_ciclo_w
                  and 	a.nr_seq_atendimento = (SELECT max(p.nr_seq_atendimento)
								                from	PACIENTE_ATEND_PROC p
								                where	p.nr_seq_atendimento = a.nr_seq_atendimento
                                                and	coalesce(p.ie_local_adm,'C') in ('H','D'));

                 update	   paciente_atendimento a
                 set	   dt_liberacao_atend     	=	clock_timestamp(),
		                   nm_usuario_lib_atend	=	nm_usuario_p,
		                   nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                 where	nr_seq_paciente		=	nr_seq_paciente_w
                 and		nr_ciclo		=	nr_ciclo_w
                 and 	a.nr_seq_atendimento = (SELECT max(r.nr_seq_atendimento)
								                from	PACIENTE_ATEND_REC r
								                where	r.nr_seq_atendimento = a.nr_seq_atendimento
								                and	coalesce(r.ie_local_adm,'C') in ('H','D'));
				else
					update	paciente_atendimento a
                    set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                    where	nr_seq_paciente		=	nr_seq_paciente_w
                    and		nr_ciclo		=	nr_ciclo_w
                    and 	    a.nr_seq_atendimento = (SELECT max(x.nr_seq_atendimento)
								                    from	paciente_atend_medic x
								                    where	x.nr_seq_atendimento = a.nr_seq_atendimento
                                                    and	coalesce(x.ie_local_adm,'C') in ('H','D'));

                   update	paciente_atendimento a
                   set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                   where	nr_seq_paciente		=	nr_seq_paciente_w
                   and		nr_ciclo		=	nr_ciclo_w
                   and 	    a.nr_seq_atendimento = (SELECT max(s.nr_seq_atendimento)
								                    from	PACIENTE_ATEND_SOLUC s
								                    where	s.nr_seq_atendimento = a.nr_seq_atendimento
								                    and	coalesce(s.ie_local_adm,'C') in ('H','D'));

                  update	paciente_atendimento a
                  set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                  where	   nr_seq_paciente		=	nr_seq_paciente_w
                  and		nr_ciclo		=	nr_ciclo_w
                  and 	a.nr_seq_atendimento = (SELECT max(p.nr_seq_atendimento)
								                from	PACIENTE_ATEND_PROC p
								                where	p.nr_seq_atendimento = a.nr_seq_atendimento
                                                and	coalesce(p.ie_local_adm,'C') in ('H','D'));

                 update	   paciente_atendimento a
                 set	   dt_liberacao_atend     	=	clock_timestamp(),
		                   nm_usuario_lib_atend	=	nm_usuario_p,
		                   nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                 where	nr_seq_paciente		=	nr_seq_paciente_w
                 and		nr_ciclo		=	nr_ciclo_w
                 and 	a.nr_seq_atendimento = (SELECT max(r.nr_seq_atendimento)
								                from	PACIENTE_ATEND_REC r
								                where	r.nr_seq_atendimento = a.nr_seq_atendimento
								                and	coalesce(r.ie_local_adm,'C') in ('H','D'));
					
				end if;
			else
				open C02;
				loop
				fetch C02 into	
					nr_ciclo_ww;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin
					if (ie_adm_hospital_w = 'N') then
						 update	paciente_atendimento a
                         set		dt_liberacao_atend     	=	clock_timestamp(),
		                            nm_usuario_lib_atend	=	nm_usuario_p,
                                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                         where	    nr_seq_paciente		=	nr_seq_paciente_w
                         and	nr_ciclo		=	nr_ciclo_ww
                         and 	    a.nr_seq_atendimento = (SELECT max(x.nr_seq_atendimento)
								                    from	paciente_atend_medic x
								                    where	x.nr_seq_atendimento = a.nr_seq_atendimento
                                                    and	coalesce(x.ie_local_adm,'C') in ('H','D'));

                   update	paciente_atendimento a
                   set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                   where	nr_seq_paciente		=	nr_seq_paciente_w
                   and	nr_ciclo		=	nr_ciclo_ww
                   and 	    a.nr_seq_atendimento = (SELECT max(s.nr_seq_atendimento)
								                    from	PACIENTE_ATEND_SOLUC s
								                    where	s.nr_seq_atendimento = a.nr_seq_atendimento
								                    and	coalesce(s.ie_local_adm,'C') in ('H','D'));

                  update	paciente_atendimento a
                  set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                  where	   nr_seq_paciente		=	nr_seq_paciente_w
                  and	nr_ciclo		=	nr_ciclo_ww
                  and 	a.nr_seq_atendimento = (SELECT max(p.nr_seq_atendimento)
								                from	PACIENTE_ATEND_PROC p
								                where	p.nr_seq_atendimento = a.nr_seq_atendimento
                                                and	coalesce(p.ie_local_adm,'C') in ('H','D'));

                 update	   paciente_atendimento a
                 set	   dt_liberacao_atend     	=	clock_timestamp(),
		                   nm_usuario_lib_atend	=	nm_usuario_p,
		                   nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                 where	nr_seq_paciente		=	nr_seq_paciente_w
                 and	nr_ciclo		=	nr_ciclo_ww
                 and 	a.nr_seq_atendimento = (SELECT max(r.nr_seq_atendimento)
                                                from	PACIENTE_ATEND_REC r
								                where	r.nr_seq_atendimento = a.nr_seq_atendimento
								                and	coalesce(r.ie_local_adm,'C') in ('H','D'));
					else
						update	paciente_atendimento a
                        set		dt_liberacao_atend     	=	clock_timestamp(),
		                        nm_usuario_lib_atend	=	nm_usuario_p,
		                        nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                        where	nr_seq_paciente		=	nr_seq_paciente_w
                        and	nr_ciclo		=	nr_ciclo_ww
                        and 	    a.nr_seq_atendimento = (SELECT max(x.nr_seq_atendimento)
								                    from	paciente_atend_medic x
								                    where	x.nr_seq_atendimento = a.nr_seq_atendimento
                                                    and	coalesce(x.ie_local_adm,'C') in ('H','D'));

                   update	paciente_atendimento a
                   set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                   where	nr_seq_paciente		=	nr_seq_paciente_w
                   and	nr_ciclo		=	nr_ciclo_ww
                   and 	    a.nr_seq_atendimento = (SELECT max(s.nr_seq_atendimento)
								                    from	PACIENTE_ATEND_SOLUC s
								                    where	s.nr_seq_atendimento = a.nr_seq_atendimento
								                    and	coalesce(s.ie_local_adm,'C') in ('H','D'));

                  update	paciente_atendimento a
                  set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                  where	   nr_seq_paciente		=	nr_seq_paciente_w
                  and	nr_ciclo		=	nr_ciclo_ww
                  and 	a.nr_seq_atendimento = (SELECT max(p.nr_seq_atendimento)
								                from	PACIENTE_ATEND_PROC p
								                where	p.nr_seq_atendimento = a.nr_seq_atendimento
                                                and	coalesce(p.ie_local_adm,'C') in ('H','D'));

                 update	   paciente_atendimento a
                 set	   dt_liberacao_atend     	=	clock_timestamp(),
		                   nm_usuario_lib_atend	=	nm_usuario_p,
		                   nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                 where	nr_seq_paciente		=	nr_seq_paciente_w
                 and	nr_ciclo		=	nr_ciclo_ww
                 and 	a.nr_seq_atendimento = (SELECT max(r.nr_seq_atendimento)
								                from	PACIENTE_ATEND_REC r
								                where	r.nr_seq_atendimento = a.nr_seq_atendimento
								                and	coalesce(r.ie_local_adm,'C') in ('H','D'));
					end if;
					end;
				end loop;
				close C02;
			end if;
			/*Open C01;
			Loop
				Fetch C01 into nr_seq_atendimento_w;
				exit when C01%notfound;

				onc_gerar_prescricao_paciente(nr_seq_atendimento_w,nm_usuario_p,1);

			end loop;
			Close C01;*/
		elsif (ie_opcao_p = 'D') then
			update	paciente_atendimento a
            set	    a.dt_liberacao_atend     =	clock_timestamp(),
				    a.nm_usuario_lib_atend	 =	nm_usuario_p,
                    a.nr_seq_pend_agenda	 =	nr_seq_pend_agenda_w
            where	a.nr_seq_atendimento	 =	nr_seq_atendimento_p
            and 	a.nr_seq_atendimento = (SELECT max(x.nr_seq_atendimento)
								            from	paciente_atend_medic x
                                            where	x.nr_seq_atendimento = a.nr_seq_atendimento
                                            and	coalesce(x.ie_local_adm,'C') in ('H','D'));

                   update	paciente_atendimento a
                   set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                   where	a.nr_seq_atendimento	 =	nr_seq_atendimento_p                  
                   and 	    a.nr_seq_atendimento = (SELECT max(s.nr_seq_atendimento)
								                    from	PACIENTE_ATEND_SOLUC s
								                    where	s.nr_seq_atendimento = a.nr_seq_atendimento
								                    and	coalesce(s.ie_local_adm,'C') in ('H','D'));

                  update	paciente_atendimento a
                  set		dt_liberacao_atend     	=	clock_timestamp(),
		                    nm_usuario_lib_atend	=	nm_usuario_p,
		                    nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                  where	a.nr_seq_atendimento	 =	nr_seq_atendimento_p                 
                  and 	    a.nr_seq_atendimento = (SELECT max(p.nr_seq_atendimento)
								                from	PACIENTE_ATEND_PROC p
								                where	p.nr_seq_atendimento = a.nr_seq_atendimento
                                                and	coalesce(p.ie_local_adm,'C') in ('H','D'));

                 update	   paciente_atendimento a
                 set	   dt_liberacao_atend     	=	clock_timestamp(),
		                   nm_usuario_lib_atend	=	nm_usuario_p,
		                   nr_seq_pend_agenda	=	nr_seq_pend_agenda_w
                 where	a.nr_seq_atendimento	 =	nr_seq_atendimento_p                 
                 and 	a.nr_seq_atendimento = (SELECT max(r.nr_seq_atendimento)
								                from	PACIENTE_ATEND_REC r
								                where	r.nr_seq_atendimento = a.nr_seq_atendimento
								                and	coalesce(r.ie_local_adm,'C') in ('H','D'));
		end if;
		
		if (ie_opcao_p	<> 'D') then
			CALL Qt_Atual_Tratamento_Simulacao(nr_seq_atendimento_p, nr_seq_pend_agenda_w, nm_usuario_p, cd_estabelecimento_p);
		end if;

		if (ie_liberar_agendamento_w = 'G') then
			ie_profissional_w := Obter_Profissional_Usuario(nm_usuario_p, ie_opcao_p);
			SELECT * FROM ageint_gerar_agenda_quimio_js(nr_seq_pend_agenda_w, cd_pessoa_fisica_w, ie_profissional_w, nm_usuario_p, cd_estabelecimento_p, nr_seq_ageint_quimio_w, cd_prof_w, nr_seq_status_w, dt_agenda_w, ie_edicao_w, dt_agenda_html_w) INTO STRICT nr_seq_ageint_quimio_w, cd_prof_w, nr_seq_status_w, dt_agenda_w, ie_edicao_w, dt_agenda_html_w;
		end if;
	
	elsif (ie_lib_desf_p = 'D') then
	
		if (ie_opcao_p = 'P') then
			update	paciente_atendimento
			set	dt_liberacao_atend     	 = NULL,
				nm_usuario_lib_atend	 = NULL,
				nr_seq_pend_agenda	 = NULL
			where	nr_seq_paciente		=	nr_seq_paciente_w;
		elsif (ie_opcao_p = 'C') then
			if (ie_liberar_todos_ciclos_w = 'N') then
				update	paciente_atendimento
				set	dt_liberacao_atend     	 = NULL,
					nm_usuario_lib_atend	 = NULL,
					nr_seq_pend_agenda	 = NULL
				where	nr_seq_paciente		=	nr_seq_paciente_w
				and	nr_ciclo		=	nr_ciclo_w;
			else
				open C02;
				loop
				fetch C02 into	
					nr_ciclo_ww;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin
					update	paciente_atendimento
					set	dt_liberacao_atend     	 = NULL,
						nm_usuario_lib_atend	 = NULL,
						nr_seq_pend_agenda	 = NULL
					where	nr_seq_paciente		=	nr_seq_paciente_w
					and	nr_ciclo		=	nr_ciclo_ww;
					end;
				end loop;
				close C02;
			end if;
		elsif (ie_opcao_p = 'D') then
			update	paciente_atendimento
			set	dt_liberacao_atend     	 = NULL,
				nm_usuario_lib_atend	 = NULL,
				nr_seq_pend_agenda	 = NULL
			where	nr_seq_atendimento	=	nr_seq_atendimento_p;
		end if;
	
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_liberar_para_agendamento ( nr_seq_atendimento_p bigint, ie_opcao_p text, ie_lib_desf_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
