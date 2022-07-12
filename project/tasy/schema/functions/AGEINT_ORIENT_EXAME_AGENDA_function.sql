-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_orient_exame_agenda (cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, nr_seq_proc_interno_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_funcao_p bigint, ie_resumo_p text default 'S') RETURNS varchar AS $body$
DECLARE


ds_orientacao_w	varchar(7000);
ds_orient_convenio_w	varchar(2000) := '';
ds_orientacao_usuario_w	varchar(4000) := '';
ie_orientacao_w		varchar(01);
ie_tipo_orientacao_w	varchar(02);


BEGIN
select	max(ds_orientacao)
into STRICT	ds_orientacao_w
from	procedimento
where	cd_procedimento = cd_procedimento_p
and	ie_origem_proced = ie_origem_proced_p;


ie_tipo_orientacao_w := Obter_Param_Usuario(820, 67, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_tipo_orientacao_w);

if (coalesce(nr_seq_proc_interno_p,0) > 0) then
	select	max(ie_orientacao),
		max(ds_orientacao_pac),
		max(ds_orientacao_usuario)
	into STRICT	ie_orientacao_w,
		ds_orientacao_w,
		ds_orientacao_usuario_w
	from	proc_interno
	where	nr_sequencia = nr_seq_proc_interno_p;

	if (ie_resumo_p = 'S') then
		select	max(ds_orientacao)
		into STRICT	ds_orient_convenio_w
		from	proc_interno_conv_orient
		where	nr_seq_proc_interno = nr_seq_proc_interno_p
		and	((cd_convenio = cd_convenio_p) or (coalesce(cd_convenio::text, '') = ''));
	else	
		ds_orient_convenio_w	:= '';
	end if;

	--1R1aise_ap1plication_error(-20011,cd_funcao_w || '#@#@');
	if (ie_orientacao_w = 'C') then
		ds_orientacao_w := ds_orient_convenio_w;
	elsif (ie_orientacao_w = 'A') and ((ie_tipo_orientacao_w = 'P') or (cd_funcao_p <> 820)) then
		ds_orientacao_w := ds_orientacao_w || chr(13) || chr(10) || ds_orient_convenio_w;
	elsif (ie_orientacao_w = 'A') and (ie_tipo_orientacao_w = 'U') and (cd_funcao_p = 820) then
		ds_orientacao_w := ds_orientacao_usuario_w || chr(13) || chr(10) || ds_orient_convenio_w;
	elsif (ie_tipo_orientacao_w = 'U') and (cd_funcao_p = 820) then
		ds_orientacao_w := ds_orientacao_usuario_w;
	elsif (ie_orientacao_w = 'A') and (ie_tipo_orientacao_w = 'PU') and (cd_funcao_p = 820) then
		ds_orientacao_w := ds_orientacao_w || chr(13) || chr(10) || ds_orient_convenio_w || chr(13) || chr(10) ||ds_orientacao_usuario_w;
	elsif (ie_tipo_orientacao_w = 'PU') and (cd_funcao_p = 820) then
		ds_orientacao_w := ds_orientacao_w || chr(13) || chr(10) || ds_orientacao_usuario_w;
	end if;
end if;

return substr(ds_orientacao_w, 1, 4000);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_orient_exame_agenda (cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, nr_seq_proc_interno_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_funcao_p bigint, ie_resumo_p text default 'S') FROM PUBLIC;
