-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_receita_amb_lme ( cd_pessoa_fisica_p text, cd_profissional_p text, nm_usuario_p text, nr_atendimento_p bigint, nr_seq_interno_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


ds_procedimento_w		varchar(1000);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
cd_intervalo_prescr_w	varchar(7);
cd_material_w		bigint;
cd_unidade_medida_w	varchar(30);
ds_unidade_medida_w	varchar(50);
nr_atendimento_w		bigint;
ie_via_aplicacao_w		varchar(5);
nr_seq_receita_w		bigint;
nr_receita_w		fa_receita_farmacia.nr_receita%type;
nr_serie_w		varchar(15);
ds_retorno_w		varchar(255);
ie_segunda_w		varchar(10);
ie_terca_w		varchar(10);
ie_quarta_w		varchar(10);
ie_quinta_w		varchar(10);
ie_sexta_w		varchar(10);
ie_sabado_w		varchar(10);
ie_domingo_w		varchar(10);
ds_texto_padrao_receita_w	varchar(4000);
ds_dias_semana_w		varchar(255);
ie_exige_laudo_w		varchar(10);
cd_estabelecimento_w		smallint;

c01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced,
		ie_via_aplicacao,
		cd_intervalo_prescr
	from	sus_laudo_medicamento
	where	nr_seq_laudo_sus = nr_seq_interno_p
	order by 1;


BEGIN

if (nr_atendimento_p > 0) then
	nr_atendimento_w := nr_atendimento_p;
else
	select	max(nr_atendimento)
	into STRICT	nr_atendimento_w
	from   	atendimento_paciente
	where  	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_fim_conta		<> 'F'
	and	coalesce(dt_alta::text, '') = '';
end if;

select 	wheb_usuario_pck.get_cd_estabelecimento
into STRICT	cd_estabelecimento_w
;

open c01;
loop
fetch c01 into
	cd_procedimento_w,
	ie_origem_proced_w,
	ie_via_aplicacao_w,
	cd_intervalo_prescr_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	sus_obter_material_proc_opm(cd_procedimento_w)
	into STRICT	cd_material_w
	;

	if (coalesce(cd_material_w,0) <> 0) then
		begin

		begin
		select	max(cd_unidade_medida)
		into STRICT	cd_unidade_medida_w
		from 	unidade_medida_dose_v
		where 	cd_material 	= cd_material_w
		and 	ie_prioridade  not in (8,9);
		exception
		when others then
			ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(281684)||cd_material_w||'.';
		end;

		if (coalesce(nr_seq_receita_w::text, '') = '') then

			select	nextval('fa_receita_farmacia_seq')
			into STRICT	nr_seq_receita_w
			;

			ds_retorno_w	:= fa_obter_numero_receita(nr_atendimento_p);

			nr_receita_w	:= substr(ds_retorno_w,1,position('-' in ds_retorno_w)-1);
			nr_serie_w	:= substr(ds_retorno_w,position('-' in ds_retorno_w)+1,length(ds_retorno_w));
			insert	into fa_receita_farmacia(	nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_atendimento,
								cd_medico,
								nr_receita,
								dt_receita,
								dt_liberacao,
								nr_serie,
								cd_pessoa_fisica,
								cd_estabelecimento)
					values (	nr_seq_receita_w,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nr_atendimento_w,
								cd_profissional_p,
								nr_receita_w,
								clock_timestamp(),
								null,
								nr_serie_w,
								cd_pessoa_fisica_p,
								cd_estabelecimento_w);
		end if;

		select	max(ds_texto_padrao_receita)
		into STRICT	ds_texto_padrao_receita_w
		from	fa_medic_farmacia_amb
		where	cd_material	= cd_material_w;

		ds_unidade_medida_w 	:= substr(obter_unidade_medida(cd_unidade_medida_w),1,40) || '(s)';

		if (ds_texto_padrao_receita_w IS NOT NULL AND ds_texto_padrao_receita_w::text <> '') then
			ds_texto_padrao_receita_w	:= substr(replace_macro(ds_texto_padrao_receita_w,'@medicamento',substr(obter_desc_material(cd_material_w),1,255)), 1,4000);
			ds_texto_padrao_receita_w	:= substr(replace_macro(ds_texto_padrao_receita_w,'@dose',1),1,4000);
			ds_texto_padrao_receita_w	:= substr(replace_macro(ds_texto_padrao_receita_w,'@orientacao',fa_obter_orientacao_medic(cd_material_w)), 1,4000);
			ds_texto_padrao_receita_w	:= substr(replace_macro(ds_texto_padrao_receita_w,'@unidade',ds_unidade_medida_w), 1,4000);
			ds_texto_padrao_receita_w	:= substr(replace_macro(ds_texto_padrao_receita_w,'@intervalo',substr(obter_desc_intervalo_prescr(cd_intervalo_prescr_w),1,80)), 1,4000);
			ds_texto_padrao_receita_w	:= substr(replace_macro(ds_texto_padrao_receita_w,'@via',Obter_Desc_via(ie_via_aplicacao_w)), 1,4000);

			ds_texto_padrao_receita_w	:= substr(replace_macro(ds_texto_padrao_receita_w,'@dias_receita',''), 1,4000);
			ds_texto_padrao_receita_w	:= substr(replace_macro(ds_texto_padrao_receita_w,'@nr_ciclos',''), 1,4000);
			ds_texto_padrao_receita_w	:= substr(replace_macro(ds_texto_padrao_receita_w,'@uso_continuo',''), 1,4000);
			ds_texto_padrao_receita_w	:= substr(replace_macro(ds_texto_padrao_receita_w,'@dias_semana',''), 1,4000);

		end if;

		insert into fa_receita_farmacia_item(	nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							nr_seq_receita,
							cd_material,
							qt_dose,
							ie_via_aplicacao,
							cd_unidade_medida,
							cd_intervalo,
							ie_segunda,
							ie_terca       ,
							ie_quarta,
							ie_quinta ,
							ie_sexta  ,
							ie_sabado  ,
							ie_domingo,
							ds_texto_receita       )
					values (		nextval('fa_receita_farmacia_item_seq'),
							clock_timestamp(),
							nm_usuario_p,
							nr_seq_receita_w,
							cd_material_w,
							1,
							ie_via_aplicacao_w,
							cd_unidade_medida_w,
							cd_intervalo_prescr_w,
							'N',
							'N',
							'N',
							'N',
							'N',
							'N',
							'N',
							ds_texto_padrao_receita_w);

		end;
	else
		ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(281685)||cd_procedimento_w||WHEB_MENSAGEM_PCK.get_texto(281686);
	end if;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_receita_amb_lme ( cd_pessoa_fisica_p text, cd_profissional_p text, nm_usuario_p text, nr_atendimento_p bigint, nr_seq_interno_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

