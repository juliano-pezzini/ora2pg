-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_existe_aprov_pendente ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, cd_cargo_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE



qt_aprov_pendente_w		integer := 0;
ie_nao_liberado_w			varchar(1);
ie_aprov_regra_minimo_w		varchar(1);
ie_adm_outro_estab_w		varchar(1);
ie_Somente_Setor_w		varchar(1);
cd_estab_aprov_w			bigint;
ie_aprovacao_nivel_w	varchar(1);



BEGIN

/*Em substituicao a function OBTER_DADOS_PARAMETRO_COMPRAS*/

select	coalesce(max(ie_aprov_regra_minimo),'N'),
	coalesce(MAX(ie_aprovacao_nivel),'N')
into STRICT	ie_nao_liberado_w,
	ie_aprovacao_nivel_w
from	parametro_compras
where	cd_estabelecimento = cd_estabelecimento_p;

select	coalesce(max(obter_valor_param_usuario(267, 2, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),'N'),
	coalesce(max(obter_valor_param_usuario(267, 3, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),'N'),
	coalesce(max(obter_valor_param_usuario(267, 6, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),'N')
into STRICT	ie_Somente_Setor_w,
	ie_aprov_regra_minimo_w,
	ie_adm_outro_estab_w
;

if (ie_adm_outro_estab_w = 'S') then
	cd_estab_aprov_w := 0;
else
	cd_estab_aprov_w := cd_estabelecimento_p;
end if;

select	/*+ USE_CONCAT */	count(*)
into STRICT	qt_aprov_pendente_w
from	processo_aprov_compra a
where	a.ie_aprov_reprov = 'P'
and	(((obter_se_proc_por_nivel(a.nr_sequencia, cd_estabelecimento_p) = 'S') and (obter_se_proc_mesmo_nivel(a.nr_sequencia, a.nr_seq_proc_aprov, cd_estabelecimento_p, cd_pessoa_fisica_p) = 'S')) or
	   ((obter_se_proc_por_nivel(a.nr_sequencia, cd_estabelecimento_p) in ('N', 'A')) and
	   ((a.cd_pessoa_fisica = cd_pessoa_fisica_p) or (substr(obter_se_pessoa_delegacao(a.nr_sequencia,a.nr_seq_proc_aprov,cd_pessoa_fisica_p, 'AC', clock_timestamp()),1,1) = 'S') or (a.cd_cargo = cd_cargo_p) or
	((ie_aprovacao_nivel_w = 'S') and (obter_se_cargo_mesmo_nivel(a.cd_cargo, cd_cargo_p, cd_estabelecimento_p) = 'S')) or
	((ie_aprovacao_nivel_w = 'S') and (obter_se_pessoa_mesmo_nivel(a.cd_pessoa_fisica, cd_pessoa_fisica_p, cd_estabelecimento_p) = 'S')) or
	((a.nm_usuario_parecer = nm_usuario_p) and (coalesce(a.dt_resp_parecer::text, '') = '')))))
and	((obter_se_proc_mesmo_nivel(a.nr_sequencia, a.nr_seq_proc_aprov, cd_estabelecimento_p, cd_pessoa_fisica_p) = 'S') or
	((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (ie_nao_liberado_w = 'S') or (ie_aprov_regra_minimo_w = 'S')))
and (cd_estab_aprov_w = 0 or Obter_estab_Processo_Aprov(a.nr_sequencia) = cd_estab_aprov_w)
and	((ie_Somente_Setor_w = 'N') or
	((ie_Somente_Setor_w = 'S') and (Obter_se_Proc_Aprov_setor(a.nr_sequencia, obter_setor_ativo) = 'S')));
	
return qt_aprov_pendente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_existe_aprov_pendente ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, cd_cargo_p bigint, nm_usuario_p text) FROM PUBLIC;
