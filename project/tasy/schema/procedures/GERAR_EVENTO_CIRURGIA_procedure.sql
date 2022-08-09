-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_cirurgia ( cd_profissional_p text, dt_evento_p timestamp, nr_cirurgia_p bigint, nr_seq_evento_p bigint, cd_local_estoque_p bigint, ds_observacao_p text, nm_usuario_p text, nr_sequencia_p INOUT bigint, nr_seq_pepo_p bigint, dt_inicio_evento_p timestamp default null) AS $body$
DECLARE


ie_finaliza_cirurgia_w	varchar(1);
ie_lanc_automatico_w	varchar(1);
dt_inicio_real_w	timestamp;
qt_mintuos_w		bigint;
ie_evento_painel_w	varchar(15);
nr_sequencia_w		bigint;
nr_sequencia_ev_w	bigint := 0;
nr_seq_evento_dep_w	bigint;
dt_registro_w		timestamp;
nr_prescricao_w		bigint;
nr_prescr_mat_esp_w	bigint;
ie_trocar_sala_w		varchar(1);
nr_seq_interno_w	bigint := null;
nr_cirurgia_w		bigint;
nr_cirurgia_ww		bigint;
ie_permite_registrar_w	smallint;
nr_atendimento_w	bigint;
nr_atendimento_ww	bigint;
qt_proc_hemot_w		bigint;
ie_gerar_proc_hemo_w	varchar(1);
ie_momento_integracao_w	varchar(15);
ie_inicia_integracao_w	varchar(1);
ie_finaliza_integracao_w varchar(1);
cd_setor_atendimento_w		integer;
ie_gera_mat_autorizacao_w	varchar(1);
nr_seq_agenda_w			agenda_paciente.nr_cirurgia%type;
nr_seq_proc_interno_w		bigint; --Alteracoes feitas pelo Fabricio Theiss conforem historico do dia 02/12/15 da OS 823663
cd_perfil_w             perfil.cd_perfil%type   := wheb_usuario_pck.get_cd_perfil;
nm_usuario_w            usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;
cd_estabelecimento_w    estabelecimento.cd_estabelecimento%type:= wheb_usuario_pck.get_cd_estabelecimento;
nr_seq_evento_eritel_w  bigint;
cd_unidade_basica_w  atend_paciente_unidade.cd_unidade_basica%type;
cd_unidade_compl_w   atend_paciente_unidade.cd_unidade_compl%type;
ie_alter_status_leito_w varchar(1);
qt_existe_regra_setor_w	integer;

c01 CURSOR FOR
	SELECT	nr_cirurgia
	from	cirurgia
	where	nr_seq_pepo = nr_seq_pepo_p;
	
c02 CURSOR FOR
	SELECT	a.nr_sequencia
	from	prescr_material a
	where	a.nr_prescricao 	= nr_prescricao_w
	and	a.qt_material 		> 0
	and	not exists (SELECT 1 from material_autorizado b where a.nr_prescricao = b.nr_prescricao and a.nr_sequencia = b.nr_seq_prescricao);
	
c03 CURSOR FOR
	SELECT	a.nr_prescricao,
		b.nr_sequencia
	from	prescr_medica a,
		prescr_material b
	where	a.nr_prescricao = b.nr_prescricao
	and	a.nr_cirurgia 	= nr_cirurgia_p
	and 	coalesce(a.ie_tipo_prescr_cirur,0) <> 2
	and	b.qt_material 	> 0
	and	not exists (SELECT 1 from material_autorizado c where b.nr_prescricao = c.nr_prescricao and b.nr_sequencia = c.nr_seq_prescricao)
	order by 1;
	
c04 CURSOR FOR  --Alteracoes feitas pelo Fabricio Theiss conforem historico do dia 02/12/15 da OS 823663
	SELECT	b.nr_sequencia,
		b.nr_seq_proc_interno
	from	prescr_procedimento b
	where	b.nr_prescricao = nr_prescricao_w
	and	not exists (SELECT 1 from procedimento_autorizado c where b.nr_prescricao = c.nr_prescricao and b.nr_sequencia = c.nr_seq_prescricao)
	order by 1;
	
				

BEGIN

nr_seq_evento_eritel_w := obter_param_usuario(872, 534, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, nr_seq_evento_eritel_w);

select	coalesce(max(ie_finaliza_cirurgia),'N'),
	coalesce(max(ie_lanc_automatico),'N'),
	coalesce(max(ie_trocar_sala),'N'),
	coalesce(max(ie_gerar_proc_hemo),'N'),
	coalesce(max(ie_inicia_integracao),'N'),
	coalesce(max(ie_finaliza_integracao),'N'),
	coalesce(max(ie_gera_mat_autorizacao),'N'),
	coalesce(max(ie_alter_status_leito),'N')
into STRICT	ie_finaliza_cirurgia_w,
	ie_lanc_automatico_w,
	ie_trocar_sala_w,
	ie_gerar_proc_hemo_w,
	ie_inicia_integracao_w,
	ie_finaliza_integracao_w,
	ie_gera_mat_autorizacao_w,
	ie_alter_status_leito_w
from	evento_cirurgia
where	nr_sequencia = nr_seq_evento_p;

select	coalesce(max(ie_momento_integracao),'IF')
into STRICT	ie_momento_integracao_w
from	parametros_pepo
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

if (ie_finaliza_cirurgia_w = 'S') then
	select	max(dt_inicio_real)
	into STRICT	dt_inicio_real_w
	from	cirurgia
	where	nr_cirurgia = nr_cirurgia_p;		
	
	select	obter_minutos_espera(dt_inicio_real_w, dt_evento_p)
	into STRICT	qt_mintuos_w
	;
	if (nr_cirurgia_p > 0) then
		CALL finalizar_cirurgia(nr_cirurgia_p, dt_evento_p, qt_mintuos_w, nm_usuario_p);
	end if;
end if;

select	max(nr_prescricao),
		max(nr_atendimento)
into STRICT	nr_prescricao_w,
		nr_atendimento_w
from	cirurgia
where	nr_cirurgia = nr_cirurgia_p;

if (ie_lanc_automatico_w = 'S') then
	CALL gerar_lanc_automatico(nr_cirurgia_p, nr_prescricao_w, cd_local_estoque_p, nm_usuario_p);
end if;

---Teste
select	max(nr_seq_evento_dep)
into STRICT	nr_seq_evento_dep_w
from	evento_cirurgia
where	nr_sequencia = nr_seq_evento_p;

if (nr_seq_evento_dep_w IS NOT NULL AND nr_seq_evento_dep_w::text <> '')	then

	select  max(dt_registro)
	into STRICT	dt_registro_w
	from	evento_cirurgia_paciente
	where	nr_cirurgia = nr_cirurgia_p
	and 	coalesce(ie_situacao,'A') = 'A'
	and	nr_seq_evento = nr_seq_evento_dep_w;	
		
	if (dt_registro_w IS NOT NULL AND dt_registro_w::text <> '')	and (dt_evento_p < dt_registro_w)	then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(189748,'DS_EVENTO_CIRURGIA_W='||to_char(obter_desc_evento_cirurgia(nr_seq_evento_dep_w)));
	
	end if;
end if;

---Fim Teste
select	nextval('evento_cirurgia_paciente_seq')
into STRICT	nr_sequencia_ev_w
;

if (ie_trocar_sala_w = 'S') and (nr_cirurgia_p > 0) then
	nr_seq_interno_w := obter_unidade_cirurgia(nr_cirurgia_p);
	if (nr_seq_interno_w = 0) then
		nr_seq_interno_w := null;
	end if;
end if;

ie_permite_registrar_w := 0;

SELECT	COUNT(*)
INTO STRICT	ie_permite_registrar_w
FROM  	evento_cirurgia_paciente a
WHERE	a.nr_cirurgia 		= nr_cirurgia_p	
AND	a.nr_seq_evento  	= nr_seq_evento_p		
AND	dt_registro		= dt_evento_p
and	coalesce(a.ie_situacao,'A')	= 'A';

if (ie_permite_registrar_w = 0) then
		SELECT	COUNT(*)
		INTO STRICT	ie_permite_registrar_w
		FROM  	evento_cirurgia_paciente a
		WHERE	a.nr_seq_pepo 		= nr_seq_pepo_p	
		AND	a.nr_seq_evento  	= nr_seq_evento_p		
		AND	dt_registro		= dt_evento_p
		and	coalesce(a.ie_situacao,'A')	= 'A';
		
end if;

/*insert into logx_tasy values(sysdate,nm_usuario_p,68955,'Procedure = gerar_evento_cirurgia; Sequencia = '||nr_sequencia_ev_w||' Evento = '||nr_seq_evento_p||' Cirurgia = '||nr_cirurgia_p||'  Numero do processo ='||nr_seq_pepo_p||' data do evento = '||dt_evento_p); */

if (ie_permite_registrar_w = 0) then

	insert into evento_cirurgia_paciente(
		nr_sequencia,
		nr_seq_evento,
		nr_cirurgia,            
		ds_observacao,          
		dt_registro,            
		cd_profissional,        
		dt_atualizacao,         
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_pepo,
		nr_seq_interno,
		ie_situacao,
		dt_inicio_evento)
	values (
		nr_sequencia_ev_w,
		nr_seq_evento_p,
		CASE WHEN nr_cirurgia_p=0 THEN null  ELSE nr_cirurgia_p END ,
		ds_observacao_p,
		dt_evento_p,
		cd_profissional_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		CASE WHEN nr_seq_pepo_p=0 THEN null  ELSE nr_seq_pepo_p END ,
		nr_seq_interno_w,
		'A',
		dt_inicio_evento_p);
	commit;

	nr_sequencia_p	:=	nr_sequencia_ev_w;
	
	nr_atendimento_ww	:= 0;
	nr_cirurgia_ww 		:= 0;
	
	if (coalesce(nr_atendimento_w,0) = 0) and (coalesce(nr_seq_pepo_p,0) > 0)  then
		
		select	coalesce(max(nr_cirurgia_principal),0)
		into STRICT	nr_cirurgia_ww
		from	pepo_cirurgia
		where	nr_sequencia = nr_seq_pepo_p;

		if (coalesce(nr_cirurgia_ww,0) = 0) then
			select	coalesce(max(nr_cirurgia),0)
			into STRICT	nr_cirurgia_ww
			from	cirurgia
			where	nr_seq_pepo = nr_seq_pepo_p;
		end if;
		
		select	coalesce(max(nr_atendimento),0)
		into STRICT	nr_atendimento_ww
		from	cirurgia
		where	nr_cirurgia = nr_cirurgia_p;

	end if;
	
	if (coalesce(nr_atendimento_ww,0) = 0) then
				
		select	coalesce(max(nr_atendimento),0)
		into STRICT	nr_atendimento_ww
		from 	pepo_cirurgia
		where	nr_sequencia = nr_seq_pepo_p;	
	end if;
	
	if ((coalesce(nr_atendimento_w,nr_atendimento_ww) IS NOT NULL AND (coalesce(nr_atendimento_w,nr_atendimento_ww))::text <> '')) then
		CALL gerar_hig_leito_cc(clock_timestamp(), nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, 'EC', null, coalesce(nr_atendimento_w,nr_atendimento_ww) , null,nr_seq_evento_p, ie_alter_status_leito_w);
	end if;
end if;

if (ie_permite_registrar_w > 0 and ie_finaliza_cirurgia_w = 'S' and coalesce(nr_sequencia_p::text, '') = '') then
	SELECT
		  max(a.nr_sequencia)
	INTO STRICT  
		  nr_sequencia_p
	FROM  
		  evento_cirurgia_paciente a,
		  evento_cirurgia b
	WHERE
		  a.nr_seq_evento   				= b.nr_sequencia
	AND   a.nr_cirurgia 					= nr_cirurgia_p	
	AND	  a.nr_seq_evento  					= nr_seq_evento_p		
	AND	  a.dt_registro		  				= dt_evento_p
	AND   coalesce(b.ie_finaliza_cirurgia,'N') 	= 'S'
	AND	  coalesce(a.ie_situacao,'A')			= 'A';
end if;

if (coalesce(nr_seq_evento_eritel_w,0) > 0) and (nr_seq_evento_eritel_w = nr_seq_evento_p) then
   begin
   if (coalesce(nr_cirurgia_p,0) > 0) then
      select   max(a.cd_setor_atendimento),
               max(a.cd_unidade_basica),
               max(a.cd_unidade_compl),
               max(a.nr_seq_interno),
               max(a.nr_atendimento)
      into STRICT     cd_setor_atendimento_w,
               cd_unidade_basica_w,
               cd_unidade_compl_w,
               nr_seq_interno_w,
               nr_atendimento_w
      from     atend_paciente_unidade a,
               cirurgia b
      where    a.NR_ATENDIMENTO     = b.NR_ATENDIMENTO
      and      a.DT_ENTRADA_UNIDADE = b.DT_ENTRADA_UNIDADE
      and      b.nr_cirurgia        = nr_cirurgia_p;
   elsif (coalesce(nr_seq_pepo_p,0) > 0) then
      select   max(a.cd_setor_atendimento),
               max(a.cd_unidade_basica),
               max(a.cd_unidade_compl),
               max(a.nr_seq_interno),
               max(a.nr_atendimento)
      into STRICT     cd_setor_atendimento_w,
               cd_unidade_basica_w,
               cd_unidade_compl_w,
               nr_seq_interno_w,
               nr_atendimento_w
      from     atend_paciente_unidade a,
               cirurgia b
      where    a.NR_ATENDIMENTO     = b.NR_ATENDIMENTO
      and      a.DT_ENTRADA_UNIDADE = b.DT_ENTRADA_UNIDADE
      and      b.nr_seq_pepo        = nr_seq_pepo_p;
   end if;
   if (nr_seq_interno_w IS NOT NULL AND nr_seq_interno_w::text <> '') then
      CALL insere_w_integracao_eritel(cd_setor_atendimento_w,cd_unidade_basica_w,cd_unidade_compl_w,nr_atendimento_w,'N',nm_usuario_w,cd_estabelecimento_w);
      commit;
   end if;
   exception
   when others then
      null;
   end;
end if;


if (ie_momento_integracao_w = 'TM') then

	select	max(nr_atendimento),
		coalesce(max(obter_unid_setor_cirurgia(nr_cirurgia_p,'NI')),0)
	into STRICT	nr_atendimento_w,
		nr_seq_interno_w
	from 	cirurgia
	where   nr_cirurgia = nr_cirurgia_p;
	
	select	max(cd_setor_atendimento)
	into STRICT	cd_setor_atendimento_w
	from	atend_paciente_unidade
	where	nr_seq_interno = nr_seq_interno_w
	and		coalesce(dt_saida_unidade::text, '') = '';

	if (ie_inicia_integracao_w = 'S') and (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') and (coalesce(cd_setor_atendimento_w,0) > 0) and (nr_seq_interno_w > 0) then
		CALL gerar_cirurgia_hl7(nr_atendimento_w,nr_seq_interno_w,cd_setor_atendimento_w,'I');	
	end if;
	
	if (ie_finaliza_integracao_w = 'S') and (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') and (coalesce(cd_setor_atendimento_w,0) > 0) and (nr_seq_interno_w > 0) then
		CALL gerar_cirurgia_hl7(nr_atendimento_w,nr_seq_interno_w,cd_setor_atendimento_w,'F');	
	end if;
	
end if;

select	ie_evento_painel
into STRICT	ie_evento_painel_w
from	evento_cirurgia
where	nr_sequencia	=	nr_seq_evento_p;	

if (ie_evento_painel_w IS NOT NULL AND ie_evento_painel_w::text <> '') then
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_sequencia_w
	from	agenda_paciente
	where	nr_cirurgia	=	nr_cirurgia_p;
	
	if (nr_sequencia_w > 0) then
		CALL gerar_dados_painel_cirurgia(ie_evento_painel_w, nr_sequencia_w, 'P', nm_usuario_p);
	end if;	
	
	if (nr_seq_pepo_p IS NOT NULL AND nr_seq_pepo_p::text <> '') and (coalesce(nr_cirurgia_p::text, '') = '') then
		open c01;
		loop
		fetch c01 into	
			nr_cirurgia_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_sequencia_w
			from	agenda_paciente
			where	nr_cirurgia = nr_cirurgia_w;
			if (nr_sequencia_w > 0) then
				CALL gerar_dados_painel_cirurgia(ie_evento_painel_w, nr_sequencia_w, 'P', nm_usuario_p);
			end if;	
			end;
		end loop;
		close c01;
	end if;
end if;

if (ie_gerar_proc_hemo_w = 'S') then
	CALL hem_gerar_dados_cirurgia(nr_cirurgia_p, nm_usuario_p);
end if;

if (nr_cirurgia_p > 0) and (nr_seq_evento_p > 0) then
	CALL exec_regra_fim_evento(nr_cirurgia_p, nr_seq_evento_p, nm_usuario_p);
end if;

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_agenda_w
from	agenda_paciente
where	nr_cirurgia = nr_cirurgia_p;


if (ie_gera_mat_autorizacao_w = 'S') then
	--Materiais e medicamentos previstos
	open C02;
	loop
	fetch C02 into	
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (nr_seq_agenda_w > 0) then
			CALL gerar_autor_regra(null, null, null,  nr_prescricao_w,  nr_sequencia_w,  null, 'RTM',  nm_usuario_p,nr_seq_agenda_w,  null,  null,  null, null, null,  '', '',  '');	
		else	
			CALL gerar_autor_regra(nr_atendimento_w, null, null,  nr_prescricao_w,  nr_sequencia_w,  null, 'RTM',  nm_usuario_p,null,  null,  null,  null, null, null,  '', '',  '');	
		end if;	
		end;
	end loop;
	close C02;
		
	open C03;
	loop
	fetch C03 into	
		nr_prescr_mat_esp_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		--Materiais especiais
		if (nr_seq_agenda_w > 0) then
			CALL gerar_autor_regra(null, null, null,  nr_prescr_mat_esp_w,  nr_sequencia_w,  null, 'RTM',  nm_usuario_p,  nr_seq_agenda_w,  null,  null,  null, null, null,  '', '',  '');
		else
			CALL gerar_autor_regra(nr_atendimento_w, null, null,  nr_prescr_mat_esp_w,  nr_sequencia_w,  null, 'RTM',  nm_usuario_p,  null,  null,  null,  null, null, null,  '', '',  '');
		end if;	
		end;
	end loop;
	close C03;
	
	open C04;
	loop
	fetch C04 into	--Alteracoes feitas pelo Fabricio Theiss conforem historico do dia 02/12/15 da OS 823663
		nr_sequencia_w,
		nr_seq_proc_interno_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		--Procedimentos adicionais previstos

		--if	(nr_seq_agenda_w > 0) then

		--	gerar_autor_regra(null, null, null,  nr_prescricao_w,  null,nr_sequencia_w, 'RTM',  nm_usuario_p,  nr_seq_agenda_w,  null,  null,  null, null, null,  '', '',  '');

		--else
		if (nr_atendimento_w > 0) then
			CALL gerar_autor_regra(nr_atendimento_w, null, null,  nr_prescricao_w,  null,  nr_sequencia_w, 'RTM',  nm_usuario_p,  null,  nr_seq_proc_interno_w,  null,  null, null, null,  '', '',  '');
		end if;	
		end;
	end loop;
	close C04;
end if;


begin
select	1
into STRICT	qt_existe_regra_setor_w
from	dis_regra_setor
where	cd_setor_atendimento = cd_setor_atendimento_w  LIMIT 1;
exception
when others then
	qt_existe_regra_setor_w := 0;
end;

if (qt_existe_regra_setor_w > 0) and (ie_finaliza_cirurgia_w = 'S') then
	CALL intdisp_gerar_movimento(nr_atendimento_w, 'EPD', cd_setor_atendimento_w, nr_cirurgia_p);
end if;	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_cirurgia ( cd_profissional_p text, dt_evento_p timestamp, nr_cirurgia_p bigint, nr_seq_evento_p bigint, cd_local_estoque_p bigint, ds_observacao_p text, nm_usuario_p text, nr_sequencia_p INOUT bigint, nr_seq_pepo_p bigint, dt_inicio_evento_p timestamp default null) FROM PUBLIC;
