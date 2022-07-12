-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prof_agenda_multi ( nr_seq_agenda_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


/* Objetivo: Mostrar o profissional atual do agendamento, quando ainda houve profissional
             para atender o paciente
   Retorno.: P -> Profissional
             O -> Ordem (Única para cada horário)
*/
ie_retorno_w			varchar(80)	:= '';
qt_registro_w			bigint;
qt_nao_finalizado_w		bigint;
nr_seq_ordem_w		bigint;
ie_forma_agenda_w		varchar(15);
ie_tipo_profissional_w	varchar(15);


BEGIN

/* Leitura do parâmetro 25 da agenda de serviços */

ie_forma_agenda_w := obter_param_usuario(866, 25, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_forma_agenda_w);

/* Pega a classe profissional do usuário */

select ie_profissional
into STRICT	ie_tipo_profissional_w
from	usuario
where	nm_usuario	= nm_usuario_p;

/* Verifica se possui algum registro não iniciado ou não finalizado */

select	count(*)
into STRICT	qt_registro_w
from	agenda_consulta_prof
where	nr_seq_agenda	= nr_seq_agenda_p
and (coalesce(hr_inicio::text, '') = '' or
	 coalesce(hr_fim::text, '') = '');

/* Verifica se possui algum registro não finalizado */

select	count(*)
into STRICT	qt_nao_finalizado_w
from	agenda_consulta_prof
where	nr_seq_agenda	= nr_seq_agenda_p
and ((hr_inicio IS NOT NULL AND hr_inicio::text <> '') and
	 coalesce(hr_fim::text, '') = '');

/* Se possui algum registro nao finalizado e está com parâmetro para Classe Profissional */

if (qt_nao_finalizado_w > 0) and (ie_forma_agenda_w = 'CP') then

	select	min(nr_seq_ordem)
	into STRICT	nr_seq_ordem_w
	from	agenda_consulta_prof
	where	nr_seq_agenda	= nr_seq_agenda_p
	and ((hr_inicio IS NOT NULL AND hr_inicio::text <> '') and
		coalesce(hr_fim::text, '') = '');

elsif (qt_registro_w > 0) then
	if (ie_forma_agenda_w = 'OD') then
		select	min(nr_seq_ordem)
		into STRICT	nr_seq_ordem_w
		from	agenda_consulta_prof
		where	nr_seq_agenda	= nr_seq_agenda_p
		and	(((hr_inicio IS NOT NULL AND hr_inicio::text <> '') and coalesce(hr_fim::text, '') = '') or (coalesce(hr_inicio::text, '') = '' and coalesce(hr_fim::text, '') = ''));
	elsif (ie_forma_agenda_w = 'CP') then
		select	min(nr_seq_ordem)
		into STRICT	nr_seq_ordem_w
		from	agenda_consulta_prof
		where	nr_seq_agenda = nr_seq_agenda_p
		and	(((hr_inicio IS NOT NULL AND hr_inicio::text <> '') and coalesce(hr_fim::text, '') = '') or (coalesce(hr_inicio::text, '') = '' and coalesce(hr_fim::text, '') = ''))
		and	ie_tipo_profissional	= ie_tipo_profissional_w;
	end if;
end if;

if (nr_seq_ordem_w > 0) then
	if (ie_tipo_p = 'P') then
		select	substr(ie_tipo_profissional,1,15)
		into STRICT	ie_retorno_w
		from	agenda_consulta_prof
		where	nr_seq_agenda	= nr_seq_agenda_p
		and	nr_seq_ordem	= nr_seq_ordem_w;
	elsif (ie_tipo_p = 'O') then
		ie_retorno_w	:= nr_seq_ordem_w;
	end if;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prof_agenda_multi ( nr_seq_agenda_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_tipo_p text) FROM PUBLIC;

