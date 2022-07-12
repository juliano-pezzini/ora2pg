-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION html5_obter_se_data_periodo ( cd_funcao_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_tipo_data_p text, ie_data_vazia_p text default 'N') RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255) := 'S';


BEGIN

-- 1- Início prev análise = dt_prev_inicio_analise
if (ie_tipo_data_p = '1') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_prev_inicio_analise between dt_inicial_p and fim_dia(dt_final_p)
			and		((coalesce(ie_data_vazia_p,'N') = 'N') or ((coalesce(ie_data_vazia_p,'N') = 'S') and ( coalesce(a.dt_real_inicio_analise::text, '') = '')))
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 2- Prev checkpoint = dt_prev_checkpoint
elsif (ie_tipo_data_p = '2') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_prev_checkpoint between dt_inicial_p and fim_dia(dt_final_p)
			and		((coalesce(ie_data_vazia_p,'N') = 'N') or ((coalesce(ie_data_vazia_p,'N') = 'S') and ( coalesce(a.dt_real_checkpoint::text, '') = '')))
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 3- Início prev programação = dt_prev_inicio_prog
elsif (ie_tipo_data_p = '3') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_prev_inicio_prog between dt_inicial_p and fim_dia(dt_final_p)
			and		((coalesce(ie_data_vazia_p,'N') = 'N') or ((coalesce(ie_data_vazia_p,'N') = 'S') and ( coalesce(a.dt_real_inicio_prog::text, '') = '')))
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 4- Início prev teste = dt_prev_inicio_teste
elsif (ie_tipo_data_p = '4') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_prev_inicio_teste between dt_inicial_p and fim_dia(dt_final_p)
			and		((coalesce(ie_data_vazia_p,'N') = 'N') or ((coalesce(ie_data_vazia_p,'N') = 'S') and ( coalesce(a.dt_real_inicio_teste::text, '') = '')))
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 5- Prev aprovação gerente = dt_prev_aprov_gerente
elsif (ie_tipo_data_p = '5') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_prev_aprov_gerente between dt_inicial_p and fim_dia(dt_final_p)
			and		((coalesce(ie_data_vazia_p,'N') = 'N') or ((coalesce(ie_data_vazia_p,'N') = 'S') and ( coalesce(a.dt_real_aprov_gerente::text, '') = '')))
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 6- Fim prev programação = dt_prev_fim_prog
elsif (ie_tipo_data_p = '6') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_prev_fim_prog between dt_inicial_p and fim_dia(dt_final_p)
			and		((coalesce(ie_data_vazia_p,'N') = 'N') or ((coalesce(ie_data_vazia_p,'N') = 'S') and ( coalesce(a.dt_real_fim_prog::text, '') = '')))
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
--7- Fim prev análise = dt_prev_fim_analise
elsif (ie_tipo_data_p = '7') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_prev_fim_analise between dt_inicial_p and fim_dia(dt_final_p)
			and		((coalesce(ie_data_vazia_p,'N') = 'N') or ((coalesce(ie_data_vazia_p,'N') = 'S') and ( coalesce(a.dt_real_fim_analise::text, '') = '')))
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 8- Fim prev teste = dt_prev_fim_teste
elsif (ie_tipo_data_p = '8') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_prev_fim_teste between dt_inicial_p and fim_dia(dt_final_p)
			and		((coalesce(ie_data_vazia_p,'N') = 'N') or ((coalesce(ie_data_vazia_p,'N') = 'S') and ( coalesce(a.dt_real_fim_teste::text, '') = '')))
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 9- Início real programação = dt_real_inicio_prog
elsif (ie_tipo_data_p = '9') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_real_inicio_prog between dt_inicial_p and fim_dia(dt_final_p)
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 10- Fim real programação = dt_real_fim_prog
elsif (ie_tipo_data_p = '10') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_real_fim_prog between dt_inicial_p and fim_dia(dt_final_p)
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 11- Início real análise = dt_real_inicio_analise
elsif (ie_tipo_data_p = '11') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_real_inicio_analise between dt_inicial_p and fim_dia(dt_final_p)
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 12- Fim real análise = dt_real_fim_analise
elsif (ie_tipo_data_p = '12') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_real_fim_analise between dt_inicial_p and fim_dia(dt_final_p)
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 13- Início real teste = dt_real_inicio_teste
elsif (ie_tipo_data_p = '13') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_real_inicio_teste between dt_inicial_p and fim_dia(dt_final_p)
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 14- Fim real teste = dt_real_fim_teste
elsif (ie_tipo_data_p = '14') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_real_fim_teste between dt_inicial_p and fim_dia(dt_final_p)
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 15- Aprovação do Gerente = dt_real_aprov_gerente
elsif (ie_tipo_data_p = '15') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_real_aprov_gerente between dt_inicial_p and fim_dia(dt_final_p)
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
-- 16- Real checkpoint = dt_real_checkpoint
elsif (ie_tipo_data_p = '16') then
	ds_retorno_w	:= 'N';

	begin
	select	'S'
	into STRICT	ds_retorno_w
	
	where	exists (SELECT	1
			from	funcoes_html5 a
			where	a.dt_real_checkpoint between dt_inicial_p and fim_dia(dt_final_p)
			and	a.cd_funcao	= cd_funcao_p);
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;
end if;

return

ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION html5_obter_se_data_periodo ( cd_funcao_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_tipo_data_p text, ie_data_vazia_p text default 'N') FROM PUBLIC;

