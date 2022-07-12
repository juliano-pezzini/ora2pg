-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_wl_liberado ( cd_perfil_p bigint, nm_usuario_p text, nr_seq_regra_p bigint, nr_seq_worklist_p wl_worklist.nr_sequencia%type default null) RETURNS varchar AS $body$
DECLARE


ie_regra_liberado_w			varchar(1)	:= 'S';
qt_regra_w					bigint;


BEGIN

if (coalesce(nr_seq_regra_p,0) > 0 ) then

	select	count(1)
	into STRICT	qt_regra_w	
	from	wl_regra_item c,
			wl_perfil d
	where	c.nr_sequencia = d.nr_seq_regra_item
	and		c.ie_situacao = 'A'
	and		d.ie_situacao = 'A'
	and		c.nr_sequencia = nr_seq_regra_p;

	if (qt_regra_w > 0) then
		
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_regra_liberado_w
		from	wl_regra_item c,
				wl_perfil d
		where	c.nr_sequencia = d.nr_seq_regra_item
		and		c.ie_situacao = 'A'
		and		d.ie_situacao = 'A'
		and		c.nr_sequencia = nr_seq_regra_p
		and		((d.is_specific_rule = 'S' and obter_se_wl_specific_rule(nr_seq_worklist_p, d.nr_sequencia, cd_perfil_p, nm_usuario_p) = 'S' and ((coalesce(d.cd_perfil::text, '') = '') or (d.cd_perfil = cd_perfil_p)))
		or 		( coalesce(d.is_specific_rule, 'N') = 'N'
		and		((coalesce(d.cd_perfil::text, '') = '') or (d.cd_perfil = cd_perfil_p))
		and		((coalesce(d.nm_usuario_wl::text, '') = '') or (d.nm_usuario_wl = nm_usuario_p))
		and		((coalesce(d.cd_departamento::text, '') = '') or (obter_se_dept_usuario(d.cd_departamento,nm_usuario_p) = 'S'))
		and		((coalesce(d.cd_setor_atendimento::text, '') = '') or (obter_se_setor_usuario(d.cd_setor_atendimento,nm_usuario_p) = 'S'))
		and		((coalesce(d.nr_seq_grupo_usuario::text, '') = '') or (obter_se_usuario_grupo(d.nr_seq_grupo_usuario,nm_usuario_p) = 'S'))));
		
	end if;

end if;


return	ie_regra_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_wl_liberado ( cd_perfil_p bigint, nm_usuario_p text, nr_seq_regra_p bigint, nr_seq_worklist_p wl_worklist.nr_sequencia%type default null) FROM PUBLIC;
