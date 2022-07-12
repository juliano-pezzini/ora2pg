-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_final_cirurgia_graf ( nr_cirurgia_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_termino_w			timestamp;
dt_termino_prevista_w	timestamp;
dt_retorno_w			timestamp;
dt_retorno_ww			timestamp;
nr_cirurgia_w			bigint;
nr_seq_evento_fim_w		varchar(10);
ie_finaliza_evento_w	varchar(1);
dt_registro_w			timestamp;
ie_grafico_novo_w		varchar(1);


BEGIN

nr_seq_evento_fim_w := obter_param_usuario(872, 272, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, nr_seq_evento_fim_w);
ie_finaliza_evento_w := obter_param_usuario(872, 473, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_finaliza_evento_w);
ie_grafico_novo_w := obter_param_usuario(872, 431, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_grafico_novo_w);

if (nr_seq_evento_fim_w IS NOT NULL AND nr_seq_evento_fim_w::text <> '') then
	select	max(dt_registro)
	into STRICT	dt_registro_w
	from 	evento_cirurgia_paciente
	where 	nr_cirurgia 		= nr_cirurgia_p
	and	nr_seq_evento 		= campo_numerico(nr_seq_evento_fim_w)
	and	coalesce(ie_situacao,'A') 	= 'A';
end if;

select	coalesce(max(nr_cirurgia),0)
into STRICT	nr_cirurgia_w
from	cirurgia
where	nr_cirurgia_superior = nr_cirurgia_p;

select	dt_termino,
	dt_termino_prevista
into STRICT	dt_termino_w,
	dt_termino_prevista_w
from	cirurgia
where	nr_cirurgia	=	nr_cirurgia_p;

if (dt_registro_w IS NOT NULL AND dt_registro_w::text <> '') then
	dt_retorno_w	:= dt_registro_w;
elsif (coalesce(dt_registro_w::text, '') = '') and (ie_finaliza_evento_w = 'S') and (dt_termino_prevista_w >= clock_timestamp()) then
	/*Alterações do novo gráfico, OS 953871*/

	if (ie_grafico_novo_w = 'S') and (dt_termino_prevista_w > clock_timestamp() + interval '1 days'/24) then
		dt_retorno_w := clock_timestamp() + interval '1 days'/24;
	else
		dt_retorno_w	:= dt_termino_prevista_w;
	end if;
elsif (coalesce(dt_registro_w::text, '') = '') and (ie_finaliza_evento_w = 'S') and (dt_termino_prevista_w < clock_timestamp()) then
	dt_retorno_w	:= clock_timestamp() + (1/24);
elsif (coalesce(dt_termino_w::text, '') = '') and (dt_termino_prevista_w < clock_timestamp()) then
	dt_retorno_w	:= clock_timestamp() + (1/24);
elsif (coalesce(dt_termino_w::text, '') = '') and (dt_termino_prevista_w >= clock_timestamp()) then
	/*Alterações do novo gráfico, OS 953871*/

	if (ie_grafico_novo_w = 'S') and (dt_termino_prevista_w > clock_timestamp() + interval '1 days'/24) then
		dt_retorno_w := clock_timestamp() + interval '1 days'/24;
	else
		dt_retorno_w	:= dt_termino_prevista_w;
	end if;
elsif (dt_termino_w IS NOT NULL AND dt_termino_w::text <> '') then
	dt_retorno_w	:= dt_termino_w;
end if;

if (nr_cirurgia_w > 0) then
	select	dt_termino,
		dt_termino_prevista
	into STRICT	dt_termino_w,
		dt_termino_prevista_w
	from	cirurgia
	where	nr_cirurgia	=	nr_cirurgia_w;

	if (coalesce(dt_termino_w::text, '') = '') and (dt_termino_prevista_w < clock_timestamp()) then
		dt_retorno_ww	:= clock_timestamp() + (1/24);
	elsif (coalesce(dt_termino_w::text, '') = '') and (dt_termino_prevista_w >= clock_timestamp()) then
		/*Alterações do novo gráfico, OS 953871*/

		if (ie_grafico_novo_w = 'S') and (dt_termino_prevista_w > clock_timestamp() + interval '1 days'/24) then
			dt_retorno_w := clock_timestamp() + interval '1 days'/24;
		else
			dt_retorno_w	:= dt_termino_prevista_w;
	end if;
	elsif (dt_termino_w IS NOT NULL AND dt_termino_w::text <> '') then
		dt_retorno_ww	:= dt_termino_w;
	end if;

	if (dt_retorno_ww	> dt_retorno_w) then
		dt_retorno_w	:= dt_retorno_ww;
	end if;
end if;

return	coalesce(dt_retorno_w, clock_timestamp());

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_final_cirurgia_graf ( nr_cirurgia_p bigint) FROM PUBLIC;
