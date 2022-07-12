-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_orient_exame_lab ( nr_seq_exame_p bigint, nr_seq_ageint_p bigint, cd_estabelecimento_p bigint, ie_mostra_obs_tecnica_p text default null, ie_mostra_obs_usuario_p text default null, ie_mostra_obs_medicamento_p text default null, ie_mostra_obs_paciente_p text default null) RETURNS varchar AS $body$
DECLARE

qt_idade_w					bigint;
ds_retorno_w				varchar(4000) := null;
ie_sexo_w					varchar(1);
ds_orientacao_tecnica_w		varchar(4000);
ds_orientacao_usuario_w		varchar(4000);
ds_orientacao_medicamento_w	varchar(4000);
ds_orientacao_paciente_w	varchar(4000);

C01 CURSOR FOR
	SELECT	ds_orientacao_tecnica,
			ds_orientacao_usuario,
			ds_orientacao_medicamento,
			ds_orientacao_paciente
	from    EXAME_LAB_ORIENTACAO
	where   nr_seq_exame 		= nr_seq_exame_p
	and     qt_idade_w	between coalesce(qt_idade_min,qt_idade_w) and coalesce(qt_idade_max,qt_idade_w)
	and		coalesce(coalesce(cd_estabelecimento,cd_estabelecimento_p),0) = coalesce(cd_estabelecimento_p,0)
	and     ((ie_sexo 	= ie_sexo_w) or (ie_sexo = 'I'))
	order   by ds_orientacao_tecnica,ds_orientacao_usuario,ds_orientacao_medicamento;

BEGIN

select 	obter_sexo_pf(a.cd_pessoa_fisica,'C'),
		obter_idade_pf(a.cd_pessoa_fisica,clock_timestamp(),'A')
into STRICT	ie_sexo_w,
		qt_idade_w
from   	agenda_integrada a
where  	a.nr_sequencia = nr_seq_ageint_p;

open C01;
loop
fetch C01 into
	ds_orientacao_tecnica_w,
	ds_orientacao_usuario_w,
	ds_orientacao_medicamento_w,
	ds_orientacao_paciente_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (ds_orientacao_usuario_w IS NOT NULL AND ds_orientacao_usuario_w::text <> '') and (coalesce(ie_mostra_obs_usuario_p,'N') = 'S') then
		ds_retorno_w := substr(wheb_mensagem_pck.get_texto(791238) || ': ' || ds_orientacao_usuario_w || chr(10),1,4000);
	end if;

	if (ds_orientacao_tecnica_w IS NOT NULL AND ds_orientacao_tecnica_w::text <> '') and (coalesce(ie_mostra_obs_tecnica_p,'N') = 'S') then
		ds_retorno_w := substr(ds_retorno_w || wheb_mensagem_pck.get_texto(791229) || ds_orientacao_tecnica_w || chr(10),1,4000);

	end if;

	if (ds_orientacao_medicamento_w IS NOT NULL AND ds_orientacao_medicamento_w::text <> '') and (coalesce(ie_mostra_obs_medicamento_p,'N') = 'S') then
		ds_retorno_w := substr(ds_retorno_w || wheb_mensagem_pck.get_texto(791239) || ': ' || ds_orientacao_medicamento_w || chr(10),1,4000);
	end if;

	if (ds_orientacao_paciente_w IS NOT NULL AND ds_orientacao_paciente_w::text <> '') and (coalesce(ie_mostra_obs_paciente_p,'N') = 'S') then
		ds_retorno_w := substr(ds_retorno_w || wheb_mensagem_pck.get_texto(791230) || ds_orientacao_paciente_w || chr(10),1,4000);
	end if;

	end;
end loop;
close C01;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_orient_exame_lab ( nr_seq_exame_p bigint, nr_seq_ageint_p bigint, cd_estabelecimento_p bigint, ie_mostra_obs_tecnica_p text default null, ie_mostra_obs_usuario_p text default null, ie_mostra_obs_medicamento_p text default null, ie_mostra_obs_paciente_p text default null) FROM PUBLIC;
