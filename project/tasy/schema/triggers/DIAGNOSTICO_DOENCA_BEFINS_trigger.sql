-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS diagnostico_doenca_befins ON diagnostico_doenca CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_diagnostico_doenca_befins() RETURNS trigger AS $BODY$
declare

ie_sexo_pf_w		varchar(1);
ie_sexo_cid_w		varchar(1);
ie_exige_lado_w		varchar(10);
ie_GeraAtualDescCirurgia_w	varchar(1):='N';
qt_dialise_w		bigint;
qt_pac_dialise_w	bigint;
cd_pessoa_fisica_w	varchar(10);
nr_seq_home_care_w	bigint;
ie_possui_home_care_w	varchar(1);

cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
ie_gerar_proc_cih_w	varchar(2);
cd_cid_primario_w 	varchar(10);
nr_sequencia_w		integer;
nr_seq_atepacu_w		bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	paciente_home_care a
	where	a.nr_atendimento_origem = NEW.nr_atendimento
	and not exists (SELECT	1
			from	paciente_hc_doenca b
			where	b.nr_seq_paciente = a.nr_sequencia
			and	b.cd_doenca_cid = NEW.cd_doenca)
	order by 1;
BEGIN
  BEGIN

ie_GeraAtualDescCirurgia_w := Obter_Param_Usuario(872, 192, obter_perfil_ativo, NEW.nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_GeraAtualDescCirurgia_w);
ie_gerar_proc_cih_w := Obter_Param_Usuario(916, 938, obter_perfil_ativo, NEW.nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_gerar_proc_cih_w);
CALL consistir_diagnostico_atend(NEW.cd_doenca,NEW.nr_atendimento);

/* obter sexo cid */


/*
select	nvl(ie_sexo,'A')
into	ie_sexo_cid_w
from	cid_doenca
where	cd_doenca_cid = :new.cd_doenca;
*/


/* obter sexo pf */


/*
select	nvl(obter_sexo_pf(obter_pessoa_atendimento(:new.nr_atendimento,'C'),'C'),'I')
into	ie_sexo_pf_w
from	dual;
*/


/* consistir sexo cid x pf */


/*
if	(ie_sexo_cid_w <> 'A') and
	(ie_sexo_pf_w <> 'I') and
	(ie_sexo_cid_w <> ie_sexo_pf_w) then
	O sexo do cid e o sexo do paciente sao incompativeis, favor verificar!');
end if;
*/

select	max(ie_exige_lado)
into STRICT	ie_exige_lado_w
from	cid_doenca
where	cd_doenca_cid = NEW.cd_doenca;
if (ie_exige_lado_w	= 'S') and (NEW.ie_lado is null) then
	--'Este CID exige a informacao do Lado. #@#@');

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(198329);
end if;

if (NEW.nr_seq_interno is null) then
	select	nextval('diagnostico_doenca_seq')
	into STRICT	NEW.nr_seq_interno
	;
end if;

select	count(*)
into STRICT	qt_dialise_w
from	HD_DIAG_DIALISE_PADRAO
where	cd_doenca_cid	= NEW.cd_doenca;

if (qt_dialise_w > 0) then

	select 	cd_pessoa_fisica
	into STRICT	cd_pessoa_fisica_w
	from	atendimento_paciente
	where	nr_atendimento = NEW.nr_Atendimento;

	select 	count(*)
	into STRICT	qt_pac_dialise_w
	from	hd_pac_renal_cronico
	where	cd_pessoa_fisica = cd_pessoa_fisica_w;

	if (qt_pac_dialise_w > 0) then
	
		insert into HD_DIAGNOSTICO_DIALISE(	NR_SEQUENCIA,
							DT_ATUALIZACAO,
							NM_USUARIO,
							DT_ATUALIZACAO_NREC,
							NM_USUARIO_NREC,
							CD_PESSOA_FISICA,
							cd_doenca
							)
					values (nextval('hd_diagnostico_dialise_seq'),
						LOCALTIMESTAMP,
						NEW.nm_usuario,
						LOCALTIMESTAMP,
						NEW.nm_usuario,
						cd_pessoa_fisica_w,
						NEW.cd_doenca);
	
	end if;
	
	
end if;

if (Obter_Funcao_Ativa = 872) and (ie_GeraAtualDescCirurgia_w = 'S') then
	CALL gera_atualiz_cirur_descricao(NEW.nr_cirurgia,NEW.nr_seq_pepo,NEW.cd_doenca,obter_perfil_ativo,Obter_Pessoa_Fisica_Usuario(NEW.nm_usuario,'C'),NEW.nm_usuario);
end if;	

BEGIN
select	'S'
into STRICT	ie_possui_home_care_w
from	paciente_home_care a
where	a.nr_atendimento_origem = NEW.nr_atendimento
and not exists (SELECT	1
		from	paciente_hc_doenca b
		where	b.nr_seq_paciente = a.nr_sequencia
		and	b.cd_doenca_cid = NEW.cd_doenca)  LIMIT 1;
exception
when others then
	ie_possui_home_care_w := 'N';
end;

if (ie_possui_home_care_w = 'S') then
	open C01;
	loop
	fetch C01 into	
		nr_seq_home_care_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		BEGIN
		
		insert into paciente_hc_doenca(	
			nr_sequencia,
			nr_seq_paciente,
			dt_atualizacao,
			nm_usuario,
			cd_doenca_cid,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
		values (	nextval('paciente_hc_doenca_seq'),
			nr_seq_home_care_w,
			LOCALTIMESTAMP,
			NEW.nm_usuario,
			NEW.cd_doenca,
			LOCALTIMESTAMP,
			NEW.nm_usuario);
		
		end;
	end loop;
	close C01;
end if;

if (ie_gerar_proc_cih_w = 'S') then
	
	BEGIN
	
	select 	coalesce(max(b.cd_procedimento),0),
		coalesce(max(b.ie_origem_proced),0)	
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w
	from 	cid_doenca a,
		sus_procedimento_cid b
	where 	a.cd_doenca_cid = b.cd_doenca_cid
	and	a.cd_doenca_cid	= NEW.cd_doenca;
	
	if (cd_procedimento_w = 0) and (ie_origem_proced_w = 0) then
		
		select 	coalesce(max(b.cd_procedimento),0),
			coalesce(max(b.ie_origem_proced),0)	
		into STRICT	cd_procedimento_w,
			ie_origem_proced_w
		from 	cid_doenca a,
			procedimento b
		where 	a.cd_doenca_cid = b.cd_doenca_cid
		and	a.cd_doenca_cid	= NEW.cd_doenca;	
		
	end if;
		
	if (cd_procedimento_w > 0)  and (ie_origem_proced_w > 0) then
		
		insert into PROCEDIMENTO_PACIENTE_CIH(	
			nr_sequencia,
			NR_ATENDIMENTO,
			dt_atualizacao,
			nm_usuario,
			CD_CID_PRIMARIO,
			CD_PROCEDIMENTO,
			IE_ORIGEM_PROCED)
		values (	1,
			NEW.NR_ATENDIMENTO,
			LOCALTIMESTAMP,
			NEW.nm_usuario,
			NEW.cd_doenca,
			cd_procedimento_w,
			ie_origem_proced_w);		
		
	end if;
	
	exception
	when others then
		ie_gerar_proc_cih_w := 'N';		
	end;
end if;

if (ie_gerar_proc_cih_w = 'C') then	
	BEGIN

	select	coalesce(max(a.nr_sequencia),0),
			coalesce(max(a.cd_cid_primario),''),
			coalesce(max(a.cd_procedimento),0)
	into STRICT
		nr_sequencia_w,
		cd_cid_primario_w,
		cd_procedimento_w
	from 	procedimento_paciente_cih a
	where a.nr_atendimento = NEW.NR_ATENDIMENTO;
		
	if (cd_cid_primario_w <> '') or (cd_procedimento_w <> 0)	then
	
		Update 	procedimento_paciente_cih
		set 	cd_cid_primario = NEW.cd_doenca
		where 	nr_atendimento = NEW.NR_ATENDIMENTO
		and 	nr_sequencia = nr_sequencia_w;
		
	else
		
		insert into PROCEDIMENTO_PACIENTE_CIH(	
			nr_sequencia,
			NR_ATENDIMENTO,
			dt_atualizacao,
			nm_usuario,
			CD_CID_PRIMARIO)
		values (	1,
			NEW.NR_ATENDIMENTO,
			LOCALTIMESTAMP,
			NEW.nm_usuario,
			NEW.cd_doenca);
		
	end if;
	
	exception
	when others then
		ie_gerar_proc_cih_w := 'N';		
	end;
		
end if;

if (NEW.nr_seq_atepacu is null) then
	BEGIN
	
	BEGIN
	select	coalesce(max(nr_seq_interno),0)
	into STRICT	nr_seq_atepacu_w
	from 	atend_paciente_unidade a
	where	a.nr_atendimento 		= NEW.nr_atendimento
	  and 	coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	=
		(SELECT max(coalesce(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
		from atend_paciente_unidade b
		where b.nr_atendimento 	= NEW.nr_atendimento);
		
	if (nr_seq_atepacu_w > 0) then
		NEW.nr_seq_atepacu := nr_seq_atepacu_w;
	end if;
	
	exception when others then
		nr_seq_atepacu_w	:= null;
	end;
	
	end;
end if;

if (coalesce(pkg_i18n.get_user_locale, 'pt_BR')= 'ja_JP') and (coalesce(NEW.cd_setor_atendimento,0) = 0) then	
	NEW.cd_setor_atendimento := wheb_usuario_pck.get_cd_setor_atendimento;	
end if;	

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_diagnostico_doenca_befins() FROM PUBLIC;

CREATE TRIGGER diagnostico_doenca_befins
	BEFORE INSERT ON diagnostico_doenca FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_diagnostico_doenca_befins();
