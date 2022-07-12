-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_paciente_doc (cd_pessoa_fisica_p text, nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


qt_agenda_pac_w			bigint;
ds_retorno_w			varchar(2) := 'N';
dt_liberacao_w			timestamp;
ie_enviar_agfa_w		varchar(1);


BEGIN

SELECT	COUNT(*)
INTO STRICT	qt_agenda_pac_w
FROM	agenda_integrada_item a,
		agenda_paciente b
WHERE	a.nr_seq_agenda_exame = b.nr_sequencia
AND		b.dt_agenda = TRUNC(clock_timestamp())
AND		b.cd_pessoa_fisica = cd_pessoa_fisica_p;


ie_enviar_agfa_w := obter_param_usuario(916, 1114, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_enviar_agfa_w);


if (ie_enviar_agfa_w <> 'C' AND qt_agenda_pac_w > 0) then
	begin
	ds_retorno_w := 'SA';
	end;
else
	begin
		select	dt_liberacao
		into STRICT	dt_liberacao_w
		from	prescr_medica
		where 	nr_prescricao = nr_prescricao_p;
		if (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') then
			begin
			ds_retorno_w := 'SP';
			end;
		end if;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_paciente_doc (cd_pessoa_fisica_p text, nr_prescricao_p bigint) FROM PUBLIC;

