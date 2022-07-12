-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_utilizada_mat_autor ( nr_seq_mat_autor_p bigint) RETURNS bigint AS $body$
DECLARE



qt_retorno_w			double precision;
qt_generico_retorno_w		double precision;
ie_autor_generico_w		varchar(1);
cd_estab_w		smallint;



BEGIN

cd_estab_w 		:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,1);

if (nr_seq_mat_autor_p IS NOT NULL AND nr_seq_mat_autor_p::text <> '') then

	select	coalesce(sum(a.qt_material),0)
	into STRICT	qt_retorno_w
	from	autorizacao_convenio d,
		material_autorizado c,
		conta_paciente b,
		material_atend_paciente a
	where	a.nr_interno_conta	= b.nr_interno_conta
	and	c.nr_sequencia_autor	= d.nr_sequencia
	and	d.nr_atendimento		= b.nr_atendimento
	and	b.cd_convenio_parametro	= d.cd_convenio
	and	c.cd_material		= a.cd_material
	and	c.nr_sequencia		= nr_seq_mat_autor_p;

	select 	coalesce(max(ie_autor_generico),'N')
	into STRICT	ie_autor_generico_w
	from	autorizacao_convenio d,
		material_autorizado c,
		convenio_estabelecimento e
	where	c.nr_sequencia_autor			= d.nr_sequencia
	and 	coalesce(d.cd_estabelecimento,cd_estab_w) 	= e.cd_estabelecimento
	and 	d.cd_convenio 				= e.cd_convenio
	and	c.nr_sequencia				= nr_seq_mat_autor_p;

	if (ie_autor_generico_w = 'S') then

		select	coalesce(sum(a.qt_material),0)
		into STRICT	qt_generico_retorno_w
		from	autorizacao_convenio d,
			material_autorizado c,
			conta_paciente b,
			material_atend_paciente a
		where	a.nr_interno_conta	= b.nr_interno_conta
		and	c.nr_sequencia_autor	= d.nr_sequencia
		and	d.nr_atendimento		= b.nr_atendimento
		and	b.cd_convenio_parametro	= d.cd_convenio
		and	c.cd_material		= obter_material_generico(a.cd_material)
		and	c.nr_sequencia		= nr_seq_mat_autor_p;

		if (qt_generico_retorno_w > 0) then
			qt_retorno_w := qt_generico_retorno_w;
		end if;

	end if;

end if;

return qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_utilizada_mat_autor ( nr_seq_mat_autor_p bigint) FROM PUBLIC;
