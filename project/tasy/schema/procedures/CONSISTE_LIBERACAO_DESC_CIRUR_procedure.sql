-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_liberacao_desc_cirur ( nr_sequencia_p bigint, nr_cirurgia_p bigint, ds_retorno_p INOUT text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_retorno_w			varchar(2000):=null;
ie_consiste_proc_lancado_w	varchar(1);
ie_consiste_ds_cirurgia_w	varchar(1);
nr_prescricao_w			numeric(30);
qt_procedimento_w		bigint;
qt_funcao_exige_w		bigint;
qt_funcao_infor_w		bigint;
ds_cirurgia_w			text;

expressao1_w	varchar(255) := obter_desc_expressao_idioma(774011, null, wheb_usuario_pck.get_nr_seq_idioma);--É obrigatório informar um procedimento para a liberação da descrição. Parâmetro [265].
expressao2_w	varchar(255) := obter_desc_expressao_idioma(774016, null, wheb_usuario_pck.get_nr_seq_idioma);--Existem funções que não foram informadas e que são obrigatórias para a liberação da descrição.
BEGIN

ie_consiste_proc_lancado_w := Obter_Param_Usuario(872, 265, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_proc_lancado_w);

if (ie_consiste_proc_lancado_w = 'S') then
	select	max(nr_prescricao)
	into STRICT	nr_prescricao_w
	from	cirurgia
	where	nr_cirurgia = nr_cirurgia_p;

	select	count(*)
	into STRICT	qt_procedimento_w
	from	prescr_procedimento
	where	nr_prescricao 			= nr_prescricao_w
	and	((coalesce(ie_descricao_cirurgica,'N') = 'S') or (obter_dados_proc_interno(nr_seq_proc_interno,'TU') = 'C'));

	if (qt_procedimento_w = 0) then
		ds_retorno_w := expressao1_w;
	end if;
end if;

if (coalesce(ds_retorno_w::text, '') = '') then
	select	count(*)
	into STRICT	qt_funcao_exige_w
	from   	funcao_medico b
	where  	coalesce(b.ie_exige_lib_descr_cir,'N') = 'S';
	if (qt_funcao_exige_w > 0) then
		select	count(distinct a.ie_funcao)
		into STRICT	qt_funcao_infor_w
		from   	cirurgia_participante a
		where  	exists (SELECT 	1
				from   	funcao_medico b
				where  	coalesce(b.ie_exige_lib_descr_cir,'N') = 'S'
				and	b.cd_funcao = a.ie_funcao)
		and	a.nr_cirurgia = nr_cirurgia_p;

		if (qt_funcao_exige_w > qt_funcao_infor_w) then
			ds_retorno_w := expressao2_w;
		end if;
	end if;
end if;

ds_retorno_p	:= ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_liberacao_desc_cirur ( nr_sequencia_p bigint, nr_cirurgia_p bigint, ds_retorno_p INOUT text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

