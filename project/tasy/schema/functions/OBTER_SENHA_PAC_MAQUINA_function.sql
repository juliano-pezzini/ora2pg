-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_senha_pac_maquina ( nm_usuario_p text, ds_maquinha_p text, ie_triagem_pep_p text default 'N') RETURNS bigint AS $body$
DECLARE


nr_sequencia_w				bigint;
r_seq_senha_w				bigint;
ie_utiliza_senha_atendida_w			varchar(1)	:=	'S';

dt_primeira_chamada_w			timestamp;
cd_estabelecimento_w			bigint;


BEGIN
cd_estabelecimento_w	:=	wheb_usuario_pck.get_cd_estabelecimento;

ie_utiliza_senha_atendida_w := obter_param_usuario(10021, 49, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, cd_estabelecimento_w, ie_utiliza_senha_atendida_w);

if (coalesce(obter_funcao_ativa, 916) = 916) then
	select	max(coalesce(dt_chamada,dt_primeira_chamada))
	into STRICT	dt_primeira_chamada_w
	from	paciente_senha_fila
	where	coalesce(dt_vinculacao_senha::text, '') = ''
	and	coalesce(dt_inutilizacao::text, '') = ''
	and	ds_maquina_chamada_pesquisa = upper(ds_maquinha_p)
	and	upper(nm_usuario) = upper(nm_usuario_p)
	and	((ie_utiliza_senha_atendida_w = 'S') or ((ie_utiliza_senha_atendida_w = 'N') and (coalesce(dt_utilizacao::text, '') = '')))
	and (coalesce(ie_rechamada,'N') = 'N');

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_sequencia_w
	from	paciente_senha_fila
	where	coalesce(dt_vinculacao_senha::text, '') = ''
	and	coalesce(dt_inutilizacao::text, '') = ''
	and	coalesce(DT_FIM_ATENDIMENTO::text, '') = ''
	and	ds_maquina_chamada_pesquisa =  upper(ds_maquinha_p)
	and	upper(nm_usuario) = upper(nm_usuario_p)
	and	((ie_utiliza_senha_atendida_w = 'S') or ((ie_utiliza_senha_atendida_w = 'N') and (coalesce(dt_utilizacao::text, '') = '')))
	and (coalesce(ie_rechamada,'N') = 'N')
	and	coalesce(dt_chamada,dt_primeira_chamada) = dt_primeira_chamada_w;

elsif (obter_funcao_ativa = 9037 or (obter_funcao_ativa = 281 and ie_triagem_pep_p = 'S')) then

	select	max(coalesce(dt_chamada,dt_primeira_chamada))
	into STRICT	dt_primeira_chamada_w
	from	paciente_senha_fila a
	where	coalesce(dt_vinculacao_senha::text, '') = ''
	and	coalesce(dt_inutilizacao::text, '') = ''
	and	ds_maquina_chamada_pesquisa = upper(ds_maquinha_p)
	and	upper(nm_usuario) = upper(nm_usuario_p)
	and	((ie_utiliza_senha_atendida_w = 'S') or ((ie_utiliza_senha_atendida_w = 'N') and (coalesce(dt_utilizacao::text, '') = '')))
	and	cd_estabelecimento 		= cd_estabelecimento_w
	and	not exists (SELECT 1 from triagem_pronto_atend x where x.nr_seq_fila_senha = a.nr_sequencia);

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_sequencia_w
	from	paciente_senha_fila
	where	coalesce(dt_vinculacao_senha::text, '') = ''
	and	coalesce(dt_inutilizacao::text, '') = ''
	and	coalesce(DT_FIM_ATENDIMENTO::text, '') = ''
	and	ds_maquina_chamada_pesquisa = upper(ds_maquinha_p)
	and	upper(nm_usuario) = upper(nm_usuario_p)
	and	((ie_utiliza_senha_atendida_w = 'S') or ((ie_utiliza_senha_atendida_w = 'N') and (coalesce(dt_utilizacao::text, '') = '')))
	and	coalesce(dt_chamada,dt_primeira_chamada) = dt_primeira_chamada_w;

elsif (obter_funcao_ativa = 10021) then
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_sequencia_w
	from	paciente_senha_fila
	where	coalesce(dt_inutilizacao::text, '') = ''
	and	dt_geracao_senha > clock_timestamp() - interval '2 days'
	and	ds_maquina_chamada_pesquisa = upper(ds_maquinha_p)
	and	upper(nm_usuario) = upper(nm_usuario_p)
	and	coalesce(dt_fim_atendimento::text, '') = ''
	and (coalesce(ie_rechamada,'N') = 'N')
	and	coalesce(dt_chamada,dt_primeira_chamada) = (	SELECT	max(coalesce(dt_chamada,dt_primeira_chamada))
							from	paciente_senha_fila a
							where	coalesce(dt_inutilizacao::text, '') = ''
							and	dt_geracao_senha > clock_timestamp() - interval '2 days'
							and	coalesce(dt_fim_atendimento::text, '') = ''
							and	upper(nm_usuario) = upper(nm_usuario_p)
							and	ds_maquina_chamada_pesquisa = upper(ds_maquinha_p));
else
	select	max(coalesce(dt_chamada,dt_primeira_chamada))
	into STRICT	dt_primeira_chamada_w
	from	paciente_senha_fila
	where	((coalesce(dt_vinculacao_senha::text, '') = '') or ((dt_inicio_atendimento IS NOT NULL AND dt_inicio_atendimento::text <> '') and (coalesce(dt_fim_atendimento::text, '') = '')))
	and	coalesce(dt_inutilizacao::text, '') = ''
	and	ds_maquina_chamada_pesquisa = upper(ds_maquinha_p)
	and	upper(nm_usuario) = upper(nm_usuario_p)
	and	((ie_utiliza_senha_atendida_w = 'S') or ((ie_utiliza_senha_atendida_w = 'N') and (coalesce(dt_utilizacao::text, '') = '')))
	and	cd_estabelecimento 		= cd_estabelecimento_w;

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_sequencia_w
	from	paciente_senha_fila
	where	((coalesce(dt_vinculacao_senha::text, '') = '') or ((dt_inicio_atendimento IS NOT NULL AND dt_inicio_atendimento::text <> '') and (coalesce(dt_fim_atendimento::text, '') = '')))
	and	coalesce(dt_inutilizacao::text, '') = ''
	and	coalesce(DT_FIM_ATENDIMENTO::text, '') = ''
	and	ds_maquina_chamada_pesquisa = upper(ds_maquinha_p)
	and	upper(nm_usuario) = upper(nm_usuario_p)
	and	((ie_utiliza_senha_atendida_w = 'S') or ((ie_utiliza_senha_atendida_w = 'N') and (coalesce(dt_utilizacao::text, '') = '')))
	and	coalesce(dt_chamada,dt_primeira_chamada) = dt_primeira_chamada_w;
end if;

return	nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_senha_pac_maquina ( nm_usuario_p text, ds_maquinha_p text, ie_triagem_pep_p text default 'N') FROM PUBLIC;
