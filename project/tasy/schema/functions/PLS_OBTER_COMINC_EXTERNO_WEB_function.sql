-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_cominc_externo_web ( nr_seq_perfil_web_p bigint, nr_seq_usuario_prest_p bigint, nm_usuario_web_p text, ie_tipo_acesso_p text, nr_seq_contrato_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE



ds_retorno_w				varchar(255)	:= 'N';
qt_registros_w				bigint	:= 0;
qt_registros_ww				bigint	:= 0;
nm_usuario_prestador_w			pls_comunic_externa_web.nm_usuario_prestador%type;
nr_seq_comunicado_w			pls_comunic_externa_web.nr_sequencia%type;
nr_posicao_w				bigint 	:= 0;
nm_usuario_w				pls_comunic_externa_web.nm_usuario_prestador%type;
nm_usuarios_ww				pls_comunic_externa_web.nm_usuario_prestador%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nm_usuario_prestador
	from	pls_comunic_externa_web
	where	ie_tipo_login = ie_tipo_acesso_p
	and	ie_situacao	= 'A'
	and   	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and     clock_timestamp()	between	dt_liberacao and (fim_dia(coalesce(dt_fim_liberacao, clock_timestamp())));

BEGIN
if (ie_tipo_acesso_p in ('P', 'E')) then
	for r_C01_w in C01 loop
		begin
			nr_seq_comunicado_w	:= r_C01_w.nr_sequencia;
			nm_usuario_prestador_w	:= r_C01_w.nm_usuario_prestador;
			nm_usuario_w		:= null;
		exception
		when others then
			nm_usuario_prestador_w	:= null;
		end;
		nm_usuarios_ww	:= nm_usuario_prestador_w;

		if (nm_usuarios_ww IS NOT NULL AND nm_usuarios_ww::text <> '') then
			while(length(nm_usuarios_ww) > 0) loop
				nr_posicao_w	:= position(',' in nm_usuarios_ww);
					if (nr_posicao_w > 0) then
						nm_usuario_w		:= substr(nm_usuarios_ww, 0, nr_posicao_w - 1);
						nm_usuarios_ww		:= substr(nm_usuarios_ww, nr_posicao_w + 1, length(nm_usuarios_ww));
					else
						nm_usuario_w		:= nm_usuarios_ww;
						nm_usuarios_ww		:= '';
					end if;

				if (ie_tipo_acesso_p = 'P') then
					select 	count(1)
					into STRICT	qt_registros_w
					from	pls_comunic_externa_web	a
					where   a.ie_tipo_login = 'P' and ie_tipo_acesso_p = 'P'
					and	a.nr_sequencia 	= nr_seq_comunicado_w
					and	((coalesce(a.nm_usuario_prestador::text, '') = ''
					or ((nm_usuario_w IS NOT NULL AND nm_usuario_w::text <> '') and upper(nm_usuario_w) like upper(nm_usuario_web_p)))
					and (coalesce(a.nr_seq_perfil_web::text, '') = '' or a.nr_seq_perfil_web =  nr_seq_perfil_web_p)
					and (coalesce(a.cd_especialidade::text, '') = '' or  exists (SELECT	1
											from	pls_prestador_med_espec	c,
												pls_prestador		d
											where 	c.nr_seq_prestador	= d.nr_sequencia
											and	clock_timestamp() between trunc(coalesce(c.dt_inicio_vigencia, clock_timestamp()), 'dd') and fim_dia(coalesce(c.dt_fim_vigencia, clock_timestamp()))
											and	exists (select	1
													from 	pls_prestador_usuario_web	x
													where	x.nr_seq_usuario	= nr_seq_usuario_prest_p
													and	x.ie_situacao		= 'A'
													and	x.nr_seq_prestador = c.nr_seq_prestador)
											and (coalesce(d.cd_pessoa_fisica::text, '') = ''
											or 	 c.cd_pessoa_fisica	= d.cd_pessoa_fisica)
											and	 a.cd_especialidade	= c.cd_especialidade))
					and 	not exists (select  1
								from    pls_comunic_ext_hist_web y
								where   a.nr_sequencia = y.nr_seq_comunicado
								and     upper(y.nm_usuario_leitura) like upper(nm_usuario_web_p)));
				elsif (ie_tipo_acesso_p = 'E') then
					select 	count(1)
					into STRICT	qt_registros_w
					from	pls_comunic_externa_web	a
					where  	a.ie_tipo_login = 'E' and ie_tipo_acesso_p = 'E'
					and	a.nr_sequencia 	= nr_seq_comunicado_w
					and	((coalesce(a.nm_usuario_prestador::text, '') = ''
					or ((nm_usuario_w IS NOT NULL AND nm_usuario_w::text <> '') and upper(nm_usuario_w) like upper(nm_usuario_web_p)))
					and 	not exists (SELECT  1
								from    pls_comunic_ext_hist_web y
								where   a.nr_sequencia = y.nr_seq_comunicado
								and 	upper(y.nm_usuario_leitura) like upper(nm_usuario_web_p)));
				end if;
				qt_registros_ww	:= qt_registros_ww + qt_registros_w;
			end loop;
		else
			if (ie_tipo_acesso_p = 'P') then
				select 	count(1)
				into STRICT	qt_registros_w
				from	pls_comunic_externa_web	a
				where   a.ie_tipo_login = 'P' and ie_tipo_acesso_p = 'P'
				and	a.nr_sequencia 	= nr_seq_comunicado_w
				and	((coalesce(a.nm_usuario_prestador::text, '') = ''
				or ((nm_usuario_w IS NOT NULL AND nm_usuario_w::text <> '') and upper(nm_usuario_w) like upper(nm_usuario_web_p)))
				and (coalesce(a.nr_seq_perfil_web::text, '') = '' or a.nr_seq_perfil_web =  nr_seq_perfil_web_p)
				and (coalesce(a.cd_especialidade::text, '') = '' or  exists (SELECT	1
										from	pls_prestador_med_espec	c,
											pls_prestador		d
										where 	c.nr_seq_prestador	= d.nr_sequencia
										and	clock_timestamp() between trunc(coalesce(c.dt_inicio_vigencia, clock_timestamp()), 'dd') and fim_dia(coalesce(c.dt_fim_vigencia, clock_timestamp()))
										and	exists (select	1
												from 	pls_prestador_usuario_web	x
												where	x.nr_seq_usuario	= nr_seq_usuario_prest_p
												and	x.ie_situacao		= 'A'
												and	x.nr_seq_prestador = c.nr_seq_prestador)
										and (coalesce(d.cd_pessoa_fisica::text, '') = ''
										or 	 c.cd_pessoa_fisica	= d.cd_pessoa_fisica)
										and	 a.cd_especialidade	= c.cd_especialidade))
				and 	not exists (select  1
							from    pls_comunic_ext_hist_web y
							where   a.nr_sequencia = y.nr_seq_comunicado
							and     upper(y.nm_usuario_leitura) like upper(nm_usuario_web_p)));
			elsif (ie_tipo_acesso_p = 'E') then
				select 	count(1)
				into STRICT	qt_registros_w
				from	pls_comunic_externa_web	a
				where  	a.ie_tipo_login = 'E' and ie_tipo_acesso_p = 'E'
				and	a.nr_sequencia 	= nr_seq_comunicado_w
				and	((coalesce(a.nm_usuario_prestador::text, '') = ''
				or ((nm_usuario_w IS NOT NULL AND nm_usuario_w::text <> '') and upper(nm_usuario_w) like upper(nm_usuario_web_p)))
				and 	not exists (SELECT  1
							from    pls_comunic_ext_hist_web y
							where   a.nr_sequencia = y.nr_seq_comunicado
							and 	upper(y.nm_usuario_leitura) like upper(nm_usuario_web_p)));
			end if;
			qt_registros_ww	:= qt_registros_ww + qt_registros_w;
		end if;
	end loop;
elsif (ie_tipo_acesso_p = 'B') then
	select 	count(1)
	into STRICT	qt_registros_ww
	from	pls_comunic_externa_web	a
	where   a.ie_situacao	= 'A'
	and     (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and     clock_timestamp()	between	a.dt_liberacao and (fim_dia(coalesce(a.dt_fim_liberacao, clock_timestamp())))
	and	a.ie_tipo_login = 'B' and ie_tipo_acesso_p = 'B'
	and	((coalesce(a.nr_seq_contrato::text, '') = '' or a.nr_seq_contrato = nr_seq_contrato_p)
	and 	not exists (SELECT  1
				from    pls_comunic_ext_hist_web y
				where   a.nr_sequencia = y.nr_seq_comunicado
				and     y.cd_pessoa_fisica_resp	= cd_pessoa_fisica_p));
end if;

if (qt_registros_ww > 0) then
	ds_retorno_w	:= 'S';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_cominc_externo_web ( nr_seq_perfil_web_p bigint, nr_seq_usuario_prest_p bigint, nm_usuario_web_p text, ie_tipo_acesso_p text, nr_seq_contrato_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;
