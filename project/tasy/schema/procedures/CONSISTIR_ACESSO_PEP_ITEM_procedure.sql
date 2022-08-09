-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_acesso_pep_item ( cd_estabelecimento_p bigint, nr_atendimento_p bigint, cd_paciente_p text, cd_pessoa_fisica_p text, nm_usuario_p text, dt_logon_p timestamp, nr_seq_item_pront_p bigint, nr_seq_item_oft_p bigint, ie_permite_p INOUT text, nr_seq_mensagem_p INOUT bigint) AS $body$
DECLARE


qt_restricao_w			bigint;
qt_restricao_ww		bigint;
qt_medico_w				bigint;
nr_seq_perfil_pac_w	bigint;
nr_seq_perfil_usu_w	bigint;
ie_acesso_w				varchar(3);
ds_mensagem_w			varchar(255);
nr_atendimento_w		bigint;
cd_enfermeiro_w		varchar(10);
cd_medico_resp_w		varchar(10);
nr_seq_mensagem_w		bigint;

nr_seq_msg_auditor_w				bigint;
nr_seq_auditoria_w				bigint;
ie_paciente_alta_w				varchar(3);
cd_setor_atendimento_w			bigint;
IE_CONSISTE_JUSTIFICATIVA_w	varchar(10);
cd_setor_internacao_w			bigint;
qt_reg_w								bigint;
ie_med_pac_agenda_w				varchar(5);
ie_conta_protocolo_w	pep_acesso_auditoria_item.ie_conta_protocolo%type;
ie_conta_definitiva_w	pep_acesso_auditoria_item.ie_conta_definitiva%type;
cd_convenio_w		pep_acesso_auditoria_item.cd_convenio%type;
qt_soma_w		bigint;
qt_restr_conta_prot_w	bigint;
qt_restr_conta_def_w	bigint;
nr_sequencia_w		pep_acesso_auditoria_item.nr_sequencia%type;
ie_libera_acesso_w	varchar(1);

C01 CURSOR FOR
	SELECT	a.ie_acesso,
		a.nr_seq_mensagem,
		coalesce(a.IE_CONSISTE_JUSTIFICATIVA,'P')
	from	pep_lib_acesso a
	where (coalesce(a.cd_estabelecimento::text, '') = '' or a.cd_estabelecimento	= cd_estabelecimento_p)
	and	a.nr_seq_perfil_pac			= nr_seq_perfil_pac_w
	and	a.nr_seq_perfil_usuario		= nr_seq_perfil_usu_w
	and (coalesce(a.ie_situacao_paciente, 'A') = 'A' or coalesce(a.ie_situacao_paciente, 'A') = ie_paciente_alta_w)
	and	((coalesce(a.IE_REGRA_SETOR,'A')	= 'A') 	or
		(a.IE_REGRA_SETOR = 'N' and  	((obter_se_setor_usuario(cd_setor_atendimento_w,nm_usuario_p)	= 'N') and (obter_se_setor_usuario(cd_setor_internacao_w,nm_usuario_p)	= 'N'))
						) or
		a.IE_REGRA_SETOR = 'S' and 	((obter_se_setor_usuario(cd_setor_atendimento_w,nm_usuario_p)	= 'S') or (obter_se_setor_usuario(cd_setor_internacao_w,nm_usuario_p)	= 'S')))
	and	((coalesce(a.ie_consiste_equipe,'N')	= 'N')	or (Obter_se_pf_equipe_atend(cd_medico_resp_w,cd_pessoa_fisica_p) = 'S'))
	and	((a.NR_SEQ_ITEM_PRONT =	nr_seq_item_pront_p) or (nr_seq_item_oft = nr_seq_item_oft_p))
	and	coalesce(cd_perfil,obter_perfil_ativo) = obter_perfil_ativo
	order by coalesce(a.ie_consiste_equipe,'N'),
		a.ie_acesso,
		a.ie_situacao_paciente;
		
C02 CURSOR FOR
	SELECT	ie_conta_protocolo,
		ie_conta_definitiva,
		cd_convenio
	from	pep_acesso_auditoria_item a
	where	a.nr_seq_auditoria = nr_seq_auditoria_w;
		

		

BEGIN

SELECT	coalesce(MAX(IE_LIBERAR_ACESSOS_PEP),'N')
into STRICT	ie_libera_acesso_w
from	parametro_medico
where	cd_estabelecimento	= wheb_usuario_pck.get_cd_estabelecimento;

if (nr_atendimento_p > 0) then
	
	begin
	
	cd_setor_atendimento_w	:= obter_setor_atendimento(nr_atendimento_p);
	cd_setor_internacao_w	:= obter_unidade_atendimento(nr_atendimento_p,'IA','CS');
	
	select coalesce(max('I'),'S')
	into STRICT	ie_paciente_alta_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_p
	and	coalesce(dt_alta::text, '') = '';
	exception
		when others then
		ie_paciente_alta_w	:= 'S';
		end;
	
	
else
	ie_paciente_alta_w := 'S';
end if;

if (obter_se_paciente_obito(cd_paciente_p)	<> 'N') then
	ie_paciente_alta_w	:= 'O';
end if;


ie_permite_p		:= 'S';
nr_seq_mensagem_p	:= null;
nr_atendimento_w	:= nr_atendimento_p;
qt_soma_w		:= 0;


select	coalesce(max(nr_seq_perfil),0)
into STRICT	nr_seq_perfil_pac_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_paciente_p;
RAISE NOTICE 'ie_permite_p = %', ie_permite_p;
if (nr_seq_perfil_pac_w > 0) then
	--ie_permite_p		:= 'N';
	nr_seq_mensagem_p	:= 0;
	
	if (nr_atendimento_w = 0) then
		select	max(nr_atendimento)
		into STRICT	nr_atendimento_w
		from	atendimento_paciente
		where	cd_pessoa_fisica	= cd_paciente_p;
	end if;

	if (nr_atendimento_w > 0) then
		select	cd_medico_resp,
			substr(Obter_enfermeiro_resp(nr_atendimento,'C'),1,10)
		into STRICT	cd_medico_resp_w,
			cd_enfermeiro_w
		from	atendimento_paciente
		where	nr_atendimento	= nr_atendimento_w;
	end if;
	
	ie_med_pac_agenda_w	:=	obter_se_pac_agenda_acesso_pep(nr_atendimento_p,cd_pessoa_fisica_p,nm_usuario_p,cd_estabelecimento_p);
	
	if (cd_medico_resp_w = cd_pessoa_fisica_p) then
		ie_permite_p		:= 'S';
		nr_seq_mensagem_p	:= null;
	elsif (cd_enfermeiro_w = cd_pessoa_fisica_p) then
		ie_permite_p		:= 'S';
		nr_seq_mensagem_p	:= null;
	elsif (ie_med_pac_agenda_w = 'S') then
		ie_permite_p		:= 'S';
		nr_seq_mensagem_p	:= null;
	else
		RAISE NOTICE ' 2 ie_permite_p = %', ie_permite_p;
		begin
		
		qt_restricao_ww	:= 0;
		qt_restricao_w	:= 0;
		select	count(*)
		into STRICT	qt_reg_w
		from	pep_autor_acesso_atend
		where	nr_atendimento	= nr_atendimento_p;
		
		if (qt_reg_w	= 0) then
		
			select	count(*)
			into STRICT	qt_restricao_w
			from	pep_autor_acesso
			where	cd_paciente			= cd_paciente_p
			and		cd_pessoa_fisica	= cd_pessoa_fisica_p
			and (clock_timestamp()	between	coalesce(dt_inicio,to_date('01/01/1900','dd/mm/yyyy')) and coalesce(dt_fim,to_date('01/01/2900','dd/mm/yyyy')))
			and ((coalesce(ie_libera_acesso_w,'N') = 'N') or((coalesce(ie_libera_acesso_w,'N') = 'S') and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')))
			and coalesce(dt_inativacao::text, '') = '';
		
		else
		
			select	count(*)
			into STRICT	qt_restricao_ww
			from	pep_autor_acesso_atend
			where	nr_atendimento			= nr_atendimento_p
			and		cd_pessoa_fisica	= cd_pessoa_fisica_p
			and (clock_timestamp()	between	coalesce(dt_inicio,to_date('01/01/1900','dd/mm/yyyy')) and coalesce(dt_fim,to_date('01/01/2900','dd/mm/yyyy')))
			and ((coalesce(ie_libera_acesso_w,'N') = 'N') or((coalesce(ie_libera_acesso_w,'N') = 'S') and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')))
			and coalesce(dt_inativacao::text, '') = '';
		
		end if;

		if (qt_restricao_w > 0) or (qt_restricao_ww	> 0)then
			ie_permite_p		:= 'S';
			nr_seq_mensagem_p	:= null;
		else	
			begin
			
			select	coalesce(max(nr_seq_perfil),0)
			into STRICT	nr_seq_perfil_usu_w
			from	USUARIO_ESTABELECIMENTO
			where	nm_usuario	= nm_usuario_p
			and		cd_estabelecimento = cd_estabelecimento_p;
			
			if (nr_seq_perfil_usu_w	= 0) then
			
				select	coalesce(max(nr_seq_perfil),0)
				into STRICT	nr_seq_perfil_usu_w
				from	usuario
				where	nm_usuario	= nm_usuario_p;
			
			end if;
			

			RAISE NOTICE ' 2 ie_permite_p = %', ie_permite_p;
			

			OPEN C01;
			LOOP
			FETCH C01 into
				ie_acesso_w,
				nr_seq_mensagem_w,
				IE_CONSISTE_JUSTIFICATIVA_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
				begin
				if (ie_acesso_w = 'T') then
					ie_permite_p		:= 'S';
					nr_seq_mensagem_p	:= null;
				elsif (ie_acesso_w = 'S') then
					ie_permite_p		:= 'N';
					nr_seq_mensagem_p	:= coalesce(nr_seq_mensagem_w,0);
				elsif (ie_acesso_w = 'A') then
					ie_permite_p		:= 'S';
					nr_seq_mensagem_p	:= nr_seq_mensagem_w;
				elsif (ie_acesso_w = 'L') then
					
					if (IE_CONSISTE_JUSTIFICATIVA_w	= 'P') then
						
						select	count(*)
						into STRICT	qt_restricao_w
						from	pep_acesso p,
							pep_acesso_item i,
							atendimento_paciente a
						where	a.nr_atendimento = p.nr_atendimento
						and	p.nr_sequencia	= i.nr_seq_acesso
						and	((i.nr_seq_item	= nr_seq_item_pront_p)  or (i.nr_seq_item_oft = nr_seq_item_oft_p))
						and	coalesce(a.dt_alta::text, '') = ''
						and	(i.nr_seq_justificativa IS NOT NULL AND i.nr_seq_justificativa::text <> '')
						and	p.nm_usuario = nm_usuario_p
						and	p.cd_pessoa_fisica = cd_paciente_p;
					elsif (IE_CONSISTE_JUSTIFICATIVA_w	= 'L') then
					
						select	count(*)
						into STRICT	qt_restricao_w
						from	pep_acesso p,
							pep_acesso_item i,
							atendimento_paciente a
						where	a.nr_atendimento = p.nr_atendimento
						and	coalesce(a.dt_alta::text, '') = ''
						and	p.nr_sequencia	= i.nr_seq_acesso
						and	((i.nr_seq_item	= nr_seq_item_pront_p)  or (i.nr_seq_item_oft = nr_seq_item_oft_p))
						and	(i.nr_seq_justificativa IS NOT NULL AND i.nr_seq_justificativa::text <> '')
						and	p.nm_usuario = nm_usuario_p
						and	p.cd_pessoa_fisica = cd_paciente_p
						and	p.dt_login	   = dt_logon_p;
					elsif (IE_CONSISTE_JUSTIFICATIVA_w	= 'T') then
						qt_restricao_w	:= 0;
					end if;
					
		
					
					if (qt_restricao_w > 0) then
						ie_permite_p		:= 'S';
						nr_seq_mensagem_p	:= null;
					else
						ie_permite_p		:= 'J';
						nr_seq_mensagem_p	:= nr_seq_mensagem_w;
					end if;
				end if;
				end;
			END LOOP;
			CLOSE C01;
			end;
		end if;
		
		end;
	end if;
end if;
RAISE NOTICE ' 4 ie_permite_p = %', ie_permite_p;


if (ie_permite_p <> 'N') then
			
	begin
	
	select	a.nr_seq_mensagem,
		a.nr_sequencia
	into STRICT	nr_seq_msg_auditor_w,
		nr_seq_auditoria_w
	from	pep_acesso_auditoria a
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_p;
	exception
	when others then
		nr_seq_msg_auditor_w	:= 0;
	end;
	
	if (nr_seq_msg_auditor_w > 0) then	/*	Oraci em 12/07/2008	*/
		
		if (nr_atendimento_p = 0) then
			select	count(*)
			into STRICT	qt_restricao_w
			from	pep_acesso_auditoria_item a
			where	a.nr_seq_auditoria = nr_seq_auditoria_w
			and exists (	SELECT 	1
					from 	atend_categoria_convenio x
					where	x.cd_convenio 		= a.cd_convenio
					and	x.nr_atendimento	= nr_atendimento_w);
					
			select	max(ie_conta_protocolo),
					max(ie_conta_definitiva),
					max(cd_convenio),
					max(nr_sequencia)
			into STRICT	ie_conta_protocolo_w,
				ie_conta_definitiva_w,
				cd_convenio_w,
				nr_sequencia_w
			from	pep_acesso_auditoria_item a
			where	a.nr_seq_auditoria = nr_seq_auditoria_w
			and (exists (	SELECT 	1
					from 	atend_categoria_convenio x
					where	x.cd_convenio 		= a.cd_convenio
					and	x.nr_atendimento	= nr_atendimento_w)
			or a.cd_pessoa_fisica = cd_pessoa_fisica_p);
		else
			select	count(*)
			into STRICT	qt_restricao_w
			from	pep_acesso_auditoria_item a
			where	a.nr_seq_auditoria = nr_seq_auditoria_w
			and exists (	SELECT 	1
					from 	atend_categoria_convenio x
					where	x.cd_convenio 		= a.cd_convenio
					and	x.nr_atendimento	= nr_atendimento_p);
					
			select	max(ie_conta_protocolo),
					max(ie_conta_definitiva),
					max(cd_convenio),
					max(nr_sequencia)
			into STRICT	ie_conta_protocolo_w,
					ie_conta_definitiva_w,
					cd_convenio_w,
					nr_sequencia_w
			from	pep_acesso_auditoria_item a
			where	a.nr_seq_auditoria = nr_seq_auditoria_w
			and (exists (	SELECT 	1
								from 	atend_categoria_convenio x
							where	x.cd_convenio 		= a.cd_convenio
							and	x.nr_atendimento	= nr_atendimento_p) or a.cd_pessoa_fisica = cd_pessoa_fisica_p);
		end if;
		
		if (ie_conta_protocolo_w = 'S') then
			select	count(*)
			into STRICT	qt_restr_conta_prot_w
			from	pep_acesso_auditoria_item a
			where	a.nr_seq_auditoria = nr_seq_auditoria_w
			and	a.nr_sequencia     = nr_sequencia_w
			and	((a.cd_convenio = cd_convenio_w) or (coalesce(cd_convenio_w::text, '') = ''))
			and exists (	SELECT 	1
					from 	conta_paciente x
					where	((x.cd_convenio_parametro = cd_convenio_w) or (coalesce(cd_convenio_w::text, '') = ''))
					and	x.nr_atendimento		= nr_atendimento_w
					and	(x.nr_seq_protocolo IS NOT NULL AND x.nr_seq_protocolo::text <> ''));				
		
		elsif (ie_conta_protocolo_w = 'N') then
			select	count(*)
			into STRICT	qt_restr_conta_prot_w
			from	pep_acesso_auditoria_item a
			where	a.nr_seq_auditoria = nr_seq_auditoria_w
			and	a.nr_sequencia     = nr_sequencia_w
			and	((a.cd_convenio = cd_convenio_w) or (coalesce(cd_convenio_w::text, '') = ''))
			and exists (	SELECT 	1
					from 	conta_paciente x
					where	((x.cd_convenio_parametro = cd_convenio_w) or (coalesce(cd_convenio_w::text, '') = ''))
					and	x.nr_atendimento		= nr_atendimento_w
					and	coalesce(x.nr_seq_protocolo::text, '') = '');
		else
			qt_restr_conta_prot_w := 1;
		end if;
		
		if (ie_conta_definitiva_w = 'S') then
			select	count(*)
			into STRICT	qt_restr_conta_def_w
			from	pep_acesso_auditoria_item a
			where	a.nr_seq_auditoria = nr_seq_auditoria_w
			and	a.nr_sequencia     = nr_sequencia_w
			and	((a.cd_convenio = cd_convenio_w) or (coalesce(cd_convenio_w::text, '') = ''))
			and exists (	SELECT 	1
					from 	conta_paciente x
					where	((x.cd_convenio_parametro = cd_convenio_w) or (coalesce(cd_convenio_w::text, '') = ''))
					and	x.nr_atendimento		= nr_atendimento_w
					and	x.ie_status_acerto = 2);	
		
		elsif (ie_conta_definitiva_w = 'N') then
			select	count(*)
			into STRICT	qt_restr_conta_def_w
			from	pep_acesso_auditoria_item a
			where	a.nr_seq_auditoria = nr_seq_auditoria_w
			and	a.nr_sequencia     = nr_sequencia_w
			and	((a.cd_convenio = cd_convenio_w) or (coalesce(cd_convenio_w::text, '') = ''))
			and exists (	SELECT 	1
					from 	conta_paciente x
					where	((x.cd_convenio_parametro = cd_convenio_w) or (coalesce(cd_convenio_w::text, '') = ''))
					and	x.nr_atendimento		= nr_atendimento_w
					and	x.ie_status_acerto = 1);
		else
			qt_restr_conta_def_w := 1;
		end if;
		
		qt_soma_w := qt_soma_w + qt_restr_conta_prot_w + qt_restr_conta_def_w;
		
		if (qt_restricao_w	= 0) then	
			select	count(*)
			into STRICT	qt_restricao_w
			from	pep_acesso_auditoria_item a
			where	a.nr_seq_auditoria = nr_seq_auditoria_w
			and	a.cd_pessoa_fisica = cd_paciente_p;
		end if;
		
		if (qt_restricao_w = 0) then
			ie_permite_p	:= 'N';
			nr_seq_mensagem_p := nr_seq_msg_auditor_w;
		elsif (qt_restricao_w > 0) and (qt_soma_w < 2) then
			ie_permite_p	:= 'N';
			nr_seq_mensagem_p := nr_seq_msg_auditor_w;
		end if;	
	end if;	
	
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_acesso_pep_item ( cd_estabelecimento_p bigint, nr_atendimento_p bigint, cd_paciente_p text, cd_pessoa_fisica_p text, nm_usuario_p text, dt_logon_p timestamp, nr_seq_item_pront_p bigint, nr_seq_item_oft_p bigint, ie_permite_p INOUT text, nr_seq_mensagem_p INOUT bigint) FROM PUBLIC;
