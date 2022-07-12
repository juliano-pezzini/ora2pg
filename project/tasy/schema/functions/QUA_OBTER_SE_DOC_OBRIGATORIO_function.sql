-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_se_doc_obrigatorio ( nr_sequencia_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_resultado_w		varchar(1);
qt_reg_w			bigint;
cd_cargo_w		bigint;
cd_estabelecimento_w	smallint;
cd_setor_atendimento_w	integer;
cd_perfil_w		integer := obter_perfil_ativo;
ie_libera_estab_w		varchar(1);
cd_classif_setor_w		varchar(02);
nr_seq_superior_w		varchar(10);
ie_doc_pai_w		varchar(1);
nr_seq_doc_w		bigint;
ds_program_w		varchar(60);


BEGIN

begin
    $IF DBMS_DB_VERSION.VERSION <= 11 $THEN
      select max(program)
      into STRICT ds_program_w
      from gv$session where audsid = userenv('sessionid');
    $ELSE
      SELECT SYS_CONTEXT('USERENV', 'CLIENT_PROGRAM_NAME')
      into STRICT ds_program_w
;
    $END
end;

if (position('.EXE' in ds_program_w) > 0) then
	return 'S';
end if;

	ds_resultado_w	:= 'N';

	select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT	ie_doc_pai_w
	from	qua_documento a
	where	a.nr_sequencia = nr_sequencia_p
	and	coalesce(a.nr_seq_superior::text, '') = '';
	
	if (ie_doc_pai_w = 'S') then
		nr_seq_doc_w := nr_sequencia_p;
	else
		select	a.nr_seq_superior
		into STRICT	nr_seq_doc_w
		from	qua_documento a
		where	a.nr_sequencia = nr_sequencia_p;
	end if;
	
	select	max(a.cd_setor_atendimento),
		max(b.cd_classif_setor)
	into STRICT	cd_setor_atendimento_w,
		cd_classif_setor_w
	from	setor_atendimento b,
		usuario a
	where	a.nm_usuario 		= nm_usuario_p
	and	a.cd_setor_atendimento 	= b.cd_setor_atendimento;

	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	qua_documento
	where	nr_sequencia = nr_seq_doc_w;

	select	count(*)
	into STRICT	qt_reg_w
	from	qua_doc_lib
	where	nr_seq_doc	= nr_seq_doc_w;

	select	b.cd_cargo
	into STRICT	cd_cargo_w
	from	usuario a,
		pessoa_fisica b
	where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	a.nm_usuario 	= nm_usuario_p;

	if	coalesce(cd_cargo_w::text, '') = '' then
		cd_cargo_w	:= 0;
	end if;

	/*Se tiver regra para usuario ou cargo do usuario, esta liberado*/

	select	count(*)
	into STRICT	qt_reg_w
	from	qua_doc_lib
	where	nr_seq_doc	= nr_seq_doc_w
	and (nm_usuario_lib	= nm_usuario_p or cd_cargo = cd_cargo_w)
	and (ie_obrigatorio = 'S')
	and     ( ((coalesce(dt_inicio_vigencia::text, '') = '') and (coalesce(dt_fim_vigencia::text, '') = '')) or
		((clock_timestamp() >= dt_inicio_vigencia) and (coalesce(dt_fim_vigencia::text, '') = ''))or
		((clock_timestamp() <= dt_fim_vigencia) and (coalesce(dt_inicio_vigencia::text, '') = ''))or
		((clock_timestamp() >= dt_inicio_vigencia) and (clock_timestamp() <= dt_fim_vigencia)));
	if (qt_reg_w > 0) then
		ds_resultado_w	:= 'S';
	else
		/*Se tiver regra para algum perfil liberado ao usuario, esta liberado*/

		select count(*)
		into STRICT	qt_reg_w
		from	usuario_perfil b,
			qua_doc_lib a
		where	a.nr_seq_doc	= nr_seq_doc_w
		and	a.cd_perfil	= b.cd_perfil
		and	b.nm_usuario	= nm_usuario_p
		and 	a.ie_obrigatorio = 'S'
		and     ( ((coalesce(a.dt_inicio_vigencia::text, '') = '') and (coalesce(a.dt_fim_vigencia::text, '') = '')) or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (coalesce(a.dt_fim_vigencia::text, '') = ''))or
			((clock_timestamp() <= a.dt_fim_vigencia) and (coalesce(a.dt_inicio_vigencia::text, '') = ''))or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (clock_timestamp() <= a.dt_fim_vigencia)));
		if (qt_reg_w > 0) then
			ds_resultado_w	:= 'S';
		end if;
	end if;

	/*Se tiver regra para algum setor liberado ao usuario, esta liberado*/

	if (ds_resultado_w = 'N') then
		/* Compara o setor da regra com o setor do usuario logado (buscando pela package) */

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ds_resultado_w
		from	qua_doc_lib a
		where	a.nr_seq_doc	       = nr_seq_doc_w
		and	a.cd_setor_atendimento = cd_setor_atendimento_w
		and 	a.ie_obrigatorio = 'S'
		and     ( ((coalesce(a.dt_inicio_vigencia::text, '') = '') and (coalesce(a.dt_fim_vigencia::text, '') = '')) or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (coalesce(a.dt_fim_vigencia::text, '') = ''))or
			((clock_timestamp() <= a.dt_fim_vigencia) and (coalesce(a.dt_inicio_vigencia::text, '') = ''))or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (clock_timestamp() <= a.dt_fim_vigencia)));
	end if;

	/* Se tiver regra para algum agrupamento liberado ao usuario, esta liberado*/

	if (ds_resultado_w = 'N') then
		select	count(*)
		into STRICT	qt_reg_w
		from	qua_doc_lib a,
			qua_grupo_cargo b,
			qua_cargo_agrup c
		where	a.nr_seq_grupo_cargo	= b.nr_sequencia
		and	b.nr_sequencia 		= c.nr_seq_agrup
		and	a.nr_seq_doc   		= nr_seq_doc_w
		and	c.cd_cargo     		= cd_cargo_w
		and 	a.ie_obrigatorio	= 'S'
		and     ( ((coalesce(a.dt_inicio_vigencia::text, '') = '') and (coalesce(a.dt_fim_vigencia::text, '') = '')) or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (coalesce(a.dt_fim_vigencia::text, '') = ''))or
			((clock_timestamp() <= a.dt_fim_vigencia) and (coalesce(a.dt_inicio_vigencia::text, '') = ''))or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (clock_timestamp() <= a.dt_fim_vigencia)));

		if (qt_reg_w > 0) then
			ds_resultado_w := 'S';
		end if;
	end if;

	/* Se tiver regra para algum 'grupo de usuario' liberado ao usuario, esta liberado*/

	if (ds_resultado_w = 'N') then
		select	count(*)
		into STRICT	qt_reg_w
		from	qua_doc_lib a,
			grupo_usuario b,
			usuario_grupo c
		where	a.nr_seq_grupo_usuario	= b.nr_sequencia
		and	b.nr_sequencia 		= c.nr_seq_grupo
		and	a.nr_seq_doc   		= nr_seq_doc_w
		and	((c.nm_usuario_grupo 	= nm_usuario_p) or (nm_usuario_exclusivo = nm_usuario_p))
		and 	a.ie_obrigatorio	= 'S'
		and     ( ((coalesce(a.dt_inicio_vigencia::text, '') = '') and (coalesce(a.dt_fim_vigencia::text, '') = '')) or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (coalesce(a.dt_fim_vigencia::text, '') = ''))or
			((clock_timestamp() <= a.dt_fim_vigencia) and (coalesce(a.dt_inicio_vigencia::text, '') = ''))or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (clock_timestamp() <= a.dt_fim_vigencia)));

		if (qt_reg_w > 0) then
			ds_resultado_w := 'S';
		end if;
	end if;

	/*Se tiver regra para algum 'grupo perfil' liberado ao usuario, esta liberado*/

	if (ds_resultado_w = 'N') then
		select	count(*)
		into STRICT	qt_reg_w
		from	qua_doc_lib a,
			grupo_perfil b,
			grupo_perfil_item c
		where	a.nr_seq_grupo_perfil	= b.nr_sequencia
		and	b.nr_sequencia 		= c.nr_seq_grupo_perfil
		and	a.nr_seq_doc   		= nr_seq_doc_w
		and	c.cd_perfil		= cd_perfil_w
		and 	a.ie_obrigatorio	= 'S'
		and     ( ((coalesce(a.dt_inicio_vigencia::text, '') = '') and (coalesce(a.dt_fim_vigencia::text, '') = '')) or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (coalesce(a.dt_fim_vigencia::text, '') = ''))or
			((clock_timestamp() <= a.dt_fim_vigencia) and (coalesce(a.dt_inicio_vigencia::text, '') = ''))or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (clock_timestamp() <= a.dt_fim_vigencia)));

		if (qt_reg_w > 0) then
			ds_resultado_w := 'S';
		end if;
	end if;


	/*Se tiver regra para algum classif setor liberado ao usuario, esta liberado*/

	if (ds_resultado_w = 'N') then
		/* Compara o setor da regra com o setor do usuario logado (buscando pela package) */

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ds_resultado_w
		from	setor_atendimento b,
			qua_doc_lib a
		where	a.nr_seq_doc	       = nr_seq_doc_w
		and	b.cd_setor_atendimento = cd_setor_atendimento_w
		and	a.cd_classif_setor = b.cd_classif_setor
		and 	ie_obrigatorio	= 'S'
		and     ( ((coalesce(a.dt_inicio_vigencia::text, '') = '') and (coalesce(a.dt_fim_vigencia::text, '') = '')) or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (coalesce(a.dt_fim_vigencia::text, '') = ''))or
			((clock_timestamp() <= a.dt_fim_vigencia) and (coalesce(a.dt_inicio_vigencia::text, '') = ''))or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (clock_timestamp() <= a.dt_fim_vigencia)));
	end if;

	if (ds_resultado_w = 'N') then
		select	count(*)
		into STRICT	qt_reg_w
		from	qua_doc_lib a,
				usuario b,
				pessoa_fisica c
		where	a.nr_seq_doc = nr_seq_doc_w
		and		(a.nr_seq_funcao IS NOT NULL AND a.nr_seq_funcao::text <> '')
		and		b.nm_usuario = nm_usuario_p
		and		b.cd_pessoa_fisica = c.cd_pessoa_fisica
		and		a.nr_seq_funcao = c.nr_seq_funcao_pf
		and		a.ie_obrigatorio = 'S';

		if (qt_reg_w > 0) then
			ds_resultado_w := 'S';
		end if;

	end if;

	if (ds_resultado_w = 'N') then
		begin
		select	count(*)
		into STRICT	qt_reg_w
		from 	qua_doc_lib a
		where	a.nr_seq_doc = nr_seq_doc_w
		and	exists (	SELECT 	1
					from	gerencia_wheb e,
						gerencia_wheb_grupo b,
						gerencia_wheb_grupo_usu c,
						usuario d
					where	e.nr_sequencia = b.nr_seq_gerencia
					and	b.nr_sequencia = c.nr_seq_grupo
					and	c.nm_usuario_grupo = d.nm_usuario
					and	b.nr_sequencia = a.nr_seq_grupo_gerencia
					and	e.ie_situacao = 'A'
					and	b.ie_situacao = 'A'
					and	coalesce(c.ie_emprestimo, 'N') = 'N'
					and	trunc(clock_timestamp()) between trunc(c.dt_inicio) and trunc(coalesce(c.dt_fim, clock_timestamp()))
					and	d.nm_usuario = nm_usuario_p)
		and	a.ie_obrigatorio = 'S'
		and     ( ((coalesce(a.dt_inicio_vigencia::text, '') = '') and (coalesce(a.dt_fim_vigencia::text, '') = '')) or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (coalesce(a.dt_fim_vigencia::text, '') = ''))or
			((clock_timestamp() <= a.dt_fim_vigencia) and (coalesce(a.dt_inicio_vigencia::text, '') = ''))or
			((clock_timestamp() >= a.dt_inicio_vigencia) and (clock_timestamp() <= a.dt_fim_vigencia)));

		if (qt_reg_w > 0)	then
			ds_resultado_w := 'S';
		end if;
		end;

	end if;

	RETURN ds_resultado_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_se_doc_obrigatorio ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
