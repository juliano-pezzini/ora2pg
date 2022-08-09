-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_guia_conv_pac_quimio (nr_seq_paciente_p bigint, nr_doc_convenio_p INOUT text) AS $body$
DECLARE


nr_doc_convenio_w	varchar(20);
ie_forma_w		varchar(15);
ds_adicional_w		varchar(20);
ie_tipo_atendimento_w	smallint;
cd_estabelecimento_w	integer;
nr_inicial_w		bigint;
nr_final_w		bigint;
nr_atual_w		bigint;
nr_sequencia_w		bigint;
ie_tipo_convenio_w		smallint;
nr_doc_mascara_w		varchar(20) := null;
ds_mascara_w		varchar(40) := null;
cd_perfil_comunic_w	integer;
nr_doc_conv_comunic_w	varchar(20);
ds_convenio_w		varchar(255);
ds_tipo_convenio_w	varchar(100);
ds_tipo_atendimento_w	varchar(100);
ie_clinica_w		integer;
nr_seq_classificacao_w	bigint;
cd_empresa_w		bigint;
ie_gerar_procedimento_w	varchar(1);

cd_area_procedimento_w	bigint;
cd_especialidade_w      bigint;
cd_grupo_proc_w         bigint;

qt_regra_guia_proc_w	bigint;
ie_aplica_regra_proc_w	varchar(1);
cd_convenio_w		bigint;
ie_tipo_guia_w		varchar(2);
cd_categoria_w		varchar(10);
c01 CURSOR FOR
	SELECT nr_sequencia,
		ie_forma,
		ds_adicional,
		nr_inicial,
		nr_final,
		nr_atual,
		ds_mascara,
		cd_perfil_comunic,
		nr_doc_conv_comunic,
		ie_gerar_procedimento
	from 	convenio_regra_guia
	where	coalesce(cd_convenio,cd_convenio_w)				= cd_convenio_w
	and	coalesce(cd_categoria,cd_categoria_w) 			= cd_categoria_w
	and 	coalesce(cd_perfil_filtro, coalesce(obter_perfil_ativo,0)) 	= coalesce(obter_perfil_ativo,0)
	and	coalesce(ie_tipo_convenio, coalesce(ie_tipo_convenio_w,0)) 	= coalesce(ie_tipo_convenio_w,0)
	and	coalesce(cd_estabelecimento,cd_estabelecimento_w)		= cd_estabelecimento_w
	and	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w)  	= ie_tipo_atendimento_w
	and	coalesce(ie_tipo_guia,coalesce(ie_tipo_guia_w,'0'))		= coalesce(ie_tipo_guia_w,'0')
	and 	coalesce(ie_clinica,coalesce(ie_clinica_w,0))                     = coalesce(ie_clinica_w,0)
	and	coalesce(nr_seq_classificacao,coalesce(nr_seq_classificacao_w,0))	= coalesce(nr_seq_classificacao_w,0)
	and	coalesce(ie_situacao,'A')		= 'A'
	and (coalesce(cd_empresa,coalesce(cd_empresa_w,0)) = coalesce(cd_empresa_w,0))
	order by coalesce(cd_estabelecimento,0),
		coalesce(cd_convenio,0),
		coalesce(cd_categoria,'0'),
		coalesce(ie_tipo_atendimento,0),
		coalesce(cd_perfil_filtro,0),
		coalesce(ie_clinica,0),
		coalesce(ie_tipo_convenio,0),
		coalesce(ie_tipo_guia,'0'),
		coalesce(nr_seq_classificacao,0),
		coalesce(cd_empresa,0);


BEGIN

nr_doc_convenio_w	:= '';
ie_forma_w		:= '';
ie_aplica_regra_proc_w  := 'N';

begin
select	coalesce(max(a.ie_tipo_atendimento),0),
	max(b.cd_estabelecimento),
	coalesce(max(Obter_Tipo_Convenio(a.cd_convenio)),0),
	coalesce(max(null),0),
	coalesce(max(null),0),
	coalesce(max(a.cd_convenio),0),
	coalesce(max(a.cd_categoria),'XxX')
into STRICT	ie_tipo_atendimento_w,
	cd_estabelecimento_w,
	ie_tipo_convenio_w,
	ie_clinica_w,
	nr_seq_classificacao_w,
	cd_convenio_w,
	cd_categoria_w
from	paciente_setor_convenio a,
	paciente_setor b
where	b.nr_seq_paciente 	= a.nr_seq_paciente
and	b.nr_seq_paciente	= nr_seq_paciente_p;
exception
	when no_data_found then
		null;
end;

select	max(cd_empresa)
into STRICT	cd_empresa_w
from	estabelecimento
where	cd_estabelecimento = coalesce(cd_estabelecimento_w,wheb_usuario_pck.get_cd_estabelecimento);


open c01;
loop
	fetch c01 into
		nr_sequencia_w,
		ie_forma_w,
		ds_adicional_w,
		nr_inicial_w,
		nr_final_w,
		nr_atual_w,
		ds_mascara_w,
		cd_perfil_comunic_w,
		nr_doc_conv_comunic_w,
		ie_gerar_procedimento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	ie_forma_w		:= ie_forma_w;
	ds_mascara_w		:= ds_mascara_w;
	nr_sequencia_w		:= nr_sequencia_w;
	ie_gerar_procedimento_w	:= ie_gerar_procedimento_w;

	end;
end loop;
close c01;


/* Não foi implementado porque a guia na autorização é pela autorização inteira e não somente para um procedimento */

ie_forma_w	:= coalesce(ie_forma_w,'N');

if (ie_forma_w = 'A') then
	nr_doc_convenio_w	:=  null;--nr_atendimento_p;
elsif (ie_forma_w = 'AV') then
	nr_doc_convenio_w	:= null;--nr_atendimento_p || ds_adicional_w;
elsif (ie_forma_w = 'VA') then
	nr_doc_convenio_w	:= null; --ds_adicional_w || nr_atendimento_p;
elsif (ie_forma_w = 'U6AV') then
	nr_doc_convenio_w	:= null;-- substr(nr_atendimento_p, length(nr_atendimento_p) - 5,6) || ds_adicional_w;
elsif (ie_forma_w in ('IN','INV','VIN')) and (nr_atual_w < nr_final_w) then
	begin
	if (nr_atual_w < nr_inicial_w) then
		nr_atual_w	:= nr_inicial_w;
	else
		nr_atual_w	:= nr_atual_w + 1;
	end if;
	nr_doc_convenio_w	:= nr_atual_w;
	update convenio_regra_guia
	set	nr_atual	= nr_atual_w
	where	nr_sequencia	= nr_sequencia_w;
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
	if (ie_forma_w = 'INV') then
		nr_doc_convenio_w	:= nr_doc_convenio_w||ds_adicional_w;
	end if;
	if (ie_forma_w = 'VIN') then
		nr_doc_convenio_w	:= ds_adicional_w || nr_doc_convenio_w;
	end if;
	end;
elsif (ie_forma_w = 'SV') then
	nr_doc_convenio_w	:= substr(ds_adicional_w, 1, 20);
end if;



/*Francisco - 15/06/07 - OS 59173 */

if (nr_doc_convenio_w = nr_doc_conv_comunic_w) and (cd_perfil_comunic_w IS NOT NULL AND cd_perfil_comunic_w::text <> '') then
	begin
	select	substr(obter_nome_convenio(cd_convenio),1,60),
		substr(obter_valor_dominio(11,ie_tipo_convenio),1,100),
		substr(obter_valor_dominio(12,ie_tipo_atendimento),1,100)
	into STRICT	ds_convenio_w,
		ds_tipo_convenio_w,
		ds_tipo_atendimento_w
	from	convenio_regra_guia
	where	nr_sequencia	= nr_sequencia_w;

	CALL gerar_comunic_padrao(clock_timestamp(),
			wheb_mensagem_pck.get_texto(313412),
			wheb_mensagem_pck.get_texto(313413,'DS_CONVENIO_W='||ds_convenio_w||';DS_TIPO_CONVENIO_W='||ds_tipo_convenio_w||';DS_TIPO_ATENDIMENTO_W='||ds_tipo_atendimento_w),
			'Tasy',
			'N',
			null,
			'N',
			null,
			to_char(cd_perfil_comunic_w) || ',',
			cd_estabelecimento_w,
			null,
			clock_timestamp(),
			null,
			null);
	exception
		when others then
			null;
	end;

end if;

/*Francisco - 11/06/07 - OS 58581 */

if (ds_mascara_w IS NOT NULL AND ds_mascara_w::text <> '') then
	begin
	select	trim(both to_char(somente_numero(nr_doc_convenio_w),ds_mascara_w))
	into STRICT	nr_doc_mascara_w
	;
	exception
		when others then
		nr_doc_mascara_w := null;
	end;

	if (nr_doc_mascara_w IS NOT NULL AND nr_doc_mascara_w::text <> '') then
		nr_doc_convenio_w	:= nr_doc_mascara_w;
	end if;
end if;

nr_doc_convenio_p		:= nr_doc_convenio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_guia_conv_pac_quimio (nr_seq_paciente_p bigint, nr_doc_convenio_p INOUT text) FROM PUBLIC;
