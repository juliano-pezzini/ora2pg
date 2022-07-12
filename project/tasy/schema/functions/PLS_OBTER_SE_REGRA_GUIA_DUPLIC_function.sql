-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_regra_guia_duplic ( nr_seq_guia_p bigint, ie_tipo_guia_p text, dt_solicitacao_p timestamp, nr_seq_segurado_p bigint, cd_medico_solicitante_p text, nr_seq_prestador_p bigint, cd_guia_p text) RETURNS varchar AS $body$
DECLARE


ie_valida_beneficiario_w	varchar(2);
ie_valida_data_solic_w		varchar(2);
ie_valida_medico_solic_w	varchar(2);
ie_valida_prestador_w		varchar(2);
ie_valida_tipo_guia_w		varchar(2);
ie_retorno_w			varchar(2)	:= 'N';
qt_guias_w			bigint	:= 0;
qt_regra_w			bigint	:= 0;
qt_validacao_w			bigint	:= 0;
qt_registros_w			bigint	:= 0;


BEGIN
if (pls_obter_se_controle_estab('RE') = 'S') then
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_regra_guia_duplicada
	where 	coalesce(cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento;
else
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_regra_guia_duplicada;
end if;

if (qt_registros_w	> 0) then
	if (pls_obter_se_controle_estab('RE') = 'S') then
		begin
			select	ie_valida_beneficiario,
				ie_valida_data_solic,
				ie_valida_medico_solic,
				ie_valida_prestador,
				ie_valida_tipo_guia
			into STRICT	ie_valida_beneficiario_w,
				ie_valida_data_solic_w,
				ie_valida_medico_solic_w,
				ie_valida_prestador_w,
				ie_valida_tipo_guia_w
			from	pls_regra_guia_duplicada
			where 	coalesce(cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento;
		exception
		when others then
			ie_valida_beneficiario_w	:= 'N';
			ie_valida_data_solic_w		:= 'N';
			ie_valida_medico_solic_w	:= 'N';
			ie_valida_prestador_w		:= 'N';
			ie_valida_tipo_guia_w		:= 'N';
		end;
	else
		begin
			select	ie_valida_beneficiario,
				ie_valida_data_solic,
				ie_valida_medico_solic,
				ie_valida_prestador,
				ie_valida_tipo_guia
			into STRICT	ie_valida_beneficiario_w,
				ie_valida_data_solic_w,
				ie_valida_medico_solic_w,
				ie_valida_prestador_w,
				ie_valida_tipo_guia_w
			from	pls_regra_guia_duplicada;
		exception
		when others then
			ie_valida_beneficiario_w	:= 'N';
			ie_valida_data_solic_w		:= 'N';
			ie_valida_medico_solic_w	:= 'N';
			ie_valida_prestador_w		:= 'N';
			ie_valida_tipo_guia_w		:= 'N';
		end;
	end if;

	if (coalesce(ie_valida_beneficiario_w,'N')	= 'S') then
		qt_validacao_w	:= qt_validacao_w + 1;

		select	count(1)
		into STRICT	qt_guias_w
		from	pls_guia_plano
		where	nr_seq_segurado	= nr_seq_segurado_p
		and	cd_guia		= cd_guia_p
		and	ie_estagio	<> 8
		and	nr_sequencia	<> nr_seq_guia_p;

		if (qt_guias_w	> 0) then
			qt_regra_w	:= qt_regra_w + 1;
		end if;
	end if;

	if (coalesce(ie_valida_data_solic_w,'N')	= 'S') then
		qt_validacao_w	:= qt_validacao_w + 1;

		select	count(1)
		into STRICT	qt_guias_w
		from	pls_guia_plano
		where	trunc(dt_solicitacao,'dd')	= trunc(dt_solicitacao_p,'dd')
		and	cd_guia				= cd_guia_p
		and	ie_estagio			<> 8
		and	nr_sequencia			<> nr_seq_guia_p;

		if (qt_guias_w	> 0) then
			qt_regra_w	:= qt_regra_w + 1;
		end if;
	end if;

	if (coalesce(ie_valida_medico_solic_w,'N')	= 'S') then
		qt_validacao_w	:= qt_validacao_w + 1;

		select	count(1)
		into STRICT	qt_guias_w
		from	pls_guia_plano
		where	cd_medico_solicitante	= cd_medico_solicitante_p
		and	cd_guia			= cd_guia_p
		and	ie_estagio		<> 8
		and	nr_sequencia		<> nr_seq_guia_p;

		if (qt_guias_w	> 0) then
			qt_regra_w	:= qt_regra_w + 1;
		end if;
	end if;

	if (coalesce(ie_valida_prestador_w,'N')		= 'S') then
		qt_validacao_w	:= qt_validacao_w + 1;

		select	count(1)
		into STRICT	qt_guias_w
		from	pls_guia_plano
		where	nr_seq_prestador	= nr_seq_prestador_p
		and	cd_guia			= cd_guia_p
		and	ie_estagio		<> 8
		and	nr_sequencia		<> nr_seq_guia_p;

		if (qt_guias_w	> 0) then
			qt_regra_w	:= qt_regra_w + 1;
		end if;
	end if;

	if (coalesce(ie_valida_tipo_guia_w,'N')		= 'S') then
		qt_validacao_w	:= qt_validacao_w + 1;

		select	count(1)
		into STRICT	qt_guias_w
		from	pls_guia_plano
		where	ie_tipo_guia	= ie_tipo_guia_p
		and	cd_guia		= cd_guia_p
		and	ie_estagio	<> 8
		and	nr_sequencia	<> nr_seq_guia_p;

		if (qt_guias_w	> 0) then
			qt_regra_w	:= qt_regra_w + 1;
		end if;
	end if;

	if (qt_regra_w	= qt_validacao_w) then
		ie_retorno_w	:= 'S';
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_regra_guia_duplic ( nr_seq_guia_p bigint, ie_tipo_guia_p text, dt_solicitacao_p timestamp, nr_seq_segurado_p bigint, cd_medico_solicitante_p text, nr_seq_prestador_p bigint, cd_guia_p text) FROM PUBLIC;

