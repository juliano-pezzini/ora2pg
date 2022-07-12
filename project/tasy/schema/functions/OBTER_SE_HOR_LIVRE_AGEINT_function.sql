-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_hor_livre_ageint ( hr_agenda_p timestamp, nr_minuto_duracao_p bigint, nm_usuario_p text, nr_seq_ageint_p bigint, nr_seq_ageint_item_p bigint) RETURNS varchar AS $body$
DECLARE


ds_Retorno_w		varchar(1)	:= 'S';
hr_Agenda_w		timestamp;
nr_minuto_duracao_w	bigint;
nr_minuto_duracao_ww	bigint;
ie_sobreposicao_encaixe_w  parametro_agenda.ie_sobreposicao_encaixe%type;
ie_sobreposicao_param_w  parametro_agenda.ie_consiste_duracao%type;
ie_sobrep_encaixe_par_ageint_w varchar(1);
ie_encaixe_w ageint_marcacao_usuario.ie_encaixe%TYPE;

C01 CURSOR FOR
	SELECT	a.hr_Agenda,
		a.nr_minuto_duracao - 1,
		coalesce(a.ie_encaixe,'N')
	FROM agenda_integrada_item c, ageint_marcacao_usuario a
LEFT OUTER JOIN agenda_paciente b ON (a.nr_seq_Agenda = b.nr_sequencia)
WHERE a.nm_usuario			= nm_usuario_p and a.nr_seq_ageint_item		= c.nr_sequencia and c.ie_tipo_agendamento		= 'E' and trunc(a.hr_agenda)		= trunc(hr_agenda_p) and a.nr_seq_ageint			= nr_seq_ageint_p and coalesce(a.ie_horario_auxiliar,'N')	= 'N'  and c.nr_sequencia			<> nr_seq_ageint_item_p and coalesce(b.ie_status_agenda, 'X')	<> 'C'
	
union

	SELECT	a.hr_Agenda,
		coalesce(a.nr_minuto_duracao,1) - 1,
		coalesce(a.ie_encaixe,'N')
	FROM agenda_integrada_item c, ageint_marcacao_usuario a
LEFT OUTER JOIN agenda_consulta b ON (a.nr_seq_Agenda = b.nr_sequencia)
WHERE a.nm_usuario			= nm_usuario_p and a.nr_seq_ageint_item		= c.nr_sequencia and c.ie_tipo_agendamento		in ('C','S') and trunc(a.hr_agenda)		= trunc(hr_agenda_p) and a.nr_seq_ageint			= nr_seq_ageint_p and coalesce(a.ie_horario_auxiliar,'N')	= 'N' and c.nr_sequencia			<> nr_seq_ageint_item_p  and coalesce(b.ie_status_agenda, 'X')	<> 'C';
			

BEGIN

select  coalesce(max(ie_sobreposicao_encaixe),'S'),
        coalesce(max(ie_consiste_duracao), 'I')
into STRICT    ie_sobreposicao_encaixe_w,
        ie_sobreposicao_param_w
from  parametro_agenda
where  cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

ie_sobrep_encaixe_par_ageint_w := obter_param_usuario(869, 162, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_sobrep_encaixe_par_ageint_w);

select	CASE WHEN nr_minuto_duracao_p=0 THEN  0  ELSE (nr_minuto_duracao_p -1) END
into STRICT	nr_minuto_duracao_ww
;

open C01;
loop
fetch C01 into	
	hr_Agenda_w,
	nr_minuto_duracao_w,
	ie_encaixe_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (ie_sobreposicao_param_w = 'I' AND (ie_encaixe_w = 'N' OR (ie_encaixe_w = 'S' AND ie_sobreposicao_encaixe_w = 'S' AND ie_sobrep_encaixe_par_ageint_w = 'S')))
		AND
  		((hr_agenda_p between hr_Agenda_w and hr_agenda_w + (nr_minuto_duracao_w / 1440)) or
  		(hr_agenda_p + (nr_minuto_duracao_ww / 1440) between hr_Agenda_w and hr_agenda_w + (nr_minuto_duracao_w / 1440)) or
  		(hr_agenda_w between hr_agenda_p and hr_agenda_p + (nr_minuto_duracao_ww / 1440))) then
		ds_retorno_w	:= 'N';
	end if;		
	end;
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_hor_livre_ageint ( hr_agenda_p timestamp, nr_minuto_duracao_p bigint, nm_usuario_p text, nr_seq_ageint_p bigint, nr_seq_ageint_item_p bigint) FROM PUBLIC;

