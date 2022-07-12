-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_orientacao_exame_lab ( nr_seq_exame_p bigint, ie_mostra_obs_tecnica_p text default null, ie_mostra_obs_usuario_p text default null, nr_sequencia_p bigint default null) RETURNS varchar AS $body$
DECLARE


ds_orientacao_usuario_w    varchar(4000);
ds_orientacao_tecnica_w    varchar(4000);
ds_retorno_w               varchar(4000);
nr_seq_exame_w				bigint;


BEGIN
if (coalesce(nr_seq_exame_p::text, '') = '')  then
	SELECT	coalesce(MAX(nr_seq_exame),0)
	INTO STRICT	nr_seq_exame_w
	FROM 	exame_lab_rotina
	WHERE	nr_sequencia	=	nr_sequencia_p;
else
	nr_seq_exame_w := nr_seq_exame_p;
end if;

select	ds_orientacao_usuario,
		ds_orientacao_tecnica
into STRICT	ds_orientacao_usuario_w,
		ds_orientacao_tecnica_w
from	exame_laboratorio
where	nr_seq_exame = nr_seq_exame_w;


if (ds_orientacao_usuario_w IS NOT NULL AND ds_orientacao_usuario_w::text <> '') and (coalesce(ie_mostra_obs_usuario_p,'S') = 'S') then
	ds_retorno_w := substr(obter_desc_expressao(715516)||': '  || ds_orientacao_usuario_w || chr(10),1,4000);
end if;

if (ds_orientacao_tecnica_w IS NOT NULL AND ds_orientacao_tecnica_w::text <> '') and (coalesce(ie_mostra_obs_tecnica_p,'S') = 'S') then
	ds_retorno_w := substr(ds_retorno_w || obter_desc_expressao(710637)||' ' || ds_orientacao_tecnica_w || chr(10),1,4000);
end if;


if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
	return ds_retorno_w;
else
	return '';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_orientacao_exame_lab ( nr_seq_exame_p bigint, ie_mostra_obs_tecnica_p text default null, ie_mostra_obs_usuario_p text default null, nr_sequencia_p bigint default null) FROM PUBLIC;
