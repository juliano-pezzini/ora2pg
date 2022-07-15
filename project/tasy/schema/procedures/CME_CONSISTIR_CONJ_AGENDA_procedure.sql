-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_consistir_conj_agenda ( nr_seq_agenda_p bigint, nr_seq_conjunto_p bigint, ie_novo_registro_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, nr_seq_origem_p bigint default null) AS $body$
DECLARE


ie_consiste_w		varchar(15);
qt_novo_registro_w		integer;
qt_agenda_per_w		bigint;
qt_tempo_esterilizacao_w	bigint	:= 0;
dt_inicial_w		timestamp;
dt_final_w			timestamp;
qt_conj_agenda_w		bigint;
nr_seq_agenda_w		agenda_pac_cme.nr_seq_agenda%type;
ds_conjunto_w		varchar(100);
ds_agenda_w			varchar(50);
dt_agenda_w			timestamp;
nm_paciente_w		varchar(60);
qt_equipamento_w		bigint;
nm_medico_w			varchar(50);
qt_consiste_agenda_w		bigint;

qt_conj_agenda_exec_w		bigint;
nr_seq_agenda_exec_w		bigint;
qt_agenda_per_exec_w		bigint;
qt_tempo_esterelizacao_w	bigint;
ds_erro_w			varchar(4000);


BEGIN

ie_consiste_w := Obter_Param_Usuario(871, 101, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_w);

select	coalesce(max(qt_consiste_agenda), 0)
into STRICT	qt_consiste_agenda_w
from	cm_conjunto
where	nr_sequencia		= nr_seq_conjunto_p;

qt_novo_registro_w	:= 0;
if (ie_novo_registro_p = 'S') then
	qt_novo_registro_w := 1;
end if;

select	coalesce(max(qt_tempo_esterelizacao),0)
into STRICT	qt_tempo_esterilizacao_w
from	cm_conjunto
where	nr_sequencia = nr_seq_conjunto_p;

select	hr_inicio,
	CASE WHEN ie_status_agenda='E' THEN  (hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400))  ELSE (hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400)) END
into STRICT	dt_inicial_w,
	dt_final_w
from	agenda_paciente
where	nr_sequencia	= nr_seq_agenda_p;

/* Obter qtde de agendamentos que foram executadas no periodo - neste so e contado o tempo de esterilizacao e nao considera mais o tempo de duracao pois o mesmo ja foi realizado */

select 	count(*)
into STRICT	qt_conj_agenda_exec_w
from	agenda_pac_cme a,
	agenda_paciente b
where	b.nr_sequencia = a.nr_seq_agenda 
and	((hr_inicio between dt_inicial_w and dt_final_w) or  
	(hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400) between dt_inicial_w and dt_final_w) or
	((hr_inicio < dt_inicial_w) and (hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400) > dt_final_w)))
and	a.nr_seq_conjunto = nr_seq_conjunto_p
and	b.ie_status_agenda = 'E'
and	a.ie_origem_inf = 'I'
and	b.nr_sequencia <> coalesce(nr_seq_origem_p,nr_seq_agenda_p);
		
/* Obter qtde de agendamentos que nao foram executados e/ou cancelados no periodo */
		
select 	count(*)
into STRICT	qt_conj_agenda_w
from	agenda_pac_cme a,
	agenda_paciente b
where	b.nr_sequencia = a.nr_seq_agenda 
and	((hr_inicio between dt_inicial_w and dt_final_w) or  
	(hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400) between dt_inicial_w and dt_final_w) or
	((hr_inicio < dt_inicial_w) and (hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400) > dt_final_w)))
and	a.nr_seq_conjunto = nr_seq_conjunto_p
and	b.ie_status_agenda not in ('C','E')
and	a.ie_origem_inf = 'I'
and	b.nr_sequencia <> coalesce(nr_seq_origem_p,nr_seq_agenda_p);

/* Somado todos os agendamentos */

qt_conj_agenda_w	:= qt_conj_agenda_exec_w + qt_conj_agenda_w + qt_novo_registro_w;

if (qt_conj_agenda_w > 0) then
	begin
	/* Obter o ultimo agendamento executado - Obter o ultimo agendamento desconsiderando os executados e os cancelados */

	select	max(nr_seq_agenda),
		max(qt_agenda_per)
	into STRICT	nr_seq_agenda_w,
		qt_agenda_per_w
	from	(SELECT	coalesce(max(b.nr_sequencia),0) nr_seq_agenda,
			count(*) qt_agenda_per
		from	agenda_pac_cme a,
			agenda_paciente b
		where	b.nr_sequencia = a.nr_seq_agenda 
		and	((hr_inicio between dt_inicial_w and dt_final_w) or  
			(hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400) between dt_inicial_w and dt_final_w) or
			((hr_inicio < dt_inicial_w) and (hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400) > dt_final_w)))
		and	a.nr_seq_conjunto = nr_seq_conjunto_p
		and	b.ie_status_agenda = 'E'
		and	a.ie_origem_inf = 'I'
		and	b.nr_sequencia <> coalesce(nr_seq_origem_p,nr_seq_agenda_p)
		
union

		SELECT	coalesce(max(b.nr_sequencia),0),
			count(*)
		from	agenda_pac_cme a,
			agenda_paciente b 
		where	b.nr_sequencia = a.nr_seq_agenda 
		and	((hr_inicio between dt_inicial_w and dt_final_w) or  
			(hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400) between dt_inicial_w and dt_final_w) or
			((hr_inicio < dt_inicial_w) and (hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400) > dt_final_w)))
		and	a.nr_seq_conjunto = nr_seq_conjunto_p
		and	b.ie_status_agenda not in ('C','E')
		and	a.ie_origem_inf = 'I'
		and	b.nr_sequencia <> coalesce(nr_seq_origem_p,nr_seq_agenda_p)) alias36;
	
	if (nr_seq_agenda_w > 0) and (qt_agenda_per_w >= qt_consiste_agenda_w) then
		begin
		select	substr(cme_obter_nome_conjunto(nr_seq_conjunto_p),1,100),
			hr_inicio,
			substr(obter_nome_agenda(cd_agenda),1,50),
			substr(nm_paciente,1,60),
			substr(obter_nome_pf(cd_medico),1,50),
			substr(cm_obter_dados_conjunto(nr_seq_conjunto_p,'T'),1,10)
		into STRICT	ds_conjunto_w,
			dt_agenda_w,
			ds_agenda_w,
			nm_paciente_w,
			nm_medico_w,
			qt_tempo_esterelizacao_w
		from	agenda_paciente
		where	nr_sequencia	= nr_seq_agenda_w;		
		
		ds_erro_w :=	substr(wheb_mensagem_pck.get_texto(278852, 'DS_CONJUNTO_P=' || ds_conjunto_w ||
									';NM_PACIENTE_P=' || nm_paciente_w ||
									';DT_AGENDA_P=' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_agenda_w, 'short', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
									';DS_AGENDA_P=' || ds_agenda_w ||
									';NM_CIRURGIA_P=' || nm_medico_w ||
									';QT_TEMPO_ESTERILIZACAO_P=' || qt_tempo_esterelizacao_w),1,4000);
						
		if	((ie_consiste_w = 'S') or (ie_consiste_w = 'A')) then
			insert into agenda_pac_hist(
				nr_sequencia,
				nr_seq_agenda,          
				ds_historico,           
				dt_atualizacao,         
				nm_usuario,             
				dt_historico,           
				cd_pessoa_fisica,       
				dt_atualizacao_nrec,    
				nm_usuario_nrec)
			values (
				nextval('agenda_pac_hist_seq'),
				nr_seq_agenda_p,
				wheb_mensagem_pck.get_texto(278854) || ds_erro_w,
				clock_timestamp(),
				'Tasy',
				clock_timestamp(),
				Obter_Dados_Usuario_Opcao(nm_usuario_p,'C'),
				clock_timestamp(),
				'Tasy');
			commit;
		end if;	
		
		ds_erro_p :=	substr(ds_erro_w,1,255);
		
		end;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_consistir_conj_agenda ( nr_seq_agenda_p bigint, nr_seq_conjunto_p bigint, ie_novo_registro_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, nr_seq_origem_p bigint default null) FROM PUBLIC;

