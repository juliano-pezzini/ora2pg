-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_setor_esclusivo_js ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_setor_atendimento_p bigint, nr_seq_proc_interno_p bigint, cd_convenio_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


qt_retorno_w		bigint := 1;
qt_proc_interno_w		bigint;
qt_proc_setor_atend_w	bigint;
ie_tipo_convenio_w		bigint;
cd_setor_exclusivo_w	integer;

BEGIN
	if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then
		select 	count(*)
		into STRICT	qt_proc_interno_w
		from	proc_interno_setor
		where	nr_seq_proc_interno = nr_seq_proc_interno_p;
		if (qt_proc_interno_w > 0) then
			select 	max(ie_tipo_convenio)
			into STRICT 	ie_tipo_convenio_w
			from	convenio
			where  	cd_convenio = cd_convenio_p;

			select 	count(*)
			into STRICT	qt_retorno_w
			from  	proc_interno_setor
			where  	nr_seq_proc_interno = nr_seq_proc_interno_p
			and   	cd_setor_atendimento = cd_setor_atendimento_p
			and    	coalesce(cd_perfil,cd_perfil_p) = cd_perfil_p
			and    	coalesce(ie_tipo_convenio, coalesce(ie_tipo_convenio_w,0)) = coalesce(ie_tipo_convenio_w,0);
		end if;
	else
		select	max(cd_setor_exclusivo)
		into STRICT	cd_setor_exclusivo_w
		from 	procedimento
		where 	cd_procedimento   =  cd_procedimento_p
		and 	ie_origem_proced  =  ie_origem_proced_p;

		if (cd_setor_exclusivo_w IS NOT NULL AND cd_setor_exclusivo_w::text <> '') then
			select 	count(*) qt_registros
			into STRICT 	qt_retorno_w
			from 	usuario_setor_v b,
				procedimento a
			where 	a.cd_setor_exclusivo = b.cd_setor_atendimento
			and 	b.nm_usuario         = nm_usuario_p
			and 	a.cd_procedimento    = cd_procedimento_p
			and 	a.ie_origem_proced   = ie_origem_proced_p
			and 	a.cd_setor_exclusivo = cd_setor_atendimento_p;
		else
			select	count(*)
			into STRICT	qt_proc_setor_atend_w
			from 	procedimento_setor_atend a
			where 	a.cd_procedimento  = cd_procedimento_p
			and 	a.ie_origem_proced = ie_origem_proced_p
			and 	coalesce(a.cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p;
			if (qt_proc_setor_atend_w > 0) then
				select 	count(*)
				into STRICT 	qt_retorno_w
				from 	usuario_setor_v b,
					procedimento_setor_atend a
				where 	a.cd_setor_atendimento = b.cd_setor_atendimento
				and 	b.nm_usuario         = nm_usuario_p
				and 	a.cd_procedimento    = cd_procedimento_p
				and 	a.ie_origem_proced   = ie_origem_proced_p
				and 	a.cd_setor_atendimento = cd_setor_atendimento_p
				and 	coalesce(a.cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p;
			end if;
		end if;
	end if;
return	qt_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_setor_esclusivo_js ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_setor_atendimento_p bigint, nr_seq_proc_interno_p bigint, cd_convenio_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

