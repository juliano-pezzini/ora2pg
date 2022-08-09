-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_exec_agenda ( cd_agenda_p bigint, nr_atendimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text ) AS $body$
DECLARE



ie_exige_lib_evol_w		varchar(5);
ie_evolucao_w		varchar(1);
ie_diagnostico_w		varchar(1);
ds_erro_w		varchar(2000)	:= '';
qt_registro_w		bigint;
cd_estabelecimento_w	smallint;
cd_tipo_agenda_w		bigint;
ie_tipo_atendimento_w	smallint;
cd_setor_atendimento_w	integer;
cd_perfil_w          perfil.cd_perfil%type;

c01 CURSOR FOR
	SELECT	coalesce(ie_evolucao,'N'),
		coalesce(ie_diagnostico,'N')
	from	consistencia_exec_agenda
	where	cd_estabelecimento		= cd_estabelecimento_w
	and	cd_tipo_agenda		= cd_tipo_agenda_w
	and	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w) = ie_tipo_atendimento_w
	and	coalesce(cd_setor_atendimento, cd_setor_atendimento_w) = cd_setor_atendimento_w
	and	coalesce(cd_perfil, cd_perfil_w)		= cd_perfil_w
	order by	coalesce(ie_tipo_atendimento,0),
		coalesce(cd_setor_atendimento,0),
		coalesce(cd_perfil,0);


BEGIN

cd_perfil_w 	:= obter_perfil_ativo;

select	cd_tipo_agenda,
	cd_estabelecimento
into STRICT	cd_tipo_agenda_w,
	cd_estabelecimento_w
from	agenda
where	cd_agenda	=	cd_agenda_p;

/* OS 96572 - Jerusa em 16/06/2008 */

select	coalesce(obter_Tipo_Atendimento(nr_atendimento_p),0),
	coalesce(Obter_Setor_Atendimento(nr_atendimento_p),0)
into STRICT	ie_tipo_atendimento_w,
	cd_setor_atendimento_w
;

ie_exige_lib_evol_w := obter_param_usuario(0, 37, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_exige_lib_evol_w);

open c01;
loop
fetch c01 into
	ie_evolucao_w,
	ie_diagnostico_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_evolucao_w	:= ie_evolucao_w;
	ie_diagnostico_w	:= ie_diagnostico_w;
	end;
end loop;
close c01;

if	(ie_evolucao_w = 'S' AND ie_exige_lib_evol_w = 'S') then
	select	count(*)
	into STRICT	qt_registro_w
	from	evolucao_paciente
	where	nr_atendimento	=	nr_atendimento_p
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
	
	if (qt_registro_w = 0) then	
		ds_erro_w := ds_erro_w || WHEB_MENSAGEM_PCK.get_texto(277763,null) || chr(13);
	end if;
elsif	(ie_evolucao_w = 'S' AND ie_exige_lib_evol_w = 'N') then
	select	count(*)
	into STRICT	qt_registro_w
	from	evolucao_paciente
	where	nr_atendimento	=	nr_atendimento_p;

	if (qt_registro_w = 0) then	
		ds_erro_w := ds_erro_w || WHEB_MENSAGEM_PCK.get_texto(277764,null) || chr(13);
	end if;
end if;

if (ie_diagnostico_w = 'S') then
	select	count(*)
	into STRICT	qt_registro_w
	from	diagnostico_medico 
	where	nr_atendimento = nr_atendimento_p;

	if (qt_registro_w = 0) then	
		ds_erro_w := ds_erro_w || WHEB_MENSAGEM_PCK.get_texto(277766,null) || chr(13);
	end if;
end if;

ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_exec_agenda ( cd_agenda_p bigint, nr_atendimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text ) FROM PUBLIC;
